tests:assert() {
  local func="$1"
  if "${func}" "${@:2}"; then
    return 0
  else
    echo "Assertion failed: '$*' must return 0" >&2
    return 1
  fi
}


tests:assert_equal() {
  if [[ "${1}" == "${2}" ]]; then
    return 0
  else
    echo "${3:-"Assertion failed '${1}' != '${2}'"}" >&2
    return 1
  fi
}


tests:assert_not_equal() {
  if tests:assert_equal "$@" 2>/dev/null; then
    echo "${3: Assertion failed ${!1@} == ${!2@}}" >&2
    return 1
  else
    return 0
  fi

}


tests:assert_ok() {
  local __rc__="$?"
  if (($# == 0 )); then
    tests:assert_equal "${__rc__}" 0 && return 0 || return 1
  fi
  tests:assert "$@"
}


tests:assert_not_ok() {
  if tests:assert "$@" 2>/dev/null; then
    echo "Assertion failed: '$*' must NOT return 0" >&2
    return 1
  fi
  return 0
}


tests:run_suite() {
  bashenv:blueify "Running suite ${1:? tests:run_suite: suite name is missing}\n"
  local -a __cases__
  $1 __cases__
  for test_case in "${__cases__[@]}"; do
    echo -ne "\tRunning ${test_case}..."
    ${test_case} && bashenv:greenify "OK\n" || bashenv:redify "FAIL\n"
  done
}


tests:autodiscover_suites() {
  local test_suite
  for test_suite in $(compgen -A function|grep ":test_suite$");do
    tests:run_suite "${test_suite}"
  done
}


#TODO print stack tracxe
