# TODO List
- [ ] install Qt5.7 silently
- [ ] configure Qt5.7 environment variable
- [ ] re-write ros qtcreator plugin installation script
- [ ] configure ros qtcreator plugin
- [ ] update gazebo | install double version gazebo


# Known Issues and Limitations
- `qtcreator` run application can't be stopped normally
- **ros qtcreator plugin  need qt57creator, but this dependence should not satisfied!**
- the container os kernel should be close to the host os due to the **graphics driver**. (Ubuntu 14.04 intel graphics driver can not work with host kernel 4.7)
- keyboard-configuration installation need select the map during container compiling. This caused the compile failed.



# Reference
- [Silent install Qt run installer on ubuntu server -  stackoverflow](http://stackoverflow.com/questions/25105269/silent-install-qt-run-installer-on-ubuntu-server)
- [Qt installer framework controller scripting](http://doc.qt.io/qtinstallerframework/noninteractive.html)
- [Support headless unattended installation -  qt bug report](https://bugreports.qt.io/browse/QTIFW-166)
- [Setup Qt Creator for ROS - ros_qtc_plugin](https://github.com/ros-industrial/ros_qtc_plugin/wiki/3.-Setup-Qt-Creator-for-ROS#section3.1)
