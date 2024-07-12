#!/usr/bin/python3

# Copyright (C) 2023 Giovanni Fulco
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
from datetime import datetime

tidal_plugin_name : str = "tidal"


def print_setting(name : str, value : str):
    print(f"{name}={value}")


tmp_directory : str = "generated"
file_path : str = os.path.join("/tmp", tmp_directory)
if not os.path.exists(file_path):
    os.makedirs(file_path)

file_name = f"{file_path}/credentials.json"

session = tidalapi.Session()
# Will run until you visit the printed url and link your account
session.login_oauth_simple()

token_type = session.token_type
access_token = session.access_token
refresh_token = session.refresh_token
expiry_time = session.expiry_time

storable_expiry_time = datetime.timestamp(expiry_time)

cred_dict: dict = dict()
cred_dict["authentication_type"] = "oauth2"
cred_dict["tokentype"] = "Bearer"
cred_dict["accesstoken"] = access_token
cred_dict["refreshtoken"] = refresh_token
cred_dict["expirytimetimestampstr"] = storable_expiry_time

print(json.dumps(cred_dict, indent=4, sort_keys=True))

print(f"Writing credentials to file [{file_name}] ...")
with open(file_name, 'w') as wcf:
    json.dump(cred_dict, wcf, indent = 4)
print(f"Credentials written to file [{file_name}].")
