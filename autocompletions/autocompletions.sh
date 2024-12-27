#!/bin/bash
# AUTHOR: Marcos Paulo de Almeida Lima

# ADICIONE ESTE BLOCO DE CODIGO AO SCRIPT QUE DESEJA AUTO COMPLITE

# # bloco autocomplite
# # implemente a variavel completions contendo um array de palavras para autocompletar
# completions='"p1" "p2" "p3"'
# source "$(readlink -f $(dirname $(readlink -f $0))/../autocompletions/autocompletions.sh)"
# # bloco autocomplite

# FIM DO BLOCO

_autocomplite() {
  script=$(basename $1)
  script_completion='_my_'"$(basename $script .sh)"'_completion'

  echo '
'"$script_completion"'() {
  local completions=('"$completions"')

  COMPREPLY=()
  word="${COMP_WORDS[COMP_CWORD]}"

  # Faça a correspondência com as opções disponíveis
  COMPREPLY=($(compgen -W "${completions[*]}" -- "$word"))

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
