__utils:init__() {
  if [[ -z "${__utils__config__[is_set]}" ]]; then
    declare -gA __utils__config__
    #TODO parser with or without json/yaml
    __utils__config__[json_backend]="$(which jq)"
    __utils__config__[yaml_backend]="$(which yq)"
    __utils__config__[yaml_linter]="$(which yamllint)"
    __utils__config__[yaml_linter_params]="-s"
    __utils__config__[is_set]=1
  fi
}

__utils:init__
