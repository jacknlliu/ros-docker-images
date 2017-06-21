#! /bin/sh

if [ -e "/dev/dri/card0" ]
then
  /bin/chmod a+rwx /dev/dri/card0
fi
