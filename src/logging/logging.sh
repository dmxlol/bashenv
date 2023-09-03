declare -gr __logging__dependencies__=(utils)
declare -gA __logging__loggers__
declare -gA __logging__config__


__logging:setup__() {
  if [[ -z "${__logging__config__[is_set]}" ]]; then
    utils:enum "logging_debug" "logging_info" "logging_warn" "logging_error" "logging_fatal"
    #TOOD add default config
    __logging__config__[default_level]=logging_info
    __logging__config__[default_logger]=root
    __logging__config__[log_level]=logging_info
    __logging__config__[log_format]="${__bashenv__config__[log_format]}"
    __logging__config__[datetime_format]="${__bashenv__config__[datetime_format]}"
    __logging__config__[stderr_descriptor]=2
    export __logging__active_logger__=root
    __logging__config__[is_set]=1
  fi
}


__logging:setup__
