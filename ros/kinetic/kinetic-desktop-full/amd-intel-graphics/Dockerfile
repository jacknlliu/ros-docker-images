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
RUN apt-get update -y  && apt-get install -y -q --no-install-recommends ros-kinetic-desktop-full

# rosdep init
RUN rosdep init

# enables you to easily download many source trees for ROS packages with one command
RUN apt-get install -y -q --no-install-recommends python-rosinstall

# install additional system packages and ros packages
# update gazebo
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu xenial main" > /etc/apt/sources.list.d/gazebo-latest.list

RUN curl http://packages.osrfoundation.org/gazebo.key |apt-key add -

RUN apt-get update && apt-get install -y -q --no-install-recommends gazebo7


# install ros related components
RUN apt-get install -y -q --no-install-recommends  ros-kinetic-gazebo-ros-control \
    ros-kinetic-ros-controllers \
    ros-kinetic-rqt-controller-manager \
    ros-kinetic-moveit \
    ros-kinetic-orocos-kdl \
    ros-kinetic-orocos-kinematics-dynamics \
    ros-kinetic-pid

# install fast inverse kinematics module
RUN apt-get install -y -q --no-install-recommends ros-kinetic-katana-moveit-ikfast-plugin  ros-kinetic-trac-ik-lib

# install Barret_Hand related components
RUN apt-get install -y -q --no-install-recommends libignition-math2-dev libignition-common-dev ros-kinetic-barrett-hand ros-kinetic-barrett-hand-sim

# install essential tools
RUN apt-get install -y -q --no-install-recommends  bash-completion wget vim git iputils-ping terminator

# install additional build tool
RUN apt-get install -y -q --no-install-recommends build-essential gdb

# install IDE essential packages
RUN apt-get install -y -q --no-install-recommends mesa-common-dev libglu1-mesa-dev libfontconfig1

# install qt5 and qtcreator
RUN apt-get install -y -q --no-install-recommends qt5-default qtcreator

# install Qt plugin
RUN apt-get install -y -q --no-install-recommends qtdeclarative5-qtquick2-plugin

# install ssh and sudo
RUN apt-get install -y -q --no-install-recommends supervisor openssh-server  sudo

RUN mkdir -p /var/run/sshd && echo "ForwardX11Trusted yes" >> /etc/ssh/ssh_config

# install intel graphics driver
RUN apt-get install -y -q --no-install-recommends libgl1-mesa-glx libgl1-mesa-dri

# install amd graphics open source driver
RUN apt-get install -y -q --no-install-recommends mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils

# apt-get autoclean
RUN apt-get autoclean -y \
&& apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*

# copy supervisord.conf file
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy entrypoint file
COPY ./ros_entrypoint.sh /

# set user ros and sudo
RUN adduser --gecos "ROS User" --home /home/ros --disabled-password ros
RUN usermod -a -G dialout ros
RUN echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget

# switch to user ros, but the HOME is still /, not /home/ros
USER ros

# setup ros env
RUN HOME=/home/ros rosdep update
RUN echo "export QT_X11_NO_MITSHM=1" >> /home/ros/.bashrc
RUN echo "export HOME=/home/ros" >> /home/ros/.bashrc
RUN echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" >> /home/ros/.bashrc

# configure Qt
RUN mkdir -p /home/ros/.config/QtProject

USER root
COPY ./QtCreator.ini  /home/ros/.config/QtProject/
RUN chown -R ros:ros  /home/ros/.config/QtProject/

# config gazebo volume
RUN mkdir -p /home/ros/.gazebo/models && chown -R ros:ros /home/ros/.gazebo

# share this volume with other containers from this image
VOLUME ["/home/ros/.gazebo/models"]

USER ros

CMD ["bash"]
ENTRYPOINT ["/ros_entrypoint.sh"]
