from ubuntu:20.04 as base-ubuntu

run apt -y update
run apt -y upgrade
run apt -y autoremove

run apt -y install systemd less vim net-tools apt-utils
run apt install -y --no-install-recommends systemd-sysv

# General build environment

from base-ubuntu as builder

run apt -y install build-essential git make wget pkg-config

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

# Build DEXED standalone

from builder as dexed

run apt install -y git
run mkdir /build-dexed
workdir /build-dexed
run git clone https://github.com/asb2m10/dexed.git
workdir dexed
run git submodule update --init --recursive
run git checkout v0.9.6
run apt install -y freeglut3-dev g++ libasound2-dev libcurl4-openssl-dev
run apt install -y libfreetype6-dev libx11-dev libxcomposite-dev cmake
run apt install -y libxcursor-dev libxinerama-dev libxrandr-dev mesa-common-dev make curl unzip libjack-jackd2-dev
run ./scripts/get-juce.sh
run ./scripts/projuce.sh
run ./scripts/build-lin.sh

# Build Carla

from builder as carla

run apt install -y git python3-pyqt5.qtsvg python3-rdflib pyqt5-dev-tools \
                   libmagic-dev liblo-dev libasound2-dev libx11-dev \
                   libgtk2.0-dev qtbase5-dev libfluidsynth-dev
run mkdir /build-carla
workdir /build-carla
run git clone https://github.com/falkTX/Carla.git
workdir Carla
run git checkout v2.4.3
run make PREFIX=/usr
run make install PREFIX=/usr



from base-ubuntu as alsynth

# Install kx-studio packages

workdir /install-kx

# Install required dependencies if needed

run apt -y install apt-transport-https gpgv wget

# Download package file

run wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb

# Install it

run dpkg -i kxstudio-repos_10.0.3_all.deb

run apt -y update

run rm -rf /install-kx

run env DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends alsa-utils \
        zynaddsubfx python3 jq x11-utils kxstudio-meta-audio-plugins-ladspa \
	xterm xinit psmisc dbus-x11 locales gmrun liblilv-0-0 libsratom-0-0 libserd-0-0 libsuil-0-0 libgtk-3-0 \
	wmctrl zenity xdotool ghc xmlstarlet libxml2-utils qsynth

run update-alternatives --install /usr/bin/python python /usr/bin/python3 1

add usrbin /usr/bin
add etcdefault /etc/default
add units /lib/systemd/system
run mkdir -p /usr/lib/alsynth/json
add json /usr/lib/alsynth/json

run systemctl enable dotghci.service
run systemctl enable delxauth.service
run systemctl enable conlog.service
run systemctl disable systemd-resolved.service
run systemctl disable networkd-dispatcher.service
run systemctl disable console-getty.service
run systemctl disable dbus.service
run systemctl disable systemd-logind.service
run systemctl disable multi-user.target
run systemctl disable graphical.target
run systemctl set-default basic.target

run locale-gen en_US.UTF-8

# Copy from all builders

run apt install -y libmagic1 python3 libglib2.0-dev-bin python3-pyqt5.qtsvg python3-rdflib liblo7 libfluidsynth2 libcurl4

# Install Carla

#copy --from=carla /usr/bin/carla-* /usr/bin
#copy --from=carla /usr/lib/carla /usr/lib/carla
#copy --from=carla /usr/share/carla /usr/share/carla
#copy --from=carla /usr/lib/vst /usr/lib/vst

# Install qmidiarp

copy --from=qmidiarp /usr/bin/qmidiarp /usr/bin
copy --from=qmidiarp /usr/share/qmidiarp /usr/share

# Install dexed

copy --from=dexed /build-dexed/dexed/Builds/Linux/build/Dexed /usr/bin

# Generate the Haskell plugins database

run mkdir -p /usr/lib/alsynth/haskell

add haskell /usr/lib/alsynth/haskell
add dotghci /usr/lib/alsynth/haskell

workdir /usr/lib/alsynth/haskell

run for f in *.hs; do echo :q | ghci $f 2>&1 | tee /dev/stderr | grep 'error:$' | wc -l | (read n; exit $n) ; done

# Install yq

run wget -qO /usr/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64

run chmod +x /usr/bin/yq

run yq --version

# .bashrc to properly access X display

add root.bashrc /etc/profile.d/root.bashrc.sh

# Flatten image

from scratch

copy --from=alsynth / /

