#!/bin/bash

path_script=$(dirname $(readlink -f $0))

# para testes sem instalar o script no sistema descomente a linha abaixo
# export HOME=$(readlink -f ".")

path_home=$(readlink -f "$path_script")

index=0
env_path_name_prefix="$(echo $path_script | xargs basename | sed -E 's|-|_|g' | tr '[:lower:]' '[:upper:]')_HOME_"
env_path_name="${env_path_name_prefix}${index}"

function export_path_rc() {
  echo -n '
'$env_path_name'="'$path_home'"
[ -z "$(echo $PATH | grep "$'$env_path_name'/bin")" ] &&
  export PATH="$'$env_path_name'/bin:$PATH"
'
}

function export_path_rc_source() {
  echo -n '
'$env_path_name'="'$path_home'"
[ -z "$(echo $PATH | grep "$'$env_path_name'/bin")" ] &&
  export PATH="$'$env_path_name'/bin:$PATH"
[ -n "$(echo $PATH | grep "$'$env_path_name'/bin")" ] &&
  source $'$env_path_name'/autocompletions/setup-autocomplite.sh $'$env_path_name'/bin
'
}

procurar_padrao_sed_if() {
  if [ -f "$1" ]; then
    sed -n -E '/'$env_path_name_prefix'.*'$(echo $path_home | sed -E 's|/|.|g')'"/,/export/p' $1
    sed -n -E '/'$env_path_name_prefix'/,/source \$'$env_path_name_prefix'.*\$'$env_path_name_prefix'/p' $1
  fi
}

excluir_padrao_sed_if() {
  if [ -f "$1" ]; then
    sed -i -E '/'$env_path_name_prefix'.*'$(echo $path_home | sed -E 's|/|.|g')'"/,/export/d' $1
    sed -i -E '/'$env_path_name_prefix'/,/source \$'$env_path_name_prefix'.*\$'$env_path_name_prefix'/d' $1
  fi
}

exportar_bin() {
  local value=$($2)

  sed -i -E ':a;N;$!ba;s/\n+$//g' "$1"
  if [ -z "$(procurar_padrao_sed_if "$1")" ]; then
    echo -e "$value" >>"$1"
  else
    echo -e "\033[31mA configuração:\n$value\njá existe no arquivo:\n$1\033[0m"
  fi
}

function install_bin() {
  exportar_bin "$HOME/.profile" export_path_rc
  exportar_bin "$HOME/.bashrc" export_path_rc_source
  exportar_bin "$HOME/.zshrc" export_path_rc_source
}

function uninstall_bin() {
  excluir_padrao_sed_if "$HOME/.profile"
  excluir_padrao_sed_if "$HOME/.bashrc"
  excluir_padrao_sed_if "$HOME/.zshrc"
}

path_auto_complete="$path_script/autocompletions/setup-autocomplite.sh"

while read -p "Deseja instalar ou desinstalar o bin? [install/uninstall]: " opcao; do
  case $opcao in
  install)
    install_bin
    # $path_auto_complete install
    break
    ;;
  uninstall)
    uninstall_bin
    # $path_auto_complete uninstall
    break
    ;;
  *)
    echo -e "\033[31mOpção inválida!\033[0m"
    ;;
  esac
done
