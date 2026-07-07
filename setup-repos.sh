#!/bin/bash
set -e

# RPM Fusion Free
curl -o /etc/yum.repos.d/rpmfusion-free.repo https://download1.rpmfusion.org/free/fedora/rpmfusion-free.repo
# RPM Fusion Nonfree
curl -o /etc/yum.repos.d/rpmfusion-nonfree.repo https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree.repo
# CachyOS kernel Copr
curl -o /etc/yum.repos.d/bieszczaders-kernel-cachyos.repo https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/repo/fedora-44/bieszczaders-kernel-cachyos-fedora-44.repo
