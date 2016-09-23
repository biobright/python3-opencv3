# tag `latest` is 3.5, but base image's python3-dev is 3.4. Since OCV will only build for 3.4, we'll leave pythonas 3.4 until 3.5 makes it into jessie.
FROM python:3.4
MAINTAINER Nate Johnson <nate@biobright.org>

# Do we want to build with CUDA support?
# Pass this at build time with `docker build --build-arg USECUDA=ON`
ARG USECUDA=OFF

# libopencv-dev 
ENV PACKAGES "python3-numpy python3-dev unzip build-essential cmake git libavresample-dev libhdf5-dev libjpeg-dev libpng12-dev libtiff5-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libprotobuf-dev tesseract-ocr libtesseract-dev libleptonica-dev libmp3lame-dev libtheora-dev libvorbis-dev libxvidcore-dev x264  libopencore-amrnb-dev libopencore-amrwb-dev libgstreamer1.0-dev libgstreamer1.0-0 libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev libgstreamer-plugins-bad1.0-0 libgstreamer-plugins-base1.0-0 gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly v4l-utils libv4l-dev libtbb-dev libeigen3-dev liblapack-dev libatlas-dev liblapacke-dev"

ENV CUDAPACKAGES "nvidia-cuda-dev nvidia-cuda-toolkit"

# There IS a way to configure #retries in APT, so this can be replaced
RUN apt-get -y -qq update && apt-get -y install ${PACKAGES} || apt-get -y install ${PACKAGES} || apt-get -y install ${PACKAGES} || apt-get -y install ${PACKAGES} || apt-get -y install ${PACKAGES}

# FFMPEG isn't currently in debian jessie, though it is in sid
# We'll install the static build for now.
ENV FFMPEG_RELEASE ffmpeg-release-64bit-static.tar.xz
RUN curl -SLO "https://johnvansickle.com/ffmpeg/releases/$FFMPEG_RELEASE" \
    && tar -xf $FFMPEG_RELEASE --strip-components=1 -C /usr/local/bin \
    && rm ${FFMPEG_RELEASE}

# the spaces in this conditional ARE important!!!
RUN if [ "${USECUDA}" = "ON" ]; then apt-get -y -qq update && apt-get -y install ${CUDAPACKAGES}; fi

RUN cd /tmp \
    && git clone git://github.com/opencv/opencv \
    && git clone git://github.com/opencv/opencv_contrib \
    && cd opencv \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=RELEASE \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DINSTALL_C_EXAMPLES=OFF \
        -DINSTALL_PYTHON_EXAMPLES=OFF \
        -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -DBUILD_EXAMPLES=OFF \
        -DWITH_CAROTENE=OFF \
        -DBUILD_NEW_PYTHON_SUPPORT=ON \
        -DWITH_FFMPEG=ON \
        -DWITH_GSTREAMER=ON \
        -DWITH_LAPACK=ON \
        -DCUDA_NVCC_FLAGS="-D_FORCE_INLINES" \
        -DWITH_TBB=ON \
        -DENABLE_FAST_MATH=ON \
        -DWITH_CUDA=${USECUDA} \
        -DWITH_CUFFT=${USECUDA} \
        -DWITH_CUBLAS=${USECUDA} \
        -DWITH_NVCUVID=${USECUDA} \
        -DCUDA_FAST_MATH=${USECUDA} \
        .. \
        && make -j`nproc` \
        && make install \
        && make clean \
        && cd / \
        && rm -rf /tmp/*opencv*
        
        