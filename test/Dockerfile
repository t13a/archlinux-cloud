FROM archlinux

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

RUN useradd -m -s /bin/bash -U test \
    && echo "test ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/test

USER test
