#!/bin/bash

for pkg in automake build-essential cpp-8 gcc-8 m4 adwaita-icon-theme \
fontconfig fontconfig-config fonts-dejavu-core gsettings-desktop-schemas \
gtk-update-icon-cache hicolor-icon-theme humanity-icon-theme \
libcairo-gobject2 libfontconfig1 libfreetype6 libpango-1.0-0 \
libpangocairo-1.0-0 libpangoft2-1.0-0 libpixman-1-0 libpng16-16  \
librest-0.7-0 libthai-data libthai0 libtiff5 libwayland-client0 \
libwayland-cursor0 cmake autotools \
gcc g++ vim wget curl fortan autoconf make cmake git
    do apt-get remove  -y $pkg > /dev/null || echo "moving on"
done
apt-get autoclean -y && apt-get autoremove -y
