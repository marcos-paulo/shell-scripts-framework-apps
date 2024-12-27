#!/bin/bash

debug="false"

# -----------------------------------------------------------------------------
# Modo de Carregamento do autocomplite
# -----------------------------------------------------------------------------
# $1 é obrigatória e é o caminho completo de onde de estao armazenados os scripts.
# deve ser passado como parametro de source

# source "/home/.../install-autocomplite.sh" "/home/.../bin"
# $1 = caminho completo de onde estao armazenados os scripts

# log="/home/marcos/desenv/projects-shell-script/scripts-bb/autocompletions/log.txt"
# echo >$log

BIN_SCRIPTS="$1"

# ------------------------------------------------------------------------------------------------------
# Carrega dinamicamente todos os scripts de autocomplite presentes nos diretorios da variavel PATH
# ------------------------------------------------------------------------------------------------------
IFS=$'\n'
list_script_files=("$BIN_SCRIPTS/"*)

if [ ${#list_script_files[@]} -gt 0 ]; then
  for script_file in "${list_script_files[@]}"; do
    if [ -f "$script_file" ]; then
      completions=$(cat $script_file | grep -E "^completions.*=")
      completions_source=$(cat $script_file | grep -E '^source "\$\(readlink -f \$\(dirname \$\(readlink -f \$0\)\).*autocompletions.*.sh\)"')
      if [ -n "$completions" -a -n "$completions_source" ]; then
        source <($script_file autocomplite)
      elif [ "$debug" = "true" ]; then
        echo "O script $script_file não possui a variavel completions ou source autocompletions.sh"
      fi
    fi
  done
fi
