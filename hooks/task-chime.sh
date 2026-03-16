#!/bin/bash
# task-chime.sh — Stop hook
# Plays a subtle chime when Claude finishes responding.
# Cross-platform: macOS (afplay), Linux (paplay/aplay), Windows (PowerShell).
#
# Config:  NOX_CHIME_SOUND — sound file path (default: system Tink on macOS)
#          NOX_SKIP_CHIME=1 to disable
#          NOX_SKIP_ALL=1 also disables
# Install: Add to Stop hook in settings.json

[[ "${NOX_SKIP_ALL:-0}" == "1" ]] && exit 0
[[ "${NOX_SKIP_CHIME:-0}" == "1" ]] && exit 0

# Default sounds per platform
if [[ "$(uname)" == "Darwin" ]]; then
    SOUND="${NOX_CHIME_SOUND:-/System/Library/Sounds/Tink.aiff}"
    afplay "$SOUND" &>/dev/null &
elif [[ -f /data/data/com.termux ]]; then
    # Termux — use termux-notification sound
    termux-notification --sound --title "Claude" --content "Done" &>/dev/null &
elif command -v paplay &>/dev/null; then
    # Linux (PulseAudio)
    SOUND="${NOX_CHIME_SOUND:-/usr/share/sounds/freedesktop/stereo/complete.oga}"
    [ -f "$SOUND" ] && paplay "$SOUND" &>/dev/null &
elif command -v aplay &>/dev/null; then
    # Linux (ALSA)
    SOUND="${NOX_CHIME_SOUND:-/usr/share/sounds/freedesktop/stereo/complete.oga}"
    [ -f "$SOUND" ] && aplay "$SOUND" &>/dev/null &
elif command -v powershell.exe &>/dev/null; then
    # Windows (Git Bash / WSL)
    powershell.exe -NoProfile -Command "[Console]::Beep(800,150)" &>/dev/null &
fi

exit 0
