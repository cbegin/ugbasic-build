# ugBASIC Build

A Docker based build system for ugBASIC, primarily intended to support Mac dev environments
to target 8-bit computing platforms (6502, 6809, Z80 and based systems).

## Installation:

The fastest way to install is to simply pull the docker
image down, with all the precompiled dependencies.

```
docker pull cbegin/ugbasic:main
```

You'll also want to either copy the Makefile or clone
this repo, as it has a number of useful commands.
Alternatively you can just use it for inspiration
to make your own shell script to run your builds.

If you previously pulled the docker image as above, you
can focus strictly on the compile and run targets.

```
Available targets:
  make build    - Build the Docker image
  make clean    - Remove the Docker image
  make rebuild  - Build the Docker image without cache
  make push     - Push the Docker image
  make pull     - Pull the Docker image
  make list     - List all Docker images
  make shell    - Run the container in interactive mode
  make compile  - Compile BASIC program using ugBASIC
  make run      - Run the compiled program in VICE emulator
```

The Makefile has configuration variables at the top, to
specify the location of the Vice emulator, as well as
the compiler and input file settings you want to use.

```
COMPILER=c64
INPUT_FILE=test.bas
OUTPUT_FILE=test.prg

# Run Vars
VICE_PATH=/Applications/vice-arm64-sdl2-3.8/bin
EMULATOR=x64sc
```

My typical dev loop is simply code, and then:

```
make compile && make run
```

## Building

If you choose to build from scratch (takes hours),
then you you need to download the ugBASIC linux
tarball from: https://ugbasic.iwashere.eu/

You'll want the 64 bit version for Linux, and
choose the option to download "all compilers",
to support all platforms.

Drop the `ugbc-main.tar.gz` file into the root
of the cloned git repo, and run `make build`.
