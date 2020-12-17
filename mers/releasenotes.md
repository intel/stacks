# Media Reference Stack Release Notes

The Media Reference Stack supports analytics and transcode workloads, built on
Intel® Xeon® Scalable Platforms and featuring software optimizations at each
layer. Customers, developers and CSPs who use this stack can gain a
significant performance boost, from hardware up through the application layer.

The Media Reference Stack is containerized software integrating industry-leading components:

* FFmpeg*, an open source project consisting of a vast software suite of
  libraries and programs for handling video, audio, and other multimedia files
  and streams
* GStreamer* a pipeline-based multimedia framework which links together a wide
  variety of media processing systems to complete complex workflows
* x264, an open source library and command-line utility developed for encoding video streams
* Scalable Video Technology (SVT), a software-based video coding technology
  that allows encoders to achieve, on Intel  Xeon Scalable processors, the best
  possible trade-offs between performance, latency, and visual quality: AV1 & HEVC
* Intel® OpenVINO (™) toolkit, an Open Visual Inference and Neural Network
  optimized toolkit, provides developers with improved neural network
  performance on a variety of Intel® processors and helps them further unlock
  cost-effective, real-time vision applications.

The Media Reference Stack is designed to accelerate offline and live media
processing, analytics, and inference recommendations for real-world use cases
such as smart city applications, immersive media enhancement, video
surveillance, and product placement.

## The Media Reference Stack

The release includes

  * Ubuntu* OS `20.04 LTS (Focal Fossa)`
  * x264 version `1771b556ee45207f8711744ccbd5d42a3949b14c`
  * SVT-HEVC `ead6fdf7c9ff84511b42fc1658c1654b84d83e4b`
  * SVT-AV1 `v0.8.4`
  * FFmpeg `7800cc6e82068c6dfb5af53817f03dfda794c568`
  * GStreamer `1.18.0`
  * OPENCV `4.4.0`
  * OpenVINO (DLDT) `2020.4`
  * GStreamer Video Analytics `1.1.0`

## Licensing

The Media Reference Stack is guided by the [Media Reference Stack Terms of
Use](https://clearlinux.org/stacks/media/terms-of-use). The Docker images are
hosted on https://hub.docker.com and as with all Docker images, these likely
also contain other software which may be under other licenses (such as Bash,
etc. from the base distribution, along with any direct or indirect
dependencies of the primary software being contained).

## The Media Reference Stack licenses

The Media Reference Stack integrates the following tools and libraries with
the corresponding licenses

|Components|License Type|
|----------|------------|
|gst-plugins-orc	 |BSD 3-clause
|gmmlib              |Intel, MIT, Gabi Melman
|dav1d               |VideoLAN and dav1d authors
|Intel® Media Driver for VAAPI|Intel, WebM Project Authors, and many more
|Intel® Media SDK  |Intel
|libva-utils         |Intel
|gst-vaapi           |LGPL v2.1+
|FFmpeg	             |LGPL v2.1+
|GStreamer	         |LGPL v2
|gst-plugins-base	 |GPL v2
|gst-plugins-good	 |LGPL v2.1
|gst-plugins-bad	 |GPL v2
|gst-plugins-ugly	 |LGPL v2.1
|gst-libav	         |GPL v2
|libgstx264.so	     |GPL v2
|libgstsvtav1enc.so	 |LGPL v2.1
|libgstsvthevcenc.so |GPL v2.1
|SVT-HEVC	         |BSD-2-Clause-Patent
|SVT-AV1	         |BSD-2-Clause-Patent
|x264	             |GPL v2
|OpenCV	             |BSD 3-clause
|OpenVINO	         |Apache License v2
|gst-video-analytics |MIT
|Ubuntu* OS	         |Multiple

## Disclaimer

FFmpeg is an open source framework licensed under LGPL and GPL. See
https://www.ffmpeg.org/legal.html. GStreamer is an open source framework
licensed under LGPL. See
https://gstreamer.freedesktop.org/documentation/frequently-asked-questions/licensing.html?gi-language=c
. X264 is an open source framework licensed under GPL. See
https://code.videolan.org/videolan/x264.git You are solely responsible for
determining if your use of FFmpeg, GStreamer or X264 requires any additional
licenses. Intel is not responsible for obtaining any such licenses, nor liable
for any licensing fees due in connection with your use of FFmpeg, Gstreamer or
X264.

## Source code

The dockerfile fetches software from different projects and repositories as
indicated in the dockerfile. For faster look up, all sources are collected in
the following single point: https://github.com/OpenVisualCloud/Dockerfiles-Resources

## Contributing to the Media Reference Stack

We encourage your contributions to this project, through the established Clear
Linux community tools.  Our team uses typical open source collaboration tools
that are described on the Clear Linux [community
page](https://clearlinux.org/community).

## Reporting Security Issues

  If you have discovered potential security vulnerability in an Intel product, please contact the iPSIRT at secure@intel.com.

  It is important to include the following details:

  * The products and versions affected
  * Detailed description of the vulnerability
  * Information on known exploits

  Vulnerability information is extremely sensitive. The iPSIRT strongly recommends that all security vulnerability reports sent to Intel be encrypted using the iPSIRT PGP key. The PGP key is available here: https://www.intel.com/content/www/us/en/security-center/pgp-public-key.html

  Software to encrypt messages may be obtained from:

  * PGP Corporation
  * GnuPG

*Intel and the Intel logo are trademarks of Intel Corporation or its
subsidiaries.*

*\*Other names and brands may be claimed as the property of others*