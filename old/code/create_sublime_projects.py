#!/usr/bin/env python
import json
import os
import shutil

"""

  For each subfolder of 'code_home', this script will create a Sublime
  project file and store it in 'projects_path'. These will be added to
  your recent workspaces list in your 'sublime_session_file'. The script
  will make a backup copy of your 'sublime_session_file' in case you
  want to undo this later.

"""

code_home = "/Users/sparks/dev"
projects_path = "/Users/sparks/code/sublime-projects-3"
sublime_session_file = "/Users/sparks/Library/Application Support/Sublime Text 3/Local/Session.sublime_session"

def tabular_json_encode(d): return json.dumps(d, sort_keys=True, indent=4).replace("    ", "\t")
def repo_location(x): return "{path}/{repo}".format(path=code_home, repo=x)
def project_location(x): return "{path}/{project}.sublime-project".format(path=projects_path, project=x)

project_names = os.listdir(code_home)
project_dict = {project_location(project): repo_location(project) for project in project_names}
project_files = map(project_location, project_names)

# create the project files
for project, repo in project_dict.iteritems():
  open(project, "w").write(tabular_json_encode({"folders": [ {"path": repo } ] }))

# update the session file, backup the old one, and write the new one
session_dict = json.loads(open(sublime_session_file, "r").read())
session_dict['workspaces']['recent_workspaces'] += project_files
shutil.move(sublime_session_file, sublime_session_file + "_back")
open(sublime_session_file, "w").write(tabular_json_encode(session_dict))
