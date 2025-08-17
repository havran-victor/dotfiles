#!/usr/bin/env bash
set -euo pipefail

MIN_WS=1
MAX_WS=11
cur_ws="$(hyprctl activeworkspace -j | jq -r '.id | tonumber? // 1')"

if (( cur_ws <= MIN_WS )); then
  prev_ws=$MAX_WS
else
  prev_ws=$((cur_ws - 1))
fi

hyprctl dispatch workspace "$prev_ws"

