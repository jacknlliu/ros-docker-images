FROM jacknlliu/ubuntu-init:16.04

LABEL maintainer="Jack Liu <jacknlliu@gmail.com>"

# setup environment
ENV DEBIAN_FRONTEND noninteractive

ENV LANG en_US.UTF-8

# define ros distribution version
ENV ROS_DISTRO kinetic

RUN apt update -y \
&& apt install -y -q --no-install-recommends apt-utils apt-transport-https locales && locale-gen en_US.UTF-8

# for fix pip2 SSL AttributionError
RUN apt install -y -q --no-install-recommends python-pip && apt-get --auto-remove --yes remove python-openssl && pip2 install -U pyOpenSSL

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list  \
    \
# setup keys
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654  \
    \
# update the repository and install ros kinetic
    && apt update -y -q && apt install -y -q --no-install-recommends ros-kinetic-desktop-full \
    python-rosinstall python-rosinstall-generator ninja-build python3-pip python3-setuptools \
    python3-defusedxml python3-dev \
    ros-kinetic-rosbridge-library ros-kinetic-rosbridge-server ros-kinetic-rosbridge-suite \
    ros-kinetic-tf2-web-republisher \
    ros-kinetic-tf2-relay ros-kinetic-tf2-geometry-msgs ros-kinetic-tf2-sensor-msgs

# update gazebo7.0 to gazebo7 latest
RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu xenial main" > /etc/apt/sources.list.d/gazebo-latest.list \
    && curl http://packages.osrfoundation.org/gazebo.key |apt-key add - \
    && apt update -y -q \
    && apt upgrade -y -q --no-install-recommends gazebo7

# install ros python3 support
RUN pip3 install --upgrade pip && pip3 install --no-cache-dir catkin-tools rospkg ws4py transforms3d trollius

# install dependecies for ros genmsg
RUN pip install empy

# install other tools
RUN  pip3 install pendulum; pip2 install pendulum \
    \
     # install roslibpy for ROS Bridge
    && pip3 install numpy roslibpy; pip2 install numpy roslibpy \
    && pip3 install scipy pandas pyquaternion; pip2 install scipy pandas pyquaternion; \
    pip3 install tldr.py

# install additional system packages and ros packages
# install additional build tool
RUN apt install -y -q --no-install-recommends build-essential gdb tmux \
    doxygen doxygen-gui \
# install IDE essential packages and qt5, qtcreator, qtdeclarative5-qtquick2
    && apt install -y -q --no-install-recommends mesa-common-dev libglu1-mesa-dev libfontconfig1 qt5-default qtcreator qtdeclarative5-qtquick2-plugin \
    \
# install intel graphics driver
    && apt install -y -q --no-install-recommends libgl1-mesa-glx libgl1-mesa-dri \
    \
# install amd graphics open source driver
    && apt install -y -q --no-install-recommends mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils module-init-tools

# install RoboWare
RUN apt install -y -q --no-install-recommends wget python-pip pylint clang libxss1 libxtst6 \
    && export ROBOWAREVERSION="1.2.0-1524709819"  \
    && wget https://github.com/tonyrobotics/RoboWare/raw/master/Studio/roboware-studio_${ROBOWAREVERSION}_amd64.deb -O roboware_amd64.deb \
    && chmod a+x roboware_amd64.deb && apt install -y -q --no-install-recommends ./roboware_amd64.deb \
    && apt install -y -q --no-install-recommends -f \
    && rm -f roboware_amd64.deb

# install essential tools, ssh sever, sudo
RUN apt update -y -q && apt install -y -q --no-install-recommends bash-completion \
    wget vim git iputils-ping iproute2 netcat tmux terminator xauth openssh-server sudo pcmanfm \
    tree ranger curl ca-certificates openssl

