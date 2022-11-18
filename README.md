# upmpdcli-docker

A Docker image for upmpdcli.  
Now with support for custom radios.

## Reference

First and foremost, the reference to the awesome project:

[An UPnP Audio Media Renderer based on MPD](https://www.lesbonscomptes.com/upmpdcli/)

## Links

Source: [GitHub](https://github.com/giof71/upmpdcli-docker)  
Images: [DockerHub](https://hub.docker.com/r/giof71/upmpdcli)

## Why

I prepared this Dockerfile Because I wanted to be able to install upmpdcli easily on any machine (provided the architecture is amd64 or arm). Also I wanted to be able to configure and govern the parameter easily, maybe through a webapp like Portainer.

## Prerequisites

You need to have Docker up and running on a Linux machine, and the current user must be allowed to run containers (this usually means that the current user belongs to the "docker" group).

You will also need a running instance mpd server (Music Player Daemon) on your network.  
You might consider using my mpd-alsa docker image, at the following links:

mpd-alsa-docker Source: [GitHub](https://github.com/giof71/mpd-alsa-docker)  
mpd-alsa Images: [DockerHub](https://hub.docker.com/r/giof71/mpd-alsa)

You can verify whether your user belongs to the "docker" group with the following command:

`getent group | grep docker`

This command will output one line if the current user does belong to the "docker" group, otherwise there will be no output.

The Dockerfile and the included scripts have been tested on the following distros:

- Manjaro Linux with Gnome (amd64)
- Asus Tinkerboard
- Raspberry Pi 3 and 4, both 32 and 64 bit

As I test the Dockerfile on more platforms, I will update this list.

## Get the image

Here is the [repository](https://hub.docker.com/repository/docker/giof71/upmpdcli) on DockerHub.

Getting the image from DockerHub is as simple as typing:

`docker pull giof71/upmpdcli:stable`

You may want to pull the "stable" image as opposed to the "latest".

## Usage

Say your mpd host is "mpd.local", you can start upmpdcli by typing

`docker run -d --rm --net host -e MPD_HOST:mpd.local giof71/upmpdcli:stable`

Note that we have used the *MPD_HOST* environment variable so that upmpdcli can use the mpd instance running on *mpd.local*.

We also need to use the *host* network so the upnp renderer can be discovered on your network.

### Environment variables

The following tables reports all the currently supported environment variables.

VARIABLE|DEFAULT|NOTES
---|---|---
PUID|1000|User id. Used only when UPRCL is enabled
PGID|1000|Group id. Used only when UPRCL is enabled
MPD_HOST|localhost|The host where mpd runs
MPD_PORT|6600|The port used by mpd
PORT_OFFSET||If set, the offset is applied to `UPNP_PORT` (summed) and to `PLG_MICRO_HTTP_PORT` (subtracted). Setting this variable overrides these individual variables.
UPNPIFACE||UPnP network interface
UPNPPORT||UPnP port
UPMPD_FRIENDLY_NAME|upmpd|Name of the upnpd renderer
AV_FRIENDLY_NAME|upmpd-av|Name of the upnpd renderer (av mode)
FRIENDLY_NAME||Name of the renderer, overrides `UPMPD_FRIENDLY_NAME` and `AV_FRIENDLY_NAME`. The latter is set to the specified `FRIENDLY_NAME` and appended with `-av`.
UPNPAV|0|Enable UPnP AV services (0/1)
OPENHOME|1|Enable OpenHome services (0/1)
ENABLE_UPRCL||Enable local music support (uprcl). Set to `yes` to enable
UPRCL_AUTOSTART||Autostart UPRCL if set to `1`
UPCRL_USER||User for uprcl
UPRCL_HOSTPORT||Hostname and port for uprcl. Currently required when enabling UPRCL. Format: `<ip:port>`. Example value: `192.168.1.8:9090`.
UPRCL_TITLE|Local Music|Title for the media server
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
STARTUP_DELAY_SEC|0| Delay before starting the application. This can be useful if your container is set up to start automatically, so that you can resolve race conditions with mpd and with squeezelite if all those services run on the same audio device. I experienced issues with my Asus Tinkerboard, while the Raspberry Pi has never really needed this. Your mileage may vary. Feel free to report your personal experience.

### Volumes

Volume|Description
:---|:---
/uprcl/confdir|Uprcl configuration directory
/uprcl/mediadirs|Uprcl media directories
/user/config|Location for additional files. Currently: `additional-radio-list.txt` and `recoll.conf.user`.

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

## Build

You can build (or rebuild) the image by opening a terminal from the root of the repository and issuing the following command:

`docker build . -t giof71/upmpdcli`

It will take very little time even on a Raspberry Pi. When it's finished, you can run the container following the previous instructions.  
Just be careful to use the tag you have built.

## Change History

Change Date|Major Changes
---|---
2022-11-18|Add PORT_OFFSET environment variable for easier configuration
2022-11-13|Upnp av services are disabled by default
2022-11-13|Add env variable FRIENDLY_NAME
2022-11-04|Support for uprclconfrecolluser when `recoll.conf.user` file is available
2022-10-31|Support for additional radio list
2022-10-26|Added `exiftool` package
2022-10-26|Support for local build with experimental ppa (exp5)
2022-10-25|Updated github actions
2022-10-25|Added support for msfriendlyname (Media Server Friendly Name)
2022-10-25|Added support for PLG_MICRO_HTTP_HOST and PLG_MICRO_HTTP_PORT
2022-10-04|Added support for UPRCL_AUTOSTART (uprclautostart)
2022-10-03|Added support for Uprcl
2022-09-30|Dropped focal build (due to a build error, to be investigated)
2022-09-30|Build process review: build enabled on tag push
2022-09-26|Moved file 01proxy to app/conf
2022-09-26|Build process reviewed
2022-09-26|Restored Qobuz and Tidal placeholders ([issue #5](https://github.com/GioF71/upmpdcli-docker/issues/5))
2022-09-25|New environment variables & cleanup
2022-03-12|Ubuntu version bump, fixed build-arg for base-image
2022-02-11|Reduced docker image sizes (installation process is now in one line). Add README.md to the image in the directory `/app/doc`.
2022-02-07|Automated builds, largely inspired to the work from [Der-Henning](https://github.com/Der-Henning/) for [this](https://github.com/GioF71/squeezelite-docker) repository.
