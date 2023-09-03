utils:get_type_of() {
  local typevar __result__
  # shellcheck disable=SC2086
  if typevar="$(declare -p "$1" 2>/dev/null)"; then
    if [[ "${typevar}" =~ "declare -a" ]]; then
      __result__="array"
    elif [[ "${typevar}" =~ "declare -A" ]]; then
      __result__="map"
    elif [[ "${typevar}" =~ "declare -i" ]]; then
      __result__="int"
    elif [[ "${typevar}" =~ "declare --" ]]; then
      __result__="str"
    elif [[ "${typevar}" =~ "declare -n" ]]; then
      __result__="nameref"
    fi

    if [[ "${typevar}" =~ declare\ -[[:alpha:]]*r ]]; then
      __result__="${__result__:-str}+"
    fi
    echo "${__result__:-unknown}"
  elif typevar=$(type -t "$1"); then
    echo "$typevar"
  else
    echo "unknown"
  fi
}


utils:is_string() {
  [[ "$(utils:get_type_of "$1")" =~ str ]]
}


utils:is_array() {
  [[ "$(utils:get_type_of "$1")" =~ array ]]
}


utils:is_map() {
  [[ "$(utils:get_type_of "$1")" =~ map ]]
}


utils:is_int() {
  [[ "$(utils:get_type_of "$1")" =~ int ]] || [[ "$1" =~ ^[0-9]+$ ]]
}


utils:is_nameref() {
  [[ "$(utils:get_type_of "$1")" =~ nameref ]]
}


utils:is_unknown() {
  [[ "$(utils:get_type_of "$1")" =~ unknown ]]
}


utils:is_readonly() {
  [[ "$(utils:get_type_of "$1")" =~ \+$ ]]
}


utils:is_function() {
  [[ "$(utils:get_type_of "${!1}")" =~ function ]]
}
