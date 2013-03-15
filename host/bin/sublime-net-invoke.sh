#!/bin/bash

set -e 
set -u 

BASE="/opt/ui/data/dev/"
TRNS="A:/"

while [ true ]; do
  echo "Listening ...";
  nc -l 127.0.0.1 5115 | while read -r fn ; do
    echo ">>> $fn";

    # Now translate to local filesystem path ...
    echo $BASE
    FILES=$(echo "$fn" | sed -r "s|$BASE|$TRNS|g")

    echo "   > $FILES"

    # Invoke Sublime
    '/cygdrive/c/Program Files/Sublime Text 2/sublime_text.exe' "$FILES" &
    echo
  done
done