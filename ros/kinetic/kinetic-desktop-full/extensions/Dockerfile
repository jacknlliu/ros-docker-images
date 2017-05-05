FROM lmaths/ros:kinetic-core

MAINTAINER Jack Liu jacknlliu@gmail.com

# install essential tools, ssh sever, sudo
RUN aptitude update -y -q && aptitude install -y -q -R  bash-completion wget vim git iputils-ping terminator supervisor xauth openssh-server sudo

# install ros related components
RUN aptitude install -y -q -R ros-kinetic-gazebo-ros-control \
    ros-kinetic-ros-controllers \
    ros-kinetic-rqt-controller-manager \
    ros-kinetic-moveit \
    ros-kinetic-orocos-kdl \
    ros-kinetic-orocos-kinematics-dynamics \
    ros-kinetic-pid  \
\
# install Barret_Hand related components
    && aptitude install -y -q -R libignition-math2-dev libignition-common-dev ros-kinetic-barrett-hand ros-kinetic-barrett-hand-sim \
\
# install kinematics module
&& aptitude install -y -q -R ros-kinetic-calibration-estimation ros-kinetic-kdl-parser-py  \
\
# install fast inverse kinematics module
&& aptitude install -y -q -R ros-kinetic-katana-moveit-ikfast-plugin  ros-kinetic-trac-ik-lib ros-kinetic-trac-ik-kinematics-plugin

# apt-get autoclean
RUN aptitude clean -y -q \
&& sudo aptitude -o Aptitude::Delete-Unused=1 install -y -q \
&& rm -rf /var/lib/apt/lists/*
