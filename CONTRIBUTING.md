# Contributing

Thank you for contributing to Argvus Calendar.

## Guidelines

- Keep the popup responsive; never block the GTK main loop on network, file or database I/O.
- Keep single-instance behavior: the popup toggles via the IPC socket, not by spawning new windows.
- Preserve the precedence order: embedded defaults, `/usr/share/argvus-calendar`, user overrides.
- Store calendar data in the SQLite database, not in config files.
- Keep styling in CSS files and TOML settings, not hard-coded in Rust, unless behavior requires code.
- Do not move system defaults back into `argvus`; this package owns its config and themes.

## Pull requests

Include:

- what changed;
- how it affects Waybar or the calendar popup;
- how it was tested;
- any new configuration keys, subcommands or theme selectors.

Run before submitting:

```sh
cargo test --locked
cargo clippy --locked --all-targets --all-features -- -D warnings
```
