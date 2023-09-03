utils:read_file() {
  local file="${1:? utils:read_file: missing file to read}"
  if ! [[ -e "$file" ]]; then
    bashenv:warn "File $file does not exist"
    return 1
  fi
  [[ -n "$2" ]] && local -n __container__="$2"
  if utils:is_nameref __container__; then
    __container__="$(<"$file")"
  else
    echo "$(<"$file")"
  fi
}


utils:is_json_file() {
  local file="${1:? utils:is_json_file: missing file to check}"
  [[ "$(file --mime-type -b "$file")" == "application/json" ]]
}


utils:is_yaml_file() {
  local file="${1:? utils:is_yaml_file: missing file to check}"
  if [[ -n "${__utils__config__[yaml_linter]}" ]]; then
    # shellcheck disable=SC2086
    "${__utils__config__[yaml_linter]}" ${__utils__config__[yaml_linter_params]} "$file" &>/dev/null
    return $?
  else
    [[ "$file" =~ \.ya?ml$ ]] && return 0
  fi
  return 1
}


utils:get_file_mime() {
  local file="${1:? utils:get_file_type: missing file to check}"
  file --mime-type -b "$file"
}


utils:read_serialized_file() {
  local __file__="${1:? utils:read_serialized_file: missing file to read}"
  local __data__
  utils:read_file "$__file__" __data__
  if utils:is_json_file "$__file__"; then
    echo "$__data__" | utils:parse_json "${2}"
  elif utils:is_yaml_file "$__file__"; then
    echo "$__data__" | utils:parse_yaml "${2}"
  else
    bashenv:warn "File '$__file__' has unsupported format: '$(utils:get_file_mime "$__file__")'"
    return 1
  fi
}
