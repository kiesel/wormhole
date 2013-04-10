#!/bin/bash

set -e 
set -u 

BASE="/opt/ui/data/dev/"
TRNS="A:/"

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
        '/cygdrive/c/Program Files/Sublime Text 2/sublime_text.exe' "${FILES[@]}" &
        ;;

      SHELL)
        LOCATION="${FILES[0]}"
        if [ ! -d "$LOCATION" ]; then
          echo "No directory: $LOCATION";
          continue;
        fi

        echo "Opening shell at ${FILES[0]}"
        cd $LOCATION && mintty &
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