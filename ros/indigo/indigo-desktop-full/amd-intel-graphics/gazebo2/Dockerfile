FROM ubuntu:trusty

MAINTAINER Jack Liu jacknlliu@gmail.com

# setup environment
ENV DEBIAN_FRONTEND noninteractive

# setup environment
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list

# setup keys
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 0xB01FA116

# update the repository
RUN apt-get update -y

# install ros packages
ENV ROS_DISTRO indigo
RUN apt-get install -y -q --no-install-recommends ros-indigo-desktop-full=1.1.4-0*  python-rosinstall

# rosdep init
RUN rosdep init


# install additional system packages and ros packages
# update gazebo2.2 to gazebo2.2.5
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/gazebo-latest.list

RUN curl http://packages.osrfoundation.org/gazebo.key |apt-key add -

RUN apt-get update -y && apt-get upgrade -y gazebo2


# install essential tools
RUN apt-get install -y -q --no-install-recommends  bash-completion wget vim git terminator supervisor xauth openssh-server sudo

# install additional build tool
RUN apt-get install -y -q --no-install-recommends build-essential gdb

# install IDE essential packages
RUN apt-get install -y -q --no-install-recommends mesa-common-dev libglu1-mesa-dev libfontconfig1 qt5-default qtcreator qtdeclarative5-qtquick2-plugin


# setup ssh
RUN mkdir -p /var/run/sshd && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# install intel graphics driver
RUN apt-get install -y -q --no-install-recommends libgl1-mesa-glx libgl1-mesa-dri

# install amd graphics open source driver
RUN apt-get install -y -q --no-install-recommends mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils

# we should fix AMD graphics driver with image driver extension not found in ubuntu 14.04.2, refrence: https://wiki.ubuntu.com/Kernel/LTSEnablementStack#Ubuntu_14.04_LTS_-_Trusty_Tahr
RUN apt-get install -y -q --no-install-recommends linux-generic-lts-xenial xserver-xorg-core-lts-xenial xserver-xorg-lts-xenial xserver-xorg-video-all-lts-xenial xserver-xorg-input-all-lts-xenial libwayland-egl1-mesa-lts-xenial

# install ros related components
RUN apt-get install -y -q --no-install-recommends ros-indigo-moveit-full \
    ros-indigo-gazebo-ros-control \
    ros-indigo-ros-controllers \
    ros-indigo-rqt-controller-manager \
    ros-indigo-ur-description \
    ros-indigo-camera-calibration \
    ros-indigo-camera-calibration-parsers \
    ros-indigo-camera-info-manager

# install orocos rtt components
RUN apt-get install -y -q --no-install-recommends ros-indigo-orocos-kdl ros-indigo-rtt ros-indigo-rtt-*

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
RUN HOME=/home/ros rosdep update && \
echo "export QT_X11_NO_MITSHM=1" >> /home/ros/.bashrc && \
echo "export HOME=/home/ros" >> /home/ros/.bashrc && \
echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" >> /home/ros/.bashrc

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
