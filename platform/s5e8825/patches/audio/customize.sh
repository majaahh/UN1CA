DELETE_FROM_WORK_DIR "system" "system/lib/lib_SoundAlive_play_plus_ver800.so"
DELETE_FROM_WORK_DIR "system" "system/lib64/lib_SoundAlive_play_plus_ver800.so"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libsamsungSoundbooster_plus_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"

if [[ "$TARGET_CODENAME" != "m33x" ]] && [[ "$TARGET_CODENAME" != "m34x" ]]; then
    LOG "\033[0;33m! Skipping extra blob replacement\033[0m"
    return 0
fi

if [[ "$TARGET_PRODUCT_SHIPPING_API_LEVEL" -lt "33" ]]; then
    ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/libaudioprocessing.so" 0 0 644 "u:object_r:system_lib_file:s0"
fi
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/lib_SoundAlive_play_plus_ver400.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/libaudioclient.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/libaudiopolicycomponents.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/libaudiopolicyengineconfigurable.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib/libaudiosaplus_sec_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/lib_SoundAlive_play_plus_ver400.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libaudioclient.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libaudioflinger.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libaudioflinger_fastpath.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libaudiopolicycomponents.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libaudiopolicyengineconfigurable.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libaudiopolicyenginedefault.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libaudiopolicymanagerdefault.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libaudioprocessing.so" 0 0 644 "u:object_r:system_lib_file:s0"
ADD_TO_WORK_DIR "$TARGET_FIRMWARE" "system" "system/lib64/libaudiosaplus_sec_legacy.so" 0 0 644 "u:object_r:system_lib_file:s0"
