#!/bin/bash
source /etc/profile.d/nix.sh
nix --extra-experimental-features 'nix-command flakes' shell --command mesonBuildPhase