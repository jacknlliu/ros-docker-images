FROM jacknlliu/ros:kinetic-core

LABEL maintainer="Jack Liu <jacknlliu@gmail.com>"

RUN apt-get update -y && apt-get install -y curl bzip2 libfreetype6 \
		libgl1-mesa-dev libglu1-mesa libxi6 libxrender1

# thanks to [ikester/blender-docker](https://github.com/ikester/blender-docker/tree/2.78c)
ENV BLENDER_MAJOR 2.78
ENV BLENDER_VERSION 2.78c
ENV BLENDER_BZ2_URL http://mirror.cs.umn.edu/blender.org/release/Blender$BLENDER_MAJOR/blender-$BLENDER_VERSION-linux-glibc219-x86_64.tar.bz2

RUN mkdir -p /opt/blender && \
	curl -SL "$BLENDER_BZ2_URL" -o blender.tar.bz2 && \
	tar -jxvf blender.tar.bz2 -C /opt/blender --strip-components=1 && \
	rm -f blender.tar.bz2

COPY scripts/install_brd.py /opt/scripts/container/
RUN chmod a+rx /opt/scripts/container/install_brd.py

USER ros
RUN sudo /opt/blender/blender -b --python /opt/scripts/container/install_brd.py \
    && sudo chown -R ros:ros /home/ros/ \
    && echo 'export PATH=$PATH:/opt/blender/' >> /home/ros/.bashrc

USER root
RUN rm -f /home/ros/.config/blender/$BLENDER_MAJOR/config/userpref.blend
COPY configs/userpref.blend /home/ros/.config/blender/$BLENDER_MAJOR/config/

RUN chmod a+x /home/ros/.config/blender/$BLENDER_MAJOR/config/userpref.blend && chown -R ros:ros /home/ros

# apt-get autoclean
RUN apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && rm -rf /root/.cache
