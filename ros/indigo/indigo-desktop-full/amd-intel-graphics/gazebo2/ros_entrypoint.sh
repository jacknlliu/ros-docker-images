#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"

# start supervisor
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf

# start CMD
/sbin/my_init --quiet -- setuser ${DOCKER_USER} "$@"
