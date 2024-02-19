#!/bin/bash

# Navigate into LEDE directory and execute subsequent commands
cd lede && \

# Generate .config file non-interactively
make defconfig && \

# Copy your custom .config file
wget https://raw.githubusercontent.com/niceluckyday/bianyi/main/.config -O .config && \

# Start compilation
make download -j$(nproc) && \
make V=s -j$(nproc)
