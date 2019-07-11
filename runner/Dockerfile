FROM archlinux/base

RUN pacman -Syu --noconfirm \
    && pacman -S --needed --noconfirm \
        cdrtools \
        expect \
        iproute2 \
        make \
        net-tools \
        openssh \
        procps-ng \
        qemu-headless \
        socat \
        sudo \
    && pacman -Scc --noconfirm

COPY /rootfs /

VOLUME ["/out", "/work"]

ENV PGID=1000
ENV PUID=1000
ENV PUSER=runner

WORKDIR /test

ENTRYPOINT ["/entrypoint.sh"]

CMD ["make"]
