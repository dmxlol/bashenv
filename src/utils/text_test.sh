utils:test_parser() {
  local data yaml
  utils:parse_json "data" 2>/dev/null
  tests:assert_not_ok

  utils:result_to_var data utils:parse_json '{"data": "value"}' '.data'
  tests:assert_ok
  tests:assert_equal "$data" "value"

  yaml="$(echo -e "\n\tbar\nfoo")"
  utils:parse_yaml "$yaml" 2>/dev/null
  tests:assert_not_ok

  yaml="$(echo -e "---\nfoo: bar")"
  utils:result_to_var data utils:parse_yaml "$yaml" '.foo'
  tests:assert_ok
  tests:assert_equal "$data" "bar"
}


utils:test_has_backend() {
  :
#  __utils:has_backend__ json
#  tests:assert_ok
#
#  __utils:has_backend__ yaml
#  tests:assert_ok
#
#  __utils:has_backend__ foo
#  tests:assert_not_ok
}
