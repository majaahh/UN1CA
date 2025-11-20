# [
EXTRACT_DTBO()
{
    EVAL "mkdtboimg dump $WORK_DIR/kernel/dtbo.img --dtb $DTBO"

    for i in $(seq 0 4); do
        if [[ ! -f "$DTBO.$i" ]]; then
            break
        fi
        EVAL "dtc -I dtb -O dts $DTBO.$i -o $DTSI.$i"
        EVAL "rm -f \"$DTBO.$i\"" || true
    done
}

APPLY_DTBO_PATCH()
{
    local PATCH="$MODPATH/patches/$1"

    if [[ ! -f "$PATCH" ]]; then
        LOGE "File not found: ${PATCH//$SRC_DIR\//}"
        return 1
    fi

    LOG "- Applying \"$(grep "^Subject:" "$PATCH" | sed "s/.*PATCH] //")\" to dtbo"
    EVAL "LC_ALL=C git apply --directory=\"$TMP_DIR\" --verbose --unsafe-paths \"$PATCH\"" || return 1
}

PACK_TO_DTBO()
{
    for i in $(seq 0 4); do
        if [[ ! -f "$DTSI.$i" ]]; then
            break
        fi
        EVAL "dtc -I dts -O dtb -o $DTBO.$i $DTSI.$i"
    done
}

PACK_TO_IMG()
{
    local CONF="$MODPATH/configs/$TARGET_CODENAME.cfg"

    EVAL "mkdtboimg cfg_create $TMP_DIR/dtbo.img $CONF -d $TMP_DIR"
}
# ]

if [[ "$TARGET_CODENAME" == "a53x" ]]; then
    LOG "\033[0;33m! Nothing to do\033[0m"
    return 0
fi

if [[ ! -f "$MODPATH/configs/$TARGET_CODENAME.cfg" ]]; then
    LOG "\033[0;33m! File not found: ${MODPATH//$SRC_DIR\//}/configs/$TARGET_CODENAME.cfg. Skipping dtbo patch.\033[0m"
    return 0
fi

DTBO="$TMP_DIR/dtbo"
DTSI="$TMP_DIR/dtsi"

if [[ -d "$TMP_DIR" ]]; then
    EVAL "rm -rf \"$TMP_DIR\""
fi
EVAL "mkdir -p \"$TMP_DIR\""

LOG "- Extracting dtbo"
EXTRACT_DTBO
APPLY_DTBO_PATCH "0001-Fix-Adaptive-Refresh-Rate-Color-Flickering.$TARGET_CODENAME.patch"
LOG "- Repacking dtbo"
PACK_TO_DTBO
PACK_TO_IMG

if [[ -f "$WORK_DIR/kernel/dtbo.img" ]]; then
    EVAL "rm -rf \"$WORK_DIR/kernel/dtbo.img\""
fi

LOG "- Copying new dtbo image"
EVAL "cp -a \"$TMP_DIR/dtbo.img\" \"$WORK_DIR/kernel/dtbo.img\""

EVAL "rm -rf \"$TMP_DIR\""

unset DTBO DTSI
