# Docker image configuration
IMAGE_NAME = ugbasic
TAG = main

# Compile Vars
# COMPILER=c64
# INPUT_FILE=test.bas
# OUTPUT_FILE=test.prg
# TYPE=prg
COMPILER=c128
INPUT_FILE=test.bas
OUTPUT_FILE=test.prg
TYPE=prg

# Run Vars
VICE_PATH=/Applications/vice-arm64-sdl2-3.8/bin
EMULATOR=x128

.PHONY: build
# Build the Docker image
build:
	docker build -t $(IMAGE_NAME):$(TAG) .

.PHONY: clean
# Remove the Docker image
clean:
	docker rm $(docker ps -aq | xargs)
	docker rmi $(IMAGE_NAME):$(TAG)

.PHONY: rebuild
# Build with no cache
rebuild:
	docker build --no-cache -t $(IMAGE_NAME):$(TAG) .

.PHONY: list
# List all Docker images
list:
	docker images

.PHONY: shell
# Run the Docker container in interactive mode
shell:
	docker run  -it -v "$(shell pwd)":/workdir -w /workdir $(IMAGE_NAME):$(TAG)

.PHONY: help
# Help command
help:
	@echo "Available commands:"
	@echo "  make build    - Build the Docker image"
	@echo "  make clean    - Remove the Docker image"
	@echo "  make rebuild  - Build the Docker image without cache"
	@echo "  make list     - List all Docker images"
	@echo "  make shell    - Run the container in interactive mode"

.PHONY: run
compile:
	@docker run -it -v "$(shell pwd)":/workdir -w /workdir $(IMAGE_NAME):$(TAG) \
	/app/ugbc.$(COMPILER) -O $(TYPE) -o $(OUTPUT_FILE) $(INPUT_FILE)

.PHONY: run
run:
	@$(VICE_PATH)/$(EMULATOR) $(OUTPUT_FILE)
