FROM lmaths/ros:kinetic-extensions

MAINTAINER Jack Liu jacknlliu@gmail.com

# install additional build tool
RUN apt-get update -y && apt-get install -y -q --no-install-recommends build-essential gdb

# install IDE essential packages
RUN apt-get install -y -q --no-install-recommends mesa-common-dev libglu1-mesa-dev libfontconfig1

# install qt5 and qtcreator, qtdeclarative5-qtquick2
RUN apt-get install -y -q --no-install-recommends qt5-default qtcreator qtdeclarative5-qtquick2-plugin

# install intel graphics driver
RUN apt-get install -y -q --no-install-recommends libgl1-mesa-glx libgl1-mesa-dri

# install amd graphics open source driver
RUN apt-get install -y -q --no-install-recommends mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils

# apt-get autoclean
RUN apt-get autoclean -y \
&& apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*

# copy supervisord.conf file
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy entrypoint file
COPY ./scripts/ros_entrypoint.sh /

# set user ros and sudo
RUN adduser --gecos "ROS User" --home /home/ros --disabled-password ros && \
    usermod -a -G dialout ros && \
    echo "ros ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget

# switch to user ros, but the HOME is still /, not /home/ros
USER ros

# setup ros env
RUN HOME=/home/ros rosdep update
RUN echo "export QT_X11_NO_MITSHM=1" >> /home/ros/.bashrc && \
    echo "export HOME=/home/ros" >> /home/ros/.bashrc && \
    echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" >> /home/ros/.bashrc

# configure Qt
RUN mkdir -p /home/ros/.config/QtProject

USER root
COPY ./config/QtCreator.ini  /home/ros/.config/QtProject/
RUN chown -R ros:ros  /home/ros/.config/QtProject/

# config gazebo volume
RUN mkdir -p /home/ros/.gazebo/models && chown -R ros:ros /home/ros/.gazebo

# share this volume with other containers from this image
VOLUME ["/home/ros/.gazebo/models"]

USER ros

CMD ["bash"]
ENTRYPOINT ["/ros_entrypoint.sh"]
