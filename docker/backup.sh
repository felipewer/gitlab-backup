#!/bin/bash

source /assets/export_passphrase

duplicity --full-if-older-than 1M \
  --include /etc/gitlab \
  --include /var/log/gitlab \
  --include /var/opt/gitlab \
  --exclude '**' \
  / file:///backup/
