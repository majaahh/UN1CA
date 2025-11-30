# Copyright (c) 2026 Majaahh
# SPDX-License-Identifier: GPL-3.0-or-later

# Debloat list for Galaxy A25 5G (a25x)
# - Add entries inside the specific partition containing that file (<PARTITION>_DEBLOAT+="")
# - DO NOT add the partition name at the start of any entry (eg. "/system/dpolicy_system")
# - DO NOT add a slash at the start of any entry (eg. "/dpolicy_system")

# Hotword
PRODUCT_DEBLOAT+="
priv-app/HotwordEnrollmentXGoogleEx4CORTEXM55
priv-app/HotwordEnrollmentOKGoogleEx4CORTEXM55
"
