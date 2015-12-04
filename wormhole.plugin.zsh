# Detect host or guest mode:

if [ -n ${WORMHOLE_REMOTE} -o \
     -n ${WORMHOLE_LOCAL} -o \
     -n ${WORMHOLE_EDITOR} -o \
     -n ${WORMHOLE_TERM} -o \
     -n ${WORMHOLE_PORT} ]; then

  echo "Detected wormhole host mode."
  nohup $(dirname $0)/host/bin/wormhole.sh </dev/null 2>&1 >/dev/null &
  disown

else

  source $(dirname $0)/guest/bin/wormhole-guest.sh
fi
