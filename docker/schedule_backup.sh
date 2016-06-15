#!/bin/bash

echo "export PASSPHRASE=$PASSPHRASE" > /assets/export_passphrase
cron &

tail -f /var/log/cron.log
