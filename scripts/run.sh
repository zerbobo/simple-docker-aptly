#!/bin/bash

# 1. preprate gpg keys
echo "-----> STEP 1: check and generate nesessary gpg keys..."
/opt/aptly/scripts/gen-gpg-keys.sh
[ $? -ne 0 ] && { echo "step 1 fails, quit."; exit 1; }

# 2. run nginx
echo "-----> STEP 2: launch nginx..."
/usr/sbin/nginx -g "daemon off;"
