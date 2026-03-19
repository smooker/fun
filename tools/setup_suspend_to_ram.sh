#!/bin/bash
# setup_suspend_to_ram.sh — Fix lid close suspend on ThinkPad P53 (st)
# Run as root on host (NOT in chroot)
# 2026-03-19

set -e

echo "=== ThinkPad P53 Suspend Setup ==="

# 1. Check current state
echo ""
echo "--- Current suspend mode ---"
cat /sys/power/mem_sleep
echo ""

# 2. Elogind config
echo "--- Configuring elogind ---"
LOGIND="/etc/elogind/logind.conf"
cp -a "$LOGIND" "$LOGIND.bak.$(date +%Y%m%d)"

sed -i 's/^#HandleLidSwitch=.*/HandleLidSwitch=suspend/' "$LOGIND"
sed -i 's/^#HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=suspend/' "$LOGIND"
sed -i 's/^#LidSwitchIgnoreInhibited=.*/LidSwitchIgnoreInhibited=yes/' "$LOGIND"

echo "  HandleLidSwitch=suspend"
echo "  HandleLidSwitchExternalPower=suspend"
echo "  LidSwitchIgnoreInhibited=yes"
echo "  backup: $LOGIND.bak.$(date +%Y%m%d)"

# 3. ACPI default.sh — add lid handler as backup
echo ""
echo "--- Configuring acpid lid handler ---"
ACPI="/etc/acpi/default.sh"
cp -a "$ACPI" "$ACPI.bak.$(date +%Y%m%d)"

if grep -q '#lid)' "$ACPI"; then
    # Replace commented lid section
    sed -i '/^[[:space:]]*#lid)/,/^[[:space:]]*#;;/{
        s/^[[:space:]]*#lid)/            lid)/
        s/^[[:space:]]*#.*/            test "$id" = "close" \&\& loginctl suspend/
        s/^[[:space:]]*#;;/            ;;/
    }' "$ACPI"
    echo "  lid handler uncommented and set to loginctl suspend"
else
    echo "  lid handler already configured or not found — check manually"
fi
echo "  backup: $ACPI.bak.$(date +%Y%m%d)"

# 4. Ensure deep sleep is default (GRUB)
echo ""
echo "--- Checking GRUB for mem_sleep_default ---"
GRUB="/etc/default/grub"
if grep -q "mem_sleep_default=deep" "$GRUB" 2>/dev/null; then
    echo "  already set in GRUB"
else
    echo "  NOTE: Consider adding to $GRUB:"
    echo "    GRUB_CMDLINE_LINUX=\"... mem_sleep_default=deep\""
    echo "    then: grub-mkconfig -o /boot/grub/grub.cfg"
fi

# 5. Restart services
echo ""
echo "--- Restarting services ---"
pkill -9 elogind 2>/dev/null || true
sleep 2
/etc/init.d/elogind start && echo "  elogind: started" || echo "  elogind: FAILED"
/etc/init.d/acpid restart && echo "  acpid: restarted" || echo "  acpid: FAILED"

# 6. Verify
echo ""
echo "--- Verification ---"
echo "elogind config:"
grep -E "^HandleLidSwitch|^LidSwitchIgnoreInhibited" "$LOGIND" || echo "  WARNING: settings not found"
echo ""
echo "acpid status:"
rc-status -s | grep acpid
echo ""
echo "suspend mode:"
cat /sys/power/mem_sleep
echo ""
echo "=== Done. Close lid to test suspend. ==="
