maps:value_exists() {
  local __value__="${1:? maps:value_exists: value is missing}"
  local -n __map__=$2
  (
    export IFS="|"
    [[ "${map[*]}" =~ (^|\|)$__value__(\||$) ]]
  )
}


maps:key_exists() {
  local __key__="${1:? maps:key_exists: key is missing}"
  local -n __map__=$2
  [[ -n "${map[$__key__]+x}" ]]
}
