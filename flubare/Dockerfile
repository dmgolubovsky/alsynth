# Build bare qsynth/fluidsynth

from ubuntu:20.04 as flubare

run apt -y update
run apt -y upgrade
run apt -y autoremove

run apt -y install qsynth

from scratch

copy --from=flubare / /


