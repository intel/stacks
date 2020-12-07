FROM ubuntu:20.04 AS build
WORKDIR /home

ENV LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib
ENV LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu
ENV PKG_CONFIG_PATH=/usr/local/lib/x86_64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pgkconfig:/usr/lib/pkgconfig
ENV XDG_RUNTIME_DIR=/home/mers-user
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ='GST-1'

ARG CFLAGS="-O3 "
ARG CXXFLAGS="-O3 "
ARG FCFLAGS="$CFLAGS "
ARG FFLAGS="$CFLAGS "
ARG CFLAGS="$CFLAGS -mfma -msse -msse2 -msse3 -mssse3 -mcx16 -msahf -mmovbe -mlzcnt -mavx -mtune=skylake-avx512 -m64"
ARG CXXFLAGS="$CXXFLAGS -mfma -msse -msse2 -msse3 -mssse3 -mcx16 -msahf -mmovbe -mlzcnt -mtune=skylake-avx512 -m64"
ARG GCC_IGNORE_WERROR=1
ARG CMAKE_CXX_FLAGS="Wno-error=deprecated-declarations -Wno-error=redundant-move -Wno-error=pessimizing-move -Wno-error=unused-function -Wno-error=parentheses -Wno-error=implicit-function-declaration"

RUN apt-get update && apt-get install -y -q --no-install-recommends build-essential autoconf make git wget pciutils cpio libtool lsb-release ca-certificates pkg-config bison flex libcurl4-gnutls-dev zlib1g-dev
# Install cmake
ARG CMAKE_VER=3.13.1
ARG CMAKE_REPO=https://cmake.org/files
RUN wget -O - ${CMAKE_REPO}/v${CMAKE_VER%.*}/cmake-${CMAKE_VER}.tar.gz | tar xz && \
    cd cmake-${CMAKE_VER} && \
    ./bootstrap --prefix=/usr/local --system-curl && \
    make -j $(nproc) && \
    make install

# Install automake, use version 1.14 on CentOS
ARG AUTOMAKE_VER=1.14
ARG AUTOMAKE_REPO=https://ftp.gnu.org/pub/gnu/automake/automake-${AUTOMAKE_VER}.tar.xz

RUN apt-get install -y -q automake

# Build NASM
ARG NASM_VER=2.14.02
ARG NASM_REPO=https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.bz2
RUN  wget ${NASM_REPO} && \
     tar -xaf nasm* && \
     cd nasm-${NASM_VER} && \
     ./autogen.sh && \
     ./configure --prefix=/usr/local --libdir=/usr/local/lib/x86_64-linux-gnu && \
     make -j $(nproc) && \
     make install

# Build YASM
ARG YASM_VER=1.3.0
ARG YASM_REPO=https://www.tortall.net/projects/yasm/releases/yasm-${YASM_VER}.tar.gz

RUN  wget -O - ${YASM_REPO} | tar xz && \
     cd yasm-${YASM_VER} && \
     sed -i "s/) ytasm.*/)/" Makefile.in && \
     ./configure --prefix=/usr/local --libdir=/usr/local/lib/x86_64-linux-gnu && \
     make -j $(nproc) && \
     make install

RUN apt-get update -y && apt-get install -y python3-pip ninja-build
ARG MESON_VER=0.53.1
ARG MESON_REPO=https://github.com/mesonbuild/meson

RUN git clone ${MESON_REPO}; \
    cd meson; \
    git checkout ${MESON_VER}; \
    python3 setup.py install;

# DAV1D_DOT=OS;color=red
ARG LIBDAV1D_VERSION=0.7.1
ARG LIBDAV1D_URL="https://code.videolan.org/videolan/dav1d/-/archive/$LIBDAV1D_VERSION/dav1d-$LIBDAV1D_VERSION.tar.gz"
ARG LIBDAV1D_MD5SUM=3f943fd57625533ce55faf138e7faab2

RUN \
  wget -O dav1d.tar.gz "$LIBDAV1D_URL" && \
  echo "${LIBDAV1D_MD5SUM}  dav1d.tar.gz" | md5sum -c - && \
  tar xfz dav1d.tar.gz && \
  cd dav1d-* && \
  meson build --prefix=/usr/local --libdir /usr/local/lib/x86_64-linux-gnu --buildtype=plain && \
  cd build && \
  ninja install && \
  DESTDIR=/home/build ninja install

# X264_DOT=OS
ARG X264_VER=1771b556ee45207f8711744ccbd5d42a3949b14c
ARG X264_REPO=https://code.videolan.org/videolan/x264.git

RUN \
  git clone ${X264_REPO} && \
  cd x264 && \
  git checkout ${X264_VER} && \
  ./configure --prefix=/usr/local --libdir=/usr/local/lib/x86_64-linux-gnu --enable-shared && \
  make -j $(nproc) && \
	make install DESTDIR=/home/build && \
	make install

# SVT_HEVC_DOT=OS
ARG SVT_HEVC_VER=ead6fdf7c9ff84511b42fc1658c1654b84d83e4b
ARG SVT_HEVC_REPO=https://github.com/OpenVisualCloud/SVT-HEVC

RUN \
  git clone ${SVT_HEVC_REPO} && \
  cd SVT-HEVC/Build/linux && \
  git checkout ${SVT_HEVC_VER} && \
  mkdir -p ../../Bin/Release && \
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install

# SVT_AV1_DOT=OS
ARG SVT_AV1_VER=v0.8.4
ARG SVT_AV1_REPO=https://github.com/OpenVisualCloud/SVT-AV1

