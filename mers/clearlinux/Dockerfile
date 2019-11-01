FROM clearlinux:latest AS tools

# Move to latest Clear Linux release to ensure
# that the swupd command line arguments are
# correct
RUN swupd update --no-boot-update $swupd_args

# Grab os-release info from the minimal base image so
# that the new content matches the exact OS version
COPY --from=clearlinux/os-core:latest /usr/lib/os-release /

# Install additional content in a target directory
# using the os version from the minimal base
RUN source /os-release && \
    mkdir /install_root \
    && swupd os-install -V ${VERSION_ID} \
    --path /install_root --statedir /swupd-state \
    --bundles=c-basic,dev-utils,devpkg-libusb,devpkg-openssl,devpkg-gstreamer,devpkg-gst-plugins-base,git,kde-frameworks5-dev,make,os-core-update,patch,sysadmin-basic,yasm,wget --no-boot-update \
    && rm -rf /install_root/var/lib/swupd/*

FROM clearlinux:latest AS build
WORKDIR /home

COPY --from=tools /install_root /

ENV GCC_IGNORE_WERROR=1

ARG X264_VER=3759fcb7b48037a5169715ab89f80a0ab4801cdf
ARG X264_REPO=https://code.videolan.org/videolan/x264.git

RUN  git clone ${X264_REPO} && \
     cd x264 && \
     git checkout ${X264_VER} && \
     ./configure --prefix=/usr --libdir=/usr/lib64 --enable-shared && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install

ARG SVT_HEVC_VER=v1.4.1
ARG SVT_HEVC_REPO=https://github.com/OpenVisualCloud/SVT-HEVC

RUN git clone ${SVT_HEVC_REPO} && \
    cd SVT-HEVC/Build/linux && \
    git checkout ${SVT_HEVC_VER} && \
    mkdir -p ../../Bin/Release && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j $(nproc) && \
    make install DESTDIR=/home/build && \
    make install

# Fetch SVT-AV1
ARG SVT_AV1_VER=v0.7.0
ARG SVT_AV1_REPO=https://github.com/OpenVisualCloud/SVT-AV1

RUN git clone ${SVT_AV1_REPO} && \
    cd SVT-AV1/Build/linux && \
    git checkout ${SVT_AV1_VER} && \
    mkdir -p ../../Bin/Release && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib64 -DCMAKE_ASM_NASM_COMPILER=yasm ../.. && \
    make -j8 && \
    make install DESTDIR=/home/build && \
    make install

#Remove build residue from SVT-AV1 build -- temp fix for bug
RUN if [ -d "build/home/" ]; then rm -rf build/home/; fi

# Fetch FFmpeg source
ARG FFMPEG_VER=n4.1.4
ARG FFMPEG_REPO=https://github.com/FFmpeg/FFmpeg/archive/${FFMPEG_VER}.tar.gz

ARG FFMPEG_1TN_PATCH_REPO=https://patchwork.ffmpeg.org/patch/11625/raw
ARG FFMPEG_THREAD_PATCH_REPO=https://patchwork.ffmpeg.org/patch/11035/raw

ARG FFMPEG_PATCHES_RELEASE_VER=0.1
ARG FFMPEG_PATCHES_RELEASE_URL=https://github.com/VCDP/CDN/archive/v${FFMPEG_PATCHES_RELEASE_VER}.tar.gz
ARG FFMPEG_PATCHES_PATH=/home/CDN-${FFMPEG_PATCHES_RELEASE_VER}
RUN wget -O - ${FFMPEG_PATCHES_RELEASE_URL} | tar xz

ARG FFMPEG_MA_RELEASE_VER=0.2
ARG FFMPEG_MA_RELEASE_URL=https://github.com/VCDP/FFmpeg-patch/archive/v${FFMPEG_MA_RELEASE_VER}.tar.gz
ARG FFMPEG_MA_PATH=/home/FFmpeg-patch-${FFMPEG_MA_RELEASE_VER}
RUN wget -O - ${FFMPEG_MA_RELEASE_URL} | tar xz

RUN wget -O - ${FFMPEG_REPO} | tar xz && mv FFmpeg-${FFMPEG_VER} FFmpeg && \
    cd FFmpeg && \
    wget -O - https://git.ffmpeg.org/gitweb/ffmpeg.git/commitdiff_plain/434588596fef6bd2cef17f8c9c2979a010153edd | patch -p1 && \
    wget -O - https://git.ffmpeg.org/gitweb/ffmpeg.git/commitdiff_plain/02f909dc24b1f05cfbba75077c7707b905e63cd2 | patch -p1 && \
    find ${FFMPEG_PATCHES_PATH}/FFmpeg_patches -type f -name '0001*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i && \
    wget -O - ${FFMPEG_1TN_PATCH_REPO} | patch -p1 && \
    wget -O - ${FFMPEG_THREAD_PATCH_REPO} | patch -p1  && \
    find ${FFMPEG_MA_PATH}/media-analytics -type f -name '*.patch' -print0 | sort -z | xargs -t -0 -n 1 patch -p1 -i;

# Patch FFmpeg source for SVT-HEVC
RUN cd FFmpeg && \
    patch -p1 < ../SVT-HEVC/ffmpeg_plugin/0001-lavc-svt_hevc-add-libsvt-hevc-encoder-wrapper.patch;

# Patch FFmpeg source for SVT-AV1
RUN cd FFmpeg; \
    patch -p1 < ../SVT-AV1/ffmpeg_plugin/0001-Add-ability-for-ffmpeg-to-run-svt-av1-with-svt-hevc.patch;

# Patch for CLR build issues
COPY ffmpeg-patches/* ffmpeg-patches/
RUN cd FFmpeg; \
    for file in ../ffmpeg-patches/*.patch; do patch -p1 < $file; done

# Compile FFmpeg (base on http://kojiclear.jf.intel.com/cgit/packages/not-ffmpeg/plain/configure + MeRS codecs and tools)
ARG MERS_ENABLE_ENCODERS=libsvt_hevc,libsvt_av1,libx264
ARG MERS_ENABLE_DECODERS=h264,hevc,libaom_av1
ARG MERS_ENABLE_MUXERS=mp4
ARG MERS_ENABLES="--enable-libsvthevc --enable-libsvtav1 --enable-nonfree --enable-gpl --enable-libx264"
ARG MERS_OTHERS="--enable-ffprobe"

RUN cd FFmpeg && \
    ./configure \
    --disable-static \
    --extra-ldflags='-ldl' \
    --disable-everything \
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
    --enable-demuxer="mjpeg,image2,webm_dash_manifest,ogg,matroska,mp3,pcm_s16le,rawvideo,wav,mov,ivf,rtp,rtsp,flv,ass,subviewer,subviewer1,webvtt" \
    --enable-decoder="rawvideo,libvorbis,mjpeg,jpeg,opus,mp3,pcm_u8,pcm_s16le,pcm_s24le,pcm_s32le,pcm_f32le,pcm_s16be,pcm_s24be,pcm_mulaw,pcm_alaw,pcm_u24le,pcm_u32be,pcm_u32le,pgm,pgmyuv,libvpx_vp8,vp8_qsv,vp8,libvpx_vp9,vp9,tiff,bmp,wavpack,ass,saa,subviewer,subviewer1,webvtt,${MERS_ENABLE_DECODERS}" \
    --enable-encoder="rawvideo,wrapped_avframe,libvorbis,opus,yuv4,tiff,bmp,libvpx_vp8,vp8_vaapi,libvpx_vp9,vp9_vaapi,mjpeg_vaapi,pcm_u8,pcm_s16le,pcm_s24le,pcm_s32le,pcm_f32le,pcm_s16be,pcm_s24be,pcm_mulaw,pcm_alaw,pcm_u24le,pcm_u32be,pcm_u32le,ass,ssa,webvtt,mjpeg_qsv,${MERS_ENABLE_ENCODERS}" \
    --enable-hwaccel="vp8_vaapi,vp9_vaapi,mjpeg_vaapi" \
    --enable-parser="opus,libvorbis,vp3,vp8,vp9,mjpeg" \
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

# Build the gstremaer core
ARG GST_VER=1.16.0
ARG GST_REPO=https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-${GST_VER}.tar.xz

RUN  wget -O - ${GST_REPO} | tar xJ && \
     cd gstreamer-${GST_VER} && \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/lib64 \
        --enable-shared \
        --enable-introspection \
        --disable-examples \
        --disable-debug \
        --disable-benchmarks \
        --disable-gtk-doc && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install;

# Build the gstremaer plugin base
ARG GST_PLUGIN_BASE_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-${GST_VER}.tar.xz

RUN  wget -O - ${GST_PLUGIN_BASE_REPO} | tar xJ && \
     cd gst-plugins-base-${GST_VER} && \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/lib64 \
        --enable-introspection \
        --enable-shared \
        --disable-examples --disable-debug \
        --disable-gtk-doc && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install


# Build the gstremaer plugin good set
ARG GST_PLUGIN_GOOD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-${GST_VER}.tar.xz

RUN  wget -O - ${GST_PLUGIN_GOOD_REPO} | tar xJ && \
     cd gst-plugins-good-${GST_VER} && \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/lib64 \
        --enable-shared \
        --disable-examples --disable-debug \
        --disable-gtk-doc && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install


# Build the gstremaer plugin bad set
ARG GST_PLUGIN_BAD_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-${GST_VER}.tar.xz

RUN  wget -O - ${GST_PLUGIN_BAD_REPO} | tar xJ && \
     cd gst-plugins-bad-${GST_VER} && \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/lib64 \
        --enable-shared \
        --disable-examples --disable-debug \
        --disable-gtk-doc && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install

# Build the gstremaer plugin ugly set
ARG GST_PLUGIN_UGLY_REPO=https://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-${GST_VER}.tar.xz

RUN  wget -O - ${GST_PLUGIN_UGLY_REPO} | tar xJ; \
     cd gst-plugins-ugly-${GST_VER}; \
     ./autogen.sh \
        --prefix=/usr \
        --libdir=/usr/lib64 \
        --libexecdir=/usr/lib64 \
        --enable-shared \
        --disable-examples --disable-debug \
        --disable-gtk-doc && \
     make -j $(nproc) && \
     make install DESTDIR=/home/build && \
     make install

COPY svt-hevc-patches/0001-include-pbutils-as-gst-plugin-depedency.patch /home/SVT-HEVC/gstreamer-plugin/

RUN cd SVT-HEVC/gstreamer-plugin && \
    git apply 0001-include-pbutils-as-gst-plugin-depedency.patch && \
    cmake . && \
    make -j$(nproc) && \
    make install DESTDIR=/home/build && \
    make install

RUN cd SVT-AV1/gstreamer-plugin && \
    cmake . && \
    make -j$(nproc) && \
    make install DESTDIR=/home/build && \
    make install

# Build gst-libav
ARG GST_PLUGIN_LIBAV_REPO=https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-${GST_VER}.tar.xz

RUN wget -O - ${GST_PLUGIN_LIBAV_REPO} | tar xJ && \
    cd gst-libav-${GST_VER} && \
    ./autogen.sh \
        --prefix="/usr" \
        --libdir=/usr/lib64 \
        --enable-shared \
        --enable-gpl \
        --disable-gtk-doc && \
    make -j $(nproc) && \
    make install DESTDIR=/home/build && \
    make install

ARG OPENCV_VER=4.1.2
ARG OPENCV_REPO=https://github.com/opencv/opencv/archive/${OPENCV_VER}.tar.gz

RUN wget ${OPENCV_REPO} && \
    tar -zxvf ${OPENCV_VER}.tar.gz && \
    cd opencv-${OPENCV_VER} && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -D BUILD_EXAMPLES=OFF -D BUILD_PERF_TESTS=OFF -D BUILD_DOCS=OFF -D BUILD_TESTS=OFF .. && \
    make -j $(nproc) && \
    make install DESTDIR=/home/build && \
    make install

ARG DLDT_VER=2019_R2
ARG DLDT_REPO=https://github.com/opencv/dldt.git

ENV MKL_VERSION=mklml_lnx_2019.0.5.20190502
ENV MKLDNN=v1.0.1

RUN git clone -b ${DLDT_VER} ${DLDT_REPO} && \
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

ARG libdir=/opt/intel/dldt/inference-engine/lib/intel64

RUN mkdir -p /opt/intel/dldt/inference-engine/include && \
    cp -r dldt/inference-engine/include/* /opt/intel/dldt/inference-engine/include && \
    mkdir -p /${libdir} && \
    cp -r dldt/inference-engine/bin/intel64/Release/lib/*  ${libdir} && \
    mkdir -p /opt/intel/dldt/inference-engine/src && \
    cp -r dldt/inference-engine/src/* /opt/intel/dldt/inference-engine/src/ && \
    mkdir -p /opt/intel/dldt/inference-engine/share && \
    cp -r dldt/inference-engine/build/share/* /opt/intel/dldt/inference-engine/share/ && \
    mkdir -p    /opt/intel/dldt/inference-engine/external/ && \
    cp -r dldt/inference-engine/temp/* /opt/intel/dldt/inference-engine/external

RUN mkdir -p build/opt/intel/dldt/inference-engine/include && \
    cp -r dldt/inference-engine/include/* build/opt/intel/dldt/inference-engine/include && \
    mkdir -p build/${libdir} && \
    cp -r dldt/inference-engine/bin/intel64/Release/lib/* build${libdir} && \
    mkdir -p build/opt/intel/dldt/inference-engine/src && \
    cp -r dldt/inference-engine/src/* build/opt/intel/dldt/inference-engine/src/ && \
    mkdir -p build/opt/intel/dldt/inference-engine/share && \
    cp -r dldt/inference-engine/build/share/* build/opt/intel/dldt/inference-engine/share/ && \
    mkdir -p build/opt/intel/dldt/inference-engine/external/ && \
    cp -r dldt/inference-engine/temp/* build/opt/intel/dldt/inference-engine/external

RUN for p in /usr /home/build/usr /opt/intel/dldt/inference-engine /home/build/opt/intel/dldt/inference-engine; do \
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

ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/dldt/inference-engine/lib:/opt/intel/dldt/inference-engine/external/tbb/lib:${libdir}

ARG VA_GSTREAMER_PLUGINS_VER=0.6.1
ARG VA_GSTREAMER_PLUGINS_REPO=https://github.com/opencv/gst-video-analytics/archive/v${VA_GSTREAMER_PLUGINS_VER}.tar.gz
ARG ENABLE_PAHO_INSTALLATION=OFF
ARG ENABLE_RDKAFKA_INSTALLATION=OFF

RUN wget -O - ${VA_GSTREAMER_PLUGINS_REPO} | tar xz && \
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
    -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make -j $(nproc) && \
    make install
RUN mkdir -p build/usr/lib64/gstreamer-1.0 && \
    cp -r gst-video-analytics-${VA_GSTREAMER_PLUGINS_VER}/build/intel64/Release/lib/* build/usr/lib64/gstreamer-1.0
RUN mkdir -p /usr/lib64/gstreamer-1.0 && \
    cp -r gst-video-analytics-${VA_GSTREAMER_PLUGINS_VER}/build/intel64/Release/lib/* /usr/lib64/gstreamer-1.0

# Clean up after build
RUN rm -rf /home/build/usr/include && \
    rm -rf /home/build/usr/share/doc && \
    rm -rf /home/build/usr/share/gtk-doc && \
    rm -rf /home/build/usr/share/man && \
    find /home/build -name "*.a" -exec rm -f {} \;

FROM clearlinux:latest AS bundles

# Move to latest Clear Linux release to ensure
# that the swupd command line arguments are
# correct
RUN swupd update --no-boot-update $swupd_args

# Grab os-release info from the minimal base image so
# that the new content matches the exact OS version
COPY --from=clearlinux/os-core:latest /usr/lib/os-release /

# Install additional content in a target directory
# using the os version from the minimal base
RUN source /os-release && \
    mkdir /install_root \
    && swupd os-install -V ${VERSION_ID} \
    --path /install_root --statedir /swupd-state \
    --bundles=alsa-utils,devpkg-libass,devpkg-opus,devpkg-libsrtp,devpkg-taglib,qt-basic-dev,os-core-update,mpv --no-boot-update \
    && rm -rf /install_root/var/lib/swupd/*

FROM clearlinux/os-core:latest
LABEL Description="This is the image for Media Stacks on ClearLinux OS"
LABEL Vendor="Intel Corporation"
LABEL maintainer=otc-swstacks@intel.com

COPY --from=bundles /install_root /
COPY --from=build /home/build /
COPY scripts/entrypoint.sh scripts/docker-healthcheck /usr/bin/

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/dldt/inference-engine/lib/intel64:/opt/intel/dldt/inference-engine/external/omp/lib:/usr/lib64/gstreamer-1.0:/usr/local/lib:${libdir}
ENV InferenceEngine_DIR=/opt/intel/dldt/inference-engine/share
ENV OpenCV_DIR=/opt/intel/dldt/inference-engine/external/opencv/cmake
ENV LIBRARY_PATH=/usr/lib:${LIBRARY_PATH}
ENV GST_PLUGIN_PATH=/usr/lib64/gstreamer-1.0

RUN useradd mers-user
WORKDIR /home/mers-user
USER mers-user

HEALTHCHECK --interval=15s CMD ["docker-healthcheck"]
ENTRYPOINT ["entrypoint.sh"]
CMD ["start"]
