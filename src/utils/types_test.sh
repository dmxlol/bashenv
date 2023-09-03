utils:test_types() {
  declare -a arr
  declare -A map
  declare -i int
  declare -- str
  declare -n ref
  func() { :; }

  tests:assert_equal "$(utils:get_type_of arr)" "array"
  tests:assert_equal "$(utils:get_type_of map)" "map"
  tests:assert_equal "$(utils:get_type_of int)" "int"
  tests:assert_equal "$(utils:get_type_of str)" "str"
  tests:assert_equal "$(utils:get_type_of ref)" "nameref"
  tests:assert_equal "$(utils:get_type_of func)" "function"
  tests:assert_equal "$(utils:get_type_of foo)" "unknown"

  declare -r arr map int str ref
  tests:assert_equal "$(utils:get_type_of arr)" "array+"
  tests:assert_equal "$(utils:get_type_of map)" "map+"
  tests:assert_equal "$(utils:get_type_of int)" "int+"
  tests:assert_equal "$(utils:get_type_of str)" "str+"
  tests:assert_equal "$(utils:get_type_of ref)" "nameref+"
  tests:assert_equal "$(utils:get_type_of foo)" "unknown"
}


utils:test_is_types() {
  declare -a arr
  declare -A map
  declare -i int
  declare -- str
  declare -n ref
  func() { :; }

  tests:assert utils:is_array arr
  tests:assert_not_ok utils:is_array map

  tests:assert utils:is_map map
  tests:assert_not_ok utils:is_map arr

  tests:assert utils:is_int int
  tests:assert_not_ok utils:is_int str

  tests:assert utils:is_string str
  tests:assert_not_ok utils:is_string int

  tests:assert utils:is_nameref ref
  tests:assert_not_ok utils:is_nameref str

  tests:assert utils:is_unknown foo
  tests:assert_not_ok utils:is_unknown str

  tests:assert utils:is_function func
  tests:assert_not_ok utils:is_function str

  declare -r arr map int str ref
  tests:assert utils:is_readonly arr
  tests:assert utils:is_readonly map
  tests:assert utils:is_readonly int
  tests:assert utils:is_readonly str
  tests:assert utils:is_readonly ref
}
