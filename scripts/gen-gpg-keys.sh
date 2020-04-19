#!/bin/bash

if [ -f /var/aptly/public/pubkey.txt ]; then
    echo "Pubkey already exist: /var/aptly/public/pubkey.txt. Don't gen more gpg keys." 1>&2
    exit
fi

# if gpg tells missing entropy, it's better to add more on your host first.
# $ sudo apt install rng-tools
# $ sudo rngd -f -r /dev/urandom

echo "Env variables:" 1>&2
echo "    GPG_NAME=${GPG_NAME}" 1>&2
echo "    GPG_COMMENT=${GPG_COMMENT}" 1>&2
echo "    GPG_EMAIL=${GPG_EMAIL}" 1>&2
echo "    GPG_PASSPHRASE=${GPG_PASSPHRASE}" 1>&2

if [[ "${GPG_NAME}" == "" || "${GPG_COMMENT}" == "" || "${GPG_EMAIL}" == "" || "${GPG_PASSPHRASE}" == "" ]]; then
    echo "GPG_NAME GPG_COMMENT GPG_EMAIL GPG_PASSPHRASE must be set. exit." 1>&2
    exit 1
fi

(cat <<EOF
%echo Generating a default key
#Refering docs from https://www.gnupg.org/documentation/manuals/gnupg-devel/Unattended-GPG-key-generation.html
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: ${GPG_NAME}
Name-Comment: ${GPG_COMMENT}
Name-Email: ${GPG_EMAIL}
Expire-Date: 0
Passphrase: ${GPG_PASSPHRASE}
%commit
%echo done
EOF
) | gpg --gen-key --batch -

mkdir -p /var/aptly/public
gpg --armor --export > /var/aptly/public/pubkey.txt || { rm /var/aptly/public/pubkey.txt; exit 2; }
