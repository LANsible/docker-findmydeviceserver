# Does not work on Alpine, objectbox install scripts fails
FROM golang:1.21-bullseye as builder

# https://gitlab.com/Nulide/findmydeviceserver/-/tags
# https://github.com/objectbox/objectbox-c/releases
ENV VERSION=v0.4.0 \
    GOPATH=/go

# Add unprivileged user
RUN echo "findmydeviceserver:x:1000:1000:findmydeviceserver:/:" > /etc_passwd
RUN echo "findmydeviceserver:x:1000:findmydeviceserver" > /etc_group

# Install build needs
RUN apt-get update && apt-get install --yes \
  git \
  upx \
  gcc

# Get findmydeviceserver from Gitlab
RUN git clone --depth 1 --branch "${VERSION}" https://gitlab.com/Nulide/findmydeviceserver.git /go/src/findmydeviceserver
WORKDIR /go/src/findmydeviceserver

# Setup objectbox
# Compile fmdserver (can't be static due objectbox not being static)
# Setup libs directory with needed objectbox libs
# https://gitlab.com/Nulide/findmydeviceserver/-/blob/master/Dockerfile?ref_type=heads
RUN --mount=type=cache,target=/root/.cache \
  wget -qO- https://raw.githubusercontent.com/objectbox/objectbox-go/main/install.sh | bash && \
  mkdir /data /libs /config /fmd && \
  go build -o /fmd/server cmd/fmdserver.go && \
  cp -r web/ /fmd/web && \
  ln -sf /data /fmd/objectbox && \
  ln -sf /config/config.json /fmd/config.json && \
  ldd /usr/lib/libobjectbox.so | awk '{print $3}' | xargs -I{} cp "{}" /libs

# Minify binaries and create config folder
# no upx: 23.6M
# upx: 9.4M
# --best: 9.1M
# --brute: breaks the binary
RUN upx --best /fmd/server && \
    upx -t /fmd/server


# Minimal image with C linkers available
FROM busybox

# Copy the unprivileged user
COPY --from=builder /etc_passwd /etc/passwd
COPY --from=builder /etc_group /etc/group

# ca-certificates are required to resolve https:// domains:
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Add needed files, libs and executable
COPY --from=builder --chown=findmydeviceserver:findmydeviceserver /fmd /fmd
COPY --from=builder /usr/lib/libobjectbox.so /usr/lib/libobjectbox.so

# Setup needed libs for objectbox
COPY --from=builder /libs/ /usr/lib/

# Setup data dir
COPY --from=builder --chown=findmydeviceserver:findmydeviceserver /data /data

# Setup default config.json
COPY --chown=findmydeviceserver:findmydeviceserver <<EOF /config/config.json
{
 "PortSecure": 8081,
 "PortUnsecure": 8080,
 "IdLength": 5,
 "MaxSavedLoc": 1000,
 "MaxSavedPic": 10
}
EOF

USER findmydeviceserver
ENTRYPOINT ["/fmd/server"]
# Expose the webinterface and the protocol ports
EXPOSE 1020/tcp