# install ros related components
RUN apt install -y -q --no-install-recommends ros-kinetic-gazebo-ros-control \
    ros-kinetic-ros-controllers \
    ros-kinetic-rqt-controller-manager \
    ros-kinetic-moveit \
    ros-kinetic-orocos-kdl \
    ros-kinetic-orocos-kinematics-dynamics \
    ros-kinetic-pid  \
    \
    # install orocos rtt components
    && apt install -y -q --no-install-recommends ros-kinetic-rtt ros-kinetic-rtt-* \
    \
# install Barret_Hand related components
    && apt install -y -q --no-install-recommends libignition-math2-dev ros-kinetic-barrett-hand ros-kinetic-barrett-hand-sim \
    \
# install force dimension device driver and related components
    && apt install -y -q --no-install-recommends libusb-1.0-0 libusb-1.0-0-dev freeglut3 freeglut3-dev \
    \
# install kinematics module
    && apt install -y -q --no-install-recommends ros-kinetic-calibration-estimation ros-kinetic-kdl-parser-py  \
    \
# install fast inverse kinematics module
    && apt install -y -q --no-install-recommends ros-kinetic-katana-moveit-ikfast-plugin  ros-kinetic-trac-ik-lib ros-kinetic-trac-ik-kinematics-plugin \
    \
# install video opencv driver and find_object application
    && apt install -y -q --no-install-recommends ros-kinetic-video-stream-opencv ros-kinetic-find-object-2d libcgal-dev  libcgal-qt5-dev \
    \
# install multiplot
    && apt install -y -q --no-install-recommends libqwt-dev libqwt-qt5-dev ros-kinetic-rqt-multiplot


RUN mkdir -p /opt/scripts/container/
COPY ./scripts/* /opt/scripts/container/
# copy entrypoint file
RUN chmod -R a+rx /opt/scripts/ && cp /opt/scripts/container/containerinit.sh /etc/my_init.d/ && chmod u+x /etc/my_init.d/containerinit.sh

RUN /opt/scripts/container/quick-fix.sh

# config sshd
RUN mkdir -p /var/run/sshd && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config \
    &&  rm -f /etc/service/sshd/down  && /etc/my_init.d/00_regen_ssh_host_keys.sh

# set user ros and sudo
ENV DOCKER_USER ros
RUN adduser --gecos "ROS User" --home /home/$DOCKER_USER --disabled-password $DOCKER_USER && \
    usermod -a -G dialout $DOCKER_USER && \
    echo "$DOCKER_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget

# switch to user ros, and $HOME is /home/ros, but workdir is still at /
USER $DOCKER_USER

# setup ros env
RUN sudo rosdep init && rosdep update  \
    && echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" >> $HOME/.bashrc

# configure Qt
RUN mkdir -p $HOME/.config/QtProject

# install urdf-rviz
RUN cd $HOME && curl https://sh.rustup.rs -sSf > rustup.sh && chmod a+x rustup.sh \
    && ./rustup.sh -y && rm -f ./rustup.sh \
    && echo "source $HOME/.cargo/env" >> $HOME/.bashrc \
    && /bin/bash -c "source $HOME/.cargo/env && cargo install -f urdf-viz"

USER root

# apt clean
RUN apt autoclean \
    && apt clean all \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*


COPY ./config/QtCreator.ini  /home/$DOCKER_USER/.config/QtProject/
RUN chown -R $DOCKER_USER:$DOCKER_USER  /home/$DOCKER_USER/.config/QtProject/

# config gazebo volume
RUN mkdir -p /home/$DOCKER_USER/.gazebo/models && chown -R $DOCKER_USER:$DOCKER_USER /home/$DOCKER_USER/.gazebo

# share this volume with other containers from this image. VOLUME allow use shell environment variable like ${}
VOLUME ["/home/$DOCKER_USER/.gazebo/models"]

# cd /home/ros default
WORKDIR /home/$DOCKER_USER

# must run /sbin/my_init with root user
ENTRYPOINT ["/opt/scripts/container/ros_entrypoint.sh"]
CMD ["bash"]
