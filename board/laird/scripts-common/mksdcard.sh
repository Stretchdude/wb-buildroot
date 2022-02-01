#!/bin/sh

set -e

DRIVE=${1}
ARG=${1##*/}
SRCDIR=${0%/*}
DRIVE_SIZE=/sys/block/${DRIVE##*/}/size

if [ -z "${DRIVE}" ] || [ -z "${ARG}" ]; then
    echo "mksdcard.sh <device>"
    echo "  <device> is the SD card to be programmed (e.g., /dev/sdc)"
    exit
fi

if [ ! -b ${DRIVE} ] || [ "$(cat ${DRIVE_SIZE})" -eq 0 ]; then
    echo "Can not find destination drive \"${DRIVE}\""
    exit
fi

if [ ! -e ${SRCDIR}/rootfs.tar ]; then
    echo "Can not find required rootfs.tar file."
    exit
fi

case "${ARG}" in
    sd*)
        PART_BOOT=${DRIVE}1
        #PART_SWAP=${DRIVE}2
        #PART_ROOTFS=${DRIVE}3
	PART_CONF=${DRIVE}2
	PART_LOG=${DRIVE}3
        ;;

    mmcblk*)
        PART_BOOT=${DRIVE}p1
	PART_CONF=${DRIVE}p2
	PART_LOG=${DRIVE}p3
#        PART_SWAP=${DRIVE}p2
#        PART_ROOTFS=${DRIVE}p3
        ;;

    *)
        echo "Invalid device name: ${ARG}"
        exit
        ;;
esac

which udisksctl > /dev/null && udisk=1 || udisk=0

unmount_all() {
	local drives="$(mount |grep -oP "^${1}\d+")"

	for f in ${drives} ; do
		if [ ${udisk} -ne 0 ]; then
			udisksctl unmount -f -b ${f} >/dev/null
		else
			umount -f ${f} >/dev/null
		fi
	done

	[ -z "${drives}" ] || sleep 1
}

# Un-mount all mounted partitions
unmount_all ${DRIVE}

# Check if device is busy
hdparm -z ${DRIVE} >/dev/null

echo "[Partitioning ${DRIVE}...]"

# Wipe MBR and Partition Table
dd if=/dev/zero of=${DRIVE} bs=512 count=1 status=none
dd if=/dev/zero of=${DRIVE} bs=1KiB count=1 seek=1024 status=none
dd if=/dev/zero of=${DRIVE} bs=1KiB count=4 seek=$((100*1024)) status=none
dd if=/dev/zero of=${DRIVE} bs=1KiB count=4 seek=$((800*1024)) status=none
dd if=/dev/zero of=${DRIVE} bs=1KiB count=4 seek=$((801*1024)) status=none

parted -s ${DRIVE} mklabel msdos unit MiB \
    mkpart primary fat16 1 100 set 1 lba on set 1 boot on \
    mkpart primary ext4 100 800 \
    mkpart primary ext4 801 100%

[ $? -ne 0 ] && exit

sync
sleep 1

echo "[Making file systems...]"

# Format newly created partitions
mkfs.vfat -F 16 -n BOOT ${PART_BOOT} >/dev/null
#mkswap -L swap ${PART_SWAP} >/dev/null
mkfs.ext3 -q -L config ${PART_CONF} -E lazy_itable_init=0,lazy_journal_init=0
mkfs.ext3 -q -L log ${PART_LOG} -E lazy_itable_init=0,lazy_journal_init=0
sync

echo "[Copying files...]"

MNT_BOOT=/mnt/${PART_BOOT##*/}
#MNT_ROOTFS=/mnt/${PART_ROOTFS##*/}

# Copy files to boot partition
mkdir -p ${MNT_BOOT}
mount ${PART_BOOT} ${MNT_BOOT}

cp ${SRCDIR}/u-boot-spl.bin ${MNT_BOOT}/boot.bin
cp ${SRCDIR}/u-boot.itb ${MNT_BOOT}
cp ${SRCDIR}/kernel.itb ${MNT_BOOT}
sync

umount -f ${MNT_BOOT} && rm -rf ${MNT_BOOT}

# Copy files to rootfs partition
#mkdir -p ${MNT_ROOTFS}
#mount ${PART_ROOTFS} ${MNT_ROOTFS} || exit
#
#tar xf ${SRCDIR}/rootfs.tar -C ${MNT_ROOTFS}
#sync
#
#umount ${MNT_ROOTFS} && rm -rf ${MNT_ROOTFS}

unmount_all ${DRIVE}

echo "[Done]"
