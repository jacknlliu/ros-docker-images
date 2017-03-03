# ros-docker-images

[![](https://images.microbadger.com/badges/image/lmaths/ros.svg)](https://microbadger.com/images/lmaths/ros "lmaths/ros docker images")


ROS desktop-full docker images with Qt C++ debug toolchains for Fedora users who do not use Ubuntu.


# Usage
```shell
docker   run  --device   /dev/dri    \
 --security-opt="label:disable"      \
 --security-opt seccomp:unconfined   \
 --env="DISPLAY" --env QT_X11_NO_MITSHM=1  \
 --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
 --volume="/home/<your_user_name>/Workspace:/data:rw"  \
 --volume="/path/to/gazebo_models:/home/ros/.gazebo/models:rw" \
 lmaths/ros:indigo-qt-amd-intel terminator
``` 


# TODO List
- [x] ~~install Qt5.7 silently install Qt5.7.0 from source~~
- [x] ~~configure Qt5.7 environment variable~~
- [ ] ~~re-write ros qtcreator plugin installation script~~
- [ ] ~~configure ros qtcreator plugin~~


# Known Issues and Limitations
- `qtcreator` run application can't be stopped normally
- **ros qtcreator plugin  need qt57creator, but this dependence should not satisfied!**
- the container os kernel should be close to the host os due to the **graphics driver**. (Ubuntu 14.04 intel graphics driver can not work with host kernel 4.7)
- `libxcb` error in kinetic images which cause the `rqt` tool can not work.
error like:
```
The X11 connection broke: I/O error (code 1)
XIO:  fatal IO error 11 (Resource temporarily unavailable) on X server ":0"
      after 445 requests (439 known processed) with 0 events remaining.
```
**NOTE:** This error caused by the X applications in the docker container request the Mir which is the default display server on Ubuntu 16.04, but Fedora use X11 protocol. More details, please see [Wayland vs Mir vs X11](https://www.reddit.com/r/linux/comments/4bq9kl/eli5_wayland_vs_mir_vs_x11/?st=iu85rt2i&sh=6e4ab55c) and [X11 connection broke: I/O error](https://github.com/osrf/docker_images/issues/40#issuecomment-253314055)


# Reference
- [Silent install Qt run installer on ubuntu server -  stackoverflow](http://stackoverflow.com/questions/25105269/silent-install-qt-run-installer-on-ubuntu-server)
- [Qt installer framework controller scripting](http://doc.qt.io/qtinstallerframework/noninteractive.html)
- [Support headless unattended installation -  qt bug report](https://bugreports.qt.io/browse/QTIFW-166)
- [Setup Qt Creator for ROS - ros_qtc_plugin](https://github.com/ros-industrial/ros_qtc_plugin/wiki/3.-Setup-Qt-Creator-for-ROS#section3.1)
