#/bin/bash

apt-get update -y && apt-get install -y --no-install-recommends libusb-dev libudev-dev libxinerama-dev
cd /opt && hg clone https://bitbucket.org/osrf/oculussdk
cd oculussdk
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr
make
make install
cp ../LibOVR/90-oculus.rules /etc/udev/rules.d/
# udevadm control --reload-rules


# recompile gazebo

# install dependencies. Should we remove previous packages from ros?
apt-get remove -y '.*gazebo.*' '.*sdformat.*' '.*ignition-math.*' '.*ignition-msgs.*' '.*ignition-transport.*'

sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'

wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
apt-get update -y

wget https://bitbucket.org/osrf/release-tools/raw/default/jenkins-scripts/lib/dependencies_archive.sh -O /tmp/dependencies.sh

ROS_DISTRO=kinetic . /tmp/dependencies.sh

apt-get install -y --no-install-recommends $(sed 's:\\ ::g' <<< $BASE_DEPENDENCIES) $(sed 's:\\ ::g' <<< $GAZEBO_BASE_DEPENDENCIES)


# build and install gazebo
hg clone https://bitbucket.org/osrf/gazebo /tmp/gazebo
cd /tmp/gazebo

mkdir build
cd build

cmake ../

make -j4

make install

make tests
