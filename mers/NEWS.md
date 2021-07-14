Changes for `v0.4.0` :
----------------------------

This release maintains the execution on Intel® Processor Graphics including Linux* Ubuntu* OS.

- Ubuntu* OS, validated on `20.04 LTS (Focal Fossa)`
- Versions:
  - X264 ->  `b3aadb76329d3c2aedac85142441476bbe5f002c`
  - SVT_HEVC ->  `ead6fdf7c9ff84511b42fc1658c1654b84d83e4b`
  - SVT_AV1 ->  `v0.8.4`
  - GMMLIB ->  `intel-gmmlib-20.4.1`
  - LIBVA ->  `2.10.0`
  - LIBVA_UTILS ->  `2.10.0`
  - MEDIA_DRIVER ->  `intel-media-20.4.5`
  - MSDK ->  `intel-mediasdk-20.5.1`
  - FFMPEG ->  `7800cc6e82068c6dfb5af53817f03dfda794c568`
  - GStreamer* (GST)
    * GST PLUGINS BASE -> `1.18.2`
    * GST PLUGINS GOOD -> `1.18.2`
    * GST PLUGINS BAD -> `1.18.2`
    * GST PLUGINS UGLY -> `1.18.2`
    * GST PLUGINS VAAPI -> `1.18.2`
    * GST PLUGINS SVT_AV1 -> `v0.8.4`
    * GST PLUGINS SVT_HEVC -> `ead6fdf7c9ff84511b42fc1658c1654b84d83e4b`
    * GST PLUGINS LIBAV -> `1.18.2`
    * GST PLUGINS ORC -> `0.4.32`
  - OPENCV ->  `4.5.1`
  - DLDT ->  `2021.2`
  - VA_GSTREAMER_PLUGINS ->  `1.3`
  - NEO(OpenCL) -> `20.52.18783`
  - LEVEL_ZERO -> `1.0.26`

- Intel highlights:
  - Intel(R) Graphics Compute Runtime for oneAPI Level Zero and OpenCL(TM) Driver to enable GPU Plugin on DLDT
  - FFmpeg* AV1 VA-API HW decoder support
  - Intel® Gen12 graphics devices support
  - Intel® Xeon® Cascade Lake support
  - Intel® OpenVINO* Toolkit with Threading Building Blocks (Intel® TBB)
  - Intel® oneAPI Deep Neural Network Library (oneDNN) on DLDT
  - Accelerated video analytics with Intel® Advanced Vector Extensions 512 (Intel® AVX-512), Intel® AVX-512 Vector Neural Network Instructions (AVX512 VNNI), and Intel® AVX-512 BFloat16 Instructions (AVX512_BF16) support

---
Changes for `v0.3.0` :
----------------------------

This release maintains the execution on Intel® Processor Graphics including Linux* Ubuntu* OS.

- Ubuntu* OS, validated on `20.04 LTS (Focal Fossa)`
- New components included:
  - orc: The Oil Runtime Compiler for Optimized Inner Loops
- Versions:
  - X264 ->  `1771b556ee45207f8711744ccbd5d42a3949b14c`
  - SVT_HEVC ->  `ead6fdf7c9ff84511b42fc1658c1654b84d83e4b`
  - SVT_AV1 ->  `v0.8.4`
  - GMMLIB ->  `intel-gmmlib-20.3.2`
  - LIBVA ->  `2.9.0`
  - LIBVA_UTILS ->  `2.9.0`
  - MEDIA_DRIVER ->  `intel-media-20.3.0`
  - MSDK ->  `intel-mediasdk-20.3.0`
  - FFMPEG ->  `7800cc6e82068c6dfb5af53817f03dfda794c568`
  - GStreamer* (GST)
    * GST PLUGINS BASE -> `1.18.0`
    * GST PLUGINS GOOD -> `1.18.0`
    * GST PLUGINS BAD -> `1.18.0`
    * GST PLUGINS UGLY -> `1.18.0`
    * GST PLUGINS VAAPI -> `1.18.0`
    * GST PLUGINS SVT_AV1 -> `v0.8.4`
    * GST PLUGINS SVT_HEVC -> `ead6fdf7c9ff84511b42fc1658c1654b84d83e4b`
    * GST PLUGINS LIBAV -> `1.18.0`
    * GST PLUGINS ORC -> `0.4.28`
  - OPENCV ->  `4.4.0`
  - DLDT ->  `2020.4`
  - VA_GSTREAMER_PLUGINS ->  `1.1.0`

  Deprecated components:
    - FFMPEG_MA_RELEASE ->  `0.4`

