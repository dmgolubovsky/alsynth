export XAUTHORITY=/root/.Xauthority

if [ ! -f $XAUTHORITY ] ; then
  echo > $XAUTHORITY
  xauth add $DISPLAY $XMMC
fi
