FROM clearlinux:latest AS build
WORKDIR /home

# build tools
RUN swupd bundle-add c-basic dev-utils devpkg-libusb devpkg-openssl devpkg-gstreamer \
          devpkg-gst-plugins-base git kde-frameworks5-dev make os-core-update patch \
          sysadmin-basic yasm wget

# versions
# DAV1D_DOT=OS;color=red
ARG LIBDAV1D_VERSION=0.5.2
ARG LIBDAV1D_URL="https://code.videolan.org/videolan/dav1d/-/archive/$LIBDAV1D_VERSION/dav1d-$LIBDAV1D_VERSION.tar.gz"
ARG LIBDAV1D_MD5SUM=cb8557037a46d9a580ba749033643741

# X264_DOT=OS
ARG X264_VER=1771b556ee45207f8711744ccbd5d42a3949b14c
ARG X264_REPO=https://code.videolan.org/videolan/x264.git

# SVT_HEVC_DOT=OS
ARG SVT_HEVC_VER=v1.4.3
ARG SVT_HEVC_REPO=https://github.com/OpenVisualCloud/SVT-HEVC

# SVT_AV1_DOT=OS
ARG SVT_AV1_VER=v0.8.0
ARG SVT_AV1_REPO=https://github.com/OpenVisualCloud/SVT-AV1

# GMMLIB_DOT=OS;color=red
ARG GMMLIB_VER=intel-gmmlib-19.4.1
ARG GMMLIB_REPO=https://github.com/intel/gmmlib/archive/${GMMLIB_VER}.tar.gz
ARG GMMLIB_MD5SUM=e26eb324fc4082fd73d90f1721154af2

# LIBVA_DOT=OS;color=red
ARG LIBVA_VER=2.6.0
ARG LIBVA_REPO=https://github.com/intel/libva/archive/${LIBVA_VER}.tar.gz
ARG LIBVA_MD5SUM=3b24c4ea8c85ab08e2d526d39af9a249

# LIBVA_UTILS_DOT=OS;color=red
ARG LIBVA_UTILS_VER=2.6.0
ARG LIBVA_UTILS_REPO=https://github.com/intel/libva-utils/archive/${LIBVA_UTILS_VER}.tar.gz
ARG LIBVA_UTILS_MD5SUM=d28e285c53a3d813e03dd37fd56a7200

# MEDIA_DRIVER_DOT=GMMLIB,LIBVA;color=red
ARG MEDIA_DRIVER_VER=intel-media-19.4.0r
ARG MEDIA_DRIVER_REPO=https://github.com/intel/media-driver/archive/${MEDIA_DRIVER_VER}.tar.gz
ARG MEDIA_DRIVER_MD5SUM=4bb729e2dd2b74e52168d3d8f9f816d8

# MEDIA_SDK_DOT=LIBVA;color=red
ARG MSDK_VER=intel-mediasdk-19.4.0
ARG MSDK_REPO=https://github.com/Intel-Media-SDK/MediaSDK/archive/${MSDK_VER}.tar.gz
ARG MSDK_MD5SUM=5cc9be55395feea95174800a6c37327d

# FFMPEG_DOT=OS;color=red,style=dashed
ARG FFMPEG_VER=n4.2
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg/archive/${FFMPEG_VER}.tar.gz
ARG FFMPEG_MA_RELEASE_VER=0.4
ARG FFMPEG_MA_RELEASE_URL=https://github.com/VCDP/FFmpeg-patch/archive/v${FFMPEG_MA_RELEASE_VER}.tar.gz
ARG FFMPEG_MA_PATH=/home/FFmpeg-patch-${FFMPEG_MA_RELEASE_VER}
ARG FFMPEG_MD5SUM=199e664666c6cde776f51a4312521489

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

# GST_DOT=OS,X264;color=red,style=dashed
ARG GST_VER=1.16.0
ARG GST_REPO=https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-${GST_VER}.tar.xz

