#!/usr/bin/env sh
#
# Removes argvus-calendar installed by tools/install.sh.
# Disables and stops the user service first.
#
# Requires root. Run as: sudo tools/uninstall.sh

set -eu

BINDIR=/usr/bin
LIBEXECDIR=/usr/lib/argvus-calendar
ETCDIR=/etc/argvus-calendar
UNITDIR=/usr/lib/systemd/user
LICDIR=/usr/share/licenses/argvus-calendar

if [ "$(id -u)" -ne 0 ]; then
    echo "error: run as root (sudo tools/uninstall.sh)" >&2
    exit 1
fi

systemctl --user disable --now argvus-calendar 2>/dev/null || true
systemctl --user daemon-reload 2>/dev/null || true

rm -f "$BINDIR/argvus-calendar"
rm -f "$LIBEXECDIR/waybar-launcher"
rmdir "$LIBEXECDIR" 2>/dev/null || true
rm -f "$UNITDIR/argvus-calendar.service"
rm -rf "$ETCDIR"
rm -rf "$LICDIR"

echo "argvus-calendar uninstalled."
