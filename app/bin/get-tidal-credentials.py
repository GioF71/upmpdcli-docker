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
from datetime import datetime

tidal_plugin_name : str = "tidal"


def print_setting(name : str, value : str):
    print(f"{name}={value}")


session = tidalapi.Session()
# Will run until you visit the printed url and link your account
session.login_oauth_simple()

token_type = session.token_type
access_token = session.access_token
refresh_token = session.refresh_token
expiry_time = session.expiry_time

storable_expiry_time = datetime.timestamp(expiry_time)

print("Environment variables:")
print_setting("TIDAL_TOKEN_TYPE", token_type)
print_setting("TIDAL_ACCESS_TOKEN", access_token)
print_setting("TIDAL_REFRESH_TOKEN", refresh_token)
print_setting("TIDAL_EXPIRY_TIME", storable_expiry_time)
