#! /bin/bash

# Author Jack Liu <jacknlliu@gmail.com>

# Install Qt5.7.0
# Dependencies: wget
mkdir /install_data

# download qt5.7.0 opensource source package
cd /install_data && wget  http://download.qt.io/archive/qt/5.7/5.7.0/single/qt-everywhere-opensource-src-5.7.0.7z

# install dependencies 7z, libxcb
apt-get install -y p7zip-full "^libxcb.*" libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev

# compile and install qt5.7.0
cd /install_data && 7za x /install_data/qt-everywhere-opensource-src-5.7.0.7z
mkdir -p /opt/Qt/Qt5.7.0
export QT5PREFIX=/opt/Qt/Qt5.7.0
echo "[DEBUG] QT5PREFIX: $QT5PREFIX"
echo "[DEBUG] Current Path: $(pwd)"
cd /install_data/qt-everywhere-opensource-src-5.7.0 && ./configure -prefix $QT5PREFIX -opensource -confirm-license -system-sqlite \
&& make \
&& make install

# ln /usr/bin/<qt_exec>
export QT5BINDIR=$QT5PREFIX/bin

for file in moc uic rcc qmake lconvert lrelease lupdate; do
  ln -sfrvn $QT5BINDIR/$file /usr/bin/$file
  echo "[DEBUG] ln -sfrvn $QT5BINDIR/$file /usr/bin/$file"
done

# setup ld.so.conf
echo "$QT5PREFIX/lib" >> /etc/ld.so.conf
ldconfig
# added for DEBUG
cat /etc/ld.so.conf

# setup environment in /etc/profile.d
cat > /etc/profile.d/qt5.sh << "EOF"
# Begin /etc/profile.d/qt5.sh

QT5DIR=/opt/Qt/Qt5.7.0

pathappend $QT5DIR/bin           PATH
pathappend $QT5DIR/lib/pkgconfig PKG_CONFIG_PATH

export QT5DIR

# End /etc/profile.d/qt5.sh
EOF

# added for DEBUG
cat /etc/profile.d/qt5.sh

### start to install Qtcreator 4.x ###
# download qtcreator source 4.1.0
cd /install_data && wget http://download.qt.io/official_releases/qtcreator/4.1/4.1.0/qt-creator-opensource-src-4.1.0.tar.xz

cd /install_data && tar -xf qt-creator-opensource-src-4.1.0.tar.xz

# prepare the Makefile using qmake
cd /install_data && mkdir qt-creator-build  \
&& cd qt-creator-build/                     \
&& qmake -r ../qt-creator-opensource-src-4.1.0/qtcreator.pro

# make
make -j 8

# install
mkdir /opt/Qt/Tools/
export INSTALL_DIRECTORY=/opt/Qt/Tools/
make install INSTALL_ROOT=$INSTALL_DIRECTORY


# ln /usr/bin/qtcreator
ln -sf $INSTALL_DIRECTORY/bin/qtcreator   /usr/bin/qtcreator
echo "[DEBUG] ln -sf $INSTALL_DIRECTORY/bin/qtcreator   /usr/bin/qtcreator"

### End installation ###

# unset the export environment variables
unset QT5PREFIX  QT5BINDIR  INSTALL_DIRECTORY

# delete install_data directory
cd / && rm -rf /install_data
