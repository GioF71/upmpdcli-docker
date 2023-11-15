# Change History

Change Date|Major Changes
---|---
2023-11-15|Support different subsonic-connect versions (see issue [#318](https://github.com/GioF71/upmpdcli-docker/issues/318))
2023-11-14|Switch from `lunar` to `mantic` (see issue [#316](https://github.com/GioF71/upmpdcli-docker/issues/316))
2023-11-13|Add tidal package to installation list (see issue [#313](https://github.com/GioF71/upmpdcli-docker/issues/313))
2023-11-04|Add installation of new packages (see issue [#309](https://github.com/GioF71/upmpdcli-docker/issues/309)) 
2023-11-04|Update to Upmpdcli version 1.8.4, first version with new radio plugins (see issue [#305](https://github.com/GioF71/upmpdcli-docker/issues/305))
2023-09-18|Update to Upmpdcli version 1.8.3, first version with new Tidal Plugin (see issue [#282](https://github.com/GioF71/upmpdcli-docker/issues/282))
2023-09-16|Support for upcoming new Tidal Plugin (see issue [#269](https://github.com/GioF71/upmpdcli-docker/issues/269))
2023-09-13|Add example subsonic configuration (see issue [#266](https://github.com/GioF71/upmpdcli-docker/issues/266))
2023-08-20|Add `renderer` tag image (see issue [#252](https://github.com/GioF71/upmpdcli-docker/issues/252))
2023-08-20|Add support for `ENABLE_AUTO_UPNPIFACE` (see issue [#248](https://github.com/GioF71/upmpdcli-docker/issues/248))
2023-08-20|Autostart by default for subsonic and uprcl (see issue [#245](https://github.com/GioF71/upmpdcli-docker/issues/245))
2023-08-19|Fixed documentation for `UPRCL_USER` (see issue [#241](https://github.com/GioF71/upmpdcli-docker/issues/241))
2023-08-19|Add autostart for radios (see issue [#239](https://github.com/GioF71/upmpdcli-docker/issues/239))
2023-08-19|Removed references to tidal plugin (see issue [#237](https://github.com/GioF71/upmpdcli-docker/issues/237))
2023-08-19|Build process cleanup, back to no separate venv (see issue [#236](https://github.com/GioF71/upmpdcli-docker/issues/236))
2023-08-15|Add missing `recoll` package (see issue [#234](https://github.com/GioF71/upmpdcli-docker/issues/234))
2023-07-23|Switch to debian (see issue [#230](https://github.com/GioF71/upmpdcli-docker/issues/230))
2023-07-11|Avoid use of `--break-system-packages` in Dockerfile (see issue [#227](https://github.com/GioF71/upmpdcli-docker/issues/227))
2023-07-08|Rebuild (see issue [#225](https://github.com/GioF71/upmpdcli-docker/issues/225))
2023-07-07|Remove redundancies in the github workflow (see issue [#223](https://github.com/GioF71/upmpdcli-docker/issues/223))
2023-07-07|Add support for checkcontentformat (see issue [#221](https://github.com/GioF71/upmpdcli-docker/issues/221))
2023-07-06|Add `-full` to tags for full builds (see issue [#218](https://github.com/GioF71/upmpdcli-docker/issues/218))
2023-07-06|Add support for radiolist and bbc plugins (see issue [#217](https://github.com/GioF71/upmpdcli-docker/issues/217))
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
