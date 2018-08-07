#!/usr/bin/env bash

# using this script to install gazebo 9 with dart support from source codes

# install tools
apt-get update -y && apt-get install -y --no-install-recommends wget mercurial python-catkin-pkg python-catkin-tools


# NOTE: we cannot install dart from package, this will have broken dependencies with ROS!
# # Main repository for dart
# apt-add-repository -y ppa:dartsim/ppa
# apt-get update -y
# apt-get install -y --no-install-recommends libdart6-dev
#
# # Optional DART utilities
# apt-get install -y --no-install-recommends libdart6-utils-urdf-dev libdart6-all-dev


# recompile gazebo

# install dependencies. Should we remove previous packages from ros?
# if we remove gazebo, then the ros-desktop-full will be removed, we cannot use ros!

# apt-get remove -y '.*gazebo.*' '.*sdformat.*' '.*ignition-math.*' '.*ignition-msgs.*' '.*ignition-transport.*'

mkdir -p /opt/gazebo/gazebo9_dart

wget https://bitbucket.org/osrf/release-tools/raw/default/jenkins-scripts/lib/dependencies_archive.sh -O /opt/gazebo/gazebo9_dart/dependencies.sh

export DISTRO="xenial"
export SDFORMAT_MAJOR_VERSION=6
export GAZEBO_MAJOR_VERSION=9
export ROS_DISTRO=kinetic
export DART_FROM_PKGS=false

. /opt/gazebo/gazebo9_dart/dependencies.sh

apt-get install -y --no-install-recommends $(sed 's:\\ ::g' <<< $BASE_DEPENDENCIES) $(sed 's:\\ ::g' <<< $GAZEBO_BASE_DEPENDENCIES)

# install some possible packages
apt-get install -y --no-install-recommends sdf sdformat-sdf libtinyxml2-2v5 libtinyxml2-dev libopenal-dev

chmod a+rwx -R /opt/gazebo && chown -R ros:ros /opt/gazebo
# we should not use -jN to avoid error: g++: internal compiler error: Killed (program cc1plus), see https://github.com/docker/for-win/issues/403
