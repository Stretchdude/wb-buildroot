TARGETDIR="$1"

export BR2_LRD_PLATFORM="$2"

echo "${BR2_LRD_PLATFORM^^} POST BUILD script: starting..."

# source the common post build script
source "board/laird/post_build_common_60.sh" "$TARGETDIR" "$BR2_LRD_PLATFORM"

# Copy the product specific rootfs additions, strip host user access control
rsync -rlptDWK --exclude=.empty "board/laird/som60/rootfs-additions/" "$TARGETDIR"

# Remove MMC automount when booting from SD card
[[ $BR2_LRD_PLATFORM == *"60sd"* ]] && \
    rm -f "$TARGETDIR/etc/udev/rules.d/91-mmcmount.rules"

# Make sure connection files have proper attributes
for f in "$TARGETDIR/etc/NetworkManager/system-connections/*" ; do
    chmod 600 $f
done

ln -sfr $TARGETDIR/lib/firmware/regulatory_summit60.db $TARGETDIR/lib/firmware/regulatory.db

echo "${BR2_LRD_PLATFORM^^} POST BUILD script: done."
