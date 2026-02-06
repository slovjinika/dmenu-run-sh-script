# ~/.local/bin/openbox-build.sh
# Displays a list of scripts via dmenu and runs the selected one.

# Settings:
SCRIPTS_DIR="${SCRIPTS_DIR:-$HOME/.local/bin/build-scripts}"
RUN_IN_TERMINAL="${RUN_IN_TERMINAL:-1}"    # 1 = run inside terminal, 0 = run in background
TERMINAL_CMD="${TERMINAL_CMD:-xterm -e}"   # e.g., "kitty -e", "alacritty -e", etc.

# Dependencies check
command -v dmenu >/dev/null 2>&1 || { notify-send "openbox-build" "Error: dmenu not found"; exit 1; }

# Collect scripts: executable files or *.sh files
# Sorted by modification time (%T@), newest first (sort -rn)
mapfile -t scripts < <(find "$SCRIPTS_DIR" -maxdepth 1 -type f \( -perm -111 -o -name '*.sh' \) -printf "%T@ %f\n" | sort -rn | cut -d' ' -f2-)

if [ ${#scripts[@]} -eq 0 ]; then
  notify-send "openbox-build" "No scripts found in $SCRIPTS_DIR"
  exit 0
fi

# Show menu
choice=$(printf '%s\n' "${scripts[@]}" | dmenu -i -p "Run build:")

# Exit if user cancelled
[ -z "$choice" ] && exit 0

script_path="$SCRIPTS_DIR/$choice"

# Ensure the file is executable
[ ! -x "$script_path" ] && chmod +x "$script_path" 2>/dev/null

if [ "$RUN_IN_TERMINAL" = "1" ]; then
  # Run in terminal to see output. Window stays open until ENTER is pressed.
  $TERMINAL_CMD bash -lc "printf 'Running: %s\n\n' \"${script_path}\"; \"${script_path}\"; echo; read -p 'Process finished. Press ENTER to close...'"
else
  # Run in background: detached, stdout/stderr redirected to /dev/null
  setsid "$script_path" >/dev/null 2>&1 &
fi

exit 0
