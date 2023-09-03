utils:get_module_name() {
  caller 0|awk '{gsub("^__|:.*","",$2);print $2}'
}


utils:get_module_dir() {
  [[ -n "$1" ]] && local -n dir="$1" || local dir
  dir="$( dirname -- "${BASH_SOURCE[0]}" )"
  [[ -z "$1" ]] && echo "${dir}"
}
