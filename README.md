# ros-docker-images

[![](https://images.microbadger.com/badges/image/lmaths/ros.svg)](https://microbadger.com/images/lmaths/ros "lmaths/ros docker images")

![docker startup demo](https://raw.githubusercontent.com/jacknlliu/ros-docker-images/master/resources/ur5_demo.gif)

ROS desktop-full docker images with Qt C++ debug tool-chain for Fedora and other Linux users who do not use Ubuntu.

This project aims to build an all-in-one development environment for robot learning including robotics and deep reinforcement learning and a portable platform for intelligent robot applications.


# Usage
```shell
docker run --device /dev/dri  \
 --security-opt="label:disable"  \
 --security-opt seccomp:unconfined  \
 --env="DISPLAY" --env QT_X11_NO_MITSHM=1  \
 --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"  \
 --volume="/home/<your_user_name>/Workspace:/data:rw"  \
 --volume="/path/to/gazebo_models:/home/ros/.gazebo/models:rw"  \
 lmaths/ros:kinetic-ide terminator
```


# TODO List
- [ ] reduce the number of docker image layers
- [ ] add reinforcement learning libraries, including rllab.
- [ ] add machine learning libraries.
- [ ] add deep learning, including tensorflow.


# Known Issues and Limitations
- It will be a large image.

# Reference
