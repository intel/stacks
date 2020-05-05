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
  - GST ->  `1.16.0`
  - OPENCV ->  `4.1.2`
  - DLDT ->  `2019_R3.1`
  - VA_GSTREAMER_PLUGINS ->  `0.6.1`


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