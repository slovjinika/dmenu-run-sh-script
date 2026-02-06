#!/usr/bin/env bash
# ~/.local/bin/run-hello-build.sh
TERMINAL_CMD="${TERMINAL_CMD:-xterm -e}"
RUN_IN_TERMINAL=1
TARGET_FULL_PATH="/root/.local/bin/build-scripts/hello-build.sh"
if [ ! -f "$TARGET_FULL_PATH" ]; then
    notify-send "Error" "Run Script" "Файл не найден: $TARGET_FULL_PATH"
    exit 1
fi

chmod +x "$TARGET_FULL_PATH" 2>/dev/null

if [ "$RUN_IN_TERMINAL" = "1" ]; then
    $TERMINAL_CMD bash -lc "printf 'Running: %s\n\n' \"$TARGET_FULL_PATH\"; \"$TARGET_FULL_PATH\"; echo; read -p 'Press ENTER to close...'"
else
    setsid "$TARGET_FULL_PATH" >/dev/null 2>&1 &
fi

exit 0
