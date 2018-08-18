FROM jacknlliu/ros:kinetic-extensions

LABEL maintainer="Jack Liu <jacknlliu@gmail.com>"

RUN apt update -y && apt install -y -q --no-install-recommends qt5-default qtcreator qtdeclarative5-qtquick2-plugin

# configure Qt
RUN mkdir -p /home/$DOCKER_USER/.config/QtProject

COPY ./config/QtCreator.ini  /home/$DOCKER_USER/.config/QtProject/
RUN chown -R $DOCKER_USER:$DOCKER_USER  /home/$DOCKER_USER/.config/

WORKDIR /home/$DOCKER_USER
