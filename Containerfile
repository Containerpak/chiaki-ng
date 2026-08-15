FROM ubuntu:26.04 AS source

ADD --checksum=sha256:cac42c21a19a111f2f0729bb9eef7d3878c6d2a4f06e017d383aff2aba719fd3 https://github.com/streetpea/chiaki-ng/releases/download/v1.10.0/chiaki-ng.AppImage_x86_64 /tmp/app.AppImage

RUN chmod 0755 /tmp/app.AppImage && \
    cd /tmp && \
    ./app.AppImage --appimage-extract >/dev/null && \
    mkdir -p /stage && \
    cp -a /tmp/squashfs-root/. /stage/

FROM ghcr.io/containerpak/mesa64:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/chiaki-ng"

COPY --from=source /stage/ /opt/chiaki-ng/
COPY chiaki-ng /usr/bin/chiaki-ng
COPY chiaki-ng.desktop /usr/share/applications/chiaki-ng.desktop
COPY icon.png /usr/share/icons/hicolor/128x128/apps/chiaki-ng.png

RUN apt-get update && \
    apt-get install -y --no-install-recommends libopengl0 libva-drm2 libva-wayland2 libva-x11-2 && \
    chmod 0755 /usr/bin/chiaki-ng && \
    cpak-clean-junk