# GST_PLUGIN_BASE_DOT=GST
# GST_PLUGIN_GOOD_DOT=GST
# GST_PLUGIN_BAD_DOT=GST
# GST_PLUGIN_UGLY_DOT=GST
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

ARG GST_PLUGIN_BASE_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${GST_VER}.tar.xz
ARG GST_PLUGIN_GOOD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${GST_VER}.tar.xz
ARG GST_PLUGIN_BAD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${GST_VER}.tar.xz
ARG GST_PLUGIN_UGLY_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${GST_VER}.tar.xz

# GST_PLUGIN_LIBAV_DOT=GST,FFMPEG
ARG GST_PLUGIN_LIBAV_REPO=https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-${GST_VER}.tar.xz

# GST_PLUGIN_SVT_HEVC_DOT=SVT_HEVC,GST
# GST_PLUGIN_SVT_AV1_DOT=SVT_AV1,GST

# OPENCV_DOT=OS
ARG OPENCV_VER=4.1.2
ARG OPENCV_REPO=https://github.com/opencv/opencv/archive/${OPENCV_VER}.tar.gz

# DLDT_DOT=OS
ARG DLDT_VER=2019_R3.1
ARG DLDT_REPO=https://github.com/opencv/dldt.git

ARG MKL_VERSION=mklml_lnx_2019.0.5.20190502
ARG MKLDNN=v1.0.1
ARG libdir=/opt/intel/dldt/inference-engine/lib/intel64

# GST_PLUGIN_VIDEO_ANALYTICS_DOT=GST,OPENCV,DLDT
# GST_GVAINFERENCE_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVADETECT_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVACLASSIFY_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVAIDENTIFY_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVAMETACONVERT_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVAWATERMARK_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVAFPSCOUNTER_DOT=GST_PLUGIN_VIDEO_ANALYTICS
# GST_GVAMETAPUBLISH_DOT=GST_PLUGIN_VIDEO_ANALYTICS
ARG VA_GSTREAMER_PLUGINS_VER=0.6.1
ARG VA_GSTREAMER_PLUGINS_REPO=https://github.com/opencv/gst-video-analytics/archive/v${VA_GSTREAMER_PLUGINS_VER}.tar.gz
ARG ENABLE_PAHO_INSTALLATION=OFF
ARG ENABLE_RDKAFKA_INSTALLATION=OFF

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

# enviroment variables
ENV GCC_IGNORE_WERROR=1
ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share
ENV LD_LIBRARY_PATH=/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64:/usr/local/lib64/gstreamer-1.0:/opt/intel/dldt/inference-engine/lib/intel64:/opt/intel/dldt/inference-engine/external/omp/lib
ENV PKG_CONFIG_PATH=/usr/lib64/pkgconfig:/usr/local/lib64/pkgconfig

RUN \
  wget -O dav1d.tar.gz "$LIBDAV1D_URL" && \
  echo "${LIBDAV1D_MD5SUM}  dav1d.tar.gz" | md5sum -c - && \
  tar xfz dav1d.tar.gz && \
  cd dav1d-* && \
  meson usr-build --prefix=/usr/local --buildtype=plain && \
  meson home-build --prefix=/usr/local --buildtype=plain && \
  ninja -C usr-build install && \
  DESTDIR=/home/build ninja -C home-build install

RUN \
  git clone ${X264_REPO} && \
  cd x264 && \
  git checkout ${X264_VER} && \
  ./configure --prefix=/usr/local --libdir=/usr/local/lib64 --enable-shared && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install

RUN \
  git clone ${SVT_HEVC_REPO} && \
  cd SVT-HEVC/Build/linux && \
  git checkout ${SVT_HEVC_VER} && \
  mkdir -p ../../Bin/Release && \
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install

RUN \
  git clone ${SVT_AV1_REPO} && \
  cd SVT-AV1/Build/linux && \
  git checkout ${SVT_AV1_VER} && \
  mkdir -p ../../Bin/Release && \
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install

