FROM ubuntu:xenial

MAINTAINER Jack Liu jacknlliu@gmail.com

# setup environment
ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# define ros distribution version
ENV ROS_DISTRO kinetic

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list

# setup keys
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116

# update the repository and install ros kinetic
RUN apt-get update -y  && apt-get install -y -q --no-install-recommends ros-kinetic-desktop-full python-rosinstall

# rosdep init
RUN rosdep init

# install additional system packages and ros packages
# update gazebo
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu xenial main" > /etc/apt/sources.list.d/gazebo-latest.list

RUN curl http://packages.osrfoundation.org/gazebo.key |apt-key add -

RUN apt-get update -y && apt-get install -y -q --no-install-recommends gazebo7

# apt-get autoclean
RUN apt-get autoclean -y \
&& apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*
