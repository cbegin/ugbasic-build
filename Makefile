# Docker image configuration
IMAGE_NAME = docker.io/cbegin/ugbasic
TAG = main

# Compile Vars
COMPILER=c64
INPUT_FILE=test.bas
OUTPUT_FILE=test.prg
TYPE=$(shell echo $(OUTPUT_FILE) | sed 's/.*\.//')

# Run Vars
VICE_PATH=/Applications/vice-arm64-sdl2-3.8/bin
EMULATOR=x64sc

# Help command
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make build    - Build the Docker image"
	@echo "  make clean    - Remove the Docker image"
	@echo "  make rebuild  - Build the Docker image without cache"
	@echo "  make push     - Push the Docker image"
	@echo "  make pull     - Pull the Docker image"
	@echo "  make list     - List all Docker images"
	@echo "  make shell    - Run the container in interactive mode"
	@echo "  make compile  - Compile BASIC program using ugBASIC"
	@echo "  make run      - Run the compiled program in VICE emulator"

# Build the Docker image
.PHONY: build
build:
	docker build -t $(IMAGE_NAME):$(TAG) .

# Remove the Docker image
.PHONY: clean
clean:
	docker rm $(docker ps -aq | xargs)
	docker rmi $(IMAGE_NAME):$(TAG)

# Build with no cache
.PHONY: rebuild
rebuild:
	docker build --no-cache -t $(IMAGE_NAME):$(TAG) .

# Push the Docker image
.PHONY: push
push:
	docker push $(IMAGE_NAME):$(TAG)

# Pull the Docker image
.PHONY: pull
pull:
	docker pull $(IMAGE_NAME):$(TAG)

# List all Docker images
.PHONY: list
list:
	docker images

# Run the Docker container in interactive mode
.PHONY: shell
shell:
	docker run  -it -v "$(shell pwd)":/workdir -w /workdir $(IMAGE_NAME):$(TAG)

# Compile BASIC program using ugBASIC
.PHONY: compile
compile:
	@docker run -it -v "$(shell pwd)":/workdir -w /workdir $(IMAGE_NAME):$(TAG) \
	/app/ugbc.$(COMPILER) -O $(TYPE) -o $(OUTPUT_FILE) $(INPUT_FILE)

# Run the compiled program in VICE emulator
.PHONY: run
run:
	@$(VICE_PATH)/$(EMULATOR) $(OUTPUT_FILE)