#Remove build residue from SVT-AV1 build -- temp fix for bug
RUN if [ -d "build/home/" ]; then rm -rf build/home/; fi

RUN \
   wget -O ${GMMLIB_VER}.tar.gz ${GMMLIB_REPO} && \
   echo "${GMMLIB_MD5SUM}  ${GMMLIB_VER}.tar.gz" | md5sum -c - && \
   tar zxf ${GMMLIB_VER}.tar.gz && mv gmmlib-${GMMLIB_VER} gmmlib;

RUN \
  wget -O ${LIBVA_VER} ${LIBVA_REPO} && \
  echo "${LIBVA_MD5SUM}  ${LIBVA_VER}" | md5sum -c - && \
  tar zxf ${LIBVA_VER} && \
  cd libva-${LIBVA_VER} && \
  ./autogen.sh --prefix=/usr/local --libdir=/usr/local/lib64 && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install;

RUN \
  wget -O ${LIBVA_UTILS_VER} ${LIBVA_UTILS_REPO} && \
  echo "${LIBVA_UTILS_MD5SUM}  ${LIBVA_UTILS_VER}" | md5sum -c - && \
  tar zxf ${LIBVA_UTILS_VER} && \
  cd libva-utils-${LIBVA_UTILS_VER} && \
  ./autogen.sh --prefix=/usr/local --libdir=/usr/local/lib64 && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install;

RUN \
  wget -O ${MEDIA_DRIVER_VER} ${MEDIA_DRIVER_REPO} && \
  echo "${MEDIA_DRIVER_MD5SUM}  ${MEDIA_DRIVER_VER}" | md5sum -c - && \
  tar zxf ${MEDIA_DRIVER_VER} && mv media-driver-${MEDIA_DRIVER_VER} media-driver && \
  mkdir -p media-driver/build && \
  cd media-driver/build && \
  export PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig" && \
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
    /home/build/usr/local/lib64/dri/iHD_drv_video.so \
    /usr/local/lib64/dri/iHD_drv_video.so

