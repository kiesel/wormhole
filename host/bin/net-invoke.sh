#!/bin/bash

set -e 
set -u 

## Translation settings
# BASE - translate this:
BASE="/home/$USER/"

# TRNS - ... to that.
TRNS="A:/"

## NET_ - settings for external programs...
NET_VISUAL=${NET_VISUAL:-'/cygdrive/c/Program Files/Sublime Text 3/sublime_text.exe'}
NET_TERM=${NET_TERM:-mintty}

while [ true ]; do
  echo "Listening ...";
  nc -l 127.0.0.1 5115 | while read -r -a 'RARG' ; do

    COMMAND=${RARG[0]}
    unset RARG[0]

    if [ ${#RARG[@]} -lt 1 ]; then
      echo "You need to give at least one argument to a command...";
      continue;
    fi

    # Now translate to local filesystem path ...
    FILES=()
    for FILE in "${RARG[@]}"; do

      # DEBUG echo "+ $FILE";
      FILES+=($(echo "$FILE" | sed -r "s|$BASE|$TRNS|g"));
    done
    # DEBUG echo "   > ${FILES[@]}"


    case $COMMAND in
      EDIT)

        # Invoke Sublime
        "$NET_VISUAL" "${FILES[@]}" &
        ;;

      SHELL)
        LOCATION="${FILES[0]}"
        if [ ! -d "$LOCATION" ]; then
          echo "No directory: $LOCATION";
          continue;
        fi

        echo "Opening shell at ${FILES[0]}"
        cd $LOCATION && $NET_TERM &
        ;;

      EXPLORE)
        LOCATION="${FILES[0]}"
        if [ ! -d "$LOCATION" ]; then
          echo "No directory: $LOCATION";
          continue;
        fi

        echo "Opening explorer at $LOCATION"
        cygstart $LOCATION &
        ;;

      *)
        echo "Unknown command $COMMAND";
        ;;
    esac

    echo
  done
done