RUN \
  git clone ${SVT_AV1_REPO} && \
  cd SVT-AV1/Build/linux && \
  git checkout ${SVT_AV1_VER} && \
  mkdir -p ../../Bin/Release && \
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib/x86_64-linux-gnu -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install

# GMMLIB_DOT=OS;color=red
ARG GMMLIB_VER=intel-gmmlib-20.3.2
ARG GMMLIB_REPO=https://github.com/intel/gmmlib/archive/${GMMLIB_VER}.tar.gz
ARG GMMLIB_MD5SUM=583d9fbef52d880238629f2ced50a9be

RUN \
   wget -O ${GMMLIB_VER}.tar.gz ${GMMLIB_REPO} && \
   echo "${GMMLIB_MD5SUM}  ${GMMLIB_VER}.tar.gz" | md5sum -c - && \
   tar zxf ${GMMLIB_VER}.tar.gz && mv gmmlib-${GMMLIB_VER} gmmlib;

# LIBVA_DOT=OS;color=red
ARG LIBVA_VER=2.9.0
ARG LIBVA_REPO=https://github.com/intel/libva/archive/${LIBVA_VER}.tar.gz
ARG LIBVA_MD5SUM=fdc00aedad4a51e058403f5f24d9abac

RUN apt-get remove libva*

RUN apt-get update && apt-get install -y -q --no-install-recommends libdrm-dev libx11-dev xorg-dev libgl1-mesa-dev openbox
RUN \
  wget -O ${LIBVA_VER} ${LIBVA_REPO} && \
  echo "${LIBVA_MD5SUM}  ${LIBVA_VER}" | md5sum -c - && \
  tar zxf ${LIBVA_VER} && \
  cd libva-${LIBVA_VER} && \
  ./autogen.sh --prefix=/usr/local --libdir=/usr/local/lib/x86_64-linux-gnu && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install;

# LIBVA_UTILS_DOT=OS;color=red
ARG LIBVA_UTILS_VER=2.9.0
ARG LIBVA_UTILS_REPO=https://github.com/intel/libva-utils/archive/${LIBVA_UTILS_VER}.tar.gz
ARG LIBVA_UTILS_MD5SUM=0cdb4ef83be9c9b244ffba3026f759ab

RUN \
  wget -O ${LIBVA_UTILS_VER} ${LIBVA_UTILS_REPO} && \
  echo "${LIBVA_UTILS_MD5SUM}  ${LIBVA_UTILS_VER}" | md5sum -c - && \
  tar zxf ${LIBVA_UTILS_VER} && \
  cd libva-utils-${LIBVA_UTILS_VER} && \
  ./autogen.sh --prefix=/usr/local --libdir=/usr/local/lib/x86_64-linux-gnu && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install;

# MEDIA_DRIVER_DOT=GMMLIB,LIBVA;color=red
ARG MEDIA_DRIVER_VER=intel-media-20.3.0
ARG MEDIA_DRIVER_REPO=https://github.com/intel/media-driver/archive/${MEDIA_DRIVER_VER}.tar.gz
ARG MEDIA_DRIVER_MD5SUM=9c9219c09447567254aec00ade5dd3b8

RUN apt-get update && apt-get install -y -q --no-install-recommends libdrm-dev libpciaccess-dev libx11-dev xorg-dev libgl1-mesa-dev
RUN \
  wget -O ${MEDIA_DRIVER_VER} ${MEDIA_DRIVER_REPO} && \
  echo "${MEDIA_DRIVER_MD5SUM}  ${MEDIA_DRIVER_VER}" | md5sum -c - && \
  tar zxf ${MEDIA_DRIVER_VER} && mv media-driver-${MEDIA_DRIVER_VER} media-driver && \
  mkdir -p media-driver/build && \
  cd media-driver/build && \
  export PKG_CONFIG_PATH="/usr/local/lib/x86_64-linux-gnu/pkgconfig" && \
  cmake -DBUILD_TYPE=release -DBUILD_ALONG_WITH_CMRTLIB=1 \
        -DBS_DIR_GMMLIB=/home/gmmlib/Source/GmmLib \
        -DBS_DIR_COMMON=/home/gmmlib/Source/Common \
        -DBS_DIR_INC=/home/gmmlib/Source/inc \
        -DBS_DIR_MEDIA=/home/media-driver -Wno-dev \
        -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install

# The iHD_drv_video.so library is heavy so strip debug symbols
# See https://github.com/intel/media-driver/issues/859
RUN strip -S \
    /home/build//usr/local/lib/x86_64-linux-gnu/dri/iHD_drv_video.so

# MEDIA_SDK_DOT=LIBVA;color=red
ARG MSDK_VER=intel-mediasdk-20.3.0
ARG MSDK_REPO=https://github.com/Intel-Media-SDK/MediaSDK/archive/${MSDK_VER}.tar.gz
ARG MSDK_MD5SUM=1fd2cb03d15b3c308e6a9bd1735d2845

RUN \
  wget -O ${MSDK_VER} ${MSDK_REPO} && \
  echo "${MSDK_MD5SUM}  ${MSDK_VER}" | md5sum -c - && \
  tar zxf ${MSDK_VER} && mv MediaSDK-${MSDK_VER} MediaSDK && \
  mkdir -p MediaSDK/build && \
  cd MediaSDK/build && \
  cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_INCLUDEDIR=include -DBUILD_SAMPLES=OFF -DENABLE_OPENCL=OFF -Wno-dev .. && \
  make -j$(nproc) && \
  make install DESTDIR=/home/build && \
  rm -rf /home/build/samples && \
  rm -rf /home/build/plugins && \
  rm -rf /home/build/samples && \
  rm -rf /home/build/plugins && \
  make install

