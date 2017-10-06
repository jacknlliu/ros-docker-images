#/bin/bash

apt-get install -y --no-install-recommends libusb-dev libudev-dev libxinerama-dev
cd /opt && hg clone https://bitbucket.org/osrf/oculussdk
cd oculussdk
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make
make install
cp ../LibOVR/90-oculus.rules /etc/udev/rules.d/
# udevadm control --reload-rules
