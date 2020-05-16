FROM archlinux

RUN pacman -Syu --noconfirm \
    && pacman -S --needed --noconfirm base-devel archiso git \
    && pacman -Scc --noconfirm

COPY /rootfs /

VOLUME ["/out", "/work"]

ENV PGID=1000
ENV PUID=1000
ENV PUSER=builder

WORKDIR /src

ENTRYPOINT ["/entrypoint.sh"]

CMD ["make"]
