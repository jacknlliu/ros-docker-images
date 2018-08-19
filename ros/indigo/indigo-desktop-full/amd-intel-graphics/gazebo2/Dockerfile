FROM jacknlliu/ubuntu-init:14.04

LABEL maintainer="Jack Liu <jacknlliu@gmail.com>"

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
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
    \
# update the repository and install ros packages
    && apt update -y \
    && apt install -y -q --no-install-recommends aptitude apt-transport-https \
    && apt install -y -q --no-install-recommends ros-indigo-desktop-full python-rosinstall python-rosinstall-generator ninja-build python3-pip python3-setuptools \
    ros-indigo-rosbridge-library ros-indigo-rosbridge-server ros-indigo-rosbridge-suite \
    ros-indigo-tf2-web-republisher \
    ros-indigo-tf2-geometry-msgs ros-indigo-tf2-sensor-msgs

# install additional system packages and ros packages
# update gazebo2.2 to gazebo2.2.5
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/gazebo-latest.list \
    && curl http://packages.osrfoundation.org/gazebo.key |apt-key add - \
    && apt update -y -q \
    && apt upgrade -y -q --no-install-recommends gazebo2

# install essential tools
RUN apt install -y -q --no-install-recommends  bash-completion \
    wget vim git iputils-ping iproute2 netcat tmux terminator supervisor xauth openssh-server sudo pcmanfm \
    tree ranger curl ca-certificates openssl doxygen doxygen-gui \
# install additional build tool
    && apt install -y -q --no-install-recommends build-essential gdb \
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
    && aptitude install -y -q -R mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils module-init-tools \
    \
# we should fix AMD graphics driver with image driver extension not found in ubuntu 14.04.2, refrence: https://wiki.ubuntu.com/Kernel/LTSEnablementStack#Ubuntu_14.04_LTS_-_Trusty_Tahr
    && aptitude install -y -q -R linux-generic-lts-xenial xserver-xorg-core-lts-xenial xserver-xorg-lts-xenial xserver-xorg-video-all-lts-xenial xserver-xorg-input-all-lts-xenial libwayland-egl1-mesa-lts-xenial

# install ros related components
RUN apt install -y -q --no-install-recommends ros-indigo-moveit-full \
    ros-indigo-gazebo-ros-control \
    ros-indigo-ros-controllers \
    ros-indigo-controller-manager \
    ros-indigo-rqt-controller-manager \
    ros-indigo-ur-description \
    ros-indigo-camera-calibration \
    ros-indigo-camera-calibration-parsers \
    ros-indigo-camera-info-manager \
    ros-indigo-video-stream-opencv \
    ros-indigo-find-object-2d \
    libcgal-dev \
    \
# install force dimension device driver and related components
    && apt install -y -q --no-install-recommends libusb-1.0-0 freeglut3 freeglut3-dev \
    \
# install orocos rtt components
    && apt install -y -q --no-install-recommends ros-indigo-orocos-kdl ros-indigo-rtt ros-indigo-rtt-* \
    \
# install multiplot
    && apt install -y -q --no-install-recommends python3-matplotlib python-matplotlib libqwt-dev ros-indigo-rqt-multiplot


# install RoboWare
RUN apt install -y -q --no-install-recommends wget python-pip pylint clang libxss1 libxtst6 \
    && export ROBOWAREVERSION="1.2.0-1524709819"  \
    && wget https://github.com/tonyrobotics/RoboWare/raw/master/Studio/roboware-studio_${ROBOWAREVERSION}_amd64.deb -O roboware_amd64.deb \
    && chmod a+x roboware_amd64.deb && dpkg --force-depends -i ./roboware_amd64.deb \
    && apt-get install -y -q --no-install-recommends -f \
    && rm -f roboware_amd64.deb

# copy supervisord.conf file
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy entrypoint file
COPY ./ros_entrypoint.sh /

# set user ros and sudo
ENV DOCKER_USER ros
RUN adduser --gecos "ROS User" --home /home/$DOCKER_USER --disabled-password $DOCKER_USER && \
    usermod -a -G dialout $DOCKER_USER && \
    echo "$DOCKER_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget

# switch to user ros, and $HOME is /home/ros, but workdir is still at /
USER $DOCKER_USER

# setup ros env
RUN sudo rosdep init && rosdep update  \
    && echo "export QT_X11_NO_MITSHM=1" >> $HOME/.bashrc \
    && echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" >> $HOME/.bashrc

# configure Qt
RUN mkdir -p $HOME/.config/QtProject

# install urdf-rviz
RUN cd $HOME && curl https://sh.rustup.rs -sSf > rustup.sh && chmod a+x rustup.sh \
    && ./rustup.sh -y && rm -f ./rustup.sh \
    && echo "source $HOME/.cargo/env" >> $HOME/.bashrc \
    && /bin/bash -c "source $HOME/.cargo/env && cargo install -f urdf-viz"

USER root

# install ros python3 support
RUN apt install -y -q --no-install-recommends python3-dev libyaml-dev libyaml-0-2  libyaml-cpp0.5 libyaml-cpp-dev && pip3 install --upgrade pip && pip3 install catkin-tools rospkg ws4py transforms3d trollius defusedxml

# install dependecies for ros genmsg
RUN pip install empy

# install other tools
RUN pip3 install --upgrade --ignore-installed six; pip2 install --upgrade --ignore-installed six \
    && pip3 install pendulum; pip2 install pendulum \
    \
     # install roslibpy for ROS Bridge
    && pip3 install numpy roslibpy; pip2 install numpy roslibpy \
    && pip3 install scipy pandas pyquaternion; pip2 install scipy pandas pyquaternion; \
       pip3 install tldr.py

# apt clean
RUN apt-get autoclean \
    && apt-get clean all \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*


COPY ./QtCreator.ini  /home/$DOCKER_USER/.config/QtProject/
RUN chown -R $DOCKER_USER:$DOCKER_USER  /home/$DOCKER_USER/.config/QtProject/

# config gazebo volume
RUN mkdir -p /home/$DOCKER_USER/.gazebo/models && chown -R $DOCKER_USER:$DOCKER_USER /home/$DOCKER_USER/.gazebo

# share this volume with other containers from this image. VOLUME allow use shell environment variable like ${}
VOLUME ["/home/$DOCKER_USER/.gazebo/models"]

# cd /home/ros default
WORKDIR /home/$DOCKER_USER

# must run /sbin/my_init with root user
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
