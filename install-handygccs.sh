#!/bin/bash
set -e
cd /tmp
git clone https://github.com/ShadowBlip/HandyGCCS
cd HandyGCCS
make install
systemctl enable handygccs
