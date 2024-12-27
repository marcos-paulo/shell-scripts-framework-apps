#!/bin/bash
# AUTHOR: Marcos Paulo de Almeida Lima

_autocomplite() {
  script=$(basename $1)
  script_completion='_my_'"$(basename $script .sh)"'_completion'

  local completions_envs=""
  for ((i = 1; i <= ${#completions[@]}; i++)); do
    # local varname="completions_${i}"
    # completions_envs+="local options_${i}=(${!varname});"
    completions_envs+="local options_${i}=(${completions[$i]});"
  done

  echo '#!/bin/bash
function '"$script_completion"'() {
  '"$completions_envs"'
  COMPREPLY=()

  local varname="options_${COMP_CWORD}"
  eval "local completion=(\${$varname[@]})"
  word="${COMP_WORDS[COMP_CWORD]}"

  # Faça a correspondência com as opções disponíveis
  COMPREPLY=($(compgen -W "${completion[*]}" -- "$word"))

  return 0
}

# Registre a função de conclusão para o script
complete -F '"$script_completion"' '"$script"'
'
  unset script
  unset script_completion
}

if [ "$1" = "autocomplite" ]; then
  _autocomplite $0
  exit 0
fi
