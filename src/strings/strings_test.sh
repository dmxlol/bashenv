strings:test_split() {
  local -a array
  tests:assert_equal "$(strings:split "us-we_st-2" "-_")" "us we st 2"
  tests:assert_equal "$(strings:split "a%b^c-d!e" "%^-!")" "a b c d e"
  tests:assert_equal "$(strings:split "a%b^c-d!e" "%^-!")" "a b c d e"

  strings:split_to_var array "a%b^c-d!e" "%^-!"
  tests:assert_equal "${array[*]}" "a b c d e"

  strings:split_to_var array "a%b^c-d!e" "%^-!"
  tests:assert_equal "${array[*]}" "a b c d e"

  strings:split_to_var array "a%b^c-d!e" "%^-!"
  tests:assert_equal "${array[*]}" "a b c d e"
}

strings:test_is_empty() {
  tests:assert_ok strings:is_empty "  "
  tests:assert_ok strings:is_empty " "
  tests:assert_ok strings:is_empty "  "
  tests:assert_not_ok strings:is_empty "FOO"
  tests:assert_not_ok strings:is_empty " foo"
  tests:assert_not_ok strings:is_empty "bar "
  tests:assert_not_ok strings:is_empty "  bar"
  tests:assert_not_ok strings:is_empty " bar baz  "
  tests:assert_not_ok strings:is_empty "foo bar bAZ "
  tests:assert_not_ok strings:is_empty "foo bar "
}


strings:test_remove_empty_lines() {
  tests:assert_equal "$(strings:remove_empty_lines "a\nb\n\n\nc")" "$(echo -e "a\nb\nc")"
  tests:assert_equal "$(strings:remove_empty_lines "a\n\nb\n\n\n\nc")" "$(echo -e "a\nb\nc")"
  tests:assert_equal "$(strings:remove_empty_lines "a\n\nb\n\n\n\nc\n")" "$(echo -e "a\nb\nc")"
  tests:assert_equal "$(strings:remove_empty_lines "a\n\nb\n\n\n\nc\n\n")" "$(echo -e "a\nb\nc")"
  tests:assert_equal "$(strings:remove_empty_lines "a\n\nb\n\n\n\nc\n\n\n")" "$(echo -e "a\nb\nc")"
  tests:assert_equal "$(strings:remove_empty_lines "a\n\nb\n\n\n\nc\n\n\n\n")" "$(echo -e "a\nb\nc")"
  tests:assert_equal "$(strings:remove_empty_lines "a\n\nb\n\n\n\nc\n\n\n\n\n")" "$(echo -e "a\nb\nc")"
  tests:assert_equal "$(strings:remove_empty_lines "a\n\nb\n\n\n\nc\n\n\n\n\n\n")" "$(echo -e "a\nb\nc")"
  tests:assert_equal "$(strings:remove_empty_lines "a\n\nb\n\n\n\nc\n\n\n\n\n\n\n")" "$(echo -e "a\nb\nc")"
  tests:assert_equal "$(strings:remove_empty_lines "a\n\nb\n\n\n\nc\n\n\n\n\n\n\n\n")" "$(echo -e "a\nb\nc")"
  tests:assert_equal "$(strings:remove_empty_lines "a\n\nb\n\n\n\nc\n\n\n\n\n\n\n\n\n")" "$(echo -e "a\nb\nc")"

  local var
  strings:remove_empty_lines_to_var var "a\nb\n\n\nc"
  tests:assert_equal "$var" "$(echo -e "a\nb\nc")"

  strings:remove_empty_lines_to_var var "a\n\nb\n\n\n\nc"
  tests:assert_equal "$var" "$(echo -e "a\nb\nc")"

  strings:remove_empty_lines_to_var var "a\n\nb\n\n\n\nc\n"
  tests:assert_equal "$var" "$(echo -e "a\nb\nc")"

  strings:remove_empty_lines_to_var var "a\n\nb\n\n\n\nc\n\n"
  tests:assert_equal "$var" "$(echo -e "a\nb\nc")"

  strings:remove_empty_lines_to_var var "a\n\nb\n\n\n\nc\n\n\n"
  tests:assert_equal "$var" "$(echo -e "a\nb\nc")"
}

strings:test_trim() {
  tests:assert_equal "$(strings:trim " foo ")" "foo"
  tests:assert_equal "$(strings:trim " bar")" "bar"
  tests:assert_equal "$(strings:trim "\nBAZ ")" "BAZ"
  tests:assert_equal "$(strings:trim "  foo bar  ")" "foo bar"
  tests:assert_equal "$(strings:trim "\tbaz quux\n")" "baz quux"
  tests:assert_equal "$(strings:trim "\n\nbaz \t  ")" "baz"
}

strings:test_ltrim() {
  tests:assert_equal "$(strings:ltrim " foo ")" "foo "
  tests:assert_equal "$(strings:ltrim " bar")" "bar"
  tests:assert_equal "$(strings:ltrim "\nBAZ ")" "BAZ "
  tests:assert_equal "$(strings:ltrim "  foo bar  ")" "foo bar  "
  tests:assert_equal "$(strings:ltrim "\tbaz quux\n")" "$(echo -e "baz quux\n")"
  tests:assert_equal "$(strings:ltrim "\n\nbaz \t  ")" "$(echo -e "baz \t  ")"
}

strings:test_rtrim() {
  tests:assert_equal "$(strings:rtrim " foo ")" " foo"
  tests:assert_equal "$(strings:rtrim " bar  \n")" " bar"
  tests:assert_equal "$(strings:rtrim "\nBAZ ")" "$(echo -e "\nBAZ")"
  tests:assert_equal "$(strings:rtrim "  foo bar\v  ")" "  foo bar"
  tests:assert_equal "$(strings:rtrim "\tbaz quux\n")" "$(echo -e "\tbaz quux")"
  tests:assert_equal "$(strings:rtrim "\n\nbaz \t  ")" "$(echo -e "\n\nbaz")"
}

