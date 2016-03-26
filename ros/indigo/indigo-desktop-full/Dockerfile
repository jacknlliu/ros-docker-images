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
    ros-indigo-ros-controllers ros-indigo-ur-description \
    && rm -rf /var/lib/apt/lists/*


