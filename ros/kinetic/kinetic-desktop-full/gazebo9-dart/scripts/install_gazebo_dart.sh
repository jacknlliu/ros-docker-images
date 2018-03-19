#!/usr/bin/env bash

# using this script to install gazebo 9 with dart support from source codes

# install tools
apt-get update -y && apt-get install -y --no-install-recommends wget mercurial

# Main repository for dart
apt-add-repository -y ppa:dartsim/ppa
apt-get update -y
apt-get install -y --no-install-recommends libdart6-dev

# Optional DART utilities
apt-get install -y --no-install-recommends libdart6-utils-urdf-dev libdart6-all-dev


# recompile gazebo

# install dependencies. Should we remove previous packages from ros?
# if we remove gazebo, then the ros-desktop-full will be removed, we cannot use ros!

# apt-get remove -y '.*gazebo.*' '.*sdformat.*' '.*ignition-math.*' '.*ignition-msgs.*' '.*ignition-transport.*'

if [[ ! -f "/etc/apt/sources.list.d/gazebo-stable.list" ]]; then
  echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable xenial main" > /etc/apt/sources.list.d/gazebo-stable.list

  wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -

  apt-get update -y
fi

# create a workspace for gazebo
mkdir -p /tmp/gazebo_dart

# configure gazebo dependencies
wget https://bitbucket.org/osrf/release-tools/raw/default/jenkins-scripts/lib/dependencies_archive.sh -O /tmp/gazebo_dart/dependencies.sh

export DISTRO="xenial"
export SDFORMAT_MAJOR_VERSION=6
export GAZEBO_MAJOR_VERSION=9
export ROS_DISTRO=kinetic
export DART_FROM_PKGS=true

. /tmp/gazebo_dart/dependencies.sh

apt-get install -y --no-install-recommends $(sed 's:\\ ::g' <<< $BASE_DEPENDENCIES) $(sed 's:\\ ::g' <<< $GAZEBO_BASE_DEPENDENCIES)

# install some possible packages
apt-get install -y --no-install-recommends sdf sdformat-sdf libtinyxml2-2v5 libtinyxml2-dev libopenal-dev

# build and install gazebo
hg clone https://bitbucket.org/osrf/gazebo /tmp/gazebo_dart/gazebo

cd /tmp/gazebo_dart/gazebo && hg up gazebo9

echo "start to build gazebo"

mkdir build  && cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr ../

# we should not use -jN to avoid error: g++: internal compiler error: Killed (program cc1plus), see https://github.com/docker/for-win/issues/403
make

make install

echo "Install gazebo done!"


# clean
rm -rf /tmp/gazebo_dart/
