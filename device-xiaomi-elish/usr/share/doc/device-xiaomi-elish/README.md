# Xiaomi Mi Pad 5 Pro (elish) device notes

## Firmware layout

* DSP firmware is expected under `/lib/firmware/qcom/sm8250/xiaomi/elish/`.
* Hexagon/SSC runtime data is expected under `/usr/share/qcom/sm8250/xiaomi/elish/`.
* An initramfs file list for DSP firmware is provided at
  `/usr/share/mkinitfs/files/30-dsp-firmware.files` (from the firmware package).

## Services

Systemd services shipped with this device package:

* `xiaomi-elish-qrtr-ns.service`
* `xiaomi-elish-rmtfs.service`
* `xiaomi-elish-hexagonrpcd.service`

Enable them at build time so QRTR, rmtfs, and hexagonrpcd are available early.

## Kernel cmdline / initramfs

* Ensure initramfs includes the modules listed in
  `/usr/share/mkinitfs/modules.d/50-xiaomi-elish.conf`.
* If using a custom firmware path, keep `firmware_class.path=/lib/firmware` aligned
  with the firmware directory layout above (default is already correct).
