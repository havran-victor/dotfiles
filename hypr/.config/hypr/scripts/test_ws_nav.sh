#!/usr/bin/env bash
# Workspace navigation test harness.
# Runs each script with a fake hyprctl binary to verify dispatch targets.
# ID scheme: main=N(1-11), sub-up=N+100(101-111), sub-down=N+200(201-211)

PASS=0; FAIL=0
SCRIPT_DIR="$HOME/.config/hypr/scripts"
MOCK_DIR=$(mktemp -d)
trap 'rm -rf "$MOCK_DIR"' EXIT

run_script() {
  local script=$1 mock_ws=$2
  cat > "$MOCK_DIR/hyprctl" <<EOF
#!/usr/bin/env bash
case "\${1:-}" in
  activeworkspace) echo '{"id": $mock_ws}' ;;
  dispatch) echo "\${3:-}" ;;
esac
EOF
  chmod +x "$MOCK_DIR/hyprctl"
  PATH="$MOCK_DIR:$PATH" bash "$script" 2>/dev/null
}

assert_eq() {
  local label=$1 actual=$2 expected=$3
  if [[ "$actual" == "$expected" ]]; then
    echo "PASS: $label"
    PASS=$(( PASS + 1 ))
  else
    echo "FAIL: $label — expected='$expected' got='$actual'"
    FAIL=$(( FAIL + 1 ))
  fi
}

S="$SCRIPT_DIR"

# ws_nav_up.sh: sub-down→main, main→sub-up, sub-up→sub-down (wrap)
assert_eq "nav_up: main 1 → 101"            "$(run_script "$S/ws_nav_up.sh" 1)"   "101"
assert_eq "nav_up: main 3 → 103"            "$(run_script "$S/ws_nav_up.sh" 3)"   "103"
assert_eq "nav_up: main 11 → 111"           "$(run_script "$S/ws_nav_up.sh" 11)"  "111"
assert_eq "nav_up: sub-up 101 → 201 (wrap)" "$(run_script "$S/ws_nav_up.sh" 101)" "201"
assert_eq "nav_up: sub-up 103 → 203 (wrap)" "$(run_script "$S/ws_nav_up.sh" 103)" "203"
assert_eq "nav_up: sub-down 201 → 1"        "$(run_script "$S/ws_nav_up.sh" 201)" "1"
assert_eq "nav_up: sub-down 203 → 3"        "$(run_script "$S/ws_nav_up.sh" 203)" "3"
assert_eq "nav_up: sub-down 211 → 11"       "$(run_script "$S/ws_nav_up.sh" 211)" "11"

# ws_nav_down.sh: main→sub-down, sub-up/sub-down→-100
assert_eq "nav_down: main 1 → 201"              "$(run_script "$S/ws_nav_down.sh" 1)"   "201"
assert_eq "nav_down: main 3 → 203"              "$(run_script "$S/ws_nav_down.sh" 3)"   "203"
assert_eq "nav_down: main 11 → 211"             "$(run_script "$S/ws_nav_down.sh" 11)"  "211"
assert_eq "nav_down: sub-down 201 → 101 (wrap)" "$(run_script "$S/ws_nav_down.sh" 201)" "101"
assert_eq "nav_down: sub-down 203 → 103 (wrap)" "$(run_script "$S/ws_nav_down.sh" 203)" "103"
assert_eq "nav_down: sub-up 101 → 1"            "$(run_script "$S/ws_nav_down.sh" 101)" "1"
assert_eq "nav_down: sub-up 103 → 3"            "$(run_script "$S/ws_nav_down.sh" 103)" "3"
assert_eq "nav_down: sub-up 111 → 11"           "$(run_script "$S/ws_nav_down.sh" 111)" "11"

# ws_move_window_up.sh: same cycle as nav_up but movetoworkspace
assert_eq "move_up: main 3 → 103"            "$(run_script "$S/ws_move_window_up.sh" 3)"   "103"
assert_eq "move_up: sub-up 103 → 203 (wrap)" "$(run_script "$S/ws_move_window_up.sh" 103)" "203"
assert_eq "move_up: sub-down 203 → 3"        "$(run_script "$S/ws_move_window_up.sh" 203)" "3"

# ws_move_window_down.sh: same cycle as nav_down but movetoworkspace
assert_eq "move_down: main 3 → 203"              "$(run_script "$S/ws_move_window_down.sh" 3)"   "203"
assert_eq "move_down: sub-down 203 → 103 (wrap)" "$(run_script "$S/ws_move_window_down.sh" 203)" "103"
assert_eq "move_down: sub-up 103 → 3"            "$(run_script "$S/ws_move_window_down.sh" 103)" "3"

# move_to_next_ws.sh: always jump to next group main (1-11)
assert_eq "next_ws: main 1 → 2"       "$(run_script "$S/move_to_next_ws.sh" 1)"   "2"
assert_eq "next_ws: main 3 → 4"       "$(run_script "$S/move_to_next_ws.sh" 3)"   "4"
assert_eq "next_ws: main 11 → 1"      "$(run_script "$S/move_to_next_ws.sh" 11)"  "1"
assert_eq "next_ws: sub-up 103 → 4"   "$(run_script "$S/move_to_next_ws.sh" 103)" "4"
assert_eq "next_ws: sub-down 203 → 4" "$(run_script "$S/move_to_next_ws.sh" 203)" "4"
assert_eq "next_ws: sub-up 111 → 1"   "$(run_script "$S/move_to_next_ws.sh" 111)" "1"

# move_to_prev_ws.sh: always jump to prev group main (1-11)
assert_eq "prev_ws: main 3 → 2"       "$(run_script "$S/move_to_prev_ws.sh" 3)"   "2"
assert_eq "prev_ws: main 1 → 11"      "$(run_script "$S/move_to_prev_ws.sh" 1)"   "11"
assert_eq "prev_ws: sub-up 103 → 2"   "$(run_script "$S/move_to_prev_ws.sh" 103)" "2"
assert_eq "prev_ws: sub-down 203 → 2" "$(run_script "$S/move_to_prev_ws.sh" 203)" "2"
assert_eq "prev_ws: sub-up 101 → 11"  "$(run_script "$S/move_to_prev_ws.sh" 101)" "11"

# move_window_to_next_ws.sh
assert_eq "move_next: main 3 → 4"       "$(run_script "$S/move_window_to_next_ws.sh" 3)"   "4"
assert_eq "move_next: sub-up 103 → 4"   "$(run_script "$S/move_window_to_next_ws.sh" 103)" "4"
assert_eq "move_next: main 11 → 1"      "$(run_script "$S/move_window_to_next_ws.sh" 11)"  "1"

# move_window_to_prev_ws.sh
assert_eq "move_prev: main 3 → 2"       "$(run_script "$S/move_window_to_prev_ws.sh" 3)"   "2"
assert_eq "move_prev: sub-down 203 → 2" "$(run_script "$S/move_window_to_prev_ws.sh" 203)" "2"
assert_eq "move_prev: main 1 → 11"      "$(run_script "$S/move_window_to_prev_ws.sh" 1)"   "11"

echo ""
echo "Results: $PASS passed, $FAIL failed"
[[ $FAIL -eq 0 ]]
