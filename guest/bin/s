#!/bin/bash

set -u
set -e

IP="10.0.2.2"

PAYLOAD=$(realpath "$@")
echo $PAYLOAD | nc $IP 5115 -q 0
