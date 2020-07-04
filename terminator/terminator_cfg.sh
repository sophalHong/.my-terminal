#!/bin/bash
if ! [ -x "$(command -v terminator)" ]; then
    echo "Installing terminator..." >&2
    sudo apt update;
    sudo apt install -y terminator;
fi

# Backup
DIR=~/.config/terminator
CFG=$DIR/config
! [ -d $DIR ] && mkdir -p $DIR
[ -f $CFG ] && mv $CFG ${CFG}`date +%y%m%d_%H%M`

cat > $CFG << EOF
[global_config]
  enabled_plugins = LaunchpadCodeURLHandler, APTURLHandler, LaunchpadBugURLHandler
  suppress_multiple_term_dialog = True
  title_hide_sizetext = True
[keybindings]
  close_term = <Alt>w
  close_window = <Alt>F4
  full_screen = <Primary><Alt>f
  go_down = <Alt>k
  go_left = <Alt>j
  go_next = <Alt>period
  go_prev = <Alt>comma
  go_right = <Alt>l
  go_up = <Alt>i
  layout_launcher = None
  move_tab_left = <Primary><Shift>j
  move_tab_right = <Primary><Shift>l
  new_window = None
  next_profile = <Primary><Shift>space
  next_tab = <Primary>Tab
  page_down = <Primary>Page_Down
  page_down_half = <Shift>Page_Down
  page_up = <Primary>Page_Up
  page_up_half = <Shift>Page_Up
  prev_tab = None
  previous_profile = <Primary>space
  resize_down = <Shift><Alt>k
  resize_left = <Shift><Alt>j
  resize_right = <Shift><Alt>l
  resize_up = <Shift><Alt>i
  rotate_ccw = <Alt>r
  rotate_cw = <Primary><Shift>r
  split_horiz = <Alt>h
  split_vert = <Alt>semicolon
  switch_to_tab_1 = <Alt>1
  switch_to_tab_10 = None
  switch_to_tab_2 = <Alt>2
  switch_to_tab_3 = <Alt>3
  switch_to_tab_4 = <Alt>4
  switch_to_tab_5 = <Alt>5
  switch_to_tab_6 = <Alt>6
  switch_to_tab_7 = <Alt>7
  switch_to_tab_8 = <Alt>8
  switch_to_tab_9 = <Alt>9
  zoom_in = <Primary>equal
  zoom_normal = <Primary>0
  zoom_out = <Primary>minus
[layouts]
  [[default]]
    [[[child1]]]
      parent = window0
      profile = default
      type = Terminal
    [[[window0]]]
      parent = ""
      type = Window
[plugins]
[profiles]
  [[default]]
    cursor_color = "#cacaca"
    foreground_color = "#ffffff"
  [[Ambience]]
    background_color = "#300a24"
    foreground_color = "#ffffff"
  [[Black on l.yellow]]
    background_color = "#ffffdd"
    foreground_color = "#000000"
  [[Grey on black]]
  [[Solarized dark]]
    background_color = "#002b36"
    foreground_color = "#839496"
  [[White on black]]

EOF

echo "[DONE] Update config '$CFG'"
