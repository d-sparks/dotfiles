# Playground

## Intro

Playground is the equivalent of play.golang.org but within Sublime.

## Basic Usage

In the Sublime fuzzy-search command pallet, you should find commands that start with "Playground" and end with the name of a language. Executing these should bring up a template file (blank in the case of Python). If all goes well, you can type some code in and hit `cmd + shift + r` to run it.

## Setup

### Node Modules

If you want to be able to use async, underscore, or other Node modules, go into `Playground/Templates/Coffee-data` and modify package.json and do an npm install. If you look in `Playground/Templates/Coffee` you'll see a symlink to `Playground/Templates/Coffee-data/node_modules` which gets copied into a temp directory whenever you play.

### Other Languages

Look in `Default (OSX).sublime-commands`, `Playground (OSX).sublime-settings` and the folder `Playground/Templates` to see how to add languages.
