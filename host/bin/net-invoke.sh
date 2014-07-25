#!/bin/bash
set -e 
set -u 

## Translation settings
# BASE - translate this:
BASE=${BASE:-"/home/$USER/"}

# TRNS - ... to that.
TRNS=${TRNS:-"A:/"}

PORT=${PORT:-5115}

## NET_ - settings for external programs...
NET_VISUAL=${NET_VISUAL:-'/cygdrive/c/Program Files/Sublime Text 3/sublime_text.exe'}
NET_TERM=${NET_TERM:-mintty}

while [ true ]; do
  echo "Listening ...";
  (nc -p ${PORT} -l 127.0.0.1 || nc -l 127.0.0.1 ${PORT}) 2>/dev/null | while read -r -a 'RARG' ; do

    COMMAND=${RARG[0]}
    unset RARG[0]

    if [ ${#RARG[@]} -lt 1 ]; then
      echo "You need to give at least one argument to a command...";
      continue;
    fi

    # Now translate to local filesystem path ...
    FILES=()
    for FILE in "${RARG[@]}"; do

      FILES+=($(echo "$FILE" | sed -r "s|$BASE|$TRNS|g"));
    done

    case $COMMAND in
      EDIT)

        # Invoke editor
        echo "EDIT > ${FILES[@]}"
        "$NET_VISUAL" "${FILES[@]}" &
        ;;

      SHELL)
        LOCATION="${FILES[0]}"
        if [ ! -d "$LOCATION" ]; then
          echo "Not a directory: $LOCATION";
          continue;
        fi

        echo "SHELL > ${FILES[0]}"
        cd $LOCATION && $NET_TERM &
        ;;

      EXPLORE)
        LOCATION="${FILES[0]}"
        if [ ! -d "$LOCATION" ]; then
          echo "Not a directory: $LOCATION";
          continue;
        fi

        echo "EXPLORER > $LOCATION"
        cygstart $LOCATION &
        ;;

      *)
        echo "Unknown command $COMMAND";
        ;;
    esac

    echo
  done
done
