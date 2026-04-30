#!/usr/bin/env bash
# Custom Waybar workspaces module.
# Derives the active group (1-11) from any sub-workspace ID so the correct
# icon stays highlighted when navigating to sub-workspaces (N+100 / N+200).

declare -A ICONS=(
  [1]=$'\U000f08c7'
  [2]=$'\ue795'
  [3]=$'\uf268'
  [4]=$'\U000f1781'
  [5]=$'\ue8da'
  [6]=$'\U000f06a9'
  [7]=$'\U000f01ee'
  [8]=$'\U000f05a3'
  [9]=$'\uf16a'
  [10]=$'\uf07b'
  [11]=$'\uf1ff'
)

get_group() {
  local id=$1
  if   (( id >= 201 && id <= 211 )); then echo $(( id - 200 ))
  elif (( id >= 101 && id <= 111 )); then echo $(( id - 100 ))
  elif (( id >= 1   && id <= 11  )); then echo "$id"
  else echo 1
  fi
}

emit() {
  local ws group i text=""
  ws=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // 1')
  group=$(get_group "$ws")
  for i in $(seq 1 11); do
    if [[ $i -eq $group ]]; then
      text+="<span alpha='100%'>${ICONS[$i]}</span>"
    else
      text+="<span alpha='50%'>${ICONS[$i]}</span>"
    fi
    [[ $i -lt 11 ]] && text+="  "
  done
  printf '{"text":"%s"}\n' "$text"
}

emit

SOCKET="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
socat -u "UNIX-CONNECT:${SOCKET}" - 2>/dev/null | \
  while IFS= read -r event; do
    [[ "${event%%>>*}" == "workspace" ]] && emit
  done
