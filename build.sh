#!/bin/bash
set -e
rm -rf app
mkdir app
tar -xzf wilderness-to-metropolis-fog-expedition-fix.tar.gz -C app
if [ -d app/.git ]; then rm -rf app/.git; fi
cd app
bun install
bun run build
cd ..
rm -rf .next public
cp -r app/.next .next
if [ -d app/public ]; then cp -r app/public public; fi
