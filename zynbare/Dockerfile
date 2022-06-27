# Build bare zyn-fusion

from ubuntu:20.04 as zynbare

run apt -y update
run apt -y upgrade
run apt -y autoremove

# Install kx-studio packages

workdir /install-kx

# Install required dependencies if needed

run apt -y install apt-transport-https gpgv wget git

# Download package file

run wget https://launchpad.net/~kxstudio-debian/+archive/kxstudio/+files/kxstudio-repos_10.0.3_all.deb

# Install it

run dpkg -i kxstudio-repos_10.0.3_all.deb

run apt -y update

run rm -rf /install-kx

run env DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends alsa-utils zynaddsubfx

workdir /tmp

run git clone https://github.com/zynaddsubfx/instruments

workdir instruments

run cp -afpR * /usr/share/zynaddsubfx

run rm -rf /tmp/instruments

run apt -y remove git

run apt -y autoremove

from scratch

copy --from=zynbare / /




