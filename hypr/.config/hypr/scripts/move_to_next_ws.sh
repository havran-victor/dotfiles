#!/usr/bin/env bash
set -euo pipefail

MIN_WS=1
MAX_WS=11

cur_ws="$(hyprctl activeworkspace -j | jq -r '.id | tonumber? // 1')"

if (( cur_ws >= 201 && cur_ws <= 211 )); then
  group=$(( cur_ws - 200 ))
elif (( cur_ws >= 101 && cur_ws <= 111 )); then
  group=$(( cur_ws - 100 ))
elif (( cur_ws >= 1 && cur_ws <= 11 )); then
  group=$cur_ws
else
  group=$MIN_WS
fi

if (( group >= MAX_WS )); then
  next_ws=$MIN_WS
else
  next_ws=$(( group + 1 ))
fi

hyprctl keyword animation "workspaces, 1, 4, easeOutQuint, slide"
hyprctl dispatch workspace "$next_ws"
