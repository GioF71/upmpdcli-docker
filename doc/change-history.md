# Change History

Change Date|Major Changes
---|---
2025-06-04|Submodule `master` updated to Tidal Plugin 0.8.9
2025-06-04|Bump libupnpp to 1.0.3 for submodule `master`
2025-06-04|Submodule `edge` updated to Tidal Plugin 0.8.9
2025-06-04|Bump libupnpp to 1.0.3 for submodules `edge`
2025-05-21|Submodules `edge` and `master` updated to Subsonic Plugin 0.8.3
2025-05-19|Submodules `edge` and `master` updated to Tidal Plugin 0.8.8
2025-05-11|Submodule `master` updated to Tidal Plugin 0.8.7
2025-05-10|Submodule `edge` updated to Tidal Plugin 0.8.7
2025-05-10|Removed all plugin download options
2025-05-10|Submodule `edge` and `master` updated to Subsonic Plugin 0.8.2 (see issue [#522](https://github.com/GioF71/upmpdcli-docker/issues/522))
2025-05-08|Bump to release 1.9.5 (see issue [#520](https://github.com/GioF71/upmpdcli-docker/issues/520))
2025-05-07|Fix download plugin deprecation check (see issue [#518](https://github.com/GioF71/upmpdcli-docker/issues/518))
2025-04-28|Remove download option for Tidal plugin, along with TIDAL_FORCE_TIDALAPI_VERSION
2025-04-28|Remove download option for Mother Earth Radio and Radio Paradise plugin
2025-04-19|Add plugin version table (see issue [#498](https://github.com/GioF71/upmpdcli-docker/issues/498))
2025-04-19|Tidal Plugin 0.8.5 for master builds (see issue [#496](https://github.com/GioF71/upmpdcli-docker/issues/496))
2025-04-19|Add missing dependency for pyradios (see issue [#494](https://github.com/GioF71/upmpdcli-docker/issues/494))
2025-04-19|Support edge builds for faster plugin release (see issue [#492](https://github.com/GioF71/upmpdcli-docker/issues/492))
2025-04-17|Allow user to disable Tidal agent whitelist (see issue [#488](https://github.com/GioF71/upmpdcli-docker/issues/488))
2025-03-29|Review build process using git modules (see issue [#477](https://github.com/GioF71/upmpdcli-docker/issues/477))
2025-03-26|Fix proxy method not working adding libcurl4-openssl-dev (see issue [#469](https://github.com/GioF71/upmpdcli-docker/issues/469))
2025-03-22|Bump to [subsonic-connector 0.3.9](https://pypi.org/project/subsonic-connector/0.3.9)
2025-03-19|New variable for subsonic image caching SUBSONIC_ENABLE_IMAGE_CACHING
2025-03-12|Build from source code (see issue [#462](https://github.com/GioF71/upmpdcli-docker/issues/462))
2025-03-10|Build with version 1.9.2 (see issue [#460](https://github.com/GioF71/upmpdcli-docker/issues/460))
2025-02-08|Build with version 1.9.1, adapt documentation (see issue [#456](https://github.com/GioF71/upmpdcli-docker/issues/456))
2025-02-08|Bump to [subsonic-connector 0.3.7](https://pypi.org/project/subsonic-connector/0.3.7)
2025-02-08|Bump to [tidalapi 0.8.3](https://github.com/tamland/python-tidal/releases/tag/v0.8.3)
2025-02-06|Add support for some new tidal configuration variables (see issue [#453](https://github.com/GioF71/upmpdcli-docker/issues/453))
2024-11-22|Build with version 1.9.0, adapt documentation (see issue [#448](https://github.com/GioF71/upmpdcli-docker/issues/448))
2024-10-29|Add support for tidal image caching (see issue [#446](https://github.com/GioF71/upmpdcli-docker/issues/446))
2024-10-28|Add support for forcing the tidalapi version (`TIDAL_FORCE_TIDALAPI_VERSION`) (see issue [#444](https://github.com/GioF71/upmpdcli-docker/issues/444))
2024-10-15|Bump to upmpdcli version 1.8.18 (see issue [#442](https://github.com/GioF71/upmpdcli-docker/issues/442))
2024-10-03|Fix ENABLE_AUTO_UPNPIP support (see issue [#440](https://github.com/GioF71/upmpdcli-docker/issues/440))
2024-09-26|Use exec in order to get rid of bash processes
2024-08-24|Fix arm-only image build issue (see issue [#436](https://github.com/GioF71/upmpdcli-docker/issues/436))
2024-08-21|Bump to upmpdcli version 1.8.16
2024-07-19|Add `SKIP_CHOWN_CACHE` to skip chown on possibly crowded /cache
2024-07-12|Add script for generating tidal oauth2 credentials (see issue [#425](https://github.com/GioF71/upmpdcli-docker/issues/425))
2024-06-13|Automatically set ohproductroom to friendlyname if not explicitly set
2024-06-13|Add support for MPD password and timeout
2024-05-17|Support title for Qobuz (see issue [#412](https://github.com/GioF71/upmpdcli-docker/issues/412))
2024-05-17|Support title for Tidal (see issue [#410](https://github.com/GioF71/upmpdcli-docker/issues/410))
2024-05-14|Set title for Radio Broswer (see issue [#413](https://github.com/GioF71/upmpdcli-docker/issues/413))
2024-05-14|Set title for Radio Paradise (see issue [#411](https://github.com/GioF71/upmpdcli-docker/issues/411))
2024-05-14|Switch to ubuntu noble (see issue [#409](https://github.com/GioF71/upmpdcli-docker/issues/409))
2024-05-13|Set title for Mother Earth Radio (see issue [#407](https://github.com/GioF71/upmpdcli-docker/issues/407))
2024-05-10|Support for config file snippet (see issue [#401](https://github.com/GioF71/upmpdcli-docker/issues/401))
2024-05-01|Support for `subsonictitle` (see issue [#398](https://github.com/GioF71/upmpdcli-docker/issues/398))
2024-04-24|Update to Upmpdcli version 1.8.10 (see issue [#393](https://github.com/GioF71/upmpdcli-docker/issues/393))
2024-03-27|Fix executable shell files for user mode (see issue [#390](https://github.com/GioF71/upmpdcli-docker/issues/390)))
2024-03-24|Add support for upnp log file and level (see issue [#383](https://github.com/GioF71/upmpdcli-docker/issues/383)))
2024-03-05|Review default naming (see issue [#381](https://github.com/GioF71/upmpdcli-docker/issues/381)))
2024-03-05|Automatically set upnpip instead of upnpiface (see issue [#379](https://github.com/GioF71/upmpdcli-docker/issues/379)))
2024-02-29|Update workflow actions (see issue [#377](https://github.com/GioF71/upmpdcli-docker/issues/377)))
2024-02-12|Update to Upmpdcli version 1.8.7 (see issue [#371](https://github.com/GioF71/upmpdcli-docker/issues/371))
2024-01-10|Update to Upmpdcli version 1.8.7 (see issue [#366](https://github.com/GioF71/upmpdcli-docker/issues/366))
2024-01-05|New config parameters for qobuz plugin (see [#364](https://github.com/GioF71/upmpdcli-docker/issues/364))
2023-12-29|Verify log directory to be writable (see [#362](https://github.com/GioF71/upmpdcli-docker/issues/362))
2023-12-29|Removed last references to deezer (see [#359](https://github.com/GioF71/upmpdcli-docker/issues/359))
2023-12-29|Support running as user with `--user` (see [#358](https://github.com/GioF71/upmpdcli-docker/issues/358))
2023-12-19|Default naming of oh renderer (see [#356](https://github.com/GioF71/upmpdcli-docker/issues/356))
2023-12-16|Dropped support for Deezer (see [#353](https://github.com/GioF71/upmpdcli-docker/issues/353))
2023-12-11|Support `prependnumberinitemlist` for Tidal (see issue [#351](https://github.com/GioF71/upmpdcli-docker/issues/351))
2023-11-29|Dropped bullseye and mantic builds (see issue [#348](https://github.com/GioF71/upmpdcli-docker/issues/348))
2023-11-29|Add support for webserverdocumentroot (see issue [#346](https://github.com/GioF71/upmpdcli-docker/issues/346))
2023-11-25|Support enabling internet radios in subsonic (see issue [#344](https://github.com/GioF71/upmpdcli-docker/issues/344))
2023-11-25|Update to Upmpdcli version 1.8.6 (see issue [#340](https://github.com/GioF71/upmpdcli-docker/issues/340))
2023-11-17|Support for subsonic server side scrobbling (see issue [#337](https://github.com/GioF71/upmpdcli-docker/issues/337))
2023-11-17|Write subsonic legacy auth configuration properly (see issue [#335](https://github.com/GioF71/upmpdcli-docker/issues/335))
2023-11-16|Add variable PLG_PROXY_METHOD (see issue [#325](https://github.com/GioF71/upmpdcli-docker/issues/325))
2023-11-15|Clarification about new subsonic features (see issue [#320](https://github.com/GioF71/upmpdcli-docker/issues/320))
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
