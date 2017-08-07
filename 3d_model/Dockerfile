FROM jacknlliu/ros:kinetic-core

MAINTAINER Jack Liu <jacknlliu@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# install blender
RUN apt-get -y update && apt-get install -y -q --no-install-recommends wget software-properties-common \
    && add-apt-repository --yes ppa:thomas-schiex/blender \
    && aptitude update -y && aptitude install -y -q -R blender

RUN cd /opt/scripts/container && wget -q -O install.blend https://github.com/HBPNeurorobotics/BlenderRobotDesigner/raw/master/installer.blend \
    && chmod a+rwx /opt/scripts/container/install.blend

COPY scripts/install_brd.py /opt/scripts/container/
RUN chmod a+x /opt/scripts/container/install_brd.py

USER ros
RUN sudo -H blend -b /opt/scripts/container/install.blend --python /opt/scripts/container/install_brd.py

# apt-get autoclean
RUN apt-get autoclean -y \
&& apt-get autoremove -y \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
