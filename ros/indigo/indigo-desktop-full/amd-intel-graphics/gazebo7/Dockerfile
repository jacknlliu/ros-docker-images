FROM ubuntu:14.04

MAINTAINER Jack Liu <jacknlliu@gmail.com>

# setup environment
ENV DEBIAN_FRONTEND noninteractive
ENV ROS_DISTRO indigo

# setup locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list \
    \
# setup keys
    && apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
    \
# update the repository and install ros packages
    && apt-get update -y \
    && apt-get install -y -q --no-install-recommends apt-transport-https aptitude \
    && aptitude install -y -q -R ros-indigo-desktop-full python-rosinstall \
    && rosdep init

# install additional system packages and ros packages
# update gazebo2.2 to gazebo7
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/gazebo-latest.list \
    && curl http://packages.osrfoundation.org/gazebo.key |apt-key add - \
    && aptitude update -y -q \
    && aptitude remove -y -q gazebo2 \
    && aptitude install -y -q -R gazebo7

# install essential tools
RUN aptitude install -y -q -R  bash-completion wget vim git terminator supervisor xauth openssh-server sudo \
    \
# install additional build tool
    && aptitude install -y -q -R build-essential gdb \
    \
# install IDE essential packages
    && aptitude install -y -q -R mesa-common-dev libglu1-mesa-dev libfontconfig1 qt5-default qtcreator qtdeclarative5-qtquick2-plugin \
    \
# setup ssh
    && mkdir -p /var/run/sshd && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

# install intel graphics driver
RUN aptitude install -y -q -R libgl1-mesa-glx libgl1-mesa-dri \
    \
# install amd graphics open source driver
    && aptitude install -y -q -R mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils \
    \
# we should fix AMD graphics driver with image driver extension not found in ubuntu 14.04.2, refrence: https://wiki.ubuntu.com/Kernel/LTSEnablementStack#Ubuntu_14.04_LTS_-_Trusty_Tahr
    && aptitude install -y -q -R linux-generic-lts-xenial xserver-xorg-core-lts-xenial xserver-xorg-lts-xenial xserver-xorg-video-all-lts-xenial xserver-xorg-input-all-lts-xenial libwayland-egl1-mesa-lts-xenial

# install ros related components
RUN aptitude install -y -q -R ros-indigo-moveit-full \
    ros-indigo-gazebo7-ros-control \
    ros-indigo-gazebo7-ros-pkgs \
    ros-indigo-ros-controllers \
    ros-indigo-controller-manager \
    ros-indigo-rqt-controller-manager \
    ros-indigo-ur-description \
    ros-indigo-camera-calibration \
    ros-indigo-camera-calibration-parsers \
    ros-indigo-camera-info-manager \
    \
# install orocos rtt components
    && aptitude install -y -q -R ros-indigo-orocos-kdl ros-indigo-rtt ~nros-indigo-rtt-*

# install RoboWare
RUN aptitude install -y -q -R  python-pip pylint clang \
    && export ROBOWAREVERSION="0.5.1-1493340874"  \
    && curl https://github.com/tonyrobotics/RoboWare/raw/master/roboware-studio_${ROBOWAREVERSION}_amd64.deb -o roboware_amd64.deb \
    && chmod a+x roboware_amd64.deb && dpkg -i --force roboware_amd64.deb \
    && rm -f roboware_amd64.deb

# aptitude clean
RUN aptitude clean -y -q \
    && aptitude -o Aptitude::Delete-Unused=1 install -y -q \
    && rm -rf /var/lib/apt/lists/*

# copy supervisord.conf file
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy entrypoint file
COPY ./ros_entrypoint.sh /

# set user ros and sudo
RUN adduser --gecos "ROS User" --home /home/ros --disabled-password ros \
    && usermod -a -G dialout ros \
    && echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget

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
