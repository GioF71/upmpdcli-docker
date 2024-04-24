#!/usr/bin/python3

# Copyright (C) 2024 Giovanni Fulco
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

import tidalapi
import json
import os
from pathlib import Path

tidal_plugin_name : str = "tidal"


def print_setting(name : str, value : str):
    print(f"{name}={value}")


tmp_directory : str = "generated"
file_path : str = os.path.join("/tmp", tmp_directory)
if not os.path.exists(file_path):
    os.makedirs(file_path)

file_name = f"{file_path}/pkce.credentials.json"

session = tidalapi.Session()
session_file1 = Path(file_name)
# Will run until you complete the login process
session.login_session_file(session_file1, do_pkce=True)

token_type = session.token_type
session_id = session.session_id
access_token = session.access_token
refresh_token = session.refresh_token

print("Alternative 1: pkce credentials file, store as /cache/tidal/pkce.credentials.json")
cred_file = open(file_name, "r")
cred_dict = json.load(cred_file)
print(json.dumps(cred_dict, indent=4, sort_keys=True))

print("=============")
print("=============")
print("=============")

print("Alternative 2: Environment variables:")
print_setting("TIDAL_PKCE_TOKEN_TYPE", token_type)
print_setting("TIDAL_PKCE_SESSION_ID", session_id)
print_setting("TIDAL_PKCE_ACCESS_TOKEN", access_token)
print_setting("TIDAL_PKCE_REFRESH_TOKEN", refresh_token)
