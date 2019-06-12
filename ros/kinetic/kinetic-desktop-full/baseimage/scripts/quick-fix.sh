#!/usr/bin/env bash

# fix moveit error, according to https://github.com/ros-planning/moveit/issues/86
pip2 uninstall -y pyassimp

pip2 install pyassimp
