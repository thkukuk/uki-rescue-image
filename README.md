# UKI Rescue Image

UKI Rescue is a rescue image for x86-64 and arm64, built as a
[Unified Kernel Image (UKI)](https://uapi-group.org/specifications/specs/unified_kernel_image/).
The rescue system itself is a read-only Squashfs image, which
reduces memory usage because the image runs directly from RAM.

## Boot methods

The UKI is a single EFI binary and can be booted in several ways:

- **PXE boot** or **UEFI HTTP Boot**, by pointing the firmware at the
  `.efi` binary directly.
- From a **USB stick image**, which contains a `systemd-boot` menu with
  entries for the UKI itself, the plain kernel/initrd, and (on x86-64)
  memtest86+.

### Secure Boot

The UKI binary is not signed with the Microsoft key. To boot it with Secure
Boot enabled, the signing key used by mkosi (or by the Open Build
Service (OBS) project building this image) must be enrolled into the firmware's
key database (e.g. via MokManager/shim). Without enrolling the key, Secure
Boot must be disabled to boot the UKI directly.

### USB stick image

For systems that are too small to run the full UKI (see
[Memory requirements](#memory-requirements) below), the USB stick image
offers a `systemd-boot` menu with the following entries:

- **UKI Rescue** — boots the same signed UKI EFI binary described above.
  Requires the signing key to be enrolled if Secure Boot is enabled and
  the UKI is not signed with the official openSUSE key.
- **Rescue Image** — boots the plain kernel and initrd directly, without
  going through the UKI.
- **Memtest86+** (x86-64 only) — runs memtest86+ to test system memory.

The **Rescue Image** and **Memtest86+** entries do not require any extra
Secure Boot key to be enrolled, since the kernel and memtest86.efi binary
are signed with the official openSUSE key.

## Memory requirements

Booting the UKI EFI binary requires at least **2 GB of RAM**, since the
kernel and initrd are loaded twice in the memory for unpacking them.
For smaller systems, use the "Rescue Image" boot entry from the USB stick
instead.

## System extensions (sysext)

The biggest advantage of UKI Rescue is that it can easily be extended with
[systemd-sysext](https://manpages.opensuse.org/systemd-sysext) images, without
having to rebuild the UKI itself.

Two mechanisms are supported, depending on when the extensions should
become active:

- **Early, from the UKI's own initrd**: if the UKI EFI binary is booted
  from the USB stick, any sysext images placed in
  `uki-rescue/uki-rescue.efi.extra.d/` on the EFI System Partition (ESP)
  are loaded into RAM and activated by the UKI's initrd very early during
  boot (this is standard UKI addon behavior).
- **Later, during regular boot**: if booted from the USB stick image
  (either via the UKI or via the plain "Rescue Image" entry), all sysext
  images found in `/uki-rescue-sysexts/` on the ESP are picked up by the
  `uki-rescue-sysexts.service` and activated via `systemd-sysext refresh`
  once the system is running. The images are copied to RAM.

The image ships a few sysext images out of the box (built from the
`mkosi.images/` sub-images described below), for example a `utilities`
extension with `lvm2`, `pciutils`, `usbutils` and `wget`, which can be
removed from the USB stick if RAM is too tight.

## Network, SSH and proxy configuration

Network setup, SSH access and HTTP(S) proxy configuration use the same
tooling as described for the
[rdi-installer project](https://github.com/thkukuk/rdi-installer/blob/main/README.md):

- [rdii-networkd](https://github.com/thkukuk/rdi-installer/blob/main/README.md#rdii-networkd) — configures `systemd-networkd`.
- [rdii-ssh-setup](https://github.com/thkukuk/rdi-installer/blob/main/README.md#rdii-ssh-setup) — configures SSH access.
- [rdii-proxy-setup](https://github.com/thkukuk/rdi-installer/blob/main/README.md#rdii-proxy-setup) — configures an HTTP(S) proxy.

## Building

The image is built with [mkosi](https://manpages.opensuse.org/mkosi) on
openSUSE Tumbleweed:

```console
mkosi build
```

This builds several sub-images defined under `mkosi.images/`:

| Sub-image   | Purpose                                                        |
|-------------|-----------------------------------------------------------------|
| `debug`     | Sysext with debugging tools (`gdb`, `strace`, `ltrace`, `netcat-openbsd`, `traceroute`). |
| `firmware`  | Sysext with the full `kernel-firmware-all` package.             |
| `fwupd`     | Sysext with `fwupd` for firmware updates (WIP).                 |
| `utilities` | Sysext with extra utilities (`lvm2`, `pciutils`, `usbutils`, `wget`). |

The `obs/` directory contains an alternative `mkosi.conf` used to build
and sign the image on the [openSUSE Build Service](https://build.opensuse.org/).

## License

MIT, see [LICENSE](LICENSE).