# Post instalation of mfx headers and pkgconfigs
# https://github.com/Intel-FFmpeg-Plugin/Intel_FFmpeg_plugins/wiki/Working-with-Open-Source-MediaSDK-and-iHD-driver-for-QSV-codecs#get-mediasdk
RUN mkdir -p /usr/local/include/mfx && \
		cp /home/build//usr/local/include/mfx/*.h  /usr/local/include/mfx/ && \
    mkdir -p /usr/local/lib/x86_64-linux-gnu/pkgconfig && \
		cp -a /home/build//usr/local/lib/pkgconfig/*mfx*.pc /usr/local/lib/x86_64-linux-gnu/pkgconfig/

# FFMPEG_DOT=OS;color=red,style=dashed
ARG FFMPEG_VER=7800cc6e82068c6dfb5af53817f03dfda794c568
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg.git
ARG FFMPEG_MD5SUM=426ca412ca61634a248c787e29507206

# FFMPEG_LIBSVT_HEVC_ENC_DOT=FFMPEG,SVT_HEVC
# FFMPEG_LIBSVT_AV1_ENC_DOT=FFMPEG,SVT_AV1
# FFMPEG_LIBX264_ENC_DOT=FFMPEG,X264
# FFMPEG_HEVC_QSV_ENC_DOT=FFMPEG,MEDIA_SDK,SVT_HEVC;color=red
# FFMPEG_H264_QSV_ENC_DOT=FFMPEG,MEDIA_SDK,X264;color=red
# FFMPEG_HEVC_VAAPI_ENC_DOT=FFMPEG,MEDIA_DRIVER,SVT_HEVC;color=red
# FFMPEG_H264_VAAPI_ENC_DOT=FFMPEG,MEDIA_DRIVER,X264;color=red
# FFMPEG_AAC_ENC_DOT=FFMPEG;color=red
ARG MERS_ENABLE_ENCODERS=libsvt_hevc,libsvt_av1,libx264,hevc_qsv,h264_qsv,henv_vaapi,h264_vaapi,aac

# FFMPEG_H264_DEC_DOT=FFMPEG,X264
# FFMPEG_HEVC_DEC_DOT=FFMPEG,SVT_HEVC
# FFMPEG_HEVC_QSV_DEC_DOT=FFMPEG,MEDIA_SDK,SVT_HEVC;color=red
# FFMPEG_HEVC_QSV_DEC_DOT=FFMPEG,MEDIA_SDK,X264;color=red
# FFMPEG_LIBDAV1D_DEC_DOT=FFMPEG,DAV1D;color=red
# FFMPEG_AAC_DEC_DOT=FFMPEG;color=red
# FFMPEG_MP3_DEC_DOT=FFMPEG;color=red
ARG MERS_ENABLE_DECODERS=h264,hevc,hevc_qsv,h264_qsv,libdav1d,aac,mp3

# FFMPEG_MP4_MUXER_DOT=FFMPEG;color=red
# FFMPEG_HLS_MUXER_DOT=FFMPEG;color=red
# FFMPEG_RTSP_MUXER_DOT=FFMPEG;color=red
# FFMPEG_DASH_MUXER_DOT=FFMPEG;color=red
# FFMPEG_MPEGTS_MUXER_DOT=FFMPEG;color=red
# FFMPEG_MP4_MUXER_DOT=FFMPEG;color=red
# FFMPEG_AV1_MUXER_DOT=FFMPEG;color=red
# FFMPEG_WEBM_MUXER_DOT=FFMPEG;color=red
ARG MERS_ENABLE_MUXERS=mp4,hls,rtsp,dash,mpegts,avi,webm

# FFMPEG_RTSP_DEMUXER_DOT=FFMPEG;color=red
# FFMPEG_DASH_DEMUXER_DOT=FFMPEG;color=red
# FFMPEG_MPEGTS_MUXER_DOT=FFMPEG;color=red
# FFMPEG_AVI_DEMUXER_DOT=FFMPEG;color=red
# FFMPEG_WEBM_DEMUXER_DOT=FFMPEG;color=red
ARG MERS_ENABLE_DEMUXERS=rtsp,dash,mpegts,avi,webm

# FFMPEG_H264_PARSER_DOT=FFMPEG;color=red
ARG MERS_ENABLE_PARSERS=h264

ARG MERS_ENABLES="--enable-libsvthevc --enable-libsvtav1 --enable-nonfree --enable-gpl --enable-libx264 --enable-libdav1d "
ARG MERS_OTHERS="--enable-ffprobe"

RUN apt-get update && apt-get install -y -q --no-install-recommends libass-dev libfreetype6-dev libsdl2-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev zlib1g-dev libssl-dev libvdpau-dev librtmp-dev libv4l-dev libvorbis-dev libvpx-dev

RUN \
  git clone ${FFMPEG_REPO} && \
  cd FFmpeg && \
  git checkout ${FFMPEG_VER}

# Patch FFmpeg source for SVT-HEVC
RUN \
  cd FFmpeg && \
  patch -p1 < ../SVT-HEVC/ffmpeg_plugin/0001-lavc-svt_hevc-add-libsvt-hevc-encoder-wrapper.patch;

# Patch FFmpeg source for SVT-AV1
RUN \
  cd FFmpeg; \
  patch -p1 < ../SVT-AV1/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-av1.patch;

