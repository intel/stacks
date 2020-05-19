# Media Reference Stack

The Media Reference Stack (MeRS) is designed to accelerate offline and live
media processing, analytics, and inference recommendations for real-world use
cases such as smart city applications, immersive media enhancement, video
surveillance, and product placement.

MeRS supports analytics and transcode workloads featuring software optimizations
at each layer. It is built for Intel® Xeon® Scalable platforms and Intel®
Processor Graphics. Customers, developers and CSPs who use this stack can gain a
significant performance boost, from hardware up through the application layer.

The Media Reference Stack is containerized software integrating industry-leading components:

* [Clear Linux* OS](https://clearlinux.org/), an open source Linux distribution
  optimized for performance and security
* FFmpeg, an open source project consisting of a vast software suite of
  libraries and programs for handling video, audio, and other multimedia files
  and streams
* GStreamer a pipeline-based multimedia framework which links together a wide
  variety of media processing systems to complete complex workflows
* x264, an open source library and command-line utility developed for encoding video streams
* Scalable Video Technology (SVT), a software-based video coding technology
  that allows encoders to achieve, on Intel  Xeon Scalable processors, the best
  possible trade-offs between performance, latency, and visual quality: AV1 & HEVC
* Intel® OpenVINO (™) toolkit, an Open Visual Inference and Neural Network
  optimized toolkit, provides developers with improved neural network
  performance on a variety of Intel® processors and helps them further unlock
  cost-effective, real-time vision applications.

## Source Code

The dockerfile fetches software from different projects and repositories as
indicated in the dockerfile. For faster look up, all sources are collected in
the following single point: https://github.com/OpenVisualCloud/Dockerfiles-Resources

## Reporting Security Issues

If you have discovered potential security vulnerability in an Intel product,
please contact the iPSIRT at secure@intel.com.

It is important to include the following details:

  * The products and versions affected
  * Detailed description of the vulnerability
  * Information on known exploits

Vulnerability information is extremely sensitive. The iPSIRT strongly recommends
that all security vulnerability reports sent to Intel be encrypted using the
iPSIRT PGP key. The PGP key is available here:
https://www.intel.com/content/www/us/en/security-center/pgp-public-key.html

Software to encrypt messages may be obtained from:

  * PGP Corporation
  * GnuPG

For more information on how Intel works to resolve security issues, see:
[Vulnerability handling guidelines](https://www.intel.com/content/www/us/en/security-center/vulnerability-handling-guidelines.html)

## Supported Platforms and Media Codecs

The Media Reference Stack includes the Intel® Media Driver for VAAPI. Please
cross-refernece the [README of the media-driver
repository](https://github.com/intel/media-driver/blob/master/README.md#supported-platforms)
for the supported platforms list.

A table of supported libva (VA-API) media codecs across various Intel platforms
is available in the [READEME of the media-driver
repository](https://github.com/intel/media-driver/blob/master/README.md#decodingencoding-features).






*Intel, Xeon, OpenVINO, and the Intel logo are trademarks of Intel Corporation
or its subsidiaries*

*\*Other names and brands may be claimed as the property of others*
