# upmpdcli-docker

A Docker image for upmpdcli.  
There is built-in support for [Tidal](https://tidal.com/), [Qobuz](https://www.qobuz.com/), [subsonic servers](https://github.com/navidrome/navidrome/discussions/2324), [RadioBrowser](https://www.radio-browser.info/), [Radio Paradise](https://radioparadise.com/), [Mother Earth Radio](https://motherearthradio.de/), and custom radios.  
A few screenshots for the subsonic plugin on [Kazoo](https://github.com/GioF71/upmpdcli-docker/tree/main/doc/screenshots/kazoo) and [Upplay](https://github.com/GioF71/upmpdcli-docker/tree/main/doc/screenshots/upplay) are now available.  

## Support

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/H2H7UIN5D)  
Please see the [Goal](https://ko-fi.com/giof71/goal?g=0).  
Please note that support goal is limited to cover running costs for subscriptions to music services.

## Latest Build

[![Publish Docker Images](https://github.com/GioF71/upmpdcli-docker/actions/workflows/docker-multi-arch.yml/badge.svg)](https://github.com/GioF71/upmpdcli-docker/actions/workflows/docker-multi-arch.yml)

## Reference

First and foremost, the reference to the awesome project:

[An UPnP Audio Media Renderer based on MPD](https://www.lesbonscomptes.com/upmpdcli/).  
Current version is `1.9.5`.  

## News (newest first)

### Download variables deprecated

We can now avoid to download plugin at runtime. Just use updated master/edge images (see below).  

### New 'master' and 'edge' builds

As we are now building from source, it is easy to build images that are up-to-date with the upstream branchs.  
Such images are [here](https://hub.docker.com/r/giof71/upmpdcli/tags?name=master).  
See the following table for the versions of the plugins in the various images:

BUILD_TYPE|PLUGIN|VERSION
:---|:---|:---
release|subsonic|0.8.1
release|tidal|0.8.6
master|subsonic|0.8.1
master|tidal|0.8.6
edge|subsonic|0.8.2
edge|tidal|0.8.6

### Support for HiRes Tidal

Good news, Tidal HiRes is now available.  
You need to consider that there is a limitation: only the mpd/upmpdcli combination and gmrender-resurrect work properly as renderers with the Tidal plugin using HI_RES_LOSSLESS quality mode, AFAIK. Other players will still play, but will fallback to standard (LOSSLESS) quality. We are leveraging [this change](https://framagit.org/medoc92/upmpdcli/-/commit/2c742f13eb81c4fd1bf3270fa24877e04aadbaed) for the implementation of this feature.  
With the latest `master` and `edge` images though, we should be able to stream Tidal in HiRes at least also to the WiiM Pro and WiiM Pro Plus.  
If there are users, owning some other commercial streamers, who are willing to try the Tidal Plugin with user-agent whitelisting disabled `TIDAL_ENABLE_USER_AGENT_WHITELIST=no` and see if their devices are compliant, we might be able to find and properly whitelist such streamers.  
A simple installation guide for a mediaserver upmpdcli instance for Tidal Hires is [here](https://github.com/GioF71/audio-tools/blob/main/media-servers/tidal-hires/README.md).  

### Subsonic Plugin compatibility

The `latest-subsonic` branch of the subsonic plugin, which is used with the recently updated [suggested configurations](https://github.com/GioF71/upmpdcli-docker/blob/main/doc/example-configurations.md#subsonic-server), provides good compatibility with [Navidrome](https://github.com/navidrome/navidrome), [Lightweight Music Server](https://github.com/epoupon/lms)) and [Gonic](https://github.com/sentriz/gonic).  
Just a quick reminder, with Lightweight Media Server you will need to enable subsonic legacy authentication using the new variable `SUBSONIC_LEGACYAUTH`.  
Thanks to the respective authors for having helped me integrating their servers more easily.

### Mother Earth Radio

We have a new Mother Earth Radios plugin for upmpdcli. I have contributed it to upmpdcli. See the git repository forks [here](https://framagit.org/medoc92/upmpdcli) and [here](https://codeberg.org/GioF71/upmpdcli).  
This plugin has no additional dependencies. See the [configuration example](https://github.com/GioF71/upmpdcli-docker/blob/main/doc/example-configurations.md#mother-earth-radio) for information on how to create a container which will run this plugin.  

### Radio Paradise

We have a new Radio Paradise plugin for upmpdcli. I have contributed it to upmpdcli. See the git repository forks [here](https://framagit.org/medoc92/upmpdcli) and [here](https://codeberg.org/GioF71/upmpdcli).  
This plugin has no additional dependencies. See the [configuration example](https://github.com/GioF71/upmpdcli-docker/blob/main/doc/example-configurations.md#radio-paradise) for information on how to create a container which will run this plugin.  

### Tidal support is back

We have a new, updated Tidal plugin for upmpdcli. I have contributed it to upmpdcli. See the git repository forks [here](https://framagit.org/medoc92/upmpdcli) and [here](https://codeberg.org/GioF71/upmpdcli).  
See the [news](https://www.lesbonscomptes.com/upmpdcli/#news) section in the upmpdcli main page.  
The plugin is built around [python-tidal](https://github.com/tamland/python-tidal).  
Building this plugin would not have been possible without this library, so a big thank you goes to [its author](https://github.com/tamland).  
Also, once again, a big thank you to the upmpdcli author for the support he has provided to help me build this plugin.  
Remember, this is not, in any way, supported by Tidal. It might stop working at any moment. Consider alternatives as [BubbleUPnP](https://play.google.com/store/apps/details?id=com.bubblesoft.android.bubbleupnp), [mConnect Lite](https://play.google.com/store/apps/details?id=com.conversdigital) (also available on iOS/iPadOS) or similar software which are, to my knowledge, officially supported by Tidal.  
Thanks to the advancements in the underlying library, you will be able to generate your own set of credentials from a valid username/password combination.  
A premium account of Tidal will be strictly required.  

### BBC

Since release 2023-07-05, support the upmpdcli [`BBC Sounds`](https://www.lesbonscomptes.com/upmpdcli/pages/upmpdcli-manual.html#UPMPDCLI-MS-BBC) plugin has been enabled.

### Radios

Since release 2023-07-05, support the upmpdcli [`Upradios radio list`](https://www.lesbonscomptes.com/upmpdcli/pages/upmpdcli-manual.html#UPMPDCLI-MS-UPRADIOS) plugin has been enabled.

### Subsonic

Since release 2023-04-19, support for the [`Subsonic plugin`](https://www.lesbonscomptes.com/upmpdcli/pages/upmpdcli-manual.html#UPMPDCLI-MS-SUBSONIC) has been introduced.  
I am now a contributor to upmpdcli for this plugin. See the git repository forks [here](https://framagit.org/medoc92/upmpdcli) and [here](https://codeberg.org/GioF71/upmpdcli).  
The plugin uses my [subsonic-connector](https://github.com/GioF71/subsonic-connector) library which in turn is built around [py-sonic](https://github.com/crustymonkey/py-sonic).  
Everything has been developed and tested against [Navidrome](https://www.navidrome.org/) but should work with other servers hopefully.  
See [this](https://github.com/navidrome/navidrome/discussions/2324) discussion on the Navidrome repo for updates and further information.  
The current version of the image includes Subsonic Plugin version `0.6.3`.  
If you use upmpdcli as a renderer for this plugin, you might probably want to setup a scrobbler, so that the Subsonic server can keep track of what you are playing. See [this](https://github.com/GioF71/mpd-subsonic-scrobbler) repository for more details.  

### Scrobbling

I have prepared a docker container for [Yams, Yet Another MPD Scrobbler](https://github.com/Berulacks/yams). [Here](https://github.com/GioF71/yams-docker/) is the repository.  
This is the first scrobbler, to my knowledge, to be working correctly with upmpdcli.

### Support for Radio Browser

Since `2023-02-26`, I have added support for the new Radio-Browser media server plugin.  
See [here](https://www.lesbonscomptes.com/upmpdcli/upmpdcli-manual.html#UPMPDCLI-MS-RADIO-BROWSER) for more details.

### Streaming to Kodi enhanced

Starting with release `1.6.2`, (since release `2022-12-12`), Kodi support is improved. Upmpdcli as a media server can now stream hi-res from Qobuz/Tidal as well as Internet Radios. Configuration examples are available [here](https://github.com/GioF71/upmpdcli-docker/blob/main/doc/example-configurations.md).

## Links

REPOSITORY TYPE|LINK
:---|:---
Git Repository|[GitHub](https://github.com/GioF71/upmpdcli-docker)
Docker Images|[Docker Hub](https://hub.docker.com/r/giof71/upmpdcli)

## Why

I prepared this Dockerfile Because I wanted to be able to install upmpdcli easily on any machine (provided the architecture is amd64 or arm). Also I wanted to be able to configure and govern the parameter easily, maybe through a webapp like Portainer.

## Prerequisites

### Docker

You need to have Docker up and running on a Linux machine, and the current user must be allowed to run containers (this usually means that the current user belongs to the "docker" group).

You can verify whether your user belongs to the "docker" group with the following command:

`getent group | grep docker`

This command will output one line if the current user does belong to the "docker" group, otherwise there will be no output.

### MPD

If you want to create a upnp/dlna renderer with upmpdcli, you will also need a running instance of `mpd` (Music Player Daemon) on your network.  
You might consider using my `mpd-alsa` docker image, at the following links:

Repository|Type|Link
:---|:---|:---
mpd-alsa-docker|Source Code|[GitHub](https://github.com/giof71/mpd-alsa-docker)  
mpd-alsa|Docker Images|[DockerHub](https://hub.docker.com/r/giof71/mpd-alsa)

Of course the creation of a *media server only* instance of upmpdcli does not require a running instance of `mpd`.  

### Supported platforms

The Dockerfile and the scripts included in this repository have been tested on the following distros:

- Generic Linux (amd64)
- Asus Tinkerboard
- Raspberry Pi 3/4, 32/64bit

## Get the image

Getting the image from [Docker Hub](https://hub.docker.com/r/giof71/upmpdcli) is as simple as typing:

`docker pull giof71/upmpdcli`

### Image Versions

Since version 2023-07-04, we have images for renderer-only mode.  
Those images (which have `-renderer` appended to the tag) will not have support for mediaserver functionalities.  
The `renderer` images are currently about 8x smaller in size.  
Please find a list of the currently built images in the following table.

Base Image|Build Mode|Tags
:---|:---:|:---
ubuntu:noble|full|`latest` `latest-full` `stable` `stable-full` `ubuntu-lts-full` `noble-full` `daily-noble-full`
ubuntu:noble|renderer|`renderer` `latest-renderer` `stable-renderer` `ubuntu-lts-renderer` `noble-renderer` `daily-noble-renderer`
debian:bookworm-slim|full|`bookworm-full` `daily-bookworm-full`
debian:bookworm-slim|renderer|`bookworm-renderer` `daily-bookworm-renderer`

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

Replace `get-version.sh` with `get-version-ext.sh` for a more extended output.  

### Environment variables

The following table reports all the currently supported environment variables.

VARIABLE|NOTES
:---|:---
PUID|User id. Used when UPRCL is enabled. Defaults to `1000` when required
PGID|Group id. Used when UPRCL is enabled. Defaults to `1000` when required
MPD_HOST|The host where mpd runs, defaults to `localhost`
MPD_PORT|The port used by mpd, defaults to `6600`
MPD_PASSWORD|The password for the mpd connection
MPD_TIMEOUT_MS|MPD timeout in milliseconds
OWN_QUEUE|Set if we own the MPD queue, defaults to `1`, possible values `1` and `0`
PORT_OFFSET|If set, the offset is applied to the default for `UPNP_PORT` (summed) and to the default `PLG_MICRO_HTTP_PORT` (subtracted). Setting this variable overrides these individual variables.
UPNPIFACE|UPnP network interface
UPNPIP|IP V4 address to use for UPnP, alternative to using an interface name.
UPNPPORT|UPnP port
AUTO_UPNPIFACE_URL|Used by `ENABLE_AUTO_UPNPIFACE` and `ENABLE_AUTO_UPNPIP`, defaults to `1.1.1.1`
ENABLE_AUTO_UPNPIFACE|Allows to automatically set UPNPIFACE, defaults to `no`, but this does not override an explicitly set `UPNPIFACE` variable anyway
ENABLE_AUTO_UPNPIP|Allows to automatically set UPNPIP, defaults to `yes`, but this does not override an explicitly set `UPNPIP` variable anyway
CHECK_CONTENT_FORMAT|Set to `yes` to enable, see [here](https://www.lesbonscomptes.com/upmpdcli/pages/upmpdcli-manual.html#checkcontentformat)
UPMPD_FRIENDLY_NAME|Name of the upnp renderer (OpenHome), defaults to `upmpd`
AV_FRIENDLY_NAME|Name of the upnp renderer (UPnP AV mode), defaults to `upmpd-av`
FRIENDLY_NAME|Name of the renderer, overrides `UPMPD_FRIENDLY_NAME`, `AV_FRIENDLY_NAME` and `MEDIA_SERVER_FRIENDLY_NAME`. The variable `AV_FRIENDLY_NAME` is appended with the postfix `UPNPAV_POSTFIX`, unless UPNPAV is the only enabled renderer. See `UPNPAV_POSTFIX` and `UPNPAV_SKIP_NAME_POSTFIX` for more details.
RENDERER_MODE|If set, this variable overrides `UPNPAV` and `OPENHOME`. Possible values are `NONE`, `OPENHOME`, `UPNPAV` and `BOTH`
UPNPAV|Enable UPnP AV services (`0`/`1`), defaults to `0`
UPNPAV_POSTFIX|The postfix to be appended to the `FRIENDLY_NAME`, defaults to an empty string
UPNPAV_POSTFIX_PREPEND_SPACE|Option to add a space before a custom `UPNPAV_POSTFIX`, enabled by default. Set to `no` di disable
UPNPAV_SKIP_NAME_POSTFIX|If not set or set to `yes`, and if only `UPNPAV` renderer is enabled, the `UPNPAV_POSTFIX` postfix is not appended to `FRIENDLY_NAME`
OPENHOME|Enable OpenHome services (`0`/`1`), defaults to `1`
OH_PRODUCT_ROOM|Sets `ohproductroom`, defaults to same value calculated for AV_FRIENDLY_NAME if upnp-av is enabled
SKIP_CHOWN_CACHE|If set to yes, the script with not chown `/cache`, this ight be useful with plugins using lots of files in this volume
UPRCL_ENABLE|Enable local music support (uprcl). Set to `yes` to enable
UPRCL_AUTOSTART|Autostart UPRCL, defaults to `1`
UPRCL_USER|Username for `uprcl`
UPRCL_HOSTPORT|Hostname and port for uprcl. Currently required when enabling UPRCL. Format: `<ip:port>`. Example value: `192.168.1.8:9090`.
UPRCL_TITLE|Title for the media server, defaults to `Local Music`
ENABLE_OPENHOME_RADIO_SERVICE|OpenHome Radio Service, enabled by default, set to `no` to disable
ENABLE_UPRCL|Enable local music support (uprcl). Set to `yes` to enable (Deprecated, use UPRCL_ENABLE)
RADIOS_ENABLE|Enable Radios plugin. Set to `yes` to enable
RADIOS_TITLE|Title of the Radios plugin, defaults to `Upmpdcli Radio List`
RADIOS_AUTOSTART|Start Radios on startup, defaults to `1`
BBC_ENABLE|Enable BBC plugin. Set to `yes` to enable
BBC_PROGRAMME_DAYS|Past days in BBC Sounds catalog listing. This controls how many days are listed in the station displays.
RADIO_BROWSER_ENABLE|Enable the Radio Browser plugin. Set to `yes` to enable
SUBSONIC_ENABLE|Enable the Subsonic plugin. Set to `yes` to enable
SUBSONIC_TITLE|Title of the Subsonic plugin, defaults to `Subsonic`
SUBSONIC_AUTOSTART|Autostart Subsonic plugin, defaults to `1`
SUBSONIC_BASE_URL|Subsonic base url. Example: `http://my_navidrome.homelab.local`
SUBSONIC_PORT|Subsonic port, defaults to `4533`
SUBSONIC_SERVER_PATH|Subsonic server path, optional, specify only if needed
SUBSONIC_USER|Subsonic username
SUBSONIC_PASSWORD|Subsonic password
SUBSONIC_LEGACYAUTH|Subsonic legacy authentication, set to `yes` when using Lightweight Media Server (LMS) (requires subsonic-connector >= 0.2.6)
SUBSONIC_SERVER_SIDE_SCROBBLING|Subsonic server side scrobbling, set to `yes` if you want to enable
SUBSONIC_ITEMS_PER_PAGE|Number of items per page, defaults to `100`
SUBSONIC_APPEND_YEAR_TO_ALBUM_CONTAINER|If set to `yes` (default), the album year is appended to the album
SUBSONIC_APPEND_CODECS_TO_ALBUM|If set to `yes` (default), the codecs for the album are appended to the album unless all codecs are in the white list
SUBSONIC_PREPEND_NUMBER_IN_ALBUM_LIST|If set to `yes`, the album in albums list will be numbered, mostly for Kodi, defaults to `no`
SUBSONIC_WHITELIST_CODECS|List of comma-separated whitelist (ideally lossless) codecs. Defaults to `alac,wav,flac,dsf`
SUBSONIC_ENABLE_INTERNET_RADIOS|Set to `yes` to enable internet radios, disabled by default (requires plugin version >= 0.3.4)
SUBSONIC_ENABLE_IMAGE_CACHING|Set to `yes` to enable image caching, disabled by default (requires WEBSERVER_DOCUMENT_ROOT and plugin version >= 0.7.2)
SUBSONIC_DOWNLOAD_PLUGIN|If set to `yes`, the updated plugin is downloaded from the upstream repo
SUBSONIC_PLUGIN_BRANCH|If `SUBSONIC_DOWNLOAD_PLUGIN`, the branch indicated by this variable will be used. Must be specified if enabling `SUBSONIC_DOWNLOAD_PLUGIN`. Suggested branch name is `next-subsonic`, but the feature is now deprecated: use master images instead
SUBSONIC_FORCE_CONNECTOR_VERSION|If set, the specified version of subsonic-connector will be installed over the one included in the image
SUBSONIC_TRANSCODE_CODEC|If set, the value will be used as the transcode codec (requires subsonic-connector >= 0.2.6)
SUBSONIC_TRANSCODE_MAX_BITRATE|If set, the value will be used as the transcode max bitrate (requires subsonic-connector >= 0.2.6)
RADIO_PARADISE_ENABLE|Enable the Radio Paradise Plugin, set to `yes` to enable
RADIO_PARADISE_DOWNLOAD_PLUGIN|If set to `YES`, the updated plugin is downloaded from the upstream repo
RADIO_PARADISE_PLUGIN_BRANCH|If `RADIO_PARADISE_DOWNLOAD_PLUGIN` is set to `yes`, the branch indicated by this variable will be used. Must be specified if enabling `RADIO_PARADISE_DOWNLOAD_PLUGIN`. Suggested branch name is `latest-radio-paradise`, but the feature is now deprecated: use master images instead
MOTHER_EARTH_RADIO_ENABLE|Enable the Mother Earth Radio Plugin, set to `yes` to enable
MOTHER_EARTH_RADIO_DOWNLOAD_PLUGIN|If set to `YES`, the updated plugin is downloaded from the upstream repo
MOTHER_EARTH_RADIO_PLUGIN_BRANCH|If `MOTHER_EARTH_RADIO_DOWNLOAD_PLUGIN` is set to `yes`, the branch indicated by this variable will be used. Must be specified if enabling `MOTHER_EARTH_RADIO_DOWNLOAD_PLUGIN`. Suggested branch name is `latest-mother-earth-radio`, but the feature is now deprecated: use master images instead
PLG_MICRO_HTTP_HOST|IP for the qobuz local HTTP service.
PLG_MICRO_HTTP_PORT|Port for the qobuz local HTTP service.
PLG_PROXY_METHOD|Proxy method, valid values are `proxy` and `redirect`, defaults to `redirect`
MEDIA_SERVER_FRIENDLY_NAME|Friendly name for the Media Server
TIDAL_ENABLE|Set to `YES` to enable Tidal support, defaults to `no`
TIDAL_TITLE|Set the title for Tidal plugin, defaults to `Tidal`
TIDAL_AUTH_CHALLENGE_TYPE|Default login challenge type, `OAUTH2` (default) or `PKCE`
TIDAL_AUDIO_QUALITY|Possible values are `LOW` (mp3@96k), `HIGH` (mp3@320k), `LOSSLESS` (flac 44.1kHz), `HI_RES_LOSSLESS` (flac@hires), defaults to `LOSSLESS`
TIDAL_PREPEND_NUMBER_IN_ITEM_LIST|Set to `yes` to create item numbers in lists (`[01] Item` instead of `Item`), mostly for kodi, disabled by default
TIDAL_DOWNLOAD_PLUGIN|If set to `YES`, the updated plugin is downloaded from the upstream repo
TIDAL_PLUGIN_BRANCH|If `TIDAL_DOWNLOAD_PLUGIN`, the branch indicated by this variable will be used. Must be specified if enabling `TIDAL_DOWNLOAD_PLUGIN`. Suggested branch name is `latest-tidal`, but the feature is now deprecated: use master images instead
TIDAL_FORCE_TIDALAPI_VERSION|If set, the specified version of tidalapi will be installed over the one included in the image. See note below.
TIDAL_ENABLE_IMAGE_CACHING|If set to `yes`, you can enable caching of album and artist images. This can consume some disk space, so the default is `no`.
TIDAL_ALLOW_FAVORITE_ACTIONS|Allow the creation of entries that can manipulate the favorites
TIDAL_ALLOW_BOOKMARK_ACTIONS|Allow the creation of entries that can manipulate the bookmarks (local favorites)
TIDAL_ALLOW_STATISTICS_ACTIONS|Allow the creation of entries that can remove entries from the playback statistics
TIDAL_ENABLE_USER_AGENT_WHITELIST|Enables the agent whitelist for hi-res support, default is `yes`
QOBUZ_ENABLE|Set to `yes` to enable Qobuz support, defaults to `no`
QOBUZ_TITLE|Set the title for Qobuz plugin, defaults to `Qobuz`
QOBUZ_USERNAME|Your Qobuz account username
QOBUZ_PASSWORD|Your Qobuz account password
QOBUZ_FORMAT_ID|Qobuz format id: 5 for mp3/320, 6 for FLAC, 7 for FLAC 24/96, 27 for hi-res, defaults to `5`
QOBUZ_RENUM_TRACKS|Renum tracks in albums and playlists, mostly for kodi compatibility, defaults to `1`
QOBUZ_EXPLICIT_ITEM_NUMBERS|Adds numbers in square brackets in list items, mostly for kodi compatibility, defaults to `0`
QOBUZ_PREPEND_ARTIST_TO_ALBUM|Adds artist name before album title in lists, mostly for kodi compatibility, defaults to `0`
HRA_ENABLE|Set to `yes` to enable HRA support, defaults to `no`
HRA_USERNAME|Your HRA account username
HRA_PASSWORD|Your HRA account password
HRA_LANG|Your HRA account language
LOG_ENABLE|Set to `yes` to enable to enable logging to file. If enabled, the logfile is `/log/upmpdcli.log`. Otherwise, upmpdcli will log to stderr.
LOG_LEVEL|Sets the log level, if not set the upmpdcli default will apply
UPNP_LOG_ENABLE|Set to `yes` to enable logging to file. If enabled, the logfile is `/log/upnp.log`. Otherwise, upmpdcli will log to stderr.
UPNP_LOG_LEVEL|Sets the log level for upnp, if not set the upmpdcli default will apply
DUMP_ADDITIONAL_RADIO_LIST|Dumps the additional radio file when set to `yes`
WEBSERVER_DOCUMENT_ROOT|Directory from which the internal HTTP server will directly serve files (e.g. icons), disabled by default
STARTUP_DELAY_SEC|Delay before starting the application, defaults to `0`. This can be useful if your container is set up to start automatically, so that you can resolve race conditions with mpd and with squeezelite if all those services run on the same audio device. I experienced issues with my Asus Tinkerboard, while the Raspberry Pi has never really needed this. Your mileage may vary. Feel free to report your personal experience.

When using the (now deprecated) variables `TIDAL_DOWNLOAD_PLUGIN`, `TIDAL_PLUGIN_BRANCH`, `TIDAL_FORCE_TIDALAPI_VERSION`, make sure you verify the intercompatibility. For example, the code currently at the `next-tidal` branch requires [tidalapi version 0.8.3](https://github.com/tamland/python-tidal/releases/tag/v0.8.3).  
Instead of using these *DOWNLOAD* variables, look for *master* images [here](https://hub.docker.com/r/giof71/upmpdcli/tags?name=master).  

#### About RENDERER_MODE

I used to use `BOTH` for most of my configurations. However since a few weeks ago, I found that if one wants to use BubbleUPnP on a phone/tablet and also uses its cloud libraries, one choice is to use `UPNPAV` as the `RENDERER_MODE` and then create the OpenHome renderer on top on the av device using BubbleUPnP Server. This allows uninterrupted playback even if the mobile devices goes off, because the BubbleUPnP Server (which should be installed somewhere in your network) will act as a proxy between the control point (mobile) and the renderer.  
See BubbleUPnP Server documentation [here](https://bubblesoftapps.com/bubbleupnpserver2/).  
Alternatively, if you just need a OpenHome renderer, the best option is to use `OPENHOME`.  
If you plan to use both OpenHome and non-OpenHome control points (like BubbleUPnP and mConnect) and decide to use `BOTH`, be careful: control points can start to fight each other if you switch from one to the other without stopping playback and/or clearing the playlists first.  
Recently, for this purpose, I ended up creating two distinct pairs of mpd/upmpdcli, one configured as `OPENHOME` and one configured as `UPNPAV`, so opening mConnect would not destroy an existing playlist built on BubbleUPnp. Obviously in this case the synchronization object is the audio device, it this is shared by the two players.  

### Volumes

Volume|Description
:---|:---
/uprcl/confdir|Uprcl configuration directory
/uprcl/mediadirs|Uprcl media directories
/user/config|Location for additional files. See [User Config Volume](#user-config-volume) for details.
/cache|Runtime information for upmpdcli. Attach a volume to this path in order to maintain consistency across restarts.
/log|Location for the upmpdcli log file. Enabled using `LOG_ENABLE`

#### User Config Volume

FILE|DESCRIPTION
:---|:---
additional-radio-list.txt|Additional Radios
recoll.conf.user|Recoll configuration (used by upcrl)
qobuz.txt|Qobuz Credentials
hra.txt|HRA Credentials, format is like a .env file. Make sure you include all the settings related the streaming service.
upmpdcli-additional.txt|Configuration snippet, will be appended to upmpdcli.conf.

For `qobuz.txt` and `hra.txt`, the format of the file must be like a `.env` file, where all the settings which are related to the service must be listed. Mixed configurations (so part in variables, part in these files) are not supported.  
The upmpdcli-additional.txt is a simple list of lines with a `key = value` synthax.

### Custom icon

It is possible to customize the server icon by mounting a local png file to the container file `/usr/share/upmpdcli/icon.png`. Just put a suitable png file in the same directory of the compose file, then, assuming the icon is called `my-icon.png`, you would want to add an entry to the volumes section, similar to this:

```text
    volumes:
      - ./my-icon.png:/usr/share/upmpdcli/icon.png:ro
```

A square image should be a good choice. Don't use a very big image, because the players which are able to show it, will show it as a small icon, afaik.  
For example, I searched for a tidal png icon file my Tidal media server, so now BubbleUPnP shows a nice Tidal icon instead of the generic (although beloved) penguin icon.

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

### Obtain Tidal credentials

#### OAUTH2 Mode

##### Create json file

In order to obtain your set of tidal credentials, execute the following command:

```code
docker run --rm -it --entrypoint /app/bin/get_tidal_credentials.py giof71/upmpdcli
```

You will be presented with an output similar to the following prompt:

```text
Visit https://link.tidal.com/XXXXX to log in, the code will expire in 300 seconds
```

Open the link in the browser, login to Tidal and authorize the application. Once that is done, you will be greeted with an output which include the contents of a json file, which should be stored in the tidal plugin cache directory with the name `oauth2.credentials.json`.  

###### Create json file, a bit more advanced

The previous command will leave most settings of the get_tidal_credentials.py program to defaults, so the resulting file will be written to a `/tmp/oauth2.credentials.json` file.  
If you mount the `/tmp` directory to some local directory, you can have the file written directly where you want (ideally directly to the `/cache/tidal` directory in the container).  
Also, you can instruct the command to run in user mode by adding e.g. `--user 1000:1000`  but make sure you replace `1000:1000` with the preferred uid:gid.  
Example with user mode and using the `./cache/tidal` directory, provided that the directory exists:

```code
docker run --user 1000:1000 --rm -it -v $(pwd)/cache/tidal:/tmp --entrypoint /app/bin/get_tidal_credentials.py giof71/upmpdcli
```

In any case, be sure to change the ownership of the copied file according to the uid/gid used to run the upmpdcli container.  

##### OAUTH Challenge

With the latest (branch: latest-tidal) version of the plugin, you can entirely skip the the step before, if you are able to monitor the application logs.  
With docker, this should be as easy as using a `docker-compose logs -f`.  
Open a control point an try to acccess the Tidal media server. The logs will present a link, and you will have to follow instructions, similarly to what is described in the previous paragraph.  
After you will have granted authorization to the application, the plugin will store a `oauth2.credentials.json` file in the plugin cache directory. So be sure to use the `/cache` volume, or the credentials won't survive if the container is removed and created again.  
Never share the tokens on the internet (and also on public git repositories).  
Remember that currently, the Tidal Plugin actually starts when a control point (e.g. BubbleUPnP, mConnect) contacts upmpdcli asking for contents from the Tidal Plugin.  
So, you will not see the prompt until you try to use the plugin itself.  

## Usage examples

A few usage examples are available [here](https://github.com/GioF71/upmpdcli-docker/blob/main/doc/example-configurations.md).

## Build

You can build (or rebuild) the image by opening a terminal from the root of the repository and issuing the following command:

`docker build . -t giof71/upmpdcli`

It will take very little time even on a Raspberry Pi. When it's finished, you can run the container following the previous instructions.  
Just be careful to use the tag you have built.

## Change History

Please find the change history [here](https://github.com/GioF71/upmpdcli-docker/blob/main/doc/change-history.md).
