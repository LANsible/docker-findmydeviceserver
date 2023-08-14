# docker-findmydeviceserver
[![Build Status](https://github.com/LANsible/docker-findmydeviceserver/actions/workflows/docker.yml/badge.svg)](https://github.com/LANsible/docker-findmydeviceserver/actions/workflows/docker.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/lansible/findmydeviceserver.svg)](https://hub.docker.com/r/lansible/findmydeviceserver)
[![Docker Version](https://img.shields.io/docker/v/lansible/findmydeviceserver.svg?sort=semver)](https://hub.docker.com/r/lansible/findmydeviceserver)
[![Docker Size/Layers](https://img.shields.io/docker/image-size/lansible/findmydeviceserver.svg?sort=semver)](https://hub.docker.com/r/lansible/findmydeviceserver)

Dockerized static findmydeviceserver


### Running locally

```
docker run -it -p 8384:8384 -p 22000:22000/tcp -p 22000:22000/udp -v "$PWD/config:/config" lansible/findmydeviceserver:latest
```