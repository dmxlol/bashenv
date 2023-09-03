utils:test_is_input_from_stdin() {
  echo foo | utils:is_input_from_stdin
  tests:assert_ok

  utils:is_input_from_stdin
  tests:assert_not_ok
}


utils:test_results_to_var() {
  local value var i
  for i in {1..10}; do
    value="$(tr -dc A-Za-z0-9 </dev/urandom | head)"
    utils:results_to_var var echo "$value"
    tests:assert_equal "$var" "$value"
  done
}
