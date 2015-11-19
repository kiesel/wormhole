#!/bin/bash

set -e -u 

MODE=${1:-}
TARGET=$HOME/bin

case $MODE in
  "guest")
    echo "===> Installing wormhole guest into $TARGET"
    for i in s expl term start; do
      echo "   > $i"
      ln -sf $(realpath ./guest/bin/$i) $TARGET/$i
    done
    ;;

  "host")
    echo "===> Installing wormhole guest into $TARGET"
    for i in net-invoke.sh; do
      echo "   > $i"
      ln -sf $(realpath ./host/bin/$i) $TARGET/$i
    done
    ;;

  *)
    echo "$0 host|guest"
    echo "  host  -> installs host side"
    echo "  guest -> installs guest side"
    ;;
esac 