arrays:join() {
  local -n __array__=$1
  (
    export IFS="${2:-" "}"
    echo "${__array__[*]}"
  )
}


arrays:join_to_var() {
  local -n __ref__="$1"
  utils:result_to_var __ref__ arrays:join "${2:? "${FUNCNAME[0]}: missing array"}" "$3"
}


arrays:value_exists() {
  local __value__="${1:? arrays: pattern is missing}"
  local -n __array__=$2
  (
    export IFS="|"
    [[ "${array[*]}" =~ (^|\|)$__value__(\||$) ]]
  )
}


arrays:pop() {
  local -n __array__=$1
  local last_idx=$((${#__array__[@]}-1))
  ((last_idx < 0)) && return 1
  local slug index=${2:-$last_idx}
  ((index == last_idx)) && slug="${#__array__[@]}" || slug=$((index + 1))
  echo "${__array__[$index]}"
  __array__=( "${__array__[@]:0:$index}" "${__array__[@]:$slug:$last_idx}" )
}


arrays:pop_to_var() {
  local -n __ref__=${1:? ${FUNCNAME[0]}: missing reference}
  utils:result_to_var __ref__ arrays:pop "${2:? ${FUNCNAME[0]}: missing array}" "$3"
}


arrays:push() {
  local -n __array__=$1
  __array__+=("$2")
}


arrays:shift() {
  local -n __shift_array__=$1
  arrays:pop __shift_array__ 0
}


arrays:shift_to_var() {
  local -n __ref__=${1:? ${FUNCNAME[0]}: missing reference}
  utils:result_to_var __ref__ arrays:shift "${2:? ${FUNCNAME[0]}: missing array}"
}


arrays:unshift() {
  local -n __array__=$1
  __array__=("${2:? ${FUNCNAME[0]} missing value}" "${__array__[@]}")
}
