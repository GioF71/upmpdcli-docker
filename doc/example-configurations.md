# Upmpdcli example configurations

The following are just basic examples to start with. You will always need to refer to the [README](../README.md) for the full documentation.  

## References

A list of considerations that apply to the upcoming configurations are listed in this section.

### User mode

Using `PUID` and `PGID` is optional, but when using volumes in read-write mode (for example the `/cache` volume), it will help you if you want to have those files created with a specified user. Generally, the main user of a desktop system has uid and gid set to `1000`, but you can verify your user and group id by simply typing `id` from a terminal. The output will indicated the user and group id of the current user.  

### Media Server mode

If you want to create a pure server (by pure I mean, which has no playback responsability), you can set the variable `RENDERER_MODE` to `NONE`. Of course, this is not mandatory: server and renderer mode are not exclusive.  

### Runtime configuration

In order to preserve upmpdcli status across restarts, you can bind the volume `/cache` to a docker volume or a local directory.  

### Logging

In order to preserve upmpdcli logs across restarts, you can bind the volume `/log` to a docker volume or a local directory.  
Logging can be tuned using `LOG_ENABLE` and `LOG_LEVEL`. See the [README](../README.md) for the details.  

### Disabling Watchtower

We can avoid that our container is stopped and restarted by [watchtower](https://github.com/containrrr/watchtower) setting the label `com.centurylinklabs.watchtower.enable` to `false`.  
Watchtower is a great tool, but be warned that automatic updating can result in interruptions of your listening experience.  
If you want automatic updating of container images, maybe you can consider scheduling watchtower to a convenient hours of the day, when you are unlikely to be listening to music.  

## Sample Configurations

### Renderer

A simple renderer configuration:

```text
---
version: "3"

services:
  upmpdcli:
    image: giof71/upmpdcli:renderer
    container_name: upmpdcli
    network_mode: host
    environment:
      - PUID=1000
      - PGID=1000
      - FRIENDLY_NAME=upmpd
    volumes:
      - ./cache:/cache
      - ./log:/log
      - ./config/additional-radio-list.txt:/user/config/additional-radio-list.txt:ro
    labels:
      - com.centurylinklabs.watchtower.enable=false
    restart: unless-stopped
```

This configuration will instruct upmpdcli to connect to mpd on localhost at port 6600, which is the default.  
Also, it will create the OpenHome renderer. This can be easily changed adding the `RENDERER_MODE` variable.  
Easily specify the friendly name using one variable `FRIENDLY_NAME`. The container startup script will handle the different names of renderers according to the requested configuration.  
Mounting a directory for the `/cache` volume is not mandatory, but if you do so, upmpdcli will preserve its state across restarts.  
Mounting a directory for the `/log` volume is not mandatory, but if you do so, you will be able to read the application logs across restarts.  
An optional file containing additional radios has been provided via the mountpoint `/user/config/additional-radio-list.txt` in read-only mode.  
The configuration is using the optional `PUID` and `PGID` variables, see [user mode](#user-mode).  
The configuration is disabling Watchtower: see [here](#disabling-watchtower).

### Media Server

The following configurations do not implement the renderer functionality. If you want to create configurations which offer both media server and renderer functionality, change the value for the variable RENDERER_MODE accordingly (possibly set it to `BOTH`).  
A simple media server configuration:

```text
---
version: "3"

services:
  upmpdcli-library:
    image: giof71/upmpdcli
    container_name: upmpdcli-library
    network_mode: host
    environment:
      - PUID=1000
      - PGID=1000
      - RENDERER_MODE=NONE
      - FRIENDLY_NAME=upmpd-library
      - UPRCL_ENABLE=yes
      - UPRCL_USER=upmpdcli-library
      - UPRCL_AUTOSTART=1
    volumes:
      - ./cache:/cache
      - ./log:/log
      - /mnt/drive1/music:/uprcl/mediadirs/music1:ro
      - /mnt/drive2/music:/uprcl/mediadirs/music2:ro
      - ./config/uprclconfdir:/uprcl/confdir
      - ./config/upmpdcli/additional-radio-list.txt:/user/config/additional-radio-list.txt:ro
    labels:
      - com.centurylinklabs.watchtower.enable=false
    restart: unless-stopped
```

Note that we are showing how to use multiple directories as media directories under volume `/uprcl/mediadirs`. Of course this is not mandatory, you might have just one volume instead of two if you don't need to combine multiple directories.  

### Radio Server

A simple radio server configuration:

```text
---
version: "3"

services:
  upmpdcli-radio:
    image: giof71/upmpdcli
    container_name: upmpdcli-radio
    network_mode: host
    environment:
      - RENDERER_MODE=NONE
      - FRIENDLY_NAME=upmpd-radio
      - UPRCL_ENABLE=yes
      - UPRCL_USER=upmpdcli-library
      - UPRCL_AUTOSTART=1
      - LOG_ENABLE=yes
      - LOG_LEVEL=2
    volumes:
      - ./uprclconfdir:/uprcl/confdir
      - ./config/additional-radio-list.txt:/user/config/additional-radio-list.txt:ro
      - ./cache:/cache
      - ./log:/log
    restart: unless-stopped
```

This configuration disables the renderers (`RENDERER_MODE=NONE`), but this is not mandatory.  
When you disable renderers, you are essentially creating a pure upnp/dlna server.

### Subsonic Server

A simple upmpdcli instance for a Subsonic server:

```text
---
version: "3"

services:
  upmpdcli:
    image: giof71/upmpdcli
    container_name: upmpdcli-subsonic
    network_mode: host
    environment:
      - RENDERER_MODE=NONE
      - FRIENDLY_NAME=upmpdcli-subsonic
      - SUBSONIC_ENABLE=yes
      - SUBSONIC_BASE_URL=${SUBSONIC_BASE_URL}
      - SUBSONIC_PORT=${SUBSONIC_PORT}
      - SUBSONIC_USER=${SUBSONIC_USER}
      - SUBSONIC_PASSWORD=${SUBSONIC_PASSWORD}
      - SUBSONIC_DOWNLOAD_PLUGIN=yes
      - SUBSONIC_PLUGIN_BRANCH=next-subsonic
      - SUBSONIC_FORCE_CONNECTOR_VERSION=0.2.6
    volumes:
      - ./cache:/cache
    restart: unless-stopped
```

The configuration assumes the credentials to be stored in the `.env` file.

### Radio Paradise

A simple upmpdcli instance for accessing Radio Paradise webradios:

```text
---
version: "3"

services:
  upmpdcli:
    image: giof71/upmpdcli:latest
    container_name: upmpdcli-radio-paradise
    network_mode: host
    environment:
      - RENDERER_MODE=NONE
      - FRIENDLY_NAME=Radio Paradise (upmpdcli)
      - CHECK_CONTENT_FORMAT=yes
      - RADIO_PARADISE_ENABLE=yes
      - RADIO_PARADISE_DOWNLOAD_PLUGIN=yes
      - RADIO_PARADISE_PLUGIN_BRANCH=latest-radio-paradise
    restart: unless-stopped
```

### Mother Earth Radio

A simple upmpdcli instance for accessing Mother Earth Radio webradios:

```text
---
version: "3"

services:
  upmpdcli:
    image: giof71/upmpdcli:latest
    container_name: upmpdcli-mother-earth-radio
    network_mode: host
    environment:
      - RENDERER_MODE=NONE
      - FRIENDLY_NAME=Mother Earth Radio (upmpdcli)
      - CHECK_CONTENT_FORMAT=yes
      - MOTHER_EARTH_RADIO_ENABLE=yes
      - MOTHER_EARTH_RADIO_DOWNLOAD_PLUGIN=yes
      - MOTHER_EARTH_RADIO_PLUGIN_BRANCH=latest-radio-paradise
    restart: unless-stopped
```

### Streaming Services

#### Tidal

A simple upmpdcli instance for streaming Tidal:

```text
---
version: "3"

services:
  upmpdcli:
    image: giof71/upmpdcli:latest
    container_name: upmpdcli-tidal
    network_mode: host
    environment:
      - RENDERER_MODE=NONE
      - FRIENDLY_NAME=Tidal (upmpdcli)
      - TIDAL_ENABLE=yes
      - TIDAL_TOKEN_TYPE=${TIDAL_TOKEN_TYPE}
      - TIDAL_ACCESS_TOKEN=${TIDAL_ACCESS_TOKEN}
      - TIDAL_REFRESH_TOKEN=${TIDAL_REFRESH_TOKEN}
      - TIDAL_EXPIRY_TIME=${TIDAL_EXPIRY_TIME}
      - TIDAL_AUDIO_QUALITY=${TIDAL_AUDIO_QUALITY}
      - TIDAL_DOWNLOAD_PLUGIN=yes
      - TIDAL_PLUGIN_BRANCH=latest-tidal
    volumes:
      - ./cache:/cache
    restart: unless-stopped
```

Remember to use a volume for the `/cache` volume, so that the collected playback statistics will be preserved even when the container is recreated.  
Refer to the section "Obtain Tidal credentials" in the [README.md](https://github.com/GioF71/upmpdcli-docker/blob/main/README.md) for more information on how to retrieve your set of Tidal credentials.  
Please note that this plugin is still not working, we need to wait the next release of upmpdcli because of some required changes. I will update the documentation as this happens.  

#### Qobuz

A simple upmpdcli instance for streaming Qobuz:

```text
---
version: "3"

services:
  upmpdcli-streaming-services:
    image: giof71/upmpdcli
    container_name: upmpdcli-streaming-services
    network_mode: host
    environment:
      - RENDERER_MODE=NONE
      - FRIENDLY_NAME=upmpd-streaming-services
      - QOBUZ_ENABLE=yes
    volumes:
      - ./config/uprclconfdir:/uprcl/confdir
      - ./config/credentials/qobuz.txt:/user/config/qobuz.txt:ro
    labels:
      - com.centurylinklabs.watchtower.enable=false
    restart: unless-stopped
```

The `qobuz.txt` file should resemble the following:

```text
QOBUZ_USERNAME=qobuz-username
QOBUZ_PASSWORD=qobuz-password
QOBUZ_FORMAT_ID=27
```

Alternatively, those values can be passed as individual environment variables.  

