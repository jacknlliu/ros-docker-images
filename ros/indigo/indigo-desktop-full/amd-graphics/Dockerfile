FROM ubuntu:trusty

MAINTAINER Jack Liu jackliu.lab@gmail.com

# setup environment
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list

# setup keys
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 0xB01FA116

# update the repository
RUN apt-get update

# install ros packages
ENV ROS_DISTRO indigo
RUN apt-get install -y ros-indigo-desktop-full=1.1.4-0*

# rosdep init
RUN rosdep init

# enables you to easily download many source trees for ROS packages with one command
RUN apt-get install -y python-rosinstall

# install additional system packages and ros packages
# update gazebo2.2 to gazebo2.2.5
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu trusty main" > /etc/apt/sources.list.d/gazebo-latest.list

RUN curl http://packages.osrfoundation.org/gazebo.key |apt-key add -

RUN apt-get update && apt-get upgrade -y gazebo2

# install essential tools
RUN apt-get install -y  bash-completion wget vim git terminator

# install additional build tool
RUN apt-get install -y build-essential gdb

# install IDE
RUN apt-get install -y mesa-common-dev libglu1-mesa-dev libfontconfig1
RUN apt-get install -y qt5-default qtcreator

# download gazebo models
RUN mkdir -p /ros_data/gazebo && cd /ros_data/gazebo/
RUN hg clone https://bitbucket.org/osrf/gazebo_models

# chmod
RUN ls -al /ros_data/gazebo
RUN chmod -R 777 /ros_data/gazebo/gazebo_models

# install ros related components
RUN apt-get install -y ros-indigo-moveit-full \
    ros-indigo-gazebo-ros-control ros-indigo-effort-controllers \
    ros-indigo-joint-state-controller ros-indigo-joint-trajectory-controller \
    ros-indigo-ros-controllers ros-indigo-ur-description


# install ssh
RUN apt-get install -y supervisor openssh-server  sudo

RUN mkdir -p /var/run/sshd
RUN echo "	ForwardX11Trusted yes" >> /etc/ssh/ssh_config

# copy supervisord.conf file
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy entrypoint file
COPY ./ros_entrypoint.sh /

# install amd graphics open source driver
RUN apt-get install -y   xserver-xorg-video-ati mesa-utils

# apt-get autoclean
RUN apt-get autoclean -y \
&& apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*

# set user ros and sudo
RUN adduser --gecos "ROS User" --home /home/ros --disabled-password ros
RUN usermod -a -G dialout ros
RUN echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget

# use user ros
USER ros

# setup ros env
RUN export HOME=/home/ros && rosdep update
RUN echo "export QT_X11_NO_MITSHM=1" >> /home/ros/.bashrc
RUN echo "export HOME=/home/ros" >> /home/ros/.bashrc
RUN echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" >> /home/ros/.bashrc

# link to root user home directory
RUN mkdir -p /home/ros/.gazebo/ && sudo ln -s /ros_data/gazebo/gazebo_models /home/ros/.gazebo/models

CMD ["bash"]
ENTRYPOINT ["/ros_entrypoint.sh"]
