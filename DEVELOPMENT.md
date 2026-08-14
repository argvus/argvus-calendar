# Development

Argvus Calendar is a Rust application used by the Argvus Waybar module. It renders a native GTK4 calendar popup as a layer-shell surface and manages events, reminders and synchronization for Wayland/Hyprland.

## Requirements

Install Rust and the system libraries used by the GTK4 popup:

```sh
cargo --version
pkg-config --version
```

On Arch Linux, the runtime/build dependencies are represented by `packaging/PKGBUILD`.

## Commands

```sh
cargo build --release --locked
cargo test --locked
cargo clippy --locked --all-targets -- -D warnings
```

Local command checks:

```sh
cargo run --locked -- toggle
cargo run --locked -- show
cargo run --locked -- hide
cargo run --locked -- status
cargo run --locked -- import file.ics
cargo run --locked -- export --output calendar.ics
cargo run --locked -- sync
```

Run the reminder/service loop:

```sh
cargo run --locked -- service
```

The provided user systemd unit lives at `docs/systemd/argvus-calendar.service`:

```sh
systemctl --user enable --now argvus-calendar.service
```

## Configuration files

User configuration is read from:

```text
$XDG_CONFIG_HOME/argvus-calendar/config.toml
~/.config/argvus-calendar/config.toml
```

Create or edit it with:

```sh
argvus-calendar config
```

Data lives under `$XDG_DATA_HOME/argvus-calendar/` (SQLite database), state under `$XDG_STATE_HOME/argvus-calendar/` and cache under `$XDG_CACHE_HOME/argvus-calendar/`.

Styling loads from `/etc/argvus-calendar/style.css`, `/etc/argvus-calendar/theme.css`, the active theme under `/etc/argvus-calendar/themes/`, and the user-level active theme cache under `$XDG_CACHE_HOME/argvus-calendar/theme.css`.

## Release flow

1. Update `Cargo.toml` version.
2. Run tests and clippy.
3. Commit the version change.
4. Tag `vX.Y.Z` and push the tag.
5. Confirm the package workflow builds `argvus-calendar-X.Y.Z-1-x86_64.pkg.tar.zst` and its `.sig`.
6. Confirm the workflow publishes both files to `argvus/packages` under `public/arch/x86_64/` and updates the Arch repository database.

The project does not create GitHub Releases for package distribution. The built
`.pkg.tar.zst` and `.sig` are kept as GitHub Actions artifacts for one day only;
the permanent package copies live in `argvus/packages`.
