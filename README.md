# rust-linux-dev

Some rust development tools are only available on linux. This linux docker image can be used to run rust dev tools.

## install

`https://github.com/sitkevij/rust-linux-dev.git && cd rust-linux-dev && make build`

## run

runs the docker image interactively:
```
make runit
```

which executes:

```
docker run -it --volume "${PWD}:/volume" sitkevij/rust-linux-dev /bin/bash
```
