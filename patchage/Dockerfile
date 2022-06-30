# Build bare zyn-fusion

from ubuntu:18.04 as patchage

run apt -y update
run apt -y upgrade
run apt -y autoremove

run env DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends alsa-utils patchage

from scratch

copy --from=patchage / /

