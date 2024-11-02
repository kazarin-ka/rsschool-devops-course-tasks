#!/bin/bash
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

sudo apt update
sudo apt install -y htop tree jq

exit 0
