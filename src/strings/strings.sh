strings:split() {
  local string=$1 delimeter=${2:-" "} result
  IFS=$delimeter read -r -a result <<< "${string}"
  echo "${result[@]}"
}


strings:split_to_var() {
  local -n __ref__=$1
  readarray -t __ref__ <<< "$(strings:split "${2}" "${3}")"
}


strings:is_empty() {
  [[ -z "$(strings:trim "${1:? "${FUNCNAME[0]}: missing string to check}"}")" ]]
}


strings:remove_empty_lines() {
  utils:is_input_from_stdin && set -- "$(cat -)"
  sed '/^[[:space:]]*$/d' < <(echo -e "${1}");
}


strings:remove_empty_lines_to_var() {
  local -n __ref__=${1:? strings:remove_empty_lines_to_var: missing reference}
  __ref__="$(strings:remove_empty_lines "${2}")"
}


strings:trim() {
  strings:ltrim "$1" | strings:rtrim
}


strings:trim_to_var() {
  local -n __ref__=${1:? strings:trim_to_var: missing reference}
  __ref__="$(strings:trim "${2}")"
}


strings:ltrim() {
  utils:is_input_from_stdin && set -- "$(cat -)"
  echo -e "${1}" | sed 's/^[[:space:]]*//g;/[^[:space:]]/,$!d'
}


strings:ltrim_to_var() {
  local -n __ref__=${1:? strings:ltrim_to_var: missing reference}
  __ref__="$(strings:ltrim "${2}")"
}


strings:rtrim() {
  utils:is_input_from_stdin && set -- "$(cat -)"
  echo -e "${1}" | sed 's/[[:space:]]*$//g;'
}


strings:rtrim_to_var() {
  local -n __ref__=${1:? strings:rtrim_to_var: missing reference}
  __ref__="$(strings:rtrim "${2}")"
}


strings:repeat_string() {
   printf "%.s${1:? string is required}" $(seq 1 "${2:-1}")
}


strings:repeat_string_to_var() {
  local -n __ref__=${1:? strings:remove_empty_lines_to_var: missing reference}
  __ref__="$(strings:repeat_string "${2}" "${3}")"
}


strings:substring_exists() {
  # function that checks if a substring exists in a string
  # $1: substring
  # $2: string
  [[ "${2?: "${FUNCNAME[0]}: missing string"}" == *"${1:? "${FUNCNAME[0]}: missing substring"}"* ]]
}


strings:is_alpha() {
  [[ "${1:? "${FUNCNAME[0]}: missing string"}" =~ ^[[:alpha:]]+$ ]]
}


strings:is_alnum() {
  [[ "${1:? "${FUNCNAME[0]}: missing string"}" =~ ^[[:alnum:]]+$ ]]
}


strings:is_digit() {
  [[ "${1:? "${FUNCNAME[0]}: missing string"}" =~ ^[[:digit:]]+$ ]]
}

