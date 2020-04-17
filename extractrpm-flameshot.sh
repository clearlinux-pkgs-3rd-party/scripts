#!/bin/bash
cd packages
for i in flameshot
do
	cp -R $i/rpms .
done
mkdir tmp
cd tmp
for f in ../rpms/*-bin-*.rpm ../rpms/*-data-*.rpm
do
	rpm2cpio $f | cpio -idv
done
cd ..
rm -Rf rpms
rm -Rf ../3rd-party-content/flameshot
mv tmp ../3rd-party-content/flameshot
cd ../3rd-party-content/flameshot
patch -p1 < ../../patches/0001-flameshot.patch
