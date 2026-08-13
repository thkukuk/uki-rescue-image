#! /bin/bash

set -e

# Import gpg-pubkey
mkdir -m 700 gnupg
cat /buildroot/usr/lib/rpm/gnupg/keys/*.asc | gpg --homedir gnupg --import --no-options --no-default-keyring --keyring /buildroot/etc/systemd/import-pubring.gpg
rm -rfv gnupg