# Patches for build issues, ffmpeg issues and/or CVE issues
COPY ffmpeg-patches/* ffmpeg-patches/
RUN \
  cd FFmpeg && \
  for file in ../ffmpeg-patches/*.patch; do patch -p1 < $file; done

# Compile FFmpeg (base on http://kojiclear.jf.intel.com/cgit/packages/not-ffmpeg/plain/configure + MeRS codecs and tools)
RUN \
  cd FFmpeg && \
  ./configure \
    --prefix=/usr/local \
    --disable-static \
    --extra-ldflags='-ldl' \
    --enable-avcodec \
    --enable-avformat \
    --enable-avutil \
    --enable-avdevice \
    --enable-rdft \
    --enable-pixelutils \
    --enable-libvorbis \
    --enable-muxer="crc,image2,jpeg,ogg,md5,nut,webm,webm_chunk,webm_dash_manifest,rawvideo,ivf,null,wav,framecrc,rtp,rtsp,ass,webvtt,mjpeg,framehash,hash,${MERS_ENABLE_MUXERS}" \
    --enable-bsf="mp3_header_decompress,vp9_superframe" \
    --enable-demuxer="mjpeg,image2,webm_dash_manifest,ogg,matroska,mp3,pcm_s16le,rawvideo,wav,mov,ivf,rtp,rtsp,flv,ass,subviewer,subviewer1,webvtt,${MERS_ENABLE_DEMUXERS}" \
    --enable-decoder="rawvideo,libvorbis,mjpeg,jpeg,opus,mp3,pcm_u8,pcm_s16le,pcm_s24le,pcm_s32le,pcm_f32le,pcm_s16be,pcm_s24be,pcm_mulaw,pcm_alaw,pcm_u24le,pcm_u32be,pcm_u32le,pgm,pgmyuv,libvpx_vp8,vp8_qsv,vp8,libvpx_vp9,vp9,tiff,bmp,wavpack,ass,saa,subviewer,subviewer1,webvtt,${MERS_ENABLE_DECODERS}" \
    --enable-encoder="rawvideo,wrapped_avframe,libvorbis,opus,yuv4,tiff,bmp,libvpx_vp8,vp8_vaapi,libvpx_vp9,vp9_vaapi,mjpeg_vaapi,pcm_u8,pcm_s16le,pcm_s24le,pcm_s32le,pcm_f32le,pcm_s16be,pcm_s24be,pcm_mulaw,pcm_alaw,pcm_u24le,pcm_u32be,pcm_u32le,ass,ssa,webvtt,mjpeg_qsv,${MERS_ENABLE_ENCODERS}" \
    --enable-hwaccel="vp8_vaapi,vp9_vaapi,mjpeg_vaapi" \
    --enable-parser="opus,libvorbis,vp3,vp8,vp9,mjpeg,${MERS_ENABLE_PARSERS}" \
    --enable-protocol="file,md5,pipe,rtp,tcp,http,https,httpproxy,ftp,librtmp,librtmpe,librtmps,librtmpt,librtmpte,rtmpe,rtmps,rtmpt,rtmpte,rtmpts" \
    --enable-filter="aresample,asetpts,denoise_vaapi,deinterlace_vaapi,hwupload,hwdownload,pixdesctest,procamp_vaapi,scale,scale_vaapi,sharpness_vaapi,color,format,subtitles,select,setpts" \
    --enable-libvpx \
    --enable-pic \
    --enable-shared \
    --enable-swscale \
    --enable-avfilter \
    --enable-vaapi \
    --enable-libmfx \
    --disable-xvmc \
    --disable-doc \
    --disable-htmlpages \
    --disable-podpages \
    --disable-txtpages \
    --enable-version3 \
    --disable-mmx \
    --disable-mmxext \
    --disable-programs \
    --enable-ffmpeg \
    --enable-ffplay \
    --enable-sdl2 \
    --enable-network \
    --enable-openssl \
    --enable-librtmp \
    --enable-libv4l2 \
    --enable-indev=v4l2 \
    --enable-libass \
    ${MERS_ENABLES} \
    ${MERS_OTHERS} && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install

# GST_DOT=OS,X264;color=red,style=dashed
ARG GST_VER=1.18.0
ARG GST_REPO=https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-${GST_VER}.tar.xz
RUN apt-get update && apt-get install -y -q --no-install-recommends libglib2.0-dev gobject-introspection libgirepository1.0-dev libpango-1.0-0 libpangocairo-1.0-0 autopoint libcurl3-gnutls
RUN \
  wget -O - ${GST_REPO} | tar xJ && \
  cd gstreamer-${GST_VER} &&  \
  meson build --libdir=lib/x86_64-linux-gnu --libexecdir=lib/x86_64-linux-gnu \
  --prefix=/usr/local --buildtype=plain \
  -Dgtk_doc=disabled  && \
	cd build && \
  ninja install && \
  DESTDIR=/home/build ninja install

# GST_PLUGIN_ORC_DOT=GST
ARG GST_ORC_VER=0.4.28
ARG GST_PLUGIN_ORC_REPO=https://gstreamer.freedesktop.org/src/orc/orc-${GST_ORC_VER}.tar.xz
RUN apt-get update && apt-get install -y -q --no-install-recommends liborc-0.4-dev-bin gtk-doc-tools
RUN \
  wget -O - ${GST_PLUGIN_ORC_REPO} | tar xJ && \
  cd orc-${GST_ORC_VER} &&  \
  meson build --libdir=lib/x86_64-linux-gnu --libexecdir=lib/x86_64-linux-gnu \
  --prefix=/usr/local --buildtype=plain \
  -Dgtk_doc=disabled  && \
	cd build && \
  ninja install && \
  DESTDIR=/home/build ninja install

# GST_PLUGIN_BASE_DOT=GST
ARG GST_PLUGIN_BASE_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${GST_VER}.tar.xz
RUN apt-get update && apt-get install -y -q --no-install-recommends libxv-dev libtheora-dev libglib2.0-dev libasound2-dev libgl1-mesa-dev libpango1.0-dev libxrandr-dev libegl1-mesa-dev autopoint bison flex libudev-dev
RUN \
  wget -O - ${GST_PLUGIN_BASE_REPO} | tar xJ && \
  cd gst-plugins-base-${GST_VER} &&  \
  meson build --libdir=lib/x86_64-linux-gnu --libexecdir=lib/x86_64-linux-gnu \
  --prefix=/usr/local --buildtype=plain \
  -Dgtk_doc=disabled -Dlibvisual=disabled -Dcdparanoia=disabled && \
	cd build && \
  ninja install && \
  DESTDIR=/home/build ninja install


# GST_PLUGIN_GOOD_DOT=GST
ARG GST_PLUGIN_GOOD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${GST_VER}.tar.xz

RUN  apt-get update && apt-get install -y -q --no-install-recommends libsoup2.4-dev libjpeg-dev
RUN \
  wget -O - ${GST_PLUGIN_GOOD_REPO} | tar xJ && \
  cd gst-plugins-good-${GST_VER} &&  \
  meson build --libdir=lib/x86_64-linux-gnu --libexecdir=lib/x86_64-linux-gnu \
  --prefix=/usr/local --buildtype=plain \
  -Dgtk_doc=disabled  && \
	cd build && \
  ninja install && \
  DESTDIR=/home/build ninja install

# GST_PLUGIN_BAD_DOT=GST
# GST_MSDK_DOT=GST_PLUGIN_BAD;color=blue
# GST_MSDKVPP_DOT=GST_MSDK;color=blue
# GST_MSDKVP9DEC_DOT=GST_MSDK;color=blue
# GST_MSDKVC1DEC_DOT=GST_MSDK;color=blue
# GST_MSDKVP8ENC_DOT=GST_MSDK;color=blue
# GST_MSDKVP8DEC_DOT=GST_MSDK;color=blue
# GST_MSDKMPEG2ENC_DOT=GST_MSDK;color=blue
# GST_MSDKMPEG2DEC_DOT=GST_MSDK;color=blue
# GST_MSDKMJPEGENC_DOT=GST_MSDK;color=blue
# GST_MSDKMJPEGDEC_DOT=GST_MSDK;color=blue
# GST_MSDKH265ENC_DOT=GST_MSDK;color=blue
# GST_MSDKH265DEC_DOT=GST_MSDK;color=blue
# GST_MSDKH264ENC_DOT=GST_MSDK;color=blue
# GST_MSDKH264DEC_DOT=GST_MSDK;color=blue
ARG GST_PLUGIN_BAD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${GST_VER}.tar.xz

RUN  apt-get update && apt-get install -y -q --no-install-recommends libssl-dev librtmp-dev
RUN \
  wget -O - ${GST_PLUGIN_BAD_REPO} | tar xJ && \
  cd gst-plugins-bad-${GST_VER} &&  \
  meson build --libdir=lib/x86_64-linux-gnu --libexecdir=lib/x86_64-linux-gnu \
  --prefix=/usr/local --buildtype=plain \
  -Dgtk_doc=disabled  && \
	cd build && \
  ninja install && \
  DESTDIR=/home/build ninja install

# GST_PLUGIN_UGLY_DOT=GST
ARG GST_PLUGIN_UGLY_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${GST_VER}.tar.xz

RUN \
  wget -O - ${GST_PLUGIN_UGLY_REPO} | tar xJ && \
  cd gst-plugins-ugly-${GST_VER} &&  \
  meson build --libdir=lib/x86_64-linux-gnu --libexecdir=lib/x86_64-linux-gnu \
  --prefix=/usr/local --buildtype=plain \
  -Dgtk_doc=disabled  && \
	cd build && \
  ninja install && \
  DESTDIR=/home/build ninja install

# GST_PLUGIN_LIBAV_DOT=GST,FFMPEG
ARG GST_PLUGIN_LIBAV_REPO=https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-${GST_VER}.tar.xz

RUN \
  wget -O - ${GST_PLUGIN_LIBAV_REPO} | tar xJ && \
  cd gst-libav-${GST_VER} &&  \
  meson build --libdir=lib/x86_64-linux-gnu --libexecdir=lib/x86_64-linux-gnu \
  --prefix=/usr/local --buildtype=plain \
  -Dgtk_doc=disabled  && \
	cd build && \
  ninja install && \
  DESTDIR=/home/build ninja install

# GST_PLUGIN_SVT_HEVC_DOT=SVT_HEVC,GST
# GST_PLUGIN_SVT_AV1_DOT=SVT_AV1,GST

RUN \
  cd SVT-HEVC/gstreamer-plugin && \
  meson build -Dprefix=/usr/local --buildtype=plain && \
  cd build && \
	ninja install && \
  DESTDIR=/home/build ninja install

RUN \
  cd SVT-AV1/gstreamer-plugin && \
  meson build -Dprefix=/usr/local --buildtype=plain && \
  cd build && \
	ninja install && \
  DESTDIR=/home/build ninja install

# GST_PLUGIN_VAAPI_DOT=GST,LIBVA;color=red
# GST_VAAPIJPEGDEC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIMPEG2DEC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIH264DEC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIVC1DEC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIVP8DEC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIVP9DEC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIH265DEC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIPOSTPROC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIDECODEBIN_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPISINK_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIMPEG2ENC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIH265ENC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIVP8ENC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIJPEGENC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIH264ENC_DOT=GST_PLUGIN_VAAPI;color=red
# GST_VAAPIH264FEIENC_DOT=GST_PLUGIN_VAAPI;color=red
ARG GST_PLUGIN_VAAPI_REPO=https://gstreamer.freedesktop.org/src/gstreamer-vaapi/gstreamer-vaapi-${GST_VER}.tar.xz
ARG GST_PLUGIN_VAAPI_REPO_GIT=https://gitlab.freedesktop.org/gstreamer/gstreamer-vaapi.git

RUN \
  wget -O - ${GST_PLUGIN_VAAPI_REPO} | tar xJ && \
  cd gstreamer-vaapi-${GST_VER} &&  \
  meson build --libdir=lib/x86_64-linux-gnu --libexecdir=lib/x86_64-linux-gnu \
  --prefix=/usr/local --buildtype=plain \
  -Dgtk_doc=disabled  && \
	cd build && \
  ninja install && \
  DESTDIR=/home/build ninja install

# OPENCV_DOT=OS
ARG OPENCV_VER=4.4.0
ARG OPENCV_REPO=https://github.com/opencv/opencv/archive/${OPENCV_VER}.tar.gz

RUN \
  wget ${OPENCV_REPO} && \
  tar -zxvf ${OPENCV_VER}.tar.gz

ARG OpenBLAS_INCLUDE_PATH=/usr/include/openblas
ENV OpenBLAS_HOME=/usr/lib/x86_64-linux-gnu/openblas-pthread/

RUN apt-get update && apt-get install -y -q --no-install-recommends \
    pkg-config \
    # Media I/O: \
    ~nlibopenjp2-7 libtiff5-dev zlib1g-dev libwebp-dev libturbojpeg0-dev \
    # Parallelism and linear algebra libraries: \
    libeigen3-dev \
    # Math libraries: \
    libopenblas-dev libopenblas-base liblapacke-dev libgslcblas0 

RUN mkdir -p $OpenBLAS_INCLUDE_PATH && cp /usr/include/lapacke*.h $OpenBLAS_INCLUDE_PATH
RUN ln -s /usr/include/x86_64-linux-gnu/cblas.h $OpenBLAS_INCLUDE_PATH/cblas.h
RUN cd opencv-${OPENCV_VER} && \
    # https://github.com/opencv/opencv/issues/12957 \
    sed -i "s|SET(Open_BLAS_INCLUDE_SEARCH_PATHS|SET(Open_BLAS_INCLUDE_SEARCH_PATHS /usr/lib/x86_64-linux-gnu |g" cmake/OpenCVFindOpenBLAS.cmake

RUN \
  cd opencv-${OPENCV_VER} && \
  mkdir build && \
  cd build && \
  cmake -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_DOCS=OFF \
        -D BUILD_TESTS=OFF \
        -D WITH_GSTREAMER=ON \
        -D WITH_OPENEXR=OFF \
        -D WITH_JPEG=ON \
        -D BUILD_JPEG=OFF \
        -D WITH_OPENJPEG=ON \
        -D WITH_JASPER=OFF \
        -D BUILD_JASPER=OFF .. && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install

# DLDT_DOT=OS
ARG DLDT_VER=2020.4
ARG DLDT_REPO=https://github.com/opencv/dldt.git

ENV MKLDNN=v1.6.1
ARG CLDNN__OUTPUT_BIN_DIR=/home/dldt/bin/intel64/Release
ARG CLDNN__OUTPUT_LIB_DIR=/home/dldt/bin/intel64/Release/lib

RUN \
  apt-get update && apt-get install -y -q --no-install-recommends \
  libusb-1.0.0-dev python-all python-setuptools python-yaml python3-minimal \
  build-essential gcc-7 g++-7  && \
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 7 && \
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 7 && \
  update-alternatives --install /usr/bin/python python /usr/bin/python3 2
RUN \
  git clone -b ${DLDT_VER} ${DLDT_REPO} && \
  cd dldt && \
  git submodule init && \
  git submodule update --recursive && \
  cd inference-engine && \
  mkdir build && \
  cd build && \
  cmake -DCMAKE_INSTALL_PREFIX=/opt/intel/dldt \
        -DTREAT_WARNING_AS_ERROR=OFF \
        -DENABLE_SSE42=ON \
        -DENABLE_AVX2=ON \
        -DENABLE_AVX512F=ON \
        -DENABLE_MKL_DNN=ON \
        -DGEMM=JIT \
        -DTHREADING=TBB \
        -DENABLE_GNA=OFF \
        -DENABLE_CLDNN=ON \
        -DENABLE_MYRIAD=OFF \
        -DENABLE_VPU=OFF \
        -DENABLE_TESTS=OFF \
        -DENABLE_SPEECH_DEMO=OFF \
        -DENABLE_SAMPLES=OFF \
        -DENABLE_PROFILING_ITT=OFF \
        -DBUILD_TESTS=OFF \
        -DNGRAPH_UNIT_TEST_ENABLE=OFF \
        -DNGRAPH_TEST_UTIL_ENABLE=OFF \
        -DENABLE_OPENCV=OFF ../.. && \
  make -j $(nproc) && \
  rm -rf ../bin/intel64/Release/lib/libgtest* && \
  rm -rf ../bin/intel64/Release/lib/libgmock* && \
  rm -rf ../bin/intel64/Release/lib/libmock* && \
  rm -rf ../bin/intel64/Release/lib/libtest*

ARG libdir=/opt/intel/dldt/inference-engine/lib/intel64

RUN \
  mkdir -p /opt/intel/dldt/inference-engine/include && \
  cp -r dldt/inference-engine/include/* /opt/intel/dldt/inference-engine/include && \
  mkdir -p /${libdir} && \
  cp -r $CLDNN__OUTPUT_LIB_DIR/*  ${libdir} && \
  mkdir -p /opt/intel/dldt/inference-engine/src && \
  cp -r dldt/inference-engine/src/* /opt/intel/dldt/inference-engine/src/ && \
  mkdir -p /opt/intel/dldt/inference-engine/share && \
  cp -r dldt/inference-engine/build/share/* /opt/intel/dldt/inference-engine/share/ && \
  mkdir -p    /opt/intel/dldt/inference-engine/external/ && \
  cp -r dldt/inference-engine/temp/* /opt/intel/dldt/inference-engine/external

RUN \
  mkdir -p build//opt/intel/dldt/inference-engine/include && \
  cp -r dldt/inference-engine/include/* build//opt/intel/dldt/inference-engine/include && \
  mkdir -p build/${libdir} && \
  cp -r $CLDNN__OUTPUT_LIB_DIR/* build${libdir} && \
  mkdir -p build//opt/intel/dldt/inference-engine/src && \
  cp -r dldt/inference-engine/src/* build//opt/intel/dldt/inference-engine/src/ && \
  mkdir -p build//opt/intel/dldt/inference-engine/share && \
  cp -r dldt/inference-engine/build/share/* build//opt/intel/dldt/inference-engine/share/ && \
  mkdir -p build//opt/intel/dldt/inference-engine/external/ && \
  cp -r dldt/inference-engine/temp/* build//opt/intel/dldt/inference-engine/external

RUN \
  for p in /usr/local /home/build//usr/local /opt/intel/dldt/inference-engine /home/build//opt/intel/dldt/inference-engine; do \
    pkgconfiglibdir="$p/lib/x86_64-linux-gnu" && \
    mkdir -p "${pkgconfiglibdir}/pkgconfig" && \
    pc="${pkgconfiglibdir}/pkgconfig/dldt.pc" && \
    echo "prefix=/opt" > "$pc" && \
    echo "libdir=${libdir}" >> "$pc" && \
    echo "includedir=/opt/intel/dldt/inference-engine/include" >> "$pc" && \
    echo "" >> "$pc" && \
    echo "Name: DLDT" >> "$pc" && \
    echo "Description: Intel Deep Learning Deployment Toolkit" >> "$pc" && \
    echo "Version: 5.0" >> "$pc" && \
    echo "" >> "$pc" && \
    echo "Libs: -L\${libdir} -linference_engine -linference_engine_c_wrapper" >> "$pc" && \
    echo "Cflags: -I\${includedir}" >> "$pc"; \
  done;

# GST_PLUGIN_VIDEO_ANALYTICS_DOT=GST,OPENCV,DLDT
# GST_GVAINFERENCE_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVADETECT_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVACLASSIFY_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVAIDENTIFY_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVAMETACONVERT_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVAWATERMARK_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVAFPSCOUNTER_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVAMETAPUBLISH_DOT=GST_PLUGIN_VIDEO_ANALYTICS
ARG VA_GSTREAMER_PLUGINS_VER=1.1.0
ARG VA_GSTREAMER_PLUGIN_DEST_NAME=gst-video-analytics
ARG VA_GSTREAMER_PLUGINS_REPO=https://github.com/opencv/${VA_GSTREAMER_PLUGIN_DEST_NAME}/archive/v${VA_GSTREAMER_PLUGINS_VER}.tar.gz

ARG ENABLE_PAHO_INSTALLATION=OFF
ARG ENABLE_RDKAFKA_INSTALLATION=OFF

ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/intel/dldt/inference-engine/lib:/opt/intel/dldt/inference-engine/lib/intel64:/opt/intel/dldt/inference-engine/external/tbb/lib
ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share
ENV OpenCV_DIR=/opt/intel/dldt/inference-engine/external/opencv/cmake
RUN apt-get update && apt-get -y install python3-pip
RUN python3 -m pip install pyyaml

RUN apt-get install -y -q --no-install-recommends gtk-doc-tools uuid-dev python-gi-dev python3-dev libtool-bin
RUN \
  wget -O ${VA_GSTREAMER_PLUGIN_DEST_NAME}.tar.gz ${VA_GSTREAMER_PLUGINS_REPO} && \
  mkdir ${VA_GSTREAMER_PLUGIN_DEST_NAME} && \
  tar zxf ${VA_GSTREAMER_PLUGIN_DEST_NAME}.tar.gz -C ${VA_GSTREAMER_PLUGIN_DEST_NAME} --strip-components 1 && \
	cd ${VA_GSTREAMER_PLUGIN_DEST_NAME} && \
  mkdir build && \
  cd build && \
  cmake \
    -DVERSION_PATCH=$(echo "$(git rev-list --count --first-parent HEAD)") \
    -DGIT_INFO=$(echo "git_$(git rev-parse --short HEAD)") \
    -DCMAKE_BUILD_TYPE=Release \
    -DDISABLE_SAMPLES=ON \
    -DDISABLE_VAAPI=ON  \
    -DENABLE_PAHO_INSTALLATION=${ENABLE_PAHO_INSTALLATION} \
    -DENABLE_RDKAFKA_INSTALLATION=${ENABLE_RDKAFKA_INSTALLATION} \
    -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr/local .. && \
  make -j $(nproc)

RUN \
  mkdir -p /home/build//usr/local/lib/x86_64-linux-gnu/gstreamer-1.0 && \
  cp -r ${VA_GSTREAMER_PLUGIN_DEST_NAME}/build/intel64/Release/lib/* /home/build//usr/local/lib/x86_64-linux-gnu/gstreamer-1.0
RUN \
  mkdir -p /usr/local/lib/x86_64-linux-gnu/gstreamer-1.0 && \
  cp -r ${VA_GSTREAMER_PLUGIN_DEST_NAME}/build/intel64/Release/lib/* /usr/local/lib/x86_64-linux-gnu/gstreamer-1.0

# Clean up after build
RUN rm -rf /home/build/usr/include && \
    rm -rf /home/build/usr/share/doc && \
    rm -rf /home/build/usr/share/gtk-doc && \
    rm -rf /home/build/usr/share/man && \
    rm -rf /home/build/usr/local/include && \
    rm -rf /home/build/usr/local/share/doc && \
    rm -rf /home/build/usr/local/share/gtk-doc && \
    rm -rf /home/build/usr/local/share/man && \
    find /home/build -name "*.a" -exec rm -f {} \;


FROM ubuntu:20.04
LABEL Description="The Intel Media Reference Stack (MeRS) on ubuntu:20.04 (20.04) OS"
LABEL Vendor="Intel Corporation"
LABEL maintainer="otc-swstacks@intel.com"
LABEL internal_hash=46f8990
LABEL internal_tag=v0.3.0-rc1
ENV INTERNAL_HASH=46f8990
ENV INTERNAL_TAG=v0.3.0-rc1

WORKDIR /home

ENV LD_LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu:/usr/local/lib:/usr/lib/x86_64-linux-gnu:/usr/lib
ENV LIBRARY_PATH=/usr/local/lib/x86_64-linux-gnu
ENV PKG_CONFIG_PATH=/usr/local/lib/x86_64-linux-gnu/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/x86_64-linux-gnu/pgkconfig:/usr/lib/pkgconfig
ENV XDG_RUNTIME_DIR=/home/mers-user
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ='GST-1'

COPY --from=build /home/build / 
RUN \
  apt-get update && \
  apt-get install -y -q --no-install-recommends \
  libxv1 libxcb-shm0 libxcb-shape0 libxcb-xfixes0 libsdl2-2.0-0 libasound2 libvdpau1 libnuma1 libass9 libssl1.1 libpciaccess0 \
  # libraries found using ldd $(which ffmpeg) \
  libsndio7.0 libv4l-0 libvorbis0a libvorbisenc2 libvpx6  libglib2.0 libpango-1.0-0 libpangocairo-1.0-0 gobject-introspection libcurl3-gnutls libdrm-intel1 libudev1 libx11-xcb1 libgl1-mesa-glx libxrandr2 libglib2.0-0 liborc-0.4-dev libpng16-16 libxv1 libgl1-mesa-glx libegl1-mesa libpango-1.0-0 libtheora0 libasound2 libsoup2.4-1 libjpeg8 libjpeg-turbo8 libgtk2.0 libdrm2 libxv1 libpugixml1v5 uuid python3-dev libdrm2 \
  # Media I/O: \
  ~nlibopenjp2-7 libtiff5-dev zlib1g-dev libwebp-dev libturbojpeg0-dev \
  # Parallelism and linear algebra libraries: \
  libeigen3-dev \
  # Math libraries: \
  libopenblas-dev libopenblas-base liblapacke-dev libgslcblas0  && \
  apt clean && \
  rm -rf /var/lib/apt/lists/* 
ENV LIBVA_DRIVERS_PATH=/usr/local/lib/x86_64-linux-gnu/dri
ENV LIBVA_DRIVER_NAME=iHD
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/lib/x86_64-linux-gnu/gstreamer-1.0
ENV GST_PLUGIN_PATH=/usr/local/lib/x86_64-linux-gnu/gstreamer-1.0
ENV GST_PLUGIN_SCANNER=/usr/local/lib/x86_64-linux-gnu/gstreamer-1.0/gst-plugin-scanner
ENV GST_VAAPI_ALL_DRIVERS=1
ENV DISPLAY=:0.0
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/opt/intel/dldt/inference-engine/lib:/opt/intel/dldt/inference-engine/lib/intel64:/opt/intel/dldt/inference-engine/external/tbb/lib
ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share
ENV OpenCV_DIR=/opt/intel/dldt/inference-engine/external/opencv/cmake
RUN apt-get update && apt-get -y install python3-pip
RUN python3 -m pip install pyyaml

RUN useradd --create-home --home /home/mers-user --shell /bin/bash mers-user --gid video
WORKDIR /home/mers-user
USER mers-user

COPY scripts/entrypoint.sh scripts/docker-healthcheck /usr/bin/
HEALTHCHECK --interval=15s CMD ["docker-healthcheck"]
ENTRYPOINT ["entrypoint.sh"]

COPY third-party-programs.txt /home/mers-user/licenses/

CMD ["start"]


