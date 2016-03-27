FROM osrf/ros:indigo-desktop-full
MAINTAINER Jack Liu jackliu.lab@gmail.com

# update gazebo2.2 to gazebo2.2.5
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu trusty main" > /etc/apt/sources.list.d/gazebo-latest.list

RUN curl http://packages.osrfoundation.org/gazebo.key |apt-key add -

RUN apt-get update && apt-get upgrade -y gazebo2 \
    && rm -rf /var/lib/apt/lists/*

# using upgrade (not recommend)
RUN apt-get update && apt-get upgrade -y

# install related components
RUN apt-get install -y ros-indigo-moveit-core ros-indigo-moveit-ros-planning \
    ros-indigo-gazebo-ros-control ros-indigo-effort-controllers \
    ros-indigo-joint-state-controller ros-indigo-joint-trajectory-controller \ 
    ros-indigo-ros-controllers ros-indigo-ur-description \
    && rm -rf /var/lib/apt/lists/*


