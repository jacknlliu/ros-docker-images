#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"

# tips for nvidia gpu cards
echo "Tips: if you use NVIDIA video cards, you should install NVIDIA video driver for 3D graphics support!"

# start CMD
exec "$@"
