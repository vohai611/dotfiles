#! /bin/sh
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

sudo darwin-rebuild switch --flake ${SCRIPT_DIR}#m1pro
