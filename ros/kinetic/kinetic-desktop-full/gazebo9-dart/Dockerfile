FROM jacknlliu/ros:kinetic-gazebo9-nomoveit

LABEL maintainer="Jack Liu <jacknlliu@gmail.com>"
USER root

# copy scripts file
RUN mkdir -p /opt/scripts/container/ && chmod -R a+rx /opt/scripts/
COPY ./scripts/*.sh /opt/scripts/container/
RUN chmod a+rwx -R /opt/scripts/container && sync && cd /opt/scripts/container && ./install_gazebo_dart.sh


# install pydart2
RUN pip3 install numpy; pip3 install PyOpenGL PyOpenGL_accelerate; \
    apt install -y -q --no-install-recommends swig python3-pyqt5 python3-pyqt5.qtopengl && \
    pip3 install pydart2


# apt clean
RUN apt autoclean \
    && apt clean all \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* /var/tmp/*
