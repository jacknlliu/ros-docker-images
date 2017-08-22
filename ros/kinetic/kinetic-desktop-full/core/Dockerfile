FROM phusion/baseimage:latest

LABEL maintainer="Jack Liu <jacknlliu@gmail.com>"

# setup environment
ENV DEBIAN_FRONTEND noninteractive

ENV LANG en_US.UTF-8

# define ros distribution version
ENV ROS_DISTRO kinetic

RUN apt-get update -y && apt-get upgrade -y -q --no-install-recommends -o Dpkg::Options::="--force-confold"  \
    && apt-get install -y -q --no-install-recommends apt-transport-https aptitude locales && locale-gen en_US.UTF-8

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list  \
    \
# setup keys
    && apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116  \
    \
# update the repository and install ros kinetic
    && aptitude update -y -q && aptitude install -y -q -R ros-kinetic-desktop-full python-rosinstall ninja-build python3-pip python3-setuptools

# install ros python3 support
RUN pip3 install --upgrade pip && pip3 install --no-cache-dir catkin-tools rospkg

# install additional system packages and ros packages
# install additional build tool
RUN aptitude install -y -q -R build-essential gdb tmux \
    \
# install IDE essential packages and qt5, qtcreator, qtdeclarative5-qtquick2
    && aptitude install -y -q -R mesa-common-dev libglu1-mesa-dev libfontconfig1 \
    \
# install intel graphics driver
    && aptitude install -y -q -R libgl1-mesa-glx libgl1-mesa-dri \
    \
# install amd graphics open source driver
    && aptitude install -y -q -R mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils module-init-tools

# install RoboWare
RUN aptitude install -y -q -R  wget python-pip pylint clang libxss1 libnss3 libnotify4 libxtst6 ~nlibgconf-2 \
    && export ROBOWAREVERSION="0.7.0-1498718847"  \
    && wget https://github.com/tonyrobotics/RoboWare/raw/master/roboware-studio_${ROBOWAREVERSION}_amd64.deb -O roboware_amd64.deb \
    && chmod a+x roboware_amd64.deb && dpkg -i roboware_amd64.deb \
    && rm -f roboware_amd64.deb

# install essential tools, ssh sever, sudo
RUN aptitude install -y -q -R  bash-completion wget vim git iputils-ping iproute2 netcat terminator xauth openssh-server sudo pcmanfm

# aptitude clean
RUN aptitude clean -y -q \
    && aptitude -o Aptitude::Delete-Unused=1 install -y -q \
    && rm -rf /var/lib/apt/lists/*


# config sshd
RUN mkdir -p /var/run/sshd && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config \
  &&  rm -f /etc/service/sshd/down  && /etc/my_init.d/00_regen_ssh_host_keys.sh \
  && mkdir -p /opt/scripts/container/ && chmod -R a+rx /opt/scripts/

# copy entrypoint file
COPY ./scripts/ros_entrypoint.sh /opt/scripts/container/
COPY ./scripts/containerinit.sh /etc/my_init.d/
RUN chmod a+rx /opt/scripts/container/ros_entrypoint.sh && chmod +x /etc/my_init.d/containerinit.sh

# set user ros and sudo
RUN adduser --gecos "ROS User" --home /home/ros --disabled-password ros && \
  usermod -a -G dialout ros && \
  echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget

# switch to user ros, but the HOME is still /, not /home/ros
USER ros

# setup ros env
RUN sudo rosdep init && rosdep update  \
  && echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" >> /home/ros/.bashrc

USER root

# config gazebo volume
RUN mkdir -p /home/ros/.gazebo/models && chown -R ros:ros /home/ros/.gazebo

# share this volume with other containers from this image
VOLUME ["/home/ros/.gazebo/models"]

# cd /home/ros default
WORKDIR /home/ros

# must run /sbin/my_init with root user. So we shouldn't switch to normal user when use docker exec -it ...
ENTRYPOINT ["/sbin/my_init", "--quiet", "--", "setuser", "ros", "/opt/scripts/container/ros_entrypoint.sh"]
CMD ["bash"]
