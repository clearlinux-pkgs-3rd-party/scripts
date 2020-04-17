#!/bin/bash
start=`date +%s`
SOURCE_DIR=$HOME/ffmpeg_sources
OUT=$HOME/ffmpeg_build
rm -Rf $SOURCE_DIR
rm -Rf $OUT
mkdir $SOURCE_DIR
mkdir $OUT
echo "Building libaom"
cd $SOURCE_DIR
git clone --depth 1 https://aomedia.googlesource.com/aom
mkdir -p aom_build
cd aom_build
PATH="$OUT/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$OUT" -DBUILD_SHARED_LIBS=1 -DENABLE_NASM=on ../aom && PATH="$OUT/bin:$PATH" make -j$(nproc) && make -j$(nproc) install
echo "Building libdav1d"
cd $SOURCE_DIR
curl -O -L https://code.videolan.org/videolan/dav1d/-/archive/0.6.0/dav1d-0.6.0.tar.bz2
tar xjvf dav1d-0.6.0.tar.bz2
cd dav1d-0.6.0
mkdir build && cd build
meson --prefix="$OUT" ..
ninja -j$(nproc) && ninja -j$(nproc) install
echo "Building libx264"
cd $SOURCE_DIR
git clone --depth 1 https://code.videolan.org/videolan/x264.git
cd x264
PKG_CONFIG_PATH="$OUT/lib/pkgconfig" ./configure --prefix="$OUT" --enable-shared
make -j$(nproc)
make -j$(nproc) install
echo "Building libx265"
cd $SOURCE_DIR
hg clone https://bitbucket.org/multicoreware/x265
cd $SOURCE_DIR/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$OUT" -DENABLE_SHARED:bool=on ../../source
make -j$(nproc)
make -j$(nproc) install
echo "Building libfdk_aac"
cd $SOURCE_DIR
git clone --depth 1 https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$OUT" --enable-shared
make -j$(nproc)
make -j$(nproc) install
echo "Building libmp3lame"
cd $SOURCE_DIR
curl -O -L https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzvf lame-3.100.tar.gz
cd lame-3.100
./configure --prefix="$OUT" --enable-shared --enable-nasm
make -j$(nproc)
make -j$(nproc) install
echo "Building libopus"
cd $SOURCE_DIR
curl -O -L https://archive.mozilla.org/pub/opus/opus-1.3.1.tar.gz
tar xzvf opus-1.3.1.tar.gz
cd opus-1.3.1
./configure --prefix="$OUT" --enable-shared
make -j$(nproc)
make -j$(nproc) install
echo "Building libxvid"
cd $SOURCE_DIR
curl -O -L https://downloads.xvid.com/downloads/xvidcore-1.3.7.tar.gz
tar xzvf xvidcore-1.3.7.tar.gz
cd xvidcore/build/generic
./configure --prefix="$OUT" --enable-shared
make -j$(nproc)
make -j$(nproc) install
echo "Building libvpx"
cd $SOURCE_DIR
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="$OUT" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm --enable-shared
make -j$(nproc)
make -j$(nproc) install
echo "Building SDL2"
cd $SOURCE_DIR
curl -O -L https://www.libsdl.org/release/SDL2-2.0.12.tar.gz
tar xzvf SDL2-2.0.12.tar.gz
cd SDL2-2.0.12
./configure --prefix="$OUT" --enable-shared
make -j$(nproc)
make -j$(nproc) install
echo "Building libogg"
cd $SOURCE_DIR
curl -O -L https://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.4.tar.gz
tar xzvf libogg-1.3.4.tar.gz
cd libogg-1.3.4
./configure --prefix="$OUT" --enable-shared
make -j$(nproc)
make -j$(nproc) install
echo "Building libvorbis"
cd $SOURCE_DIR
curl -O -L https://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.6.tar.gz
tar xzvf libvorbis-1.3.6.tar.gz
cd libvorbis-1.3.6
PATH="$OUT/bin:$PATH" PKG_CONFIG_PATH="$OUT/lib/pkgconfig:$OUT/lib64/pkgconfig" ./configure --prefix="$OUT" --enable-shared
make -j$(nproc)
make -j$(nproc) install
echo "Building libtheora"
cd $SOURCE_DIR
git clone --depth 1 https://github.com/xiph/theora.git
cd theora
./autogen.sh
PATH="$OUT/bin:$PATH" PKG_CONFIG_PATH="$OUT/lib/pkgconfig:$OUT/lib64/pkgconfig" ./configure --prefix="$OUT" --enable-shared
make -j$(nproc)
make -j$(nproc) install
echo "Building libass"
cd $SOURCE_DIR
curl -O -L https://github.com/libass/libass/releases/download/0.14.0/libass-0.14.0.tar.gz
tar xzvf libass-0.14.0.tar.gz
cd libass-0.14.0
PATH="$OUT/bin:$PATH" PKG_CONFIG_PATH="$OUT/lib/pkgconfig:$OUT/lib64/pkgconfig" ./configure --prefix="$OUT" --enable-shared
make -j$(nproc)
make -j$(nproc) install
echo "Building FFmpeg"
cd $SOURCE_DIR
curl -O -L https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$OUT/bin:$PATH" PKG_CONFIG_PATH="$OUT/lib/pkgconfig:$OUT/lib64/pkgconfig" ./configure \
  --prefix="$OUT" \
  --extra-cflags="-I$OUT/include" \
  --extra-ldflags="-L$OUT/lib -L$OUT/lib64" \
  --extra-libs=-lpthread \
  --extra-libs=-lm \
  --disable-debug \
  --disable-stripping \
  --enable-shared \
  --disable-static \
  --enable-gpl \
  --enable-libaom \
  --enable-libass \
  --enable-libdav1d \
  --enable-libdrm \
  --enable-libfdk-aac \
  --enable-libfontconfig \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libpulse \
  --enable-libtheora \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libxvid \
  --enable-nonfree \
  --enable-opengl \
  --enable-sdl2 \
  --enable-vaapi \
  --enable-version3
make -j$(nproc)
make -j$(nproc) install
hash -r
end=`date +%s`
echo "Running time $((end-start))"
