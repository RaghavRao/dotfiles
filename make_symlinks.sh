#!/bin/bash
ln -s ".bash_aliases" "$HOME/.bash_aliases"
ln -s ".bash_functions" "$HOME/.bash_functions"
ln -s "$.bash_ps1" "$HOME/.bash_ps1"
ln -s "$.bashrc" "$HOME/.bashrc"
ln -s "$.bash_snippets" "$HOME/.bash_snippets"
ln -s "$.inputrc" "$HOME/.inputrc"
ln -s "$.pythonrc" "$HOME/.pythonrc"
echo "binding new .inputrc to current session..."
bind -f "$HOME/.inputrc"

