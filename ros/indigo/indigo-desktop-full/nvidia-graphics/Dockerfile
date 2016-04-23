FROM lmaths/ros:indigo-desktop-full
MAINTAINER Jack Liu jackliu.lab@gmail.com

# using upgrade (not recommend)
RUN apt-get update && apt-get upgrade -y

# install nvidia graphics open source driver
RUN apt-get install -y  xserver-xorg-video-nouveau \
    && rm -rf /var/lib/apt/lists/*
