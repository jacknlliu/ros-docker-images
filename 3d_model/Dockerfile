FROM ubuntu:14.04

MAINTAINER Jack Liu <jacknlliu@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

ENV NORMAL_USER robot3d

# install blender
RUN apt-get -y update && apt-get install -q -y --no-install-recommends blender

# setup sudoers
RUN apt-get install -q -y --no-install-recommends sudo

RUN adduser --home /home/$NORMAL_USER --disabled-password $NORMAL_USER

RUN echo "$NORMAL_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_aptget


# install intel graphics driver
RUN apt-get install -y -q --no-install-recommends libgl1-mesa-glx libgl1-mesa-dri

# install amd graphics open source driver
RUN apt-get install -y -q --no-install-recommends mesa-vdpau-drivers xserver-xorg-video-ati mesa-utils


# apt-get autoclean
RUN apt-get autoclean -y \
&& apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/*

# switch to $NORMAL_USER
ENV HOME /home/$NORMAL_USER
USER $NORMAL_USER
RUN echo "export HOME=/home/$NORMAL_USER" >> /home/$NORMAL_USER/.bashrc
