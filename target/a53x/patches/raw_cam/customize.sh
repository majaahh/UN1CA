# Enable RAW Support
# Before: [cbz param_1, 0x001564d6]
# After: [nop]
HEX_PATCH "$WORK_DIR/vendor/lib/libexynoscamera3.so" "f0b12749" "00bf2749"

# Before: [tbz w8, #0x0, 0x0029dc44]
# After: [nop]
HEX_PATCH "$WORK_DIR/vendor/lib64/libexynoscamera3.so" "88020036410d0090" "1f2003d5410d0090"
