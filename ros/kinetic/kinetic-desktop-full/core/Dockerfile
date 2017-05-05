FROM ubuntu:xenial

MAINTAINER Jack Liu jacknlliu@gmail.com

# setup environment
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install -y -q --no-install-recommends locales && locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8

# define ros distribution version
ENV ROS_DISTRO kinetic

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list

# setup keys
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# update the repository and install ros kinetic
RUN apt-get update -y  && apt-get install -y -q --no-install-recommends ros-kinetic-desktop-full python-rosinstall

# rosdep init
RUN rosdep init

# install additional system packages and ros packages
# update gazebo
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu xenial main" > /etc/apt/sources.list.d/gazebo-latest.list

RUN curl http://packages.osrfoundation.org/gazebo.key |apt-key add -

RUN apt-get update -y && apt-get install -y -q --no-install-recommends gazebo7

# install additional build tool
RUN apt-get install -y -q --no-install-recommends build-essential gdb

# install IDE essential packages and qt5, qtcreator, qtdeclarative5-qtquick2
RUN apt-get install -y -q --no-install-recommends mesa-common-dev libglu1-mesa-dev libfontconfig1 qt5-default qtcreator qtdeclarative5-qtquick2-plugin

# install intel graphics driver
RUN apt-get install -y -q --no-install-recommends libgl1-mesa-glx libgl1-mesa-dri

# install amd graphics open source driver
RUN apt-get install -y -q --no-install-recommends mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils

# apt-get autoclean
RUN apt-get autoclean -y \
&& apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*
