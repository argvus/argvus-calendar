# Waybar Integration

Use this as the clock/date click handler:

```json
"on-click": "/usr/lib/argvus-calendar/waybar-launcher --surface {x_root} {y_root}"
```

Argvus Waybar records `{x_root}`/`{y_root}` from the original button event
relative to its layer surface. The launcher adds the stable surface origin and
passes immutable desktop coordinates through `--x`/`--y`. The popup therefore
stays where the date was clicked even if the pointer moves while processes are
starting, and appears 12 pixels below that click. It closes on the next Waybar
click or when clicking outside it. Upstream Waybar builds without these
placeholders retain the live-pointer compatibility fallback.