RUN \
  wget -O ${MSDK_VER} ${MSDK_REPO} && \
  echo "${MSDK_MD5SUM}  ${MSDK_VER}" | md5sum -c - && \
  tar zxf ${MSDK_VER} && mv MediaSDK-${MSDK_VER} MediaSDK && \
  mkdir -p MediaSDK/build && \
  cd MediaSDK/build && \
  export PKG_CONFIG_PATH="/usr/local/lib64/pkgconfig" && \
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
RUN mkdir -p /usr/local/include/mfx     && cp    /home/build/usr/local/include/mfx/*.h          /usr/local/include/mfx/ && \
    mkdir -p /usr/local/lib64/pkgconfig && cp -a /home/build/usr/local/lib64/pkgconfig/*mfx*.pc /usr/local/lib64/pkgconfig/

RUN wget -O - ${FFMPEG_MA_RELEASE_URL} | tar xz

RUN \
  wget -O ${FFMPEG_VER} ${FFMPEG_REPO} && \
  echo "${FFMPEG_MD5SUM}  ${FFMPEG_VER}" | md5sum -c - && \
  tar zxf ${FFMPEG_VER} && mv FFmpeg-${FFMPEG_VER} FFmpeg && \
  cd FFmpeg && \
  find ${FFMPEG_MA_PATH}/patches -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i;

# Patch FFmpeg source for SVT-HEVC
RUN \
  cd FFmpeg && \
  patch -p1 < ../SVT-HEVC/ffmpeg_plugin/0001-lavc-svt_hevc-add-libsvt-hevc-encoder-wrapper.patch;

# Patch FFmpeg source for SVT-AV1
RUN \
  cd FFmpeg; \
  patch -p1 < ../SVT-AV1/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-av1-with-svt-hevc.patch;

# Patches for CLR build issues and CVE issues
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
    --enable-libvpx \
    --enable-muxer="crc,image2,jpeg,ogg,md5,nut,webm,webm_chunk,webm_dash_manifest,rawvideo,ivf,null,wav,framecrc,rtp,rtsp,ass,webvtt,mjpeg,framehash,hash,${MERS_ENABLE_MUXERS}" \
    --enable-bsf="mp3_header_decompress,vp9_superframe" \
    --enable-demuxer="mjpeg,image2,webm_dash_manifest,ogg,matroska,mp3,pcm_s16le,rawvideo,wav,mov,ivf,rtp,rtsp,flv,ass,subviewer,subviewer1,webvtt,${MERS_ENABLE_DEMUXERS}" \
    --enable-decoder="rawvideo,libvorbis,mjpeg,jpeg,opus,mp3,pcm_u8,pcm_s16le,pcm_s24le,pcm_s32le,pcm_f32le,pcm_s16be,pcm_s24be,pcm_mulaw,pcm_alaw,pcm_u24le,pcm_u32be,pcm_u32le,pgm,pgmyuv,libvpx_vp8,vp8_qsv,vp8,libvpx_vp9,vp9,tiff,bmp,wavpack,ass,saa,subviewer,subviewer1,webvtt,${MERS_ENABLE_DECODERS}" \
    --enable-encoder="rawvideo,wrapped_avframe,libvorbis,opus,yuv4,tiff,bmp,libvpx_vp8,vp8_vaapi,libvpx_vp9,vp9_vaapi,mjpeg_vaapi,pcm_u8,pcm_s16le,pcm_s24le,pcm_s32le,pcm_f32le,pcm_s16be,pcm_s24be,pcm_mulaw,pcm_alaw,pcm_u24le,pcm_u32be,pcm_u32le,ass,ssa,webvtt,mjpeg_qsv,${MERS_ENABLE_ENCODERS}" \
    --enable-hwaccel="vp8_vaapi,vp9_vaapi,mjpeg_vaapi" \
    --enable-parser="opus,libvorbis,vp3,vp8,vp9,mjpeg,${MERS_ENABLE_PARSERS}" \
    --enable-protocol="file,md5,pipe,rtp,tcp,http,https,httpproxy,ftp,librtmp,librtmpe,librtmps,librtmpt,librtmpte,rtmpe,rtmps,rtmpt,rtmpte,rtmpts" \
    --enable-filter="aresample,asetpts,denoise_vaapi,deinterlace_vaapi,hwupload,hwdownload,pixdesctest,procamp_vaapi,scale,scale_vaapi,sharpness_vaapi,color,format,subtitles,select,setpts" \
    --disable-error-resilience \
    --enable-pic \
    --enable-shared \
    --enable-swscale \
    --enable-avfilter \
    --enable-vaapi \
    --enable-libmfx \
    --disable-xvmc \
    --disable-doc \
    --disable-htmlpages \
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

RUN \
  wget -O - ${GST_REPO} | tar xJ && \
  cd gstreamer-${GST_VER} && \
  meson --libdir=lib64 --libexecdir=lib64 --prefix=/usr/local --buildtype=plain   usr-builddir && \
  meson --libdir=lib64 --libexecdir=lib64 --prefix=/usr/local --buildtype=plain  home-builddir && \
  ninja -v -C usr-builddir install && \
  DESTDIR=/home/build ninja -v -C home-builddir install

RUN \
  wget -O - ${GST_PLUGIN_BASE_REPO} | tar xJ && \
  cd gst-plugins-base-${GST_VER} && \
  meson --libdir=lib64 --libexecdir=lib64 --prefix=/usr/local --buildtype=plain   usr-builddir && \
  meson --libdir=lib64 --libexecdir=lib64 --prefix=/usr/local --buildtype=plain  home-builddir && \
  ninja -v -C usr-builddir install && \
  DESTDIR=/home/build ninja -v -C home-builddir install

RUN \
  wget -O - ${GST_PLUGIN_GOOD_REPO} | tar xJ && \
  cd gst-plugins-good-${GST_VER} && \
  meson --libdir=lib64 --libexecdir=lib64 --prefix=/usr/local --buildtype=plain   usr-builddir && \
  meson --libdir=lib64 --libexecdir=lib64 --prefix=/usr/local --buildtype=plain  home-builddir && \
  ninja -v -C usr-builddir install && \
  DESTDIR=/home/build ninja -v -C home-builddir install

RUN \
  wget -O - ${GST_PLUGIN_BAD_REPO} | tar xJ && \
  cd gst-plugins-bad-${GST_VER} && \
  meson --libdir=lib64 --libexecdir=lib64 --prefix=/usr/local --buildtype=plain   usr-builddir && \
  meson --libdir=lib64 --libexecdir=lib64 --prefix=/usr/local --buildtype=plain  home-builddir && \
  ninja -v -C usr-builddir install && \
  DESTDIR=/home/build ninja -v -C home-builddir install

RUN \
  wget -O - ${GST_PLUGIN_UGLY_REPO} | tar xJ; \
  cd gst-plugins-ugly-${GST_VER}; \
  meson --libdir=lib64 --libexecdir=lib64 --prefix=/usr/local --buildtype=plain   usr-builddir && \
  meson --libdir=lib64 --libexecdir=lib64 --prefix=/usr/local --buildtype=plain  home-builddir && \
  ninja -v -C usr-builddir install && \
  DESTDIR=/home/build ninja -v -C home-builddir install

RUN \
  wget -O - ${GST_PLUGIN_VAAPI_REPO} | tar xJ && \
  cd gstreamer-vaapi-${GST_VER} && \
  meson --libdir=lib64 --libexecdir=lib64 --prefix=/usr/local --buildtype=plain   usr-builddir && \
  meson --libdir=lib64 --libexecdir=lib64 --prefix=/usr/local --buildtype=plain  home-builddir && \
  ninja -v -C usr-builddir install && \
  DESTDIR=/home/build ninja -v -C home-builddir install

RUN \
  cd SVT-HEVC/gstreamer-plugin && \
  mkdir -p usr-builddir  && meson -Dprefix=/usr/local --buildtype=plain usr-builddir && \
  mkdir -p home-builddir && meson -Dprefix=/usr/local --buildtype=plain home-builddir && \
  ninja -C usr-builddir install && \
  DESTDIR=/home/build ninja -C home-builddir install

RUN \
  cd SVT-AV1/gstreamer-plugin && \
  mkdir -p usr-builddir  && meson -Dprefix=/usr/local usr-builddir && \
  mkdir -p home-builddir && meson -Dprefix=/usr/local home-builddir && \
  ninja -C usr-builddir install && \
  DESTDIR=/home/build ninja -C home-builddir install

RUN \
  wget -O - ${GST_PLUGIN_LIBAV_REPO} | tar xJ && \
  cd gst-libav-${GST_VER} && \
  ./autogen.sh \
      --prefix=/usr/local \
      --libdir=/usr/local/lib64 \
      --enable-shared \
      --enable-gpl \
       --disable-gtk-doc && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install

RUN \
  wget ${OPENCV_REPO} && \
  tar -zxvf ${OPENCV_VER}.tar.gz

# Patch CVE issues on OpenCV
COPY opencv-patches/* opencv-patches/
RUN \
  cd opencv-${OPENCV_VER} && \
  for file in ../opencv-patches/*.patch; do patch -p1 < $file; done

RUN \
  cd opencv-${OPENCV_VER} && \
  mkdir build && \
  cd build && \
  cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -D BUILD_EXAMPLES=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_DOCS=OFF -D BUILD_TESTS=OFF .. && \
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install

RUN \
  git clone -b ${DLDT_VER} ${DLDT_REPO} && \
  cd dldt && \
  git submodule init && \
  git submodule update --recursive && \
  cd inference-engine && \
  mkdir build && \
  cd build && \
  cmake -DENABLE_VALIDATION_SET=OFF \
        -DCMAKE_INSTALL_PREFIX=/opt/intel/dldt \
        -DLIB_INSTALL_PATH=/opt/intel/dldt \
        -DENABLE_MKL_DNN=ON \
        -DTHREADING=OMP \
        -DENABLE_GNA=OFF \
        -DENABLE_CLDNN=OFF \
        -DENABLE_MYRIAD=OFF \
        -DENABLE_VPU=OFF \
        -DENABLE_SAMPLE_CORE=OFF .. && \
  make -j $(nproc) && \
  rm -rf ../bin/intel64/Release/lib/libgtest* && \
  rm -rf ../bin/intel64/Release/lib/libgmock* && \
  rm -rf ../bin/intel64/Release/lib/libmock* && \
  rm -rf ../bin/intel64/Release/lib/libtest*

RUN \
  mkdir -p /opt/intel/dldt/inference-engine/include && \
  cp -r dldt/inference-engine/include/* /opt/intel/dldt/inference-engine/include && \
  mkdir -p /${libdir} && \
  cp -r dldt/inference-engine/bin/intel64/Release/lib/*  ${libdir} && \
  mkdir -p /opt/intel/dldt/inference-engine/src && \
  cp -r dldt/inference-engine/src/* /opt/intel/dldt/inference-engine/src/ && \
  mkdir -p /opt/intel/dldt/inference-engine/share && \
  cp -r dldt/inference-engine/build/share/* /opt/intel/dldt/inference-engine/share/ && \
  mkdir -p    /opt/intel/dldt/inference-engine/external/ && \
  cp -r dldt/inference-engine/temp/* /opt/intel/dldt/inference-engine/external

RUN \
  mkdir -p build/opt/intel/dldt/inference-engine/include && \
  cp -r dldt/inference-engine/include/* build/opt/intel/dldt/inference-engine/include && \
  mkdir -p build/${libdir} && \
  cp -r dldt/inference-engine/bin/intel64/Release/lib/* build${libdir} && \
  mkdir -p build/opt/intel/dldt/inference-engine/src && \
  cp -r dldt/inference-engine/src/* build/opt/intel/dldt/inference-engine/src/ && \
  mkdir -p build/opt/intel/dldt/inference-engine/share && \
  cp -r dldt/inference-engine/build/share/* build/opt/intel/dldt/inference-engine/share/ && \
  mkdir -p build/opt/intel/dldt/inference-engine/external/ && \
  cp -r dldt/inference-engine/temp/* build/opt/intel/dldt/inference-engine/external

RUN \
  for p in /usr /home/build/usr/local /opt/intel/dldt/inference-engine /home/build/opt/intel/dldt/inference-engine; do \
        pkgconfiglibdir="$p/lib64" && \
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

RUN \
  wget -O - ${VA_GSTREAMER_PLUGINS_REPO} | tar xz && \
  cd gst-video-analytics-${VA_GSTREAMER_PLUGINS_VER} && \
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
  make -j $(nproc) && \
  make install DESTDIR=/home/build && \
  make install

RUN \
  mkdir -p build/usr/local/lib64/gstreamer-1.0 && \
  cp -r gst-video-analytics-${VA_GSTREAMER_PLUGINS_VER}/build/intel64/Release/lib/* build/usr/local/lib64/gstreamer-1.0
RUN \
  mkdir -p /usr/lib64/gstreamer-1.0 && \
  cp -r gst-video-analytics-${VA_GSTREAMER_PLUGINS_VER}/build/intel64/Release/lib/* /usr/local/lib64/gstreamer-1.0

# Clean up after build
RUN \
  rm -rf \
    /home/build/include \
    /home/build/share/doc \
    /home/build/share/gtk-doc \
    /home/build/share/man && \
  find /home/build -name "*.a" -exec rm -f {} \;

FROM clearlinux:latest AS runtime-bundles

# Grab os-release info from the minimal base image so
# that the new content matches the exact OS version
COPY --from=clearlinux/os-core:latest /usr/lib/os-release /

# Update to clearlinux/os-core version to ensure
# that the swupd command line arguments are identical
RUN source /os-release && \
    swupd update -V ${VERSION_ID} --no-boot-update $swupd_args

# Install additional content in a target directory
# using the os version from the minimal base
RUN source /os-release && \
    mkdir /install_root \
    && swupd os-install -V ${VERSION_ID} \
    --path /install_root --statedir /swupd-state \
    --bundles=devpkg-libass,devpkg-opus,devpkg-libsrtp,devpkg-taglib,transcoding-support --no-boot-update \
    && rm -rf /install_root/var/lib/swupd/*

FROM clearlinux:latest AS extra-bundles

# Grab os-release info from the minimal base image so
# that the new content matches the exact OS version
COPY --from=clearlinux/os-core:latest /usr/lib/os-release /

# Update to clearlinux/os-core version to ensure
# that the swupd command line arguments are identical
RUN source /os-release && \
    swupd update -V ${VERSION_ID} --no-boot-update $swupd_args

# Install additional content in a target directory
# using the os version from the minimal base
# os-core-update provides swupd
# procps-ng provides ps
RUN source /os-release && \
    mkdir /install_root \
    && swupd os-install -V ${VERSION_ID} \
    --path /install_root --statedir /swupd-state \
    --bundles=os-core-update,procps-ng --no-boot-update \
    && rm -rf /install_root/var/lib/swupd/*

FROM clearlinux/os-core:latest
LABEL Description="Media Stack (MeRS) on ClearLinux OS"
LABEL Vendor="Intel Corporation"
LABEL maintainer=otc-swstacks@intel.com

COPY --from=runtime-bundles /install_root /
COPY --from=extra-bundles /install_root /

# Copy all built files from build stage to /usr/local
# .
# ├── opt
# │   └── intel
# │       └── dldt
# └── usr
#     ├── local
#     │   ├── bin
#     │   ├── include
#     │   ├── lib
#     │   ├── lib64
#     │   └── share
#     └── share
#         └── bash-completion
COPY --from=build /home/build/ /home/build/
RUN cd /home/build && \
		cp -a opt / && \
    cp -a {usr/share,usr/local/bin,usr/local/include,usr/local/lib,usr/local/lib64,usr/local/share} /usr/local && \
    cd - && rm -rf /home/build

COPY scripts/entrypoint.sh scripts/docker-healthcheck /usr/bin/

ENV LD_LIBRARY_PATH=/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64:/usr/local/lib64/gstreamer-1.0:/opt/intel/dldt/inference-engine/lib/intel64:/opt/intel/dldt/inference-engine/external/omp/lib
ENV LIBVA_DRIVERS_PATH=/usr/local/lib64/dri
ENV LIBVA_DRIVER_NAME=iHD
ENV GST_VAAPI_ALL_DRIVERS=1
ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share
ENV OpenCV_DIR=/opt/intel/dldt/inference-engine/external/opencv/cmake
ENV LIBRARY_PATH=/usr/lib:${LIBRARY_PATH}
ENV GST_PLUGIN_PATH=/usr/local/lib64/gstreamer-1.0
ENV GST_PLUGIN_SCANNER=/usr/local/lib64/gstreamer-1.0/gst-plugin-scanner
ENV PKG_CONFIG_PATH=/usr/lib64/pkgconfig:/usr/local/lib64/pkgconfig
ENV XDG_RUNTIME_DIR=/home/mers-user

RUN useradd mers-user
WORKDIR /home/mers-user
USER mers-user

HEALTHCHECK --interval=15s CMD ["docker-healthcheck"]
ENTRYPOINT ["entrypoint.sh"]
CMD ["start"]
