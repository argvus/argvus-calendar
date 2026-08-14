PREFIX ?= /usr

.PHONY: build check install uninstall reinstall service-enable service-disable service-restart clean

build:
	cargo build --release --locked

check:
	cargo clippy
	cargo test

install: build
	sudo tools/install.sh
	systemctl --user daemon-reload
	systemctl --user restart argvus-calendar

uninstall:
	sudo tools/uninstall.sh

reinstall: uninstall install

service-enable:
	systemctl --user enable --now argvus-calendar

service-disable:
	systemctl --user disable --now argvus-calendar

service-restart:
	systemctl --user restart argvus-calendar

clean:
	cargo clean
