# Set platform argument
ARG TARGETPLATFORM=linux/amd64

# Use Ubuntu 22.04 (Jammy Jellyfish) as base image
FROM --platform=$TARGETPLATFORM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and upgrade installed packages
RUN apt-get update \
    && apt-get upgrade -y

# Install glibc and related packages
RUN apt-get install -y \
    libc6 \
    libc6-dev \
    build-essential \
    libxml2-dev \
    bison \
    flex \
    wget \ 
    libgmp3-dev \
    software-properties-common \
    zlib1g-dev \
    libxml2-dev \
    libxml2 \
    pkg-config \
    curl \
    cc65

# Install asm6809
RUN add-apt-repository ppa:sixxie/ppa \
    && apt-get update \
    && apt-get install -y \
    asm6809

# Clean up
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

# Install newer Boost version (1.79.0)
RUN wget https://archives.boost.io/release/1.79.0/source/boost_1_79_0.tar.gz \
    && tar -xzf boost_1_79_0.tar.gz \
    && cd boost_1_79_0 \
    && ./bootstrap.sh \
    && ./b2 install --with-system --with-filesystem --with-program_options --prefix=/usr/local \
    && ldconfig \
    && cd .. \
    && rm boost_1_79_0.tar.gz \
    && rm -rf boost_1_79_0

# Install z88dk
RUN wget http://nightly.z88dk.org/z88dk-latest.tgz \
    && tar -xzf z88dk-latest.tgz \
    && cd z88dk/ \
    && export CFLAGS="-march=native -mtune=generic" \
    && export CXXFLAGS="-march=native -mtune=generic" \
    && BUILD_SDCC=1 BUILD_SDCC_HTTP=1 ./build.sh

# Set working directory
WORKDIR /app

# Copy ugbc-main.tar.gz into the container
COPY ugbc-main.tar.gz .

# Extract the archive
RUN tar -xzf ugbc-main.tar.gz

# Create symlinks for z88dk binaries
RUN ln -s /z88dk/bin/* /usr/local/bin

# Command to run when container starts
CMD ["/bin/bash"]