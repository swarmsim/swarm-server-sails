#!/bin/sh -eux
# Ask @erosson for .secrets_key (but you probably won't get it).
cd "`dirname "$0"`"
tar cf - secrets | openssl aes-256-cbc -k .secrets_key -out secrets.tar.enc
