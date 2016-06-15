GitLab incremental backup container
=============================================

This repository contains instructions and scripts to setup a Docker container to perform automatic encrypted backups for a GitLab container. This assumes a standard GitLab installation using the official docker [image](https://hub.docker.com/r/gitlab/gitlab-ce/) and [instructions.](http://docs.gitlab.com/omnibus/docker)

## Overview

The tool used to create the backups is [Duplicity](http://duplicity.nongnu.org/) and the backup destination is as remote directory. Due to docker security restrictions this remote directory is mounted on the docker host and passed as a local volume to the backup container. The scripts are set up to generate daily incremental backups at 3 AM and to do a full backup once a month. Duplicity compresses, encrypts and signs the backups.

## Setup

### 1 - Create backups destination folder on the host

- Create the mounting point folder on the docker host.
```
sudo mkdir /mnt/backup
```

- Next, configure the host to mount the remote directory during boot. The instructions to do this depend on your specific infrastructure and won't be covered here. The backup generation will already work once the `/mnt/backup` folder exists, but local storage kind of defeats the purpose of the backup strategy.

### 2 - Download the files

```
git clone ssh://git@github.com:felipewer/gitlab-backup.git
```

### 3 - Generate the backup container image

```
cd gitlab-backup/docker
docker build -t duplicity .
```

### 4 - Run the backup container

Substitute the value of `<the-actual-passphrase>` with the passphrase you wish to use to protect the bakups
```
docker run --detach \
    --env 'PASSPHRASE=<the-actual-passphrase>' \
    --name duplicity \
    --restart always \
    --volumes-from gitlab \
    --volume /mnt/backup:/backup \
    duplicity
```

## Backup restore

To restore the most recent backup run:
```
docker exec -it duplicity duplicity --force file:///backup /
```

## Different backup destinations

Duplicity has integrations to Amazon S3 buckets and others, therefore different storage approaches are possible with some changes to the scripts.
