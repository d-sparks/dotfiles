import json
import os
import shutil
import sublime, sublime_plugin

"""
  To do:
  ------
  - Start at top of file
  - Open by pressing enter
  - Open options:
    * Open in same view
    * Open in new view
    * Open in new window
    * Copy path to clipboard
    * More options?

"""

# State for the Explore plugin:

code_home = "/Users/sparks/dev"
projects_path = "/Users/sparks/code/sublime-projects"
sublime_session_file = "/Users/sparks/Library/Application Support/Sublime Text 2/Settings/Session.sublime_session"

def get_folder_name(path):
  if path == None: return None
  if os.path.isdir(path): return path
  n = path.rfind("/")
  if n == -1: return "/Users/sparks/dev"
  return get_folder_name(path[0:n])

def type_of_file(path_to_file):
  # Determines if a file is a directory, executable, dotfile, symbolic
  # link or none of the above.
  if os.path.isdir(path_to_file): return "dir"
  if os.access(path_to_file, os.X_OK): return "executable"
  if os.path.isfile(path_to_file): return "file"
  return "none"

def clean_up_path(path):
  for file_type in ["dir", "executable", "file"]:
    if path.endswith(file_type):
      path = path[:-len(file_type)]
      break
  return os.path.normpath(path.strip())

def horizontal_rule(view, edit, pos, width):
  # Print a horizontal rule out of equals signs. Width must be >= 2.
  view.insert(edit, pos, "\" ")
  for i in range(2, width):
    view.insert(edit, pos+i, "=")
  view.insert(edit, pos + width, "\n")

def print_header(view, edit, width):
  horizontal_rule(view, edit, 0, width)
  view.insert(edit, 0, "\"  {0}\n".format(view.path))
  horizontal_rule(view, edit, 0, width)

class gotoDotdotCommand(sublime_plugin.TextCommand):
  def run(self, edit):
    selection = self.view.sel()
    selection.clear()
    selection.add(sublime.Region(self.view.text_point(4, 0)))
    # self.view.path = path

class exploreCommand(sublime_plugin.TextCommand):
  # The main :Explore command; creates a new exploration window at the
  # current path.
  def run(self, edit, path=None):
    new_view = self.view.window().new_file()
    new_view.insert(edit, 0, "\n")
    new_view.run_command("ls", {"path": path or get_folder_name(self.view.file_name())})
    new_view.set_read_only(True)
    new_view.set_scratch(True)

class lsCommand(sublime_plugin.TextCommand):
  def run(self, edit, path):
    if not path: path = code_home
    self.view.set_read_only(False)
    self.view.path = os.path.normpath(path)
    self.view.erase(edit, sublime.Region(0, self.view.size()-1))
    self.view.set_syntax_file("Packages/Explore/Explore.tmLanguage")

    print_header(self.view, edit, 76)
    listings = os.listdir(self.view.path)
    col_width = max([len(listing) for listing in listings]) + 2
    self.view.insert(edit, self.view.size(), "{0:{1}}dir\n".format("../", col_width))
    for listing in listings:
      listing_type = type_of_file("{0}/{1}".format(path, listing))
      self.view.insert(edit, self.view.size(), "{0:{1}}{2}\n".format(listing, col_width, listing_type))
    self.view.set_read_only(True)
    self.view.run_command('goto_dotdot')

def get_listings(view):
  listing = view.substr(view.word(view.line(view.sel()[0]))).strip()
  return os.path.normpath("{0}/{1}".format(view.path, clean_up_path(listing)))

class openSingleCommand(sublime_plugin.TextCommand):
  def run(self, edit, to_view="current_view"):
    new_path = get_listings(self.view)
    listing_type = type_of_file(new_path)
    if listing_type == "dir":
      self.view.path = new_path
      self.view.run_command("ls", {"path": new_path})
    elif listing_type in ["file", "executable"]:
      self.view.set_read_only(False)
      self.view.window().open_file(new_path)

def tabular_json_encode(d): return json.dumps(d, sort_keys=True, indent=4).replace("    ", "\t")

class newProjectFromFolderCommand(sublime_plugin.TextCommand):
  def run(self, edit):
    self.writing_to=get_listings(self.view)
    self.view.window().show_input_panel('', '', self.on_done, None, None)

  def on_done(self, project_name):
    project_file = "{0}/{1}.sublime-project".format(projects_path, project_name)
    open(project_file, "w").write(tabular_json_encode({"folders" : [ {"path": self.writing_to }]}))
    # session_dict = json.loads(open(sublime_session_file, "r").read())
    # session_dict['workspaces']['recent_workspaces'].insert(0, project_file)
    # shutil.move(sublime_session_file, sublime_session_file + "_back")
    # open(sublime_session_file, "w").write(tabular_json_encode(session_dict))

