FROM jacknlliu/ros:kinetic-core

LABEL maintainer="Jack Liu <jacknlliu@gmail.com>"

# install ros related components
RUN apt update -y && apt install -y -q --no-install-recommends ros-kinetic-gazebo-ros-control \
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
    && apt install -y -q --no-install-recommends libusb-1.0-0 freeglut3 freeglut3-dev \
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


# apt clean
RUN apt autoclean \
    && apt clean all \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*
