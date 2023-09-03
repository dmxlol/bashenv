utils:test_get_module_name() {
  local name
  utils:result_to_var name utils:get_module_name
  tests:assert_equal "$name" "utils"

  mymodule:func() {
    utils:get_module_name
  }

  utils:result_to_var name mymodule:func
  tests:assert_equal "$name" "mymodule"
}


utils:test_get_module_dir() {
local dir
  utils:result_to_var dir utils:get_module_dir
  tests:assert_equal "$dir" "$(pwd)/src/utils"
}
