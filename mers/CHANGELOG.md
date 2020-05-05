============ CHANGELOG =============

2020-01-24  Leonardo Sandoval  <leonardo.sandoval.gonzalez@linux.intel.com>

    * update x264 codec to 1771b556ee45207f8711744ccbd5d42a3949b14c
    * update SVT-HEVC codec to 1.4.3
    * update SVT_AV1 codec to 0.8.0
    * update FFmpeg engine to n4.2
    * update openvino to 2019_R3.1

2020-01-27  Leonardo Sandoval  <leonardo.sandoval.gonzalez@linux.intel.com>

    * introduction of GPU stack
    * include gmmlib 19.4.1
    * include libva 2.6.0
    * include Intel media driver intel-media-19.4.0r
    * include gst vaapi plugin

2020-02-03  Leonardo Sandoval  <leonardo.sandoval.gonzalez@linux.intel.com>

    * include Intel Media SDK intel-mediasdk-19.4.0
    * include dav1d codec and libva-utils

2020-02-05  Leonardo Sandoval  <leonardo.sandoval.gonzalez@linux.intel.com>

    * enable dav1d decoder, HEVC and x264 qsv decoders/encoders in FFmpeg

2020-02-06  Leonardo Sandoval  <leonardo.sandoval.gonzalez@linux.intel.com>

    * build with meson/ninja most of the gstreamer components

2020-02-11  Leonardo Sandoval  <leonardo.sandoval.gonzalez@linux.intel.com>

    * include several ffmpeg elements
    * enable decoders  aac,mp3
    * enable muxers hls,rtsp,dash,mpegts,mp4,avi,webm
    * enable demuxers rtsp,dash,mpegts,avi,webm
    * enable parsers h264
    * include libva utils  2.6.0
    * include ffmpeg_ma_release 0.4

2020-02-18  Leonardo Sandoval  <leonardo.sandoval.gonzalez@linux.intel.com>

    * enable h264 and hevc vaapi encoders

2020-02-19  Leonardo Sandoval  <leonardo.sandoval.gonzalez@linux.intel.com>

    * enable GST_PLUGIN_SCANNER to find the scanner

2020-03-04  Leonardo Sandoval  <leonardo.sandoval.gonzalez@linux.intel.com>

    * include intel graphics kernel support

2020-03-26  Leonardo Sandoval  <leonardo.sandoval.gonzalez@linux.intel.com>

    * include aac encoder in FFmpeg

2020-04-14  Luis Ponce  <luis.f.ponce.navarro@linux.intel.com>

    * Fixed security vulnerability in ffmpeg CVE-2019-15942
    * Fixed security vulnerability in OpenCV CVE-2019-5064
