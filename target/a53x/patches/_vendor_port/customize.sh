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

unset TARGET_EXTRA_FIRMWARE_DIR MODEL REGION