- Intel highlights:
  - FFmpeg* AV1 Intel® VAAPI HW decoder support
  - Intel® Gen12 graphics devices support
  - Intel® OpenVINO* Toolkit with Threading Building Blocks (Intel® TBB)
  - TurboJPEG* on OpenCV to accelerate baseline JPEG compression and decompression on Intel's HW
  - Intel® oneAPI Deep Neural Network Library (oneDNN) on DLDT
  - Accelerated video analytics with Intel® Advanced Vector Extensions 512 (Intel® AVX-512)

---

Changes for `v0.2.0` :
----------------------------

This release enables execution on Intel® Processor Graphics.

- Clear Linux* OS, validated on `32830`
- New components included:
  - dav1d: AV1 cross-platform video decoder
  - gmmlib: Intel® Graphics Memory Management Library
  - libva: Implementation for VA-API (Video Acceleration API)
  - libva-utils: Collection of utilities and examples to exercise VA-API
  - Intel® Media Driver for VAAPI: new user mode driver supporting hardware media acceleration
  - Intel® Media SDK: Plain C API to access hardware acceleration devices
  - gst-vaapi: Collection of VA-API based plugins for GStreamer
  - FFmpeg:
    - Video encoders: hevc_qsv, h264_qsv, hevc_vaapi and h264_vaapi
	  - Video decoders: hevc_qsv, h264_qsv, libdav1d
		- Audio encoders: aac
		- Audio decoders: aac and mp3
	  - Muxers: mp4,hls,rtsp,dash,mpegts,avi and webm
	  - Demuxers: rtsp,dash,mpegts,avi and webm
	  - Parsers: h264
- Versions:
  - X264 ->  1771b556ee45207f8711744ccbd5d42a3949b14c
  - SVT_HEVC ->  `v1.4.3`
  - SVT_AV1 ->  `v0.8.0`
  - GMMLIB ->  `intel-gmmlib-19.4.1`
  - LIBVA ->  `2.6.0`
  - LIBVA_UTILS ->  `2.6.0`
  - MEDIA_DRIVER ->  `intel-media-19.4.0r`
  - MSDK ->  `intel-mediasdk-19.4.0`
  - FFMPEG ->  `n4.2`
  - FFMPEG_MA_RELEASE ->  `0.4`
  - GStreamer* (GST)
    * GST PLUGINS BASE -> `1.16.0`
    * GST PLUGINS GOOD -> `1.16.0`
    * GST PLUGINS BAD -> `1.16.0`
    * GST PLUGINS UGLY -> `1.16.0`
  - OPENCV ->  `4.1.2`
  - DLDT ->  `2019_R3.1`
  - VA_GSTREAMER_PLUGINS ->  `0.6.1`

- Intel highlights:
  - Enable Intel® IPP (ICV version) 2019.0.0 on OpenCV
  - Intel® oneAPI Deep Neural Network Library (oneDNN) `v1.0.1` on DLDT

- Runtimes performance:
  - Enable LAPACK(OpenBLAS) support for OpenCV

---

Changes for `v0.1.0` :
----------------------------

Initial release of MeRS, the Media Stack Reference Stack. This release is intended only
for CPU processing.

- Components included (Name and type):
  - Clear Linux* OS, validated on `31410`
  - x264: video encoder
  - SVT-HEVC: Scalable Video Technolgy for HEVC endoder
  - SVT-AV1: Scalable Video Technology for AV1 Encoder
  - FFmpeg: collection of libraries and tools to process multimedia content
  - GStreamer: framework for streaming media
  - gst-plugins-bad, gst-plugins-base, gst-plugins-good and gst-plugins-ugly: collection of gst plugins
  - gst-libav: gst plugin for FFmpeg
  - gst-video-analytics: gst video analytics plugin
  - OpenCV: Computer Vision Library
  - OpenVINO™ toolkit: Deep Learning Deployment Toolkit
- Versions:
  - X264 ->  3759fcb7b48037a5169715ab89f80a0ab4801cdf
  - SVT_HEVC ->  `v1.4.1`
  - SVT_AV1 ->  `v0.7.0`
  - FFMPEG ->  `n4.1.4`
  - GST ->  `1.16.0`
  - OPENCV ->  `4.1.2`
  - DLDT ->  `2019_R2`
  - VA_GSTREAMER_PLUGINS ->  `0.6.1`




*Intel, OpenVINO, and the Intel logo are trademarks of Intel Corporation or its
subsidiaries.*

*\*Other names and brands may be claimed as the property of others*