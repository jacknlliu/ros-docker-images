FROM jacknlliu/ros:kinetic-extensions

MAINTAINER Jack Liu jacknlliu@gmail.com

# config sshd
RUN mkdir -p /var/run/sshd && echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

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
RUN HOME=/home/ros rosdep update  \
    && echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" >> /home/ros/.bashrc

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
WORKDIR /home/ros

CMD ["bash"]
ENTRYPOINT ["/ros_entrypoint.sh"]
