__utils:parser__() {
  local data parser="${1:?utils: parser is missing}"
  shift
  __utils:has_backend__ "$parser" || return 1

  utils:is_input_from_stdin \
    && data="$(cat)" \
    || { data="$1"; shift;}
  "${__utils__config__[${parser}_backend]}" -r "${1:-.}" <<< "$data" 2>/dev/null \
    || { logging:error "${FUNCNAME[1]}: ${parser} parsed with errors"; return 1; }
}


utils:parse_json() {
  __utils:parser__ json "$@"
}


utils:parse_yaml() {
  __utils:parser__ yaml "$@"
}


__utils:has_backend__() {
  [[ -n "${__utils__config__[${1:?utils: backend is missing}_backend]}" ]]
}
