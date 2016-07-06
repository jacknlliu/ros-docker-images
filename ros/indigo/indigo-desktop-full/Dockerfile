FROM osrf/ros:indigo-desktop-full
MAINTAINER Jack Liu jackliu.lab@gmail.com

# update gazebo2.2 to gazebo2.2.5
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu trusty main" > /etc/apt/sources.list.d/gazebo-latest.list

RUN curl http://packages.osrfoundation.org/gazebo.key |apt-key add -

RUN apt-get update && apt-get upgrade -y gazebo2 \
    && rm -rf /var/lib/apt/lists/*

# using upgrade (not recommend)
RUN apt-get update && apt-get upgrade -y

# install essential tools
RUN apt-get install -y  vim  git

# download gazebo models
RUN hg clone https://bitbucket.org/osrf/gazebo_models
RUN mkdir -p ~/.gazebo/ && ln -s `pwd`/gazebo_models ~/.gazebo/models

# install related components
RUN apt-get install -y ros-indigo-moveit-full \
    ros-indigo-gazebo-ros-control ros-indigo-effort-controllers \
    ros-indigo-joint-state-controller ros-indigo-joint-trajectory-controller \
    ros-indigo-ros-controllers ros-indigo-ur-description \
    && rm -rf /var/lib/apt/lists/*


# add "ros" user
RUN adduser --gecos "ROS User" --disabled-password ros
RUN usermod -a -G dialout ros

RUN echo "ros ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/99_aptget
RUN chmod 0440 /etc/sudoers.d/99_aptget && chown root:root /etc/sudoers.d/99_aptget

# "ros" user
USER ros

# set environment
RUN echo "export QT_X11_NO_MITSHM=1" >> /home/ros/.bashrc
RUN echo "export HOME=/home/ros" >> /home/ros/.bashrc
RUN echo "source /opt/ros/indigo/setup.bash" >> /home/ros/.bashrc
