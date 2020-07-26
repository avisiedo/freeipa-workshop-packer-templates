#!/bin/bash -eux
# Installing build tools here because Fedora 22+ will not do so during kickstart
dnf install -y kernel-headers kernel-devel-$(uname -r) elfutils-libelf-devel gcc make perl

