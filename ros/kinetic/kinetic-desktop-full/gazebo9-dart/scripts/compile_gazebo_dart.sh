#!/usr/bin/env bash

echo "start to build gazebo"

# build and install gazebo

# create catkin workspace
export WS=/opt/gazebo/gazebo9_dart/ws
mkdir -p /opt/gazebo/gazebo9_dart/ws/src

# clone packages into this folder
cd ${WS}/src
git clone https://github.com/ros/catkin.git
git clone https://github.com/bulletphysics/bullet3.git
git clone https://github.com/dartsim/dart.git
hg clone https://bitbucket.org/osrf/sdformat
hg clone https://bitbucket.org/osrf/gazebo
# did we still need libfcl-dev here?
git clone https://github.com/flexible-collision-library/fcl

cd ${WS}/src/gazebo && hg up gazebo9
cd ${WS}/src/sdformat && hg up sdf6

cd ${WS}/src/dart && git checkout release-6.3
cd ${WS}/src/bullet3 && git checkout 2.83.6
cd ${WS}/src/fcl && git checkout 0.3.2

# add package.xml files for the plain cmake package.
curl https://bitbucket.org/scpeters/unix-stuff/raw/master/package_xml/package_bullet.xml    > ${WS}/src/bullet3/package.xml

curl https://bitbucket.org/scpeters/unix-stuff/raw/master/package_xml/package_dart-core.xml > ${WS}/src/dart/package.xml

curl https://bitbucket.org/scpeters/unix-stuff/raw/master/package_xml/package_gazebo.xml    > ${WS}/src/gazebo/package.xml

curl https://bitbucket.org/scpeters/unix-stuff/raw/master/package_xml/package_sdformat.xml  > ${WS}/src/sdformat/package.xml

cd ${WS}
catkin init
catkin build -vi --cmake-args \
  -DBUILD_CORE_ONLY=ON \
  -DBUILD_SHARED_LIBS=ON \
  -DUSE_DOUBLE_PRECISION=ON
