#!/bin/bash

apt-get update -y  && apt-get install -y  --no-install-recommends  git cmake build-essential

mkdir -p /opt/vr-ros/ && cd /opt/vr-ros

git clone https://github.com/ValveSoftware/openvr

cd openvr
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release ../
make

chmod a+rwx -R /opt/vr-ros


# install steam and steamVR
echo "install steam and steamVR"

dpkg --add-architecture i386
add-apt-repository -y multiverse
apt-get update -y

# we must run the following command, because in the installation process, we should scroll the license and type 2 for agree with the license.
# apt-get install -y --no-install-recommends steam

# NOTE: after you run steam installation, the steam will be /usr/games, you should add the path to your PATH.

# we use flatpak to install steam, and hope steamVR can be insatalled here, and can commmunicate with vive, and ros?
