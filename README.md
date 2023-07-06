# upmpdcli-docker

A Docker image for upmpdcli.  
Now with support for custom radios, [radio-browser.info](https://www.radio-browser.info/), and [subsonic servers](https://github.com/navidrome/navidrome/discussions/2324).

## Reference

First and foremost, the reference to the awesome project:

[An UPnP Audio Media Renderer based on MPD](https://www.lesbonscomptes.com/upmpdcli/).  
Current version is `1.8.1`.  

## News

### SubSonic

From release 2023-04-19, support for the SubSonic plugin has been introduced.  
I am now a contributor to upmpdcli for this plugin. See the git repository [here](https://framagit.org/medoc92/upmpdcli).  
The plugin uses my [subsonic-connector](https://github.com/GioF71/subsonic-connector) library which in turn is built around [py-sonic](https://github.com/crustymonkey/py-sonic).  
Everything has been developed and tested against [Navidrome](https://www.navidrome.org/) but should work with other servers hopefully.  
See [this](https://github.com/navidrome/navidrome/discussions/2324) discussion on the Navidrome repo for updates and further information.  
The current version of the image includes Subsonic Plugin version `0.2.0`.  

### Scrobbling

I have prepared a docker container for [Yams, Yet Another MPD Scrobbler](https://github.com/Berulacks/yams). [Here](https://github.com/GioF71/yams-docker/) is the repository.  
This is the first scrobbler, to my knowledge, to be working correctly with upmpdcli.

### Support for Radio Browser

Since `2023-02-26`, I have added support for the new Radio-Browser media server available in upmpdcli.  
See [here](https://www.lesbonscomptes.com/upmpdcli/upmpdcli-manual.html#UPMPDCLI-MS-RADIO-BROWSER) for more details.

### Streaming to Kodi enhanced

Starting with release `1.6.2`, included in this container image since `2022-12-12`, Kodi support is considerably improved. Upmpdcli (in media server mode) can now stream hi-res from Qobuz as well as it can stream Internet Radios. Configuration examples are available [here](https://github.com/GioF71/upmpdcli-docker/blob/main/doc/example-configurations.md).

## Links

Source: [GitHub](https://github.com/giof71/upmpdcli-docker)  
Images: [DockerHub](https://hub.docker.com/r/giof71/upmpdcli)

## Why

I prepared this Dockerfile Because I wanted to be able to install upmpdcli easily on any machine (provided the architecture is amd64 or arm). Also I wanted to be able to configure and govern the parameter easily, maybe through a webapp like Portainer.

## Prerequisites

### Docker

You need to have Docker up and running on a Linux machine, and the current user must be allowed to run containers (this usually means that the current user belongs to the "docker" group).

You can verify whether your user belongs to the "docker" group with the following command:

`getent group | grep docker`

This command will output one line if the current user does belong to the "docker" group, otherwise there will be no output.

### MPD

You will also need a running instance of `mpd` (Music Player Daemon) on your network.  
You might consider using my `mpd-alsa` docker image, at the following links:

Repository|Type|Link
:---|:---|:---
mpd-alsa-docker|Source Code|[GitHub](https://github.com/giof71/mpd-alsa-docker)  
mpd-alsa|Docker Images|[DockerHub](https://hub.docker.com/r/giof71/mpd-alsa)

### Supported platforms

The Dockerfile and the scripts included in this repository have been tested on the following distros:

- Manjaro Linux with Gnome (amd64)
- Asus Tinkerboard
- Raspberry Pi 3 and 4, both 32 and 64 bit

As I test the Dockerfile on more platforms, I will update this list.

## Get the image

Here is the [repository](https://hub.docker.com/repository/docker/giof71/upmpdcli) on DockerHub.

Getting the image from DockerHub is as simple as typing:

`docker pull giof71/upmpdcli:stable`

You may want to pull the "stable" image as opposed to the "latest".

### Image Versions

Since version 2023-07-04, we have dedicated images for renderer-only mode.  
If you select any of those images (which have `-renderer` appended to the tag), mediaserver functionalities will not be available.  
The `renderer` images are currently about 8x smaller in size, and thus pulling and decompressing is much faster.  
Please find a list of the currently built images in the following table.

Base Image|Build Mode|Tags
:---|:---:|:---
ubuntu:jammy|full|`stable` `lts` `jammy` `daily-jammy`
ubuntu:jammy|renderer|`stable-renderer` `current-renderer` `lts-renderer` `jammy-renderer` `daily-jammy-renderer`
ubuntu:lunar|full|`latest` `current` `lunar` `daily-lunar`
ubuntu:lunar|renderer|`latest-renderer` `current-renderer` `lunar-renderer` `daily-lunar-renderer`

## Usage

Say your mpd host is "mpd.local", you can start upmpdcli by typing

`docker run -d --rm --net host -e MPD_HOST:mpd.local giof71/upmpdcli:stable`

Note that we have used the *MPD_HOST* environment variable so that upmpdcli can use the mpd instance running on *mpd.local*.

We also need to use the *host* network so the upnp renderer can be discovered on your network.

### Check upmpdcli version

You can display the version of the upmpdcli binary using the following command:

```text
docker run --rm -i --entrypoint /app/bin/get-version.sh giof71/upmpdcli:latest
```

This will show the output of `upmpdcli -v`.  
You will get an output similar to the following:

```text
Upmpdcli 1.8.1 libupnpp 0.23.0
```

Alternatively, you can run get-version-ext.sh for a more extended output:

```text
docker run --rm -i --entrypoint /app/bin/get-version-ext.sh giof71/upmpdcli:latest
```

which will use the `--version` switch of the upmpdcli command line.  

### Environment variables

The following table reports all the currently supported environment variables.

VARIABLE|DEFAULT|NOTES
---|:---:|---
PUID||User id. Used when UPRCL is enabled. Defaults to `1000` when required
PGID||Group id. Used when UPRCL is enabled. Defaults to `1000` when required
MPD_HOST||The host where mpd runs, defaults to `localhost`
MPD_PORT||The port used by mpd, defaults to `6600`
UPRCL_HOSTPORT||Set if we own the MPD queue, defaults to `1`, possible values `1` and `0`
PORT_OFFSET||If set, the offset is applied to the default for `UPNP_PORT` (summed) and to the default `PLG_MICRO_HTTP_PORT` (subtracted). Setting this variable overrides these individual variables.
UPNPIFACE||UPnP network interface
UPNPPORT||UPnP port
UPMPD_FRIENDLY_NAME|upmpd|Name of the upnp renderer (OpenHome)
AV_FRIENDLY_NAME|upmpd-av|Name of the upnp renderer (UPnP AV mode)
FRIENDLY_NAME||Name of the renderer, overrides `UPMPD_FRIENDLY_NAME`, `AV_FRIENDLY_NAME` and `MEDIA_SERVER_FRIENDLY_NAME`. The variable `AV_FRIENDLY_NAME` is appended with the postfix `UPNPAV_POSTFIX`, unless UPNPAV is the only enabled renderer. See `UPNPAV_POSTFIX` and `UPNPAV_SKIP_NAME_POSTFIX` for more details.
RENDERER_MODE||If set, this variable overrides `UPNPAV` and `OPENHOME`. Possible values are `NONE`, `OPENHOME`, `UPNPAV` and `BOTH`
UPNPAV||Enable UPnP AV services (`0`/`1`), defaults to `0`
UPNPAV_POSTFIX||The postfix to be appended to the `FRIENDLY_NAME`, defaults to `(av)`
UPNPAV_POSTFIX_PREPEND_SPACE||Option to add a space before a custom `UPNPAV_POSTFIX`, enabled by default. Set to `no` di disable
UPNPAV_SKIP_NAME_POSTFIX||If not set or set to `yes`, and if only `UPNPAV` renderer is enabled, the `UPNPAV_POSTFIX` postfix is not appended to `FRIENDLY_NAME`
OPENHOME||Enable OpenHome services (`0`/`1`), defaults to `1`
OH_PRODUCT_ROOM||Sets `ohproductroom`, defaults to same value calculated for AV_FRIENDLY_NAME if upnp-av is enabled
UPRCL_ENABLE||Enable local music support (uprcl). Set to `yes` to enable
RADIO_BROWSER_ENABLE||Enable the Radio Browser plugin. Set to `yes` to enable
SUBSONIC_ENABLE||Enable the Subsonic plugin. Set to `yes` to enable
SUBSONIC_AUTOSTART||Autostart SubSonic plugin if set to `1`
SUBSONIC_BASE_URL||SubSonic base url. Example: `http://my_navidrome.homelab.local`
SUBSONIC_PORT||SubSonic port, defaults to `4533`
SUBSONIC_USER||SubSonic username
SUBSONIC_PASSWORD||SubSonic password
SUBSONIC_ITEMS_PER_PAGE||Number of items per page, defaults to `100`
SUBSONIC_APPEND_YEAR_TO_ALBUM||If set to `yes` (default), the album year is appended to the album
SUBSONIC_APPEND_CODECS_TO_ALBUM||If set to `yes` (default), the codecs for the album are appended to the album unless all codecs are in the white list
SUBSONIC_WHITELIST_CODECS||List of comma-separated whitelist (ideally lossless) codecs. Defaults to `alac,wav,flac,dsf`
SUBSONIC_DOWNLOAD_PLUGIN||If set to `YES`, the updated plugin is downloaded from the upstream repo
SUBSONIC_PLUGIN_BRANCH||If `SUBSONIC_DOWNLOAD_PLUGIN`, the branch indicated by this variable will be used. Must be specified if enabling `SUBSONIC_DOWNLOAD_PLUGIN`
UPRCL_AUTOSTART||Autostart UPRCL if set to `1`
UPCRL_USER||User for uprcl
UPRCL_HOSTPORT||Hostname and port for uprcl. Currently required when enabling UPRCL. Format: `<ip:port>`. Example value: `192.168.1.8:9090`.
UPRCL_TITLE|Local Music|Title for the media server
ENABLE_UPRCL||Enable local music support (uprcl). Set to `yes` to enable (Deprecated, use UPRCL_ENABLE)
PLG_MICRO_HTTP_HOST||IP for the tidal/qobuz local HTTP service.
PLG_MICRO_HTTP_PORT||Port for the tidal/qobuz local HTTP service.
MEDIA_SERVER_FRIENDLY_NAME||Friendly name for the Media Server
TIDAL_ENABLE|no|Set to yes to enable Tidal support
TIDAL_USERNAME|tidal_username|Your Tidal account username
TIDAL_PASSWORD|tidal_password|Your Tidal account password
TIDAL_API_TOKEN|tidal_api_token|Your Tidal account API token
TIDAL_QUALITY|low|Tidal quality: low, high, lossless
QOBUZ_ENABLE|no|Set to yes to enable Qobuz support
QOBUZ_USERNAME|qobuz_username|Your Qobuz account username
QOBUZ_PASSWORD|qobuz_password|Your Qobuz account password
QOBUZ_FORMAT_ID|5|Qobuz format id: 5 for mp3, 7 for FLAC, 27 for hi-res
DEEZER_ENABLE|no|Set to yes to enable Deezer support
DEEZER_USERNAME|deezer_username|Your Deezer account username
DEEZER_PASSWORD|deezer_password|Your Deezer account password
HRA_ENABLE|no|Set to yes to enable HRA support
HRA_USERNAME|hra_username|Your HRA account username
HRA_PASSWORD|hra_password|Your HRA account password
HRA_LANG|hra_lang|Your HRA account language
LOG_ENABLE||Set to `yes` to enable. If enabled, the logfile is `/log/upmpdcli.log`. Otherwise, umpdcli will log to stderr.
LOG_LEVEL||Defaults to `2`
DUMP_ADDITIONAL_RADIO_LIST||Dumps the additional radio file when set to `yes`
STARTUP_DELAY_SEC|0| Delay before starting the application. This can be useful if your container is set up to start automatically, so that you can resolve race conditions with mpd and with squeezelite if all those services run on the same audio device. I experienced issues with my Asus Tinkerboard, while the Raspberry Pi has never really needed this. Your mileage may vary. Feel free to report your personal experience.

### Volumes

Volume|Description
:---|:---
/uprcl/confdir|Uprcl configuration directory
/uprcl/mediadirs|Uprcl media directories
/user/config|Location for additional files. Currently: `additional-radio-list.txt` and `recoll.conf.user` as well as credentials for qobuz on `qobuz.txt`, for tidal on `tidal.txt`, for deezer on `deezer.txt`, for hra on `hra.txt`. The credentials file format is the same as a `.env` file. Ensure to include all the settings related the streaming service.
/cache|Runtime information for upmpdcli. Attach a volume to this path in order to maintain consistency across restarts.
/log|Location for the upmpdcli log file. Enabled using `LOG_ENABLE`

### Additional Radio file

You can add your custom radios to upmpdcli.
Mount the volume `/user/config` and make a file named `additional-radio-list.txt` available.  
Each entry in the file must follow this schema:

```text
[radio My Radio]
url = http://some.host/some/path.pls
artUrl = http://some.host/icon/path.png
artScript = /path/to/script/dynamic-art-getter
metaScript = /path/to/script/metadata-getter
preferScript = 1
```

Only the `url` line is mandatory.  
Refer to the file [radiolist.conf](https://github.com/GioF71/upmpdcli-docker/blob/main/app/reference/radiolist.conf) from the git repository for further details.

## Usage examples

A few usage examples are available [here](https://github.com/GioF71/upmpdcli-docker/blob/main/doc/example-configurations.md).

## Build

You can build (or rebuild) the image by opening a terminal from the root of the repository and issuing the following command:

`docker build . -t giof71/upmpdcli`

It will take very little time even on a Raspberry Pi. When it's finished, you can run the container following the previous instructions.  
Just be careful to use the tag you have built.

## Change History

Change Date|Major Changes
---|---
2023-07-05|Install individual upmpdci packages (see issue [#214](https://github.com/GioF71/upmpdcli-docker/issues/214))
2023-07-05|Remove old radio patch (see issue [#212](https://github.com/GioF71/upmpdcli-docker/issues/212))
2023-07-05|Reuse existing user that should exist in the base image (see issue [#194](https://github.com/GioF71/upmpdcli-docker/issues/194))
2023-07-04|Support for `lunar` for real this time (see issue [#209](https://github.com/GioF71/upmpdcli-docker/issues/209))
2023-07-04|Install python packages only when needed (see issue [#206](https://github.com/GioF71/upmpdcli-docker/issues/206))
2023-07-04|Set `latest` tag to `lunar` builds, leave `stable` to `jammy` (see issue [#204](https://github.com/GioF71/upmpdcli-docker/issues/204))
2023-07-04|Dedicated builds for `renderer` mode (see issue [#199](https://github.com/GioF71/upmpdcli-docker/issues/199))
2023-07-02|Back to installing python packages at container startup (see issue [#196](https://github.com/GioF71/upmpdcli-docker/issues/196))
2023-06-30|Add support for `lunar` (see issue [#193](https://github.com/GioF71/upmpdcli-docker/issues/193))
2023-06-30|Remove binary version from image tags (see issue [#190](https://github.com/GioF71/upmpdcli-docker/issues/190))
2023-06-30|Add entrypoints for inspecting version (see issue [#188](https://github.com/GioF71/upmpdcli-docker/issues/188)
2023-06-27|Update to Upmpdcli version 1.8.1 (see issue [#183](https://github.com/GioF71/upmpdcli-docker/issues/183))
2023-06-21|Changed default for `UPNPAV_POSTFIX` (see issue [#181](https://github.com/GioF71/upmpdcli-docker/issues/181))
2023-06-21|Bump subsonic-connector to version 0.1.17 (see issue [#179](https://github.com/GioF71/upmpdcli-docker/issues/179))
2023-06-19|Avoid package upgrade (see issue [#176](https://github.com/GioF71/upmpdcli-docker/issues/176))
2023-06-19|Add support for custom av postfix (see issue [#174](https://github.com/GioF71/upmpdcli-docker/issues/174))
2023-06-07|Bump subsonic-connector to version 0.1.16 (see issue [#166](https://github.com/GioF71/upmpdcli-docker/issues/166))
2023-05-23|Bump subsonic-connector to version 0.1.15 (see issue [#162](https://github.com/GioF71/upmpdcli-docker/issues/162))
2023-05-20|Bump subsonic-connector to version 0.1.14 (see issue [#159](https://github.com/GioF71/upmpdcli-docker/issues/159))
2023-05-09|Bump subsonic-connector to version 0.1.11 (see issue [#157](https://github.com/GioF71/upmpdcli-docker/issues/157))
2023-04-25|Add support for OH Product Room (see issue [#153](https://github.com/GioF71/upmpdcli-docker/issues/153))
2023-04-24|Bugfix: see issue [#151](https://github.com/GioF71/upmpdcli-docker/issues/151)
2023-04-22|Add support for downloading updated subsonic plugin (see issue [#148](https://github.com/GioF71/upmpdcli-docker/issues/148))
2023-04-19|Add support for the new subsonic plugin (see issue [#140](https://github.com/GioF71/upmpdcli-docker/issues/140))
2023-04-05|Add support for `OWN_QUEUE` (see issue [#138](https://github.com/GioF71/upmpdcli-docker/issues/138))
2023-03-24|Update to Upmpdcli version 1.7.7
2023-02-27|Removed defaults for `UPNPAV` and `OPENHOME` from Dockerfile
2023-02-26|Add support for Radio Browser (`RADIO_BROWSER_ENABLE`)
2023-02-25|Renamed ENABLE_UPRCL to UPRCL_ENABLE
2023-02-25|Update to Upmpdcli version 1.7.2
2022-12-23|Removed Spotify support (see [here](https://framagit.org/medoc92/upmpdcli/-/commit/43aa55d70fe6378ee7f0c65bfb4b90602334cd1c))
2022-12-18|Upmpdcli version is still `1.6.2`, my mistake
2022-12-18|Restored `Internet Radio` patch
2022-12-18|Remove `Internet Radio` patch created `2022-12-14`
2022-12-18|Upmpdcli version bump to `1.6.3`
2022-12-16|Moved mandatory variables on top of config file
2022-12-16|Usage examples provided
2022-12-14|Radio support metadata value `Internet Radio` for kodi
2022-12-12|Support for building with `kinetic` as the base image
2022-12-12|Upmpdcli version bump to `1.6.2`
2022-12-09|Minor maintenance tasks
2022-12-07|Option for dumping additional radio list
2022-12-07|Support `RENDERER_MODE` for easier renderer configuration
2022-12-07|New `UPNPAV_SKIP_NAME_POSTFIX` allows to avoid `-av` postfix
2022-11-28|Version bump to `1.6.1` for docker tags
2022-11-28|Fixed logging (was using wrong variable)
2022-11-23|Add `HRA` support
2022-11-23|Add `Deezer` support
2022-11-23|Add `Spotify` support
2022-11-22|Fixed permissions for `/cache` in user mode
2022-11-22|Undocumented volume `/var/cache/upmpdcli` changed to `/cache` for convenience
2022-11-22|Enable logging configurability, relevant volume is `/log`
2022-11-20|Enable configuration for `msfriendlyname` only when necessary
2022-11-20|Enable configuration for `friendlyname` only when `openhome` is enabled
2022-11-19|`FRIENDLY_NAME` simplified
2022-11-19|Also apply `FRIENDLY_NAME` to `MEDIA_SERVER_FRIENDLY_NAME`
2022-11-19|Add ability to read qobuz and tidal configuration from files
2022-11-18|Add PORT_OFFSET environment variable for easier configuration
2022-11-13|Upnp av services are disabled by default
2022-11-13|Add env variable `FRIENDLY_NAME`
2022-11-04|Support for uprclconfrecolluser when `recoll.conf.user` file is available
2022-10-31|Support for additional radio list
2022-10-26|Added `exiftool` package
2022-10-26|Support for local build with experimental ppa (exp5)
2022-10-25|Updated github actions
2022-10-25|Added support for `msfriendlyname` (`MEDIA_SERVER_FRIENDLY_NAME`)
2022-10-25|Added support for `PLG_MICRO_HTTP_HOST` and `PLG_MICRO_HTTP_PORT`
2022-10-04|Added support for `UPRCL_AUTOSTART` (`uprclautostart`)
2022-10-03|Added support for Uprcl
2022-09-30|Dropped focal build (due to a build error, to be investigated)
2022-09-30|Build process review: build enabled on tag push
2022-09-26|Moved file 01proxy to app/conf
2022-09-26|Build process reviewed
2022-09-26|Restored Qobuz and Tidal placeholders ([issue #5](https://github.com/GioF71/upmpdcli-docker/issues/5))
2022-09-25|New environment variables & cleanup
2022-03-12|Ubuntu version bump, fixed build-arg for base-image
2022-02-11|Reduced docker image sizes (installation process is now in one line).
2022-02-11|Add README.md to the image in the directory `/app/doc`.
2022-02-07|Automated builds, largely inspired to the work from [Der-Henning](https://github.com/Der-Henning/) for [this](https://github.com/GioF71/squeezelite-docker) repository.
