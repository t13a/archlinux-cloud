# archlinux-cloud

[![Build Status](https://travis-ci.org/t13a/archlinux-cloud.svg?branch=master)](https://travis-ci.org/t13a/archlinux-cloud)

An [Arch Linux](https://www.archlinux.org) cloud installation image.

- Based on the official Arch Linux ISO profile (`releng`)
- [cloud-init](https://cloud-init.io) installed
- Serial console enabled
- [Predictable network interface names](https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/) disabled
- Auto login disabled
- Root password locked

The build process and E2E tests (using [QEMU](https://www.qemu.org/)) are run entirely on the Docker container. Therefore, it can be easily integrated with modern CI tools.

## Prerequisites

- Docker
- GNU Make
- KVM enabled Linux (optional but strongly recommended)

## Getting started

### Build and test the ISO image

The following command generates the ISO image at `out/iso/archlinux-cloud-YYYY.mm.dd-x86_64.iso` then run all E2E tests.

```sh
$ make init build test # or just simply `make`
```

To delete all generated files, run the following command.

```sh
$ make clean
```

### Boot with cloud-init

Please refer to the [official documentation](https://cloudinit.readthedocs.io/) for a general explanation.

In Arch Linux, cloud-init 19.1 tries network configuration with [netctl](https://wiki.archlinux.org/index.php/Netctl). However, this does not work well because it has a [bug](https://bugs.launchpad.net/cloud-init/+bug/1714495). As a workaround, the following example shows how to use [systemd-networkd](https://wiki.archlinux.org/index.php/Systemd-networkd) and [systemd-resolved](https://wiki.archlinux.org/index.php/Systemd-resolved) with [`bootcmd` module](https://cloudinit.readthedocs.io/en/latest/topics/modules.html#bootcmd) instead of using normal network configuration.

```yaml
#cloud-config
...
bootcmd:
- |
    cat << EOF > /etc/systemd/network/20-wired.network
    [Match]
    Name=eth0

    [Network]
    DHCP=ipv4
    EOF
- ln -fs /run/systemd/resolve/resolv.conf /etc/resolv.conf
- systemctl start systemd-networkd systemd-resolved
...
```

## Development

### Build the ISO image step-by-step

```sh
$ make init
$ make build/exec
[build@xxxxxxxxxxxx build]$ make profile
[build@xxxxxxxxxxxx build]$ make repo
[build@xxxxxxxxxxxx build]$ make iso
[build@xxxxxxxxxxxx build]$ exit
```

### Run QEMU with the ISO image

```sh
$ make test/exec
[test@xxxxxxxxxxxx test]$ make ssh-key
[test@xxxxxxxxxxxx test]$ make cidata
[test@xxxxxxxxxxxx test]$ qemu-daemon
[test@xxxxxxxxxxxx test]$ qemu-serial
[test@xxxxxxxxxxxx test]$ qemu-kill
```

or

```sh
$ make test/exec
[test@xxxxxxxxxxxx test]$ make ssh-key
[test@xxxxxxxxxxxx test]$ make cidata
[test@xxxxxxxxxxxx test]$ qemu-daemon -f # start in foreground
```

## References

- [Archiso](https://wiki.archlinux.org/index.php/Archiso)
- [cloud-init Documentation](https://cloudinit.readthedocs.io/)
- [Docker Base Image for Arch Linux](https://github.com/archlinux/archlinux-docker)
- [Install from existing Linux](https://wiki.archlinux.org/index.php/Install_from_existing_Linux)
- [QEMU wiki](https://wiki.qemu.org)
