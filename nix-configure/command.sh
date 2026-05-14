#! /bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

nix flake update
sudo darwin-rebuild switch --flake ${SCRIPT_DIR}#m1pro
