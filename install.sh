#!/bin/bash

# OSX PREFERENCES
# ---------------
# System Preferences > Desktop / Screensaver > Screensaver > Hot corners
# Auto hide dock (Apple menu)
# System Preferences > Mission Control > Show dashboard as space

# SOFTWARE
# --------
# Chrome
# 	- Vimium
# 	- Chuck Anderson theme

# 1Password
# 	- Keychain in personal Dropbox
# 	- Install the Chrome plugin (disable auto submit)

# Sublime Text 2
# 	- Enter license
# 	- Copy in Packages

# iTerm 2
# 	- Molokai theme
# 	- Infinite scrolback
# 	- No window headers

# SEIL
# 	- Bind CAPSLOCK to escape

# Karabiner
# 	- Load private.xml
# 	- Key repeat rate 43ms

# Total spaces ($18)
# 	- 2x2 grid
# 	- Super + vim arrows to change
# 	- Super + option + vim arrows to carry window

# Irradiated Software 'Size up' ($13)
# 	- Control + alt + arrows to half maximize
# 	- Control + alt + m to maximize
# 	- Control + alt + escape to restore
# 	- Control + shit + alt + arrows to quarter maximize

# Quicksilver (try Alfred)
# 	- Bind to Super + Space

# Dropbox
# 	- Personal account (dans595@gmail)
# 	- Clever account (dan.sparks@clever.com)

# CloudApp
# 	- May need new account / recover


defaults write -g ApplePressAndHoldEnabled -bool false

copy -r * ~/
