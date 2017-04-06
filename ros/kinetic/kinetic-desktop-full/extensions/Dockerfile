FROM lmaths/ros:kinetic-core

MAINTAINER Jack Liu jacknlliu@gmail.com

# install essential tools, ssh sever, sudo
RUN apt-get install -y -q --no-install-recommends  bash-completion wget vim git iputils-ping terminator supervisor openssh-server  sudo

# install ros related components
RUN apt-get update -y && apt-get install -y -q --no-install-recommends  ros-kinetic-gazebo-ros-control \
    ros-kinetic-ros-controllers \
    ros-kinetic-rqt-controller-manager \
    ros-kinetic-moveit \
    ros-kinetic-orocos-kdl \
    ros-kinetic-orocos-kinematics-dynamics \
    ros-kinetic-pid

# install Barret_Hand related components
RUN apt-get install -y -q --no-install-recommends libignition-math2-dev libignition-common-dev ros-kinetic-barrett-hand ros-kinetic-barrett-hand-sim

# install kinematics module
RUN apt-get install -y -q --no-install-recommends ros-kinetic-calibration-estimation ros-kinetic-kdl-parser-py

# install fast inverse kinematics module
RUN apt-get install -y -q --no-install-recommends ros-kinetic-katana-moveit-ikfast-plugin  ros-kinetic-trac-ik-lib ros-kinetic-trac-ik-kinematics-plugin

# apt-get autoclean
RUN apt-get autoclean -y \
&& apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*
