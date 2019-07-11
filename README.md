# archiso-cloud

An [Arch Linux](https://www.archlinux.org) cloud installation image builder.

- Based on the official Arch Linux ISO profile (`releng`)
- [cloud-init](https://cloud-init.io) is enabled
- [Predictable network interface names](https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/) are disabled
- Serial console is enabled
- Auto login is disabled
- Root password is locked

The build process and E2E tests (using [QEMU](https://www.qemu.org/)) are run entirely on the Docker container. Therefore, it can be easily integrated with modern CI tools.

## Prerequisites

- Docker
- GNU Make
- KVM enabled Linux (for development, optional but strongly recommended)

## Getting started

### Build the ISO image

The following command generates the ISO image at `out/archlinux-cloud-YYYY.mm.dd-x86_64.iso`.

```
$ make all
```

To delete all generated files and containers, run the following command.

```
$ make clean
```

### Boot with cloud-init

Please refer to the [official documentation](https://cloudinit.readthedocs.io/) for a general explanation.

In Arch Linux, cloud-init 19.1 tries network configuration with [netctl](https://wiki.archlinux.org/index.php/Netctl). However, this does not work well because it has a [bug](https://bugs.launchpad.net/cloud-init/+bug/1714495). As a workaround, the following example shows how to use [systemd-networkd](https://wiki.archlinux.org/index.php/Systemd-networkd) and [systemd-resolved](https://wiki.archlinux.org/index.php/Systemd-resolved) with [`bootcmd` module](https://cloudinit.readthedocs.io/en/latest/topics/modules.html#bootcmd) instead of using normal network configuration.

```
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

    ln -s /run/systemd-resolve/resolv.conf /etc/resolv.conf
    systemctl start systemd-networkd systemd-resolved
...
```

## Development

### E2E test

It is good practice not to include the creation date in the `ISO_VERSION` variable to avoid unintended file name inconsistencies.

```
$ make ISO_VERSION=dev all test
```

### Debugging

#### Build the ISO image step-by-step

```
$ make ISO_VERSION=dev build-exec
[builder@ffffffffffff src]$ make archlive # build profile
[builder@ffffffffffff src]$ make repo # build custom repository
[builder@ffffffffffff src]$ make iso # build ISO image
```

#### Run QEMU with the ISO image

```
$ make all
$ make ISO_VERSION=dev run-exec
[runner@ffffffffffff test]$ make cidata # generate cloud-init data source ISO image
[runner@ffffffffffff test]$ qemu-daemon # start QEMU in background
[runner@ffffffffffff test]$ qemu-serial # connect to serial
[runner@ffffffffffff test]$ qemu-monitor # connect to monitor
[runner@ffffffffffff test]$ qemu-ssh # connect to SSH
[runner@ffffffffffff test]$ qemu-kill # stop QEMU
```

or

```
$ make all
$ make ISO_VERSION=dev run-exec
[runner@ffffffffffff test]$ make cidata
[runner@ffffffffffff test]$ qemu-daemon -f # start QEMU in foreground
```

## References

- [Archiso](https://wiki.archlinux.org/index.php/Archiso)
- [cloud-init Documentation](https://cloudinit.readthedocs.io/)
- [Install from existing Linux](https://wiki.archlinux.org/index.php/Install_from_existing_Linux)
- [QEMU wiki](https://wiki.qemu.org)
