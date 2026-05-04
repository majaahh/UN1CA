if ! $TARGET_OS_BUILD_SYSTEM_EXT_PARTITION; then
    LOG "\033[0;33m! Nothing to do\033[0m"
    return 0
fi

LOG "- Adding \"system_ext /system_ext $TARGET_OS_FILE_SYSTEM_TYPE ro wait,logical,first_stage_mount,avb=vbmeta_system\" to /vendor/etc/fstab.s5e8825"
awk '
/\t\/system\t/ { last=NR }
{ lines[NR]=$0 }
END {
  for (i=1;i<=NR;i++) {
    print lines[i]
    if (i==last)
      print "system_ext /system_ext "ENVIRON["TARGET_OS_FILE_SYSTEM_TYPE"]" ro wait,logical,first_stage_mount,avb=vbmeta_system"
  }
}' "$WORK_DIR/vendor/etc/fstab.s5e8825" > "$WORK_DIR/vendor/etc/fstab.s5e8825.tmp" && \
    mv "$WORK_DIR/vendor/etc/fstab.s5e8825.tmp" "$WORK_DIR/vendor/etc/fstab.s5e8825"
