arrays:test_join() {
  local result array=(foo bar baz)
  tests:assert_equal "$(arrays:join array)" "foo bar baz"
  tests:assert_equal "$(arrays:join array ",")" "foo,bar,baz"
  tests:assert_equal "$(arrays:join array "|")" "foo|bar|baz"

  arrays:join_to_var result array
  tests:assert_equal "${result}" "foo bar baz"
  arrays:join_to_var result array ","
  tests:assert_equal "${result}" "foo,bar,baz"
  arrays:join_to_var result array "|"
  tests:assert_equal "${result}" "foo|bar|baz"
}


arrays:test_value_exists() {
  local array=(foo BAR bAz )
  tests:assert_ok arrays:value_exists foo array
  tests:assert_ok arrays:value_exists BAR array
  tests:assert_ok arrays:value_exists bAz array
  tests:assert_not_ok arrays:value_exists quux array
  tests:assert_not_ok arrays:value_exists bar array
  tests:assert_not_ok arrays:value_exists FoO array
}


arrays:test_pop() {
  local result
  local array=(foo bar baz)

  utils:result_to_var result arrays:pop array
  tests:assert_equal "$result" "baz"
  tests:assert_equal "${#array[@]}" 2

  utils:result_to_var result arrays:pop array
  tests:assert_equal "$result" "bar"
  tests:assert_equal "${#array[@]}" 1

  utils:result_to_var result arrays:pop array
  tests:assert_equal "${#array[@]}" 0
  tests:assert_equal "$result" "foo"

  utils:result_to_var result arrays:pop array
  tests:assert_equal "${#array[@]}" 0
  tests:assert_equal "$result" ""

  local array=(foo bar baz)
  arrays:pop_to_var result array
  tests:assert_equal "${result}" "baz"
  tests:assert_equal "${#array[@]}" 2

  arrays:pop_to_var result array
  tests:assert_equal "${result}" "bar"
  tests:assert_equal "${#array[@]}" 1

  arrays:pop_to_var result array
  tests:assert_equal "${result}" "foo"
  tests:assert_equal "${#array[@]}" 0

  arrays:pop_to_var result array
  tests:assert_equal "${result}" ""
  tests:assert_equal "${#array[@]}" 0
}


arrays:test_push() {
  local result array=(foo bar baz)

  arrays:push array quux
  tests:assert_equal "${#array[@]}" 4
  tests:assert_equal "${array[3]}" "quux"

  arrays:push array BAR
  tests:assert_equal "${#array[@]}" 5
  tests:assert_equal "${array[4]}" "BAR"
}


arrays:test_shift() {
  local result array=(foo bar baz)

  utils:result_to_var result arrays:shift array
  tests:assert_equal "${result}" "foo"
  tests:assert_equal "${#array[@]}" 2

  utils:result_to_var result arrays:shift array
  tests:assert_equal "${result}" "bar"
  tests:assert_equal "${#array[@]}" 1

  utils:result_to_var result arrays:shift array
  tests:assert_equal "${result}" "baz"
  tests:assert_equal "${#array[@]}" 0

  utils:result_to_var result arrays:shift array
  tests:assert_equal "${result}" ""
  tests:assert_equal "${#array[@]}" 0
}


arrays:test_unshift() {
  local result array=(foo bar baz)

  arrays:unshift array quux
  tests:assert_equal "${#array[@]}" 4
  tests:assert_equal "${array[0]}" "quux"

  arrays:unshift array quuz
  tests:assert_equal "${#array[@]}" 5
  tests:assert_equal "${array[0]}" "quuz"
}


arrays:test_suite() {
  local -n cases=$1
  cases=(
    arrays:test_join
    arrays:test_value_exists
    arrays:test_pop
    arrays:test_push
    arrays:test_shift
    arrays:test_unshift
  )
}