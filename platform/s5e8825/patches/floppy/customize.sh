if [[ "$TARGET_CODENAME" == "a53x" ]]; then
    LOG "\033[0;33m! Nothing to do\033[0m"
    return 0
fi

KERNEL_URL="https://github.com/FlopKernel-Series/flop_s5e8825-build_compendium/releases/download/flop-v6.2.3"
KERNEL_ARCHIVE="FloppyOneUI_v6.2.3-Vanilla-exynos1280-20260305-1735.tar"

if [[ -d "$TMP_DIR" ]]; then
    EVAL "rm -rf \"$TMP_DIR\""
fi
EVAL "mkdir -p \"$TMP_DIR\""

DOWNLOAD_FILE "$KERNEL_URL/$KERNEL_ARCHIVE" "$TMP_DIR/$KERNEL_ARCHIVE"

LOG "- Extracting $KERNEL_ARCHIVE"
EVAL "tar -xvf \"$TMP_DIR/$KERNEL_ARCHIVE\" -C \"$TMP_DIR\""
EVAL "rm -f \"$TMP_DIR/$KERNEL_ARCHIVE\""

while IFS= read -r f; do
    IMG="$(basename "$f")"

    LOG "- Extracting $IMG"
    EVAL "lz4 -df --rm \"$TMP_DIR/$IMG\" \"$TMP_DIR/${IMG%.lz4}\""

    LOG "- Replacing ${IMG%.lz4}"
    if [[ -f "$WORK_DIR/kernel/${IMG%.lz4}" ]]; then
        EVAL "rm -f \"$WORK_DIR/kernel/${IMG%.lz4}\""
    fi
    EVAL "mv \"$TMP_DIR/${IMG%.lz4}\" \"$WORK_DIR/kernel/${IMG%.lz4}\""
done < <(find "$TMP_DIR" -maxdepth 1 -type f -name "*.img.lz4")

EVAL "rm -rf \"$TMP_DIR\""

unset KERNEL_ARCHIVE KERNEL_ARCHIVE_URL KERNEL_URL
