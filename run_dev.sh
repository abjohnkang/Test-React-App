#!/usr/bin/env bash
set -e

# Run from script directory (project root)
cd "$(dirname "$0")"

# Install dependencies if node_modules is missing or incomplete
if [[ ! -d node_modules/vite ]]; then
  echo "Installing dependencies..."
  npm install
fi

# Vite default dev port
DEV_PORT="${DEV_PORT:-5173}"

# Terminate server if already running on dev port
pids=$(lsof -ti :"$DEV_PORT" 2>/dev/null) || true
if [[ -n "$pids" ]]; then
  echo "Stopping existing server on port $DEV_PORT (PIDs: $pids)"
  for pid in $pids; do
    kill "$pid" 2>/dev/null || kill -9 "$pid" 2>/dev/null || true
  done
  sleep 1
fi

# Run server in dev environment (npx uses local node_modules/.bin)
export NODE_ENV=development
[[ -n "${DEBUG:-}" ]] && set -x
npx vite
