utils:test_suite() {
  local -n cases=$1
  cases=(
    utils:test_int_enum
    utils:test_str_enum
    utils:test_enum
    utils:test_read_file
    utils:test_is_json_file
    utils:test_is_yaml_file
    utils:test_get_file_mime
    utils:test_read_serialized_file
    utils:test_get_module_name
    utils:test_is_input_from_stdin
    utils:test_parser
    utils:test_has_backend
    utils:test_types
    utils:test_is_types
  )
}
