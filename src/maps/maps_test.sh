maps:test_key_exists() {
  local -A map=(
    [foo]=bar
    [baz]=quux
  )

  tests:assert_ok maps:key_exists foo map
  tests:assert_ok maps:key_exists baz map
  tests:assert_not_ok maps:key_exists quux map
  tests:assert_not_ok maps:key_exists bar map
}


maps:test_value_exists() {
  local -A map=(
    [foo]=bar
    [baz]=quux
  )

  tests:assert_ok maps:value_exists bar map
  tests:assert_ok maps:value_exists quux map
  tests:assert_not_ok maps:value_exists foo map
  tests:assert_not_ok maps:value_exists baz map
}


maps:test_suite() {
  local -n cases=$1
  cases=(
    maps:test_value_exists
    maps:test_key_exists
  )
}
