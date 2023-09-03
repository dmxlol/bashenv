__logging:set_config__() {
  if [[ -z "${__logging__config__[$1]}" ]]; then
    logging:error "Invalid config key '$1'"
    return 1
  fi
  __logging__config__[$1]="$2"
}


logging:set_config() {
  __logging:setup__
  local key
  local i

  if (($# == 1)); then
    local -n config=$1
    for key in "${!config[@]}"; do
      __logging:set_config__ "$key" "${config[$key]}"
    done
    return 0
  elif (($# > 1 )); then
    if (($# % 2 == 0)); then
      for ((i=0; i<$#; i+=2)); do
        __logging:set_config__ "${!i}" "${!((i+1))}"
      done
      return 0
    fi
  fi

  logging:error "Invalid number of arguments"
  return 1
}


logging:set_config_from_file() {
  local file="${1:? logging: missing file to load the config from}"
  if ! [[ -e "$file" ]]; then
    logging:error "File $file does not exist"
    return 1
  fi
  local config

  if utils:is_json_file "$file" || utils:is_yaml_file "$file"; then
    utils:read_serialized_file "$file" config  '.logging|to_entries[]|"\(.key)=\(.value)"'
  else
    utils:read_file "$file" config
  fi
  declare -A cfg
  while read -r line; do
    # shellcheck disable=SC2034
    cfg["${line%%=*}"]=${line#*=}
  done <<< "$config"

  logging:set_config cfg
}

logging:set_level() {
  __logging:setup__
  case "$1" in
    ?(logging_)@(debug|info|warn|error|fatal))
      [[ logging_$1 =~ (logging_)$1 ]] # this puts logging_ into first index if matched or nothing if not
       __logging__config__[log_level]="${BASH_REMATCH[1]}$1"
       ;;
    *) logging:fatal "Invalid log level '$1'";;
  esac
}

logging:dump_config() {
  if (($#>0)); then
    local key
    for key in "$@"; do
      logging:log "${__logging__config__[$key]}"
    done
  else
    for key in "${!__logging__config__[@]}"; do
      logging:log "$key=${__logging__config__[$key]}"
    done
  fi
}
