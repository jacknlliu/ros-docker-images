FROM phusion/baseimage:latest

MAINTAINER Jack Liu <jacknlliu@gmail.com>

# setup environment
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get upgrade -y -q --no-install-recommends -o Dpkg::Options::="--force-confold"  \
&& apt-get install -y -q --no-install-recommends apt-transport-https aptitude locales && locale-gen en_US.UTF-8

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
    && aptitude update -y -q && aptitude install -y -q -R ros-kinetic-desktop-full python-rosinstall \
    \
# rosdep init
    && rosdep init

# install additional system packages and ros packages
# update gazebo
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu xenial main" > /etc/apt/sources.list.d/gazebo-latest.list  \
    && curl http://packages.osrfoundation.org/gazebo.key |apt-key add -  \
    && aptitude update -y -q && aptitude install -y -q -R gazebo7

# install additional build tool
RUN aptitude install -y -q -R build-essential gdb \
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
RUN aptitude install -y -q -R  wget python-pip pylint clang libnss3 libnotify4 \
    && export ROBOWAREVERSION="0.5.1-1493340874"  \
    && wget https://github.com/tonyrobotics/RoboWare/raw/master/roboware-studio_${ROBOWAREVERSION}_amd64.deb -O roboware_amd64.deb \
    && chmod a+x roboware_amd64.deb && dpkg -i roboware_amd64.deb \
    && rm -f roboware_amd64.deb


# install essential tools, ssh sever, sudo
RUN aptitude update -y -q && aptitude install -y -q -R  bash-completion wget vim git iputils-ping terminator xauth openssh-server sudo

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

# aptitude clean
RUN aptitude clean -y -q \
    && aptitude -o Aptitude::Delete-Unused=1 install -y -q \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# config sshd
RUN mkdir -p /var/run/sshd && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# copy entrypoint file
COPY ./scripts/ros_entrypoint.sh /
COPY ./scripts/containerinit.sh /etc/my_init.d/
RUN chmod +x /etc/rc.local/containerinit.sh

# set user ros and sudo
RUN adduser --gecos "ROS User" --home /home/ros --disabled-password ros && \
    usermod -a -G dialout ros && \
    echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget

# switch to user ros, but the HOME is still /, not /home/ros
USER ros

# setup ros env
RUN HOME=/home/ros rosdep update  \
    && echo "export QT_X11_NO_MITSHM=1" >> /home/ros/.bashrc  \
    && echo "export HOME=/home/ros" >> /home/ros/.bashrc  \
    && echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" >> /home/ros/.bashrc

# configure Qt
RUN mkdir -p /home/ros/.config/QtProject

USER root
COPY ./config/QtCreator.ini  /home/ros/.config/QtProject/
RUN chown -R ros:ros  /home/ros/.config/QtProject/

# config gazebo volume
RUN mkdir -p /home/ros/.gazebo/models && chown -R ros:ros /home/ros/.gazebo

# share this volume with other containers from this image
VOLUME ["/home/ros/.gazebo/models"]

USER ros

# redefine environment variables for my_init
RUN echo "/home/ros" > /etc/container_environment/HOME \
    && echo "ros"  > /etc/container_environment/USER

CMD ["/sbin/my_init"]
ENTRYPOINT ["/ros_entrypoint.sh"]
