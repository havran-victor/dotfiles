#!/usr/bin/env bash
set -euo pipefail

# requires: hyprctl, jq
MIN_WS=1
MAX_WS=11

# Get current workspace id (fallback to 1 if parsing fails)
cur_ws="$(hyprctl activeworkspace -j | jq -r '.id | tonumber? // 1')"

# Compute next workspace with wrap-around
if (( cur_ws < MIN_WS || cur_ws >= MAX_WS )); then
  next_ws=$MIN_WS
else
  next_ws=$((cur_ws + 1))
fi

# Switch to the computed workspace
hyprctl dispatch workspace "$next_ws"

