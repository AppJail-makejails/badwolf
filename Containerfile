ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/x11appjail-base:${FREEBSD_RELEASE}-x11

ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="BadWolf" \
    org.opencontainers.image.description="Minimalist and privacy-oriented WebKitGTK browser" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/badwolf" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/badwolf" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    sysrc clear_tmp_X=NO; \
    \
    pkg update; \
    pkg install badwolf dbus; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/*; \
    fi; \
    rm -rf /var/db/pkg/repos/*
