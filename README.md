# argvus-calendar

Native ARGVUS calendar popup for Wayland/Hyprland.

Version `0.1.0` provides a compact Relm4/GTK4 popup, layer-shell positioning for Waybar, SQLite storage, ICS import/export, configurable reminder scheduling with desktop notifications, and an internal CalDAV/WebDAV client foundation.

Arch packaging is owned by this repository through `packaging/PKGBUILD`.

## Commands

```bash
argvus-calendar
argvus-calendar toggle
argvus-calendar show
argvus-calendar hide
argvus-calendar config
argvus-calendar config-path
argvus-calendar reload
argvus-calendar import file.ics
argvus-calendar export --output calendar.ics
argvus-calendar sync
argvus-calendar status
argvus-calendar service
```

Waybar:

```json
"on-click": "/usr/lib/argvus-calendar/waybar-launcher --surface {x_root} {y_root}"
```

## Paths

- Config: `/etc/argvus-calendar/config.toml` (system-wide; the package ships a default)
- Themes: `/etc/argvus-calendar/style.css`, `/etc/argvus-calendar/theme.css`, `/etc/argvus-calendar/themes/`
- Data/database: `$XDG_DATA_HOME/argvus-calendar/` or `~/.local/share/argvus-calendar/`
- State: `$XDG_STATE_HOME/argvus-calendar/` or `~/.local/state/argvus-calendar/`
- Cache: `$XDG_CACHE_HOME/argvus-calendar/` or `~/.cache/argvus-calendar/`

## Configuration

All argvus-calendar configuration lives in `/etc/argvus-calendar/`. The application uses built-in defaults when `config.toml` is missing. Open the file for editing with:

```bash
argvus-calendar config
```

This opens the file in a terminal with `sudo` (terminal from `$TERMINAL` or the `[terminal]` setting, editor from `$VISUAL`/`$EDITOR` or the `[editor]` setting, default `nano`).

Print the path with:

```bash
argvus-calendar config-path
```

Example:

```toml
[appearance]
font_family = "monospace"
font_size = 12 # valid range: 8-32

[locale]
language = "auto" # auto (system language) | en-US | pt-BR

[calendar]
week_start = "monday" # monday | sunday
show_events = false # experimental; disabled until enabled in settings
default_event_duration_minutes = 60
default_reminder_minutes = 10
sync_interval_minutes = 15

[editor]
command = "" # falls back to $VISUAL, then $EDITOR, then nano
args = []

[terminal]
command = "" # falls back to $TERMINAL, then kitty
args = []
```

The gear button opens the same config file. The popup reloads the config on each restart; `reload` refreshes the external CSS/theme on the running popup.

## Current Notes

- The popup is a single-instance layer-shell surface: it stays running after hiding, so `toggle`/`show`/`hide` go through a UNIX socket IPC (`$XDG_CACHE_HOME/argvus-calendar/`). Argvus Waybar supplies `{x_root}`/`{y_root}` from the original button event relative to its surface; the launcher adds the stable layer origin and forwards immutable desktop coordinates through IPC. The popup opens at that fixed X coordinate and 12 pixels below the click. It closes when you click anywhere outside it, click the date again, press Escape, or when it loses focus.
- The experimental events section starts disabled, is controlled by the in-window toggle and is persisted in `$XDG_CACHE_HOME/argvus-calendar/events-enabled`; `show_events` remains only as a legacy/config fallback.
- Local non-recurring events are automatically removed 10 minutes after they end. CalDAV, ICS and recurring events are preserved. New events cannot be created on past dates.
- Events notify at their start time. Additional reminders can be configured in hours and minutes before the start; all-day events can additionally repeat their notification at a chosen interval during the day.
- All-day events run from local midnight to the following midnight; start and end time controls are disabled while `ALL DAY` is active.
- CalDAV support is implemented as a maintained internal HTTP/XML client foundation. Account management and full DB reconciliation are the next integration step.
- Reminders are reliable when `argvus-calendar service` is running, or when installed as the provided user systemd service.
- Provider-specific account setup, such as Google Calendar and assisted Nextcloud setup, is planned for `0.2`.
- The `auto` language follows the operating system locale: Portuguese when the system is set to `pt-*`, English otherwise. An explicit `en-US` or `pt-BR` in the settings always wins.
- Styling is external: `/etc/argvus-calendar/style.css` provides structure, `/etc/argvus-calendar/theme.css` provides the packaged default, `/etc/argvus-calendar/themes/` contains ARGVUS themes, and `$XDG_CACHE_HOME/argvus-calendar/theme.css` is the user-level active theme written by the ARGVUS theme switcher.
- Supported ARGVUS themes: Dark Aether, Dark Aether Float, Dark Silver, Dark Silver Float, Dark Slate, Dark Slate Float, Dark Universe, Dark Universe Float, Light Veil and Light Veil Float.
