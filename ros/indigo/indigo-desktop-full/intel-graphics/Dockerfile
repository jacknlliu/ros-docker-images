FROM osrf/ros:indigo-desktop
MAINTAINER Jack Liu jackliu.lab@gmail.com

# using upgrade (not recommend)
RUN apt-get update && apt-get upgrade -y

# install ros packages
RUN apt-get update && apt-get install -y \
    ros-indigo-desktop-full=1.1.4-0* 

# install related components
RUN apt-get install -y ros-indigo-moveit-core ros-indigo-moveit-ros-planning \
    ros-indigo-gazebo-ros-control ros-indigo-effort-controllers \
    ros-indigo-joint-state-controller ros-indigo-joint-trajectory-controller \ 
    ros-indigo-ros-controllers ros-indigo-ur-description

# install intel graphics driver, especially i915 driver
RUN echo "deb http://ppa.launchpad.net/oibaf/graphics-drivers/ubuntu trusty main" > /etc/apt/sources.list.d/intel-video-driver.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 957D2708A03A4626 \
    && apt-get update

RUN apt-get install -y  xserver-xorg-video-intel \ 
    && rm -rf /var/lib/apt/lists/*
