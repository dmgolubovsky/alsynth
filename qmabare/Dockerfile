# Build bare qmidiarp  

from ubuntu:20.04 as base-ubuntu

run apt -y update
run apt -y upgrade
run apt -y autoremove

# General build environment

from base-ubuntu as builder

run env DEBIAN_FRONTEND=noninteractive apt -y install build-essential git make wget pkg-config

# Build QMidiArp standalone

from  builder as qmidiarp

run apt install -y git autoconf automake libtool libasound2-dev qt5-default libjack-jackd2-dev
run apt install -y g++ pkg-config lv2-dev
run mkdir /build-qmidiarp
workdir /build-qmidiarp
run git clone https://github.com/emuse/qmidiarp.git
workdir qmidiarp
run autoreconf -i
run ./configure --enable-buildapp --enable-alsa --disable-lv2plugins --disable-lv2pluginuis --disable-nsm --prefix=/usr
run make
run make install

from base-ubuntu as qmabare

# Install qmidiarp

copy --from=qmidiarp /usr/bin/qmidiarp /usr/bin
copy --from=qmidiarp /usr/share/qmidiarp /usr/share

run env DEBIAN_FRONTEND=noninteractive apt -y install libjack-jackd2-0 libasound2 libqt5widgets5  libqt5gui5 libqt5core5a

# Flatten image

from scratch

copy --from=qmabare / /


