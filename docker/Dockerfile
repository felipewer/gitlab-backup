FROM ubuntu:16.04
MAINTAINER Felipe Carlos Werlang <felipewer@gmail.com>

RUN apt-get update && apt-get -y install \
        duplicity \
        python-paramiko \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY schedule_backup.sh /assets/
COPY backup.sh /assets/
COPY backup_crontab /etc/cron.d/

RUN chmod 0700 /assets/* \
    && chmod 0600 /etc/cron.d/backup_crontab \
    && touch /var/log/cron.log

ENV PASSPHRASE change-me-during-run

VOLUME ["/backup"]

CMD  ["/assets/schedule_backup.sh"]