strings:test_trims_to_var() {
  local foo
  strings:trim_to_var foo " foo "
  tests:assert_equal "$foo" "foo"

  strings:trim_to_var foo " bar"
  tests:assert_equal "$foo" "bar"

  strings:trim_to_var foo "\nBAZ "
  tests:assert_equal "$foo" "BAZ"

  strings:trim_to_var foo "  foo bar  "
  tests:assert_equal "$foo" "foo bar"

  strings:trim_to_var foo "\tbaz quux\n"
  tests:assert_equal "$foo" "baz quux"

  strings:trim_to_var foo "\n\nbaz \t  "
  tests:assert_equal "$foo" "baz"

  strings:ltrim_to_var foo " foo "
  tests:assert_equal "$foo" "foo "

  strings:ltrim_to_var foo " bar"
  tests:assert_equal "$foo" "bar"

  strings:ltrim_to_var foo "\nBAZ "
  tests:assert_equal "$foo" "BAZ "

  strings:ltrim_to_var foo "  foo bar  "
  tests:assert_equal "$foo" "foo bar  "

  strings:ltrim_to_var foo "\tbaz quux\n"
  tests:assert_equal "$foo" "$(echo -e "baz quux\n")"

  strings:rtrim_to_var foo " foo "
  tests:assert_equal "$foo" " foo"

  strings:rtrim_to_var foo " bar  \n"
  tests:assert_equal "$foo" " bar"

  strings:rtrim_to_var foo "\nBAZ "
  tests:assert_equal "$foo" "$(echo -e "\nBAZ")"

  strings:rtrim_to_var foo "  foo bar\v  "
  tests:assert_equal "$foo" "  foo bar"
}


strings:test_repeat_string() {
  local var
  strings:repeat_string_to_var var "foo" 1
  tests:assert_equal "$var" "foo"

  strings:repeat_string_to_var var "foo" 2
  tests:assert_equal "$var" "foofoo"

  strings:repeat_string_to_var var "foo" 3
  tests:assert_equal "$var" "foofoofoo"

  tests:assert_equal "$(strings:repeat_string "foo")" "foo"
  tests:assert_equal "$(strings:repeat_string "foo" 1)" "foo"
  tests:assert_equal "$(strings:repeat_string "foo" 2)" "foofoo"
  tests:assert_equal "$(strings:repeat_string "foo" 3)" "foofoofoo"
}


strings:test_substring_exists() {
  tests:assert_ok strings:substring_exists "foo" "foo"
  tests:assert_ok strings:substring_exists "foo" "foobar"
  tests:assert_ok strings:substring_exists "foo" "barfoo"
  tests:assert_ok strings:substring_exists "foo" "barfoobar"
  tests:assert_ok strings:substring_exists "foo" "barfoobarbaz"
  tests:assert_ok strings:substring_exists "foo" "barfoobarbazfoo"
  tests:assert_ok strings:substring_exists "foo" "barfoobarbazfoofoo"
  tests:assert_not_ok strings:substring_exists "foo" "bar"
  tests:assert_not_ok strings:substring_exists "foo" "barbar"
  tests:assert_not_ok strings:substring_exists "foo" "barbarbaz"
  tests:assert_not_ok strings:substring_exists "foo" "barbarbazbar"
  tests:assert_not_ok strings:substring_exists "foo" "barbarbazbarbar"
}


strings:test_is_alpha() {
  tests:assert_ok strings:is_alpha "foo"
  tests:assert_ok strings:is_alpha "FOO"
  tests:assert_ok strings:is_alpha "BAR"
  tests:assert_ok strings:is_alpha "BAZ"
  tests:assert_not_ok strings:is_alpha "foo bar"
  tests:assert_not_ok strings:is_alpha "foo-bar"
  tests:assert_not_ok strings:is_alpha "foo_bar"
  tests:assert_not_ok strings:is_alpha "foo1"
}


strings:test_is_alnum() {
  tests:assert_ok strings:is_alnum "foo"
  tests:assert_ok strings:is_alnum "BAZ"
  tests:assert_ok strings:is_alnum "foo1"
  tests:assert_not_ok strings:is_alnum "foo bar"
  tests:assert_not_ok strings:is_alnum "foo-bar"
  tests:assert_not_ok strings:is_alnum "foo_bar"
}


strings:test_is_digit() {
tests:assert_ok strings:is_digit "1"
  tests:assert_ok strings:is_digit "2"
  tests:assert_ok strings:is_digit "3"
  tests:assert_ok strings:is_digit "4"
  tests:assert_ok strings:is_digit "5"
  tests:assert_ok strings:is_digit "6"
  tests:assert_ok strings:is_digit "7"
  tests:assert_ok strings:is_digit "8"
  tests:assert_ok strings:is_digit "9"
  tests:assert_ok strings:is_digit "0"
  tests:assert_not_ok strings:is_digit "foo"
  tests:assert_not_ok strings:is_digit "bar"
  tests:assert_not_ok strings:is_digit "baz"
  tests:assert_not_ok strings:is_digit "foo1"
  tests:assert_not_ok strings:is_digit "foo bar"
  tests:assert_not_ok strings:is_digit "foo-bar"
  tests:assert_not_ok strings:is_digit "foo_bar"
}


# shellcheck disable=SC2120
strings:test_suite() {
  local -n cases=$1
  readarray -t cases < <(compgen -A function|grep -P "^strings:test_(?!suite)")
}
