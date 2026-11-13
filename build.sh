#!/bin/bash
set -euo pipefail

rm -rf app
mkdir app
tar -xzf wilderness-to-metropolis-fog-expedition-fix.tar.gz -C app

if [ -d app/.git ]; then rm -rf app/.git; fi

# The archived app carries an older lockfile/Next version that is incompatible
# with Vercel's current Next adapter. Re-resolve the declared dependency set.
rm -f app/bun.lock

node <<'NODE'
const fs = require("fs");
const p = "app/package.json";
const pkg = JSON.parse(fs.readFileSync(p, "utf8"));
pkg.dependencies ??= {};
pkg.devDependencies ??= {};
pkg.dependencies.next = "16.4.6";
pkg.devDependencies["eslint-config-next"] = "16.4.6";
pkg.scripts ??= {};
pkg.scripts.build = "next build";
fs.writeFileSync(p, JSON.stringify(pkg, null, 2) + "\n");
NODE

cd app
bun install
bun run build
cd ..

rm -rf .next public
cp -r app/.next .next
if [ -d app/public ]; then cp -r app/public public; fi
