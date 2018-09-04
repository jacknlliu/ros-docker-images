# ros-docker-images

[![](https://images.microbadger.com/badges/image/jacknlliu/ros.svg)](https://microbadger.com/images/jacknlliu/ros "jacknlliu/ros docker images")

![docker startup demo](https://raw.githubusercontent.com/jacknlliu/ros-docker-images/master/resources/ur5_demo.gif)

[ROS desktop-full docker images](https://hub.docker.com/r/jacknlliu/ros/) with Qt C++ debug tool-chain for Fedora and other Linux users who do not use Ubuntu.

This project aims to build an All-in-One development environment for robot learning including robotics and deep reinforcement learning and a portable platform for intelligent robot applications.


# Features
- integrated with open source AMD and Intel GPU driver, and NVIDIA driver manually installation instruction
- support `gazebo` simulation
- including `QtCreator` and [RoboWare](http://wiki.ros.org/IDEs#RoboWare_Studio) as ROS IDE which supports build and **debug** your ROS packages
- including [terminator](http://gnometerminator.blogspot.com/p/introduction.html), a multi-windows supported free terminal emulator
- including [ranger](https://github.com/ranger/ranger) -  a console file manager with VI key bindings
- including [ros-desktop-full](http://wiki.ros.org/kinetic/Installation/Ubuntu) packages, currently support `indigo` and `kinetic` version
- including a light weight file manager GUI application [pcmanfm](http://pcmanfm.sourceforge.net/)


# Usage
- Pull docker image
```
$ docker pull jacknlliu/ros:kinetic-ide-init
```
See it on [docker hub](https://hub.docker.com/r/jacknlliu/ros/).

- set X access on your host for docker containers
```
$ xhost +
```

- Run
```shell
docker run --privileged  \
 --security-opt label=disable  \
 --security-opt seccomp=unconfined  \
 --env="DISPLAY" --env QT_X11_NO_MITSHM=1  \
 --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"  \
 --volume="/home/<your_user_name>/Workspace:/data:rw"  \
 --volume="/path/to/gazebo_models:/home/ros/.gazebo/models:rw"  \
 --name="ros_kinetic"  \
 jacknlliu/ros:kinetic-ide-init terminator
```

  **NOTE:**
   `/home/<your_user_name>/Workspace` defines your workspace according to your own workspace to share between your host and docker container,

  `/path/to/gazebo_models` defines your gazebo models directory path.

  Run the above command just in the first time, later please just run the container with its name, this will keep things easy.
```
$ docker start ros_kinetic
```

- Troubleshooting with NVIDIA video card  
  If you use NVIDIA video card, you should follow this [instruction](https://github.com/jacknlliu/ros-docker-images/wiki).

- Run ros docker images on multiple hosts, please refer to [robot-manipulation-cluster](https://github.com/jacknlliu/robot-manipulation-cluster).


# Known Issues and Limitations
- It's a little large image.
- common issues about NVIDIA GPU driver


# Reference
- [OSRF Docker Images](https://github.com/osrf/docker_images)
- [PX4 Docker Containers](https://dev.px4.io/en/test_and_ci/docker.html)
- [docker GUI tutorial - ROS wiki](http://wiki.ros.org/docker/Tutorials/GUI)
- [x11docker](https://github.com/mviereck/x11docker)
- [robot-manipulation-cluster](https://github.com/jacknlliu/robot-manipulation-cluster)

# LICENSE
This project is distributed under [MIT License](https://en.wikipedia.org/wiki/MIT_License).
