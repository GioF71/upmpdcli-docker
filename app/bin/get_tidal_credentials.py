#!/usr/bin/python3

"""Use this program to obtain credentials for the tidal plugin."""

# Copyright (C) 2023,2024 Giovanni Fulco
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import json
import argparse
from datetime import datetime
from pathlib import Path
import tidalapi

tidal_plugin_name : str = "tidal"


def print_setting(name : str, value : str):
    """Print function for script settings."""
    print(f"{tidal_plugin_name}{name} = {value}")


auth_type_legacy : str = "legacy"
auth_type_oauth2 : str = "oauth2"
auth_type_pkce : str = "pkce"

auth_type_default : str = auth_type_oauth2

auth_types : list[str] = [auth_type_legacy, auth_type_oauth2, auth_type_pkce]


def print_separator(middle_text: str, border_len: int = 20):
    """Borded text print function."""
    print(f"{'=' * border_len} {middle_text} {'=' * border_len}")


def auth_oauth2(args: argparse.Namespace, use_pkce: bool = False):
    """Performs oauth2 authentication."""
    session = tidalapi.Session()
    exists: bool = Path.exists(Path(args.f))
    if exists:
        print(f"Credentials file [{args.f}] already exists.")
    if not args.k and exists:
        # remove existing credential file
        print(f"Removing existing file [{args.f}] ...")
        Path(args.f).unlink()
        print(f"Removed existing file [{args.f}]")
    session_file = Path(args.f)
    # Will run until you complete the login process
    session.login_session_file(session_file=session_file, do_pkce=use_pkce)
    print(f"Credentials file [{args.f}] written.")
    with open(file=args.f, mode="r", encoding="utf-8") as cred_file:
        cred_dict = json.load(cred_file)
        print(f"Displaying credentials file for type [{args.f}], json format:")
        print(json.dumps(cred_dict, indent=4))


def auth_legacy(args : argparse.Namespace):
    """Performs legacy authentication (deprecated)."""
    session = tidalapi.Session()
    # Will run until you visit the printed url and link your account
    session.login_oauth_simple()
    token_type = session.token_type
    access_token = session.access_token
    refresh_token = session.refresh_token
    expiry_time = session.expiry_time
    storable_expiry_time = datetime.timestamp(expiry_time)
    cred_dict : dict[str, str] = {
        "authentication_type": "oauth2",
        "tokentype": token_type,
        "accesstoken": access_token,
        "refreshtoken": refresh_token,
        "expirytimetimestampstr": storable_expiry_time
    }
    if args.f:
        print(f"Writing the credentials to file [{args.f}] ...")
        # write a new json file
        with open(file=args.f, mode="w", encoding="utf-8") as cred_file:
            json.dump(cred_dict, cred_file, indent = 4)
        print(f"Credentials written to [{args.f}]")
    print(f"Credentials file for type [{args.t}] in json format:")
    print(json.dumps(cred_dict, indent=4))


file_switch: str = "-f"
auth_type_switch: str = "-t"
keep_file_switch: str = "-k"


def main():
    """Application entrypoint."""
    parser = argparse.ArgumentParser(description='Tidal Credentials Retriever')
    parser.add_argument(
        file_switch,
        type=str,
        help='Optionally write credentials to the specified file')
    parser.add_argument(
        auth_type_switch,
        type=str,
        help='Authentication flow, OAUTH2 (default) or PKCE')
    parser.add_argument(
        keep_file_switch,
        action='store_true',
        help='Keep existing pkce file')
    args: argparse.Namespace = parser.parse_args()
    if args.f:
        print(f"Credentials will be written to [{args.f}]")
        # ensure directory exists
        dest_path: Path = Path(args.f)
        parent_path: Path = dest_path.parent.absolute() if dest_path.parent else None
        if parent_path:
            parent_path.mkdir(parents=True, exist_ok=True)
    if args.t and args.t.lower() not in auth_types:
        raise ValueError(f"Invalid authentication type [{args.t}]")
    auth_type : str = args.t if args.t else auth_type_default
    print(f"Authentication type is [{auth_type}]")
    if auth_type_legacy.lower() == auth_type.lower():
        auth_legacy(args)
    elif auth_type.lower() in [auth_type_pkce.lower(), auth_type_oauth2.lower()]:
        use_pkce: bool = auth_type.lower() == auth_type_pkce.lower()
        # a file is needed for oauth2 and pkce authentication
        if not args.f:
            args.f = ("/tmp/pkce.credentials.json"
                      if auth_type.lower() == auth_type_pkce.lower()
                      else "/tmp/oauth2.credentials.json")
            print(f"When using [{auth_type}], the [{file_switch}] switch is required, "
                  f"using a temporary file [{args.f}] ...")
        print(f"Keep existing file: [{args.k}]")
        auth_oauth2(args, use_pkce)
    else:
        raise ValueError(f"Authentication type [{auth_type}] cannot be processed")


if __name__ == "__main__":
    main()
