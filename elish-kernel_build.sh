cd $1
kernel_branch="${2:-v6.17}"
https://gitlab.postmarketos.org/soc/qualcomm-sm8250/linux.git --depth 1 linux --branch "${kernel_branch}"
cd linux
config_source="$1/config-postmarketos-qcom-sm8250.aarch64"
if [ ! -f "${config_source}" ]; then
  echo "Missing kernel config: ${config_source}" >&2
  exit 1
fi
cp "${config_source}" .config
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
_kernel_version="$(make kernelrelease -s)"


sed -i "s/Version:.*/Version: ${_kernel_version}/" $1/linux-xiaomi-elish/DEBIAN/control

chmod +x $1/mkbootimg

cat $1/linux/arch/arm64/boot/Image.gz $1/linux/arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-csot.dtb > $1/linux/Image.gz-dtb_csot
mv $1/linux/Image.gz-dtb_csot $1/linux/zImage_csot
$1/mkbootimg --kernel zImage_csot --cmdline "root=PARTLABEL=linux" --base 0x00000000 --kernel_offset 0x00008000 --tags_offset 0x00000100 --pagesize 4096 --id -o $1/boot_csot.img

cat $1/linux/arch/arm64/boot/Image.gz $1/linux/arch/arm64/boot/dts/qcom/sm8250-xiaomi-elish-boe.dtb > $1/linux/Image.gz-dtb_boe
mv $1/linux/Image.gz-dtb_boe $1/linux/zImage_boe
$1/mkbootimg --kernel zImage_boe --cmdline "root=PARTLABEL=linux" --base 0x00000000 --kernel_offset 0x00008000 --tags_offset 0x00000100 --pagesize 4096 --id -o $1/boot_boe.img

rm $1/linux-xiaomi-elish/usr/dummy
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=$1/linux-xiaomi-elish/usr modules_install
rm $1/linux-xiaomi-elish/usr/lib/modules/**/build
cd $1
rm -rf linux

dpkg-deb --build --root-owner-group linux-xiaomi-elish
