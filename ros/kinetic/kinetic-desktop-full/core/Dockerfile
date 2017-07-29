FROM ubuntu:16.04

MAINTAINER Jack Liu <jacknlliu@gmail.com>

# setup environment
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y -q --no-install-recommends apt-transport-https aptitude locales && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8

# define ros distribution version
ENV ROS_DISTRO kinetic

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list  \
    \
# setup keys
    && apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116  \
    \
# update the repository and install ros kinetic
    && aptitude update -y -q && aptitude install -y -q -R ros-kinetic-desktop-full python-rosinstall ninja-build python3-pip python3-setuptools \
    \
# rosdep init
    && rosdep init

# install ros python3 support
RUN pip3 install --upgrade pip && pip3 install --no-cache-dir catkin-tools rospkg

# install additional system packages and ros packages
# install additional build tool
RUN aptitude install -y -q -R build-essential gdb tmux \
    \
# install IDE essential packages and qt5, qtcreator, qtdeclarative5-qtquick2
    && aptitude install -y -q -R mesa-common-dev libglu1-mesa-dev libfontconfig1 qt5-default qtcreator qtdeclarative5-qtquick2-plugin \
    \
# install intel graphics driver
    && aptitude install -y -q -R libgl1-mesa-glx libgl1-mesa-dri \
    \
# install amd graphics open source driver
    && aptitude install -y -q -R mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils

# install RoboWare
RUN aptitude install -y -q -R  wget python-pip pylint clang libxss1 libnss3 libnotify4 libxtst6 ~nlibgconf-2 \
    && export ROBOWAREVERSION="0.7.0-1498718847"  \
    && wget https://github.com/tonyrobotics/RoboWare/raw/master/roboware-studio_${ROBOWAREVERSION}_amd64.deb -O roboware_amd64.deb \
    && chmod a+x roboware_amd64.deb && dpkg -i roboware_amd64.deb \
    && rm -f roboware_amd64.deb

# aptitude clean
RUN aptitude clean -y -q \
    && aptitude -o Aptitude::Delete-Unused=1 install -y -q \
    && rm -rf /var/lib/apt/lists/*
