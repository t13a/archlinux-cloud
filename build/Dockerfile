FROM archlinux

RUN pacman -Syu --noconfirm \
    && pacman -S --needed --noconfirm \
        base-devel \
        archiso \
        git \
    && pacman -Scc --noconfirm

RUN useradd -m -s /bin/bash -U build \
    && echo "build ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/build

USER build
