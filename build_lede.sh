#!/bin/bash

# Navigate into LEDE directory and execute subsequent commands
cd lede && \

# Update LEDE repository
git pull && \

# Update and install feeds
./scripts/feeds update -a && \
./scripts/feeds install -a && \

# Generate .config file non-interactively
make defconfig && \

# Copy your custom .config file
# wget https://raw.githubusercontent.com/niceluckyday/bianyi/main/.config -O .config && \

# Start compilation
make download -j$(nproc) && \
make V=s -j$(nproc)
