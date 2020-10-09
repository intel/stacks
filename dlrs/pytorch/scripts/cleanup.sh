#!/bin/bash

declare -a KEEP_LIST=("libgl1 libopenmpi-dev libgomp1 \
	python3-certifi python3-chardet python3-distro \
	python3-idna python3-requests python3-six python3-urllib3")
declare -a REMOVE_LIST=("automake build-essential cpp-8 gcc-8 m4 adwaita-icon-theme \
  fontconfig fontconfig-config fonts-dejavu-core gsettings-desktop-schemas \
  gtk-update-icon-cache hicolor-icon-theme humanity-icon-theme \
  libcairo-gobject2 libfontconfig1 libfreetype6 libpango-1.0-0 \
  libpangocairo-1.0-0 libpangoft2-1.0-0 libpixman-1-0 libpng16-16  \
  librest-0.7-0 libthai-data libthai0 libtiff5 libwayland-client0 \
  libwayland-cursor0 cmake autotools protobuf-compiler \
  gcc g++ vim wget curl fortan autoconf make git")

for keep_pkg in ${KEEP_LIST[@]}; do
	apt-mark manual $keep_pkg
done

for pkg in ${REMOVE_LIST[@]};
    do apt-get remove  -y $pkg > /dev/null || echo "moving on"
done
apt-get autoclean -y && apt-get autoremove -y
