# docker-findmydeviceserver
[![Build Status](https://github.com/LANsible/docker-findmydeviceserver/actions/workflows/docker.yml/badge.svg)](https://github.com/LANsible/docker-findmydeviceserver/actions/workflows/docker.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/lansible/findmydeviceserver.svg)](https://hub.docker.com/r/lansible/findmydeviceserver)
[![Docker Version](https://img.shields.io/docker/v/lansible/findmydeviceserver.svg?sort=semver)](https://hub.docker.com/r/lansible/findmydeviceserver)
[![Docker Size/Layers](https://img.shields.io/docker/image-size/lansible/findmydeviceserver.svg?sort=semver)](https://hub.docker.com/r/lansible/findmydeviceserver)

Dockerized findmydeviceserver


### Running locally

```
mkdir data/
docker run -it --read-only -p 8080:8080/tcp -v "$PWD/data:/data" lansible/findmydeviceserver:latest
```