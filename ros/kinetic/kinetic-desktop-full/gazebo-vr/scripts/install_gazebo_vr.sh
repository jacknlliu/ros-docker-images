#!/bin/bash

apt-get update -y && apt-get install -y --no-install-recommends wget mercurial  libusb-dev libudev-dev libxinerama-dev
cd /opt && hg clone https://bitbucket.org/osrf/oculussdk
cd oculussdk
mkdir build && cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make
make install
cp ../LibOVR/90-oculus.rules /etc/udev/rules.d/
# udevadm control --reload-rules
cd /opt && rm -rf /opt/oculussdk/build


# recompile gazebo

# install dependencies. Should we remove previous packages from ros?
# if we remove gazebo, then the ros-desktop-full will be removed, we cannot use ros!
apt-get remove -y '.*gazebo.*' '.*sdformat.*' '.*ignition-math.*' '.*ignition-msgs.*' '.*ignition-transport.*'

echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list

wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -

apt-get update -y

mkdir -p /opt/gazebo_vr

wget https://bitbucket.org/osrf/release-tools/raw/default/jenkins-scripts/lib/dependencies_archive.sh -O /opt/gazebo_vr/dependencies.sh

export DISTRO="xenial"
export SDFORMAT_MAJOR_VERSION=4
export GAZEBO_MAJOR_VERSION=7
export ROS_DISTRO=kinetic

. /opt/gazebo_vr/dependencies.sh

apt-get install -y --no-install-recommends $(sed 's:\\ ::g' <<< $BASE_DEPENDENCIES) $(sed 's:\\ ::g' <<< $GAZEBO_BASE_DEPENDENCIES)

apt-get install -y --no-install-recommends libbullet-dev protobuf-compiler libignition-math2-dev libignition-transport-dev libqwt-dev libsdformat4 sdf  sdformat-sdf libtinyxml2-2v5 libtinyxml2-dev libopenal1 libopenal-dev


echo "start to build gazebo"

# build and install gazebo
hg clone https://bitbucket.org/jacknlliu/gazebo /opt/gazebo_vr/gazebo

cd /opt/gazebo_vr/gazebo && hg up gazebo7-fix-boost-compile-error

mkdir build  && cd build

cmake ../

make -j4

make install

echo "start to make test"

make tests


# clean
rm -rf /opt/gazebo_vr/gazebo

rm -rf /etc/apt/sources.list.d/gazebo-stable.list

apt-get update -y
