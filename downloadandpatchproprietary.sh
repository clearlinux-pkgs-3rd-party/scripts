#!/bin/bash

cd 3rd-party-content

# Clean up previous files
rm -Rf code google-chrome-stable skypeforlinux teams zoom teamviewer

# Download all rpms
wget https://update.code.visualstudio.com/latest/linux-rpm-x64/stable -O code.rpm
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm -O google-chrome-stable.rpm
wget https://go.skype.com/skypeforlinux-64.rpm -O skypeforlinux.rpm
wget https://go.microsoft.com/fwlink/p/\?linkid\=2112907 -O teams.rpm
wget https://zoom.us/client/latest/zoom_x86_64.rpm -O zoom.rpm
#wget https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm -O teamviewer.rpm

# Extract and patch the rpms
for i in code google-chrome-stable skypeforlinux teams zoom
do
	mkdir $i && cd $i
	rpm2cpio ../$i.rpm | cpio -idv
	patch -p1 < ../../patches/0001-$i.patch
	cd ..
	rm $i.rpm
done

# Fix symlinks
mkdir -p code/usr/bin && cd code/usr/bin
ln -sf ../share/code/code code
cd ../../..

cd google-chrome-stable/usr/bin
ln -sf ../../opt/google/chrome/google-chrome google-chrome-stable
cd ../../..

cd zoom/usr/bin
ln -sf ../../opt/zoom/ZoomLauncher zoom
cd ../../..

#cd teamviewer
#rm -Rf var etc
#cd usr/bin
#ln -sf /opt/3rd-party/bundles/greginator/opt/teamviewer/tv_bin/script/teamviewer teamviewer
#cd ../share/applications
#ln -sf /opt/3rd-party/bundles/greginator/opt/teamviewer/tv_bin/desktop/com.teamviewer.TeamViewer.desktop com.teamviewer.TeamViewer.desktop
#cd ../dbus-1/services
#ln -sf /opt/3rd-party/bundles/greginator/opt/teamviewer/tv_bin/script/com.teamviewer.TeamViewer.Desktop.service com.teamviewer.TeamViewer.Desktop.service
#ln -sf /opt/3rd-party/bundles/greginator/opt/teamviewer/tv_bin/script/com.teamviewer.TeamViewer.service com.teamviewer.TeamViewer.service
#cd ../../icons
#ln -sf /opt/3rd-party/bundles/greginator/opt/teamviewer/tv_bin/desktop/teamviewer_48.png hicolor/48x48/apps/TeamViewer.png
#ln -sf /opt/3rd-party/bundles/greginator/opt/teamviewer/tv_bin/desktop/teamviewer_32.png hicolor/32x32/apps/TeamViewer.png
#ln -sf /opt/3rd-party/bundles/greginator/opt/teamviewer/tv_bin/desktop/teamviewer_256.png hicolor/256x256/apps/TeamViewer.png
#ln -sf /opt/3rd-party/bundles/greginator/opt/teamviewer/tv_bin/desktop/teamviewer_24.png hicolor/24x24/apps/TeamViewer.png
#ln -sf /opt/3rd-party/bundles/greginator/opt/teamviewer/tv_bin/desktop/teamviewer_20.png hicolor/20x20/apps/TeamViewer.png
#ln -sf /opt/3rd-party/bundles/greginator/opt/teamviewer/tv_bin/desktop/teamviewer_16.png hicolor/16x16/apps/TeamViewer.png
#cd ../polkit-1/actions
#ln -sf /opt/3rd-party/bundles/greginator/opt/teamviewer/tv_bin/script/com.teamviewer.TeamViewer.policy com.teamviewer.TeamViewer.policy
#cd ../../../../opt/teamviewer
#rm config logfiles
