#!/bin/bash
cd packages
for i in aom dav1d fdk-aac gsm jack2 lame libass libbluray libogg libtheora libvorbis libvpx libxvid opus x264 x265
do
	cp -R $i/rpms .
done
mkdir tmp
cd tmp
for f in ../rpms/*.rpm
do
	rpm2cpio $f | cpio -idv
done
cd ..
rm -Rf rpms
rm -Rf ../3rd-party-content/ffmpeg-libs
mv tmp ../3rd-party-content/ffmpeg-libs
