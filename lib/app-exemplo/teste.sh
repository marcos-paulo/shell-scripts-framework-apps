#!/bin/bash

# bloco autocomplite
declare -a completions
completions[1]='"a" "b" "c"'
completions[2]='"e" "r" "g"'
completions[3]='"x" "y" "z"'
source "$(readlink -f $(dirname $(readlink -f $0))/../../autocompletions/autocompletions-mais-de-um-parametro.sh)"
# source "$(readlink -f $(dirname $(readlink -f $0))/../../a utocompletions/autocompletions.sh)"
# bloco autocomplite
