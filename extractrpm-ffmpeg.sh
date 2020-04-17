#!/bin/bash
cd packages
for i in ffmpeg
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
rm -Rf ../3rd-party-content/ffmpeg
mv tmp ../3rd-party-content/ffmpeg
