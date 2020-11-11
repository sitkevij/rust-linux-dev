# http://www.gnu.org/software/make/manual/make.html#Special-Variables
.DEFAULT_GOAL := run

# http://www.gnu.org/software/make/manual/make.html#Phony-Targets
.PHONY: clean

TARGET_DIR = target
DEBUG_DIR = $(TARGET_DIR)/debug
RELEASE_DIR = $(TARGET_DIR)/release
RLS_DIR = $(TARGET_DIR)/rls
INSTALL_DIR = /usr/local/bin
TAG = sitkevij/rust-linux-dev

all: fmt test clean

fmt:
	cargo fmt --verbose

debug:
	export RUSTFLAGS=""
	cargo build

release: test
	cargo build --release

test:
	cargo test --verbose --all -- --nocapture

tarpaulin:
	docker run --security-opt seccomp=unconfined -v "${PWD}:/volume" xd009642/tarpaulin
	open tarpaulin-report.html

grcov:
	# grcov requires rust nightly for now
	rm -rf target/debug/
	# export RUSTFLAGS="-Zprofile -Ccodegen-units=1 -Copt-level=0 -Clink-dead-code -Coverflow-checks=off"
	export CARGO_INCREMENTAL=0 && \
	export RUSTFLAGS="-Zprofile -Ccodegen-units=1 -Copt-level=0 -Clink-dead-code -Coverflow-checks=off -Zpanic_abort_tests -Cpanic=abort" && \
	export RUSTDOCFLAGS="-Cpanic=abort" && \
	cargo +nightly build
	cargo +nightly test --verbose
	grcov ./target/debug/ -s . -t html --llvm --branch --ignore-not-existing -o ./target/debug/coverage/
	open target/debug/coverage/index.html


install: release debug test
	cargo install --path . 
	## cp $(RELEASE_DIR)/$(BINARY) $(INSTALL_DIR)/$(BINARY)

install-force: clean release debug test
	cargo install --path . --force

clippy:
	cargo clippy

clean: ## Remove all artifacts
	rm -rf $(DEBUG_DIR)
	rm -rf $(RELEASE_DIR)
	rm -rf $(RLS_DIR)

build:
	docker build -t $(TAG) .

runit:
	docker container run -it --volume "${PWD}:/volume" $(TAG) /bin/bash
