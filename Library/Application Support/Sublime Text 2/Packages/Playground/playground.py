import shutil
import datetime
import os
import subprocess

import sublime_plugin
from sublime import load_settings

def link_safe_copy(src, dst):
  # Copies a file from src to dst, smartly enough to chain symlinks.
  os.symlink(os.readlink(src), dst) if os.path.islink(src) else shutil.copy(src,dst)

# These return `lang` and `1234` from `/tmp/asdf-1234/file.lang` respectively.
def extract_language(filename):
  basename = os.path.basename(filename)
  return basename[basename.index(".")+1:].lower()
def extract_timestamp(filename): return filename.split("/")[2].split("-")[1]

class playgroundListener(sublime_plugin.EventListener):
  def on_load(self, view):
    if "tmp" not in view.file_name(): return
    language = extract_language(view.file_name())
    coordinates = load_settings("Playground (OSX).sublime-settings").get("languages")[language]["start_point"]
    view.run_command("goto_line", {"line": coordinates[0]})
    for i in range(0, coordinates[1]):
      view.run_command("move", {'by': 'characters', 'extend': False, 'forward': True})
    view.run_command("enter_insert_mode")

class playgroundCommand(sublime_plugin.TextCommand):
  # Starts a playground
  def run(self, edit, language, insertion="asdf"):
    settings = load_settings("Playground (OSX).sublime-settings")
    language_settings = settings.get("languages")[language]
    timestamp = datetime.datetime.now().strftime("%s")

    # Copy data into a temporary directory
    template_dir = os.path.join(settings.get("sublime_dir"), "Packages/Playground/Templates", language_settings["name"])
    temporary_dir = "/tmp/{0}-{1}".format(language, timestamp)
    os.mkdir(temporary_dir)
    for temp_file in os.listdir(template_dir):
      print os.path.join(template_dir, temp_file), os.path.join(temporary_dir, temp_file)
      shutil.copy(os.path.join(template_dir, temp_file), os.path.join(temporary_dir, temp_file))
    try:
      for temp_file in os.listdir(template_dir + "-sym"):
        os.symlink(os.path.join(template_dir + "-sym", temp_file), os.path.join(temporary_dir, temp_file))
    except: pass

    # Make the playground view
    new_view = self.view.window().open_file(os.path.join(temporary_dir, language_settings["scratch"]))

    # If possible, move this to group 2 (right pane)
    try: new_view.window().run_command("move_to_group", { "group": 1 })
    except: pass

class playRunCommand(sublime_plugin.TextCommand):
  # Runs the code in the current playground
  def run(self, edit):
    if "tmp" not in self.view.file_name(): return
    settings = load_settings("Playground (OSX).sublime-settings")
    language = extract_language(self.view.file_name())
    language_settings = settings.get("languages")[language]

    self.view.run_command("save")
    filename = self.view.file_name()
    cmd = language_settings["compile"] + [filename]

    # Run the command, make a view for output if it doesn't exist
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, cwd=os.path.dirname(filename))
    output = process.communicate()[0]
    try:
      new_view = self.view.playtarget
    except:
      new_view = self.view.playtarget = self.view.window().new_file()
      try:
        # If possible, move output to group 1 (left pane) and refocus on group 2 (right pane)
        new_view.window().run_command("move_to_group", { "group": 0 })
        new_view.window().run_command("focus_group", { "group": 1 })
      except:
        pass
      new_view.set_scratch(True)
    new_view.insert(edit, new_view.size(), output)
    new_view.insert(edit, new_view.size(), '\n\n----------------\n\n')
