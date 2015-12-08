
# Detect host or guest mode:
if [ -n "${WORMHOLE_REMOTE}" -o \
     -n "${WORMHOLE_LOCAL}" -o \
     -n "${WORMHOLE_EDITOR}" -o \
     -n "${WORMHOLE_TERM}" -o \
     -n "${WORMHOLE_PORT}" ]; then

  nohup $(dirname $0)/host/bin/wormhole.sh </dev/null >> $HOME/wormhole.log 2>&1 &
  disown

else

  source $(dirname $0)/guest/bin/wormhole-guest.sh
fi
