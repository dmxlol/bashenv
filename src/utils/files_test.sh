utils:test_read_file() {
  local file data
  file=$(mktemp)
  echo "foo" > "$file"
  utils:read_file "$file" data
  tests:assert_equal "$data" "foo"
  tests:assert_equal "$(utils:read_file "$file")" "foo"
  rm -f "$file"
}


utils:test_is_json_file() {
  local file data
  file=$(mktemp)
  echo "foo" > "$file"
  tests:assert_not_ok utils:is_json_file "$file"
  echo '{"foo": "bar"}' > "$file"
  tests:assert_ok utils:is_json_file "$file"
  rm -f "$file"
}


utils:test_is_yaml_file() {
  local file data
  file=$(mktemp)
  echo "foo" > "$file"
  tests:assert_not_ok utils:is_yaml_file "$file"
  echo -e "---\nfoo: bar" > "$file"
  tests:assert_ok utils:is_yaml_file "$file"
  rm -f "$file"
}


utils:test_get_file_mime() {
  local file data
  file=$(mktemp)
  echo "foo" > "$file"
  tests:assert_equal "$(utils:get_file_mime "$file")" "text/plain"
  echo '{"foo": "bar"}' > "$file"
  tests:assert_equal "$(utils:get_file_mime "$file")" "application/json"
  echo "foo: bar" > "$file"
  tests:assert_equal "$(utils:get_file_mime "$file")" "text/plain"
  rm -f "$file"
}


utils:test_read_serialized_file() {
local file data
  file=$(mktemp)
  echo "foo" > "$file"
  tests:assert_not_ok utils:read_serialized_file "$file" data

  echo '{"foo": "bar"}' > "$file"
  utils:result_to_var data utils:read_serialized_file "$file" .foo
  tests:assert_equal "$data" 'bar'

  echo -e "---\nfoo: bar" > "$file"
  utils:result_to_var data utils:read_serialized_file "$file" .foo
  tests:assert_equal "$data" 'bar'
  rm -f "$file"
}
