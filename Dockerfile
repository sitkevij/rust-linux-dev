FROM ubuntu:18.04

RUN apt-get update && apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libffi-dev liblzma-dev git

RUN apt-get update && apt-get install -y pkg-config

# install rust toolchains and tools
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && echo 'export PATH="$HOME/.cargo/bin:$PATH"' >~/.bashrc && /root/.cargo/bin/cargo install cargo-deb && /root/.cargo/bin/cargo install cargo-tarpaulin && /root/.cargo/bin/cargo install cargo-geiger
 
EXPOSE 80 443
