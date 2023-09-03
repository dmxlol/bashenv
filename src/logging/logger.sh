logging:log() {
  # get default logger if none is set
  [[ -z "${__logging__active_logger__}" ]] && logging:get_logger

  # get default level if none passed
  # shellcheck disable=SC2154
  (( $# == 1 )) && set -- "${__logging__config__[default_level]}" "$@"
  local level="${1}"

  # get logger level, fallback to default level it not set
  local log_level; logging:get_logger_level log_level

  # return if log_level is gt level
  ((${!log_level} <= ${!level})) || return 0

  local fd=1
  # shellcheck disable=SC2154
  (( ${!level} >= logging_warn )) && fd="${__logging__config__[stderr_descriptor]}"

  # get logger format, fallback to default format if not set
  local format message extra;

  logging:get_logger_format format
  message="$(sed -e 's/"/\\"/g' -e "s/'/\\'/g" <<< "${2:-}")"
  extra=("${@:3}")

  (
    [[ "$format" == *datetime* ]] && { datetime=$(date +"${__logging__config__[datetime_format]}"); export datetime; }
    [[ "$format" == *level* ]] && export level=${level/logging_/}
    [[ "$format" == *message* ]] && export message
    [[ "$format" == *logger* ]] && export logger="${__logging__active_logger__}"
    for item in "${extra[@]}"; do
      [[ "$format" == *"${item%%=*}"* ]] && export "${item%%=*}"="${item#*=}"
    done
    envsubst <<< "$format" >&"$fd"
  )
}


logging:debug() {
  logging:log "logging_debug" "$@"
}


logging:info() {
  logging:log "logging_info" "$@"
}


logging:warn() {
  logging:log "logging_warn" "$@"
}


logging:error() {
  logging:log "logging_error" "$@"
}


logging:fatal() {
  logging:log "logging_fatal" "$@"
}


# shellcheck disable=SC2120
logging:get_logger() {
  local logger=${1:-__logging__config__[default_logger]}
  [[ -z "${__logging__loggers__[$logger]}" ]] && __logging:create_logger__ "$logger"
  export __logging__active_logger__="$logger"
}


__logging:create_logger__() {
  local logger="${1:?logging: missing logger name}"
  __logging__loggers__[$logger]="__logging__logger__${logger}__"
}


__logging:get_logger_property__() {
  local -n __ref__=${1:?"logging: missing reference"}
  local __property__="__logging__logger__${__logging__active_logger__}__${2:?"logging: missing property name"}__"
  # Use logger property if set, fallback to global config
  # shellcheck disable=SC2034
  __ref__="${!__property__:-${__logging__config__[$2]}}"
}


logging:get_logger_format() {
  __logging:get_logger_property__ "$1" "log_format"
}


logging:get_logger_level() {
  __logging:get_logger_property__ "$1" "log_level"
}


logging:set_logger_format() {
  __logging:set_logger_property__ "log_format" "$1"
}


logging:set_logger_level() {
  __logging:set_logger_property__ "log_level" "$1"
}


__logging:set_logger_property__() {
  local __value__="${2:?"logging: missing property $1 value"}"
  # shellcheck disable=SC2140
  export "__logging__logger__${__logging__active_logger__}__${1}__"="$__value__"
}
