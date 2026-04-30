#!/usr/bin/env bash
set -euo pipefail

cur_ws="$(hyprctl activeworkspace -j | jq -r '.id | tonumber? // 1')"

if (( cur_ws >= 1 && cur_ws <= 11 )); then
  target=$(( cur_ws + 200 ))
elif (( (cur_ws >= 101 && cur_ws <= 111) || (cur_ws >= 201 && cur_ws <= 211) )); then
  target=$(( cur_ws - 100 ))
else
  exit 0
fi

hyprctl keyword animation "workspaces, 1, 4, easeOutQuint, fade"
hyprctl dispatch movetoworkspace "$target"
