#!/bin/bash

docker run \
    --name "my-aptly" \
    --restart always \
    --detach \
    -e GPG_NAME="MY-APTLY" \
    -e GPG_COMMENT="repo published by BB" \
    -e GPG_EMAIL="BB@example.com" \
    -e GPG_PASSPHRASE="Mo0nlightLy!ngFrontOfBed" \
    -p 8080:80 \
    -v '/var/aptly-repo:/var/aptly' \
    zerbobo/simple-docker-aptly:latest
