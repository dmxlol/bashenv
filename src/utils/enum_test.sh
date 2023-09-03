utils:test_int_enum() {
  local foo bar baz
  utils:int_enum foo bar baz
  tests:assert_equal "${foo}" 0
  tests:assert_equal "${bar}" 1
  tests:assert_equal "${baz}" 2
}


utils:test_str_enum() {
  local foo bAR Baz
  utils:str_enum foo bAR Baz
  tests:assert_equal "${foo}" "foo"
  tests:assert_equal "${bAR}" "bar"
  tests:assert_equal "${Baz}" "baz"
}


utils:test_enum() {
  local foo bar baz
  utils:enum foo bar baz
  tests:assert_equal "${foo}" "0"
  tests:assert_equal "${bar}" "1"
  tests:assert_equal "${baz}" "2"
}
