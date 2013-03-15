#!/bin/bash

set -e 
set -u 

BASE="/opt/ui/data/dev/"
TRNS="A:/"

while [ true ]; do
  echo "Listening ...";
  nc -l 127.0.0.1 5115 | while read -r -a 'RARG' ; do
    echo ">>> $RARG";
    echo "  > $RARG[0]"

    case $RARG[1] in
      EDIT)
        # Now translate to local filesystem path ...
        FILES=$(echo "$fn" | sed -r "s|$BASE|$TRNS|g")

        echo "   > $FILES"

        # Invoke Sublime
        # '/cygdrive/c/Program Files/Sublime Text 2/sublime_text.exe' "$FILES" & ;
        ;;

      SHELL)
        # TODO
        DIR=FILES=$(echo "$fn" | sed -r "s|$BASE|$TRNS|g")
        echo "Opening shell at $DIR"
        ;;

      EXPLORE)
        # TODO
        DIR=FILES=$(echo "$fn" | sed -r "s|$BASE|$TRNS|g")
        echo "Opening explorer at $DIR"
        ;;

      *)
        echo "Unknown command $RARG[1]";
        ;;
    esac

    echo
  done
done