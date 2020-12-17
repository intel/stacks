### 0.3.0 (2020-11-18)

##### Functionality Changes

* **ffmpeg:**
  *  include libvpx codec for ubuntu 20.04
  *  bump to 7800cc6e82068c6dfb5af53817f03dfda794c568
* **dockerfile:**  remove state information for each apt package
* **opencv:**  bump to 4.4.0
* **va-gst-plugins:**  bump to 1.1.0
* **dldt:**  bump to 2020.4 and mkldnn to v1.6.1
* **media-driver:**  bump to 20.3.0
* **mediasdk:**  bump to 20.3.0
* **gst:**
  *  bump to 1.18.0
  *  introduce orc plugin
* **gmmlib:**  bump to 20.3.2
* **libva:**  bump to 2.9.0
* **svt-av1:**  bump to v0.8.4
* **svt-hevc:**  bump to ead6fdf7c9ff84511b42fc1658c1654b84d83e4b
* **dav1d:**  bump to 0.7.1

##### Chores

* **dockerfile:**  introduce commit hash and tag into the dockerfile

##### Documentation Changes

*  added third party programs file in image

##### New Features

* **ffmpeg:**  add av1 hwaccel patches
* **opencv:**
  *  include libjpeg-turbo
  *  include openblas lapack libraries
* **dockerfile:**
  *  bump nasm to 2.14.02
  *  bump ubuntu to 20.04

##### Bug Fixes

* **entrypoint.sh:**  ubuntu script posix compatible
* **dockerfile:**  type compatibility issue with glibc 2.30

##### Refactors

* **dldt:**
  *  use explecitely jit for gemm
  *  remove non used flags of the project
* **opencv:**  add explicitely flags to inidcate gstreamer req
* **ffmpeg:**  remove libav* and libpostproc due no required in 20.04
* **va-gst-plugins:**  homogeneous va gst plugin name
* **dockerfile:**
  *  refactor nit codes
  *  abstracted ubuntu's particularities of templates

##### Removed Features

* **opencv:**  openexr support due security cve-2018-18444
* **gst:**  blacklisted components cdparanoia libvisual

##### Security

* **opencv:**  replace jasper with openjpeg

#### 0.2.0 (2020-04-14)

* update x264 codec to 1771b556ee45207f8711744ccbd5d42a3949b14c
* update SVT-HEVC codec to 1.4.3
* update SVT_AV1 codec to 0.8.0
* update FFmpeg engine to n4.2
* update openvino to 2019_R3.1
* introduction of GPU stack
* include gmmlib 19.4.1
* include libva 2.6.0
* include Intel media driver intel-media-19.4.0r
* include gst vaapi plugin
* include Intel Media SDK intel-mediasdk-19.4.0
* include dav1d codec and libva-utils
* enable dav1d decoder, HEVC and x264 qsv decoders/encoders in FFmpeg
* build with meson/ninja most of the gstreamer components
* include several ffmpeg elements
* enable decoders  aac,mp3
* enable muxers hls,rtsp,dash,mpegts,mp4,avi,webm
* enable demuxers rtsp,dash,mpegts,avi,webm
* enable parsers h264
* include libva utils  2.6.0
* include ffmpeg_ma_release 0.4
* enable h264 and hevc vaapi encoders
* enable GST_PLUGIN_SCANNER to find the scanner
* include intel graphics kernel support
* include aac encoder in FFmpeg
* Fixed security vulnerability in ffmpeg CVE-2019-15942
* Fixed security vulnerability in OpenCV CVE-2019-5064

#### 0.1.0 (2019-10-31)

* extend documentation with detail on setup and provide examples
* patch CVE-2019-17539
* bump ffmpeg to 4.1.4
* bump opencv version from 4.1.0 to 4.1.2
* include h264, hevc and libaom_av1 decoders
* update readme with build instructions for split baseline
* use FFmpeg patch repositories
* use webm muxer instead of mp4
* bump GVA from 0.5.1 to 0.6.1
* bump SVT-HEVC from 1.4.0 to 1.4.1
* bump SVT-AV1 version from 0.6.0 to 0.7.0
* include GST SVT plugins
* build gstreamer, plugins and gst-libav
* improve readme based on the OpenVisualCloud structure
* use VA flags also for opencl and dldt
* include optimized flags
* introduce initial README
* several components added
* include SVT-AV1
* use yasm and OVC way to install
* include SVT-HEVC
* integrate x264
* introduce the first analytics media stack