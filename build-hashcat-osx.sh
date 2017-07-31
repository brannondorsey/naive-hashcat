#!/bin/bash

# clone the hashcat source
git clone https://github.com/hashcat/hashcat.git hashcat-src

# clone the OpenCL headers
mkdir -p hashcat-src/deps
git clone https://github.com/KhronosGroup/OpenCL-Headers.git hashcat-src/deps/OpenCL

# build
cd hashcat-src
make
