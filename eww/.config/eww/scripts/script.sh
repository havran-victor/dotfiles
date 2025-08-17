# ~/.config/eww/start-eww.sh
#!/usr/bin/env bash
# kill old instances (optional, handy after crashes)
pkill -x eww 2>/dev/null

# start daemon and open your windows
eww daemon
# small wait so the daemon is ready
sleep 0.2

# open your widgets/windows by name
eww open ex        # your "HELLO WORLD" bar
# eww open bar     # add others as needed
