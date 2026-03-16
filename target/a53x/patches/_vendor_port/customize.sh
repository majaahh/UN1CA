MODEL=$(cut -d "/" -f 1 -s <<< "${TARGET_EXTRA_FIRMWARES[0]}")
REGION=$(cut -d "/" -f 2 -s <<< "${TARGET_EXTRA_FIRMWARES[0]}")
TARGET_EXTRA_FIRMWARE_DIR="$FW_DIR/${MODEL}_${REGION}"

LOG_STEP_IN "- Deleting SM-A536B vendor"
while IFS= read -r i; do
    if [[ "$i" == "firmware" ]] || [[ "$i" == "overlay" ]] || \
        [[ "$i" == "app" ]]; then
        continue
    fi

    DELETE_FROM_WORK_DIR "vendor" "$i" &
done < <(find "$WORK_DIR/vendor" -maxdepth 1 | sed '1d; s#.*/vendor/##')
LOG_STEP_OUT

# shellcheck disable=SC2046
wait $(jobs -p) || return 1

LOG_STEP_IN "- Adding SM-A546B vendor"
while IFS= read -r i; do
     if [[ "$i" == "overlay" ]] || [[ "$i" == "firmware" ]] || \
         [[ "$i" == "recovery-from-boot.p" ]] || [[ "$i" == "tee" ]] || \
         [[ "$i" == "app" ]]; then
        continue
     fi

    ADD_TO_WORK_DIR "$MODEL/$REGION" "vendor" "$i" &
done < <(find "$TARGET_EXTRA_FIRMWARE_DIR/vendor" -maxdepth 1 | sed '1d; s#.*/vendor/##')
LOG_STEP_OUT

# shellcheck disable=SC2046
wait $(jobs -p) || return 1

LOG_STEP_IN "- Adapting /vendor/build.prop"
# Codec2
SET_PROP "vendor" "debug.codec2.stop_hal_before_surface" "1"
SET_PROP "vendor" "debug.sf.disable_backpressure" "1"
SET_PROP "vendor" "debug.stagefright.c2-poolmask" --delete
SET_PROP "vendor" "debug.stagefright.ccodec_lax_type" --delete
SET_PROP "vendor" "debug.stagefright.ccodec_strict_type" --delete
SET_PROP "vendor" "vendor.debug.c2.sbwc.enable" --delete

# DRM
SET_PROP "vendor" "ro.netflix.bsp_rev" "EXYNOS1280-34993-1"

# Device
SET_PROP "vendor" "ro.product.vendor.device" "a53x"
SET_PROP "vendor" "ro.product.vendor.model" "a53x"
SET_PROP "vendor" "ro.product.vendor.name" "a53xnaxx"

# Fips
SET_PROP "vendor" "ro.security.fips_fmp.ver" "4.0"
SET_PROP "vendor" "ro.security.fips_scrypto.ver" "2.6"
SET_PROP "vendor" "ro.security.fips_skc.ver" "2.3"

# Graphics
SET_PROP "vendor" "ro.vendor.ddk.set.afbc" "true"

# HWC
SET_PROP "vendor" "vendor.hwc.exynos.vsync_mode" --delete

# Keystore
SET_PROP "vendor" "ro.security.keystore.keytype" "sakv2,gak,"

# Platform
SET_PROP "vendor" "ro.board.platform" "universal8825"
SET_PROP "vendor" "ro.product.board" "s5e8825"
SET_PROP "vendor" "ro.soc.model" "s5e8825"

# Ramdisk
SET_PROP "vendor" "ro.config.pageboost.vramdisk.bootfile.enabled" "true"

# SLMK
SET_PROP "vendor" "ro.slmk.2nd.dha_cached_min" "4"
SET_PROP "vendor" "ro.slmk.2nd.dha_empty_max" "30"
SET_PROP "vendor" "ro.slmk.2nd.swap_free_low_percentage" "20"
SET_PROP "vendor" "ro.slmk.bEFKb_enable" "true"
SET_PROP "vendor" "ro.slmk.beks_key" "431"
SET_PROP "vendor" "ro.slmk.dha_empty_max" "24"
SET_PROP "vendor" "ro.slmk.dha_pwhl_chn_key" "1548"
SET_PROP "vendor" "ro.slmk.dha_th_rate" "3.5"
SET_PROP "vendor" "ro.slmk.freelimit_val" "14"
SET_PROP "vendor" "ro.slmk.plg_key" "9220"
SET_PROP "vendor" "ro.slmk.psi_critical" "120"
SET_PROP "vendor" "ro.slmk.swap_free_low_percentage" "40"
SET_PROP "vendor" "ro.slmk.v_bonusEFK" "64512"

# System
SET_PROP "vendor" "sys.perf.hmp" "6:2"

# VPNPP
SET_PROP "vendor" "ro.security.vpnpp.release" "1.0"
LOG_STEP_OUT

LOG_STEP_IN "- Adding s5e8825 Gatekeeper blobs"
DELETE_FROM_WORK_DIR "vendor" "lib/hw/gatekeeper.s5e8835.so"
DELETE_FROM_WORK_DIR "vendor" "lib64/hw/gatekeeper.s5e8835.so"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "lib/hw/gatekeeper.s5e8825.so" 0 0 644 "u:object_r:vendor_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "lib64/hw/gatekeeper.s5e8825.so" 0 0 644 "u:object_r:vendor_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Adding stock TEEgris blobs"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "bin/tee" 0 2000 755 "u:object_r:vendor_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "bin/tzdaemon" 0 2000 755 "u:object_r:tzdaemon_exec:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "bin/tzts_daemon" 0 2000 755 "u:object_r:tztsd_exec:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "lib/libteecl.so" 0 0 644 "u:object_r:same_process_hal_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "lib64/libteecl.so" 0 0 644 "u:object_r:same_process_hal_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Adding stock WiFi configurations"
DELETE_FROM_WORK_DIR "vendor" "etc/wifi"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "etc/wifi"
LOG_STEP_OUT

LOG_STEP_IN "- Adding stock fstab"
DELETE_FROM_WORK_DIR "vendor" "etc/fstab.s5e8835"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "etc/fstab.s5e8825" 0 0 644 "u:object_r:vendor_configs_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Adding stock init scripts"
DELETE_FROM_WORK_DIR "vendor" "etc/init/init.s5e8835.rc"
DELETE_FROM_WORK_DIR "vendor" "etc/init/init.s5e8835.usb.rc"
DELETE_FROM_WORK_DIR "vendor" "etc/init/teegris_tui.rc"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "etc/init/init.s5e8825.rc" 0 0 644 "u:object_r:vendor_configs_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "vendor" "etc/init/init.s5e8825.usb.rc" 0 0 644 "u:object_r:vendor_configs_file:s0"
LOG_STEP_OUT

LOG_STEP_IN "- Adding stock uevenetd.rc"
EVAL "cp -a \"$FW_DIR/SM-A536B_EUX/vendor/ueventd.rc\" \"$WORK_DIR/vendor/etc/ueventd.rc\""
LOG_STEP_OUT

unset TARGET_EXTRA_FIRMWARE_DIR MODEL REGION
