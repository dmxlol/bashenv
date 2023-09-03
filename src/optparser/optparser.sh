__optparser:parse_long_opt_argument__() {
  # function that parses long option argument
  # accepts two arguments:
  #   $1: name of the variable that contains options configuration
  #   $2: long option
  local -n optcfg=$1
  if [[ -n "${optcfg[$2:with_argument]}" ]]; then
    if [[ -n "$argument" ]]; then
      export OPTARG="$argument"
    elif [[ -n "$increment" ]]; then
      export OPTARG="${opts[$((OPTIND-1))]}"
      ((OPTIND++))
    fi
  fi
  if [[ -z "$OPTARG" ]]; then
    return 1
  fi
  return 0
}

__optparser:parse_long_opt__() {
  # function that processes long options, e.g. --option
  # accepts two arguments:
  #   $1: name of the variable that contains options configuration
  #   $2: a regular expression that matches long option
  local -n optcfg=$1
  local long short argument increment
  # case when OPTION=ARGUMENT
  if maps:value_exists "${OPTARG%=*}" shorts_and_longs; then
    long="${OPTARG%=*}"
    argument="${OPTARG#*=}"
  # case when OPTION (ARGUMENT)?
  elif [[ "$OPTARG" =~ ${2:-#}$ ]]; then
    long="$OPTARG"
    increment=1
  fi

  if [[ -n "$long" ]] && [[ -n "${optcfg[$long]+x}" ]]; then
    if ! __optparser:parse_long_opt_argument__ "$1" "$long"; then
      logging:fatal "$(utils:get_module_name): argument is required for --$long option"
      return 1
    fi

    __optparser:get_short_for__ "$1" "$long" short
    logging:debug "$(utils:get_module_name): long option '$long' processed${short:+ with short option "'$short'"}"

    __optparser:parse_opt__ "$short" "$long"
    return 0
  fi
  logging:fatal "$(utils:get_module_name): long option '$OPTARG' is unknown"
  return 1
}

__optparser:setup_help__() {
  # function that sets up help option
  # accepts three arguments:
  #   $1: name of the variable that contains optparser configuration
  #   $2: the line that contains option
  #   $3: the associative array that contains short and long options
  local -n optcfg=$1
  local -n line=$2
  local -n sal=$3

  if [[ -z "${optcfg[help]+x}" ]]; then
    optcfg[help]=""
    if ! [[ "$line" =~ h ]]; then
      optcfg[help]="h"
      sal[h]="help"
      line+="h"
    else
      optcfg[help:long_only]=1
    fi
    optcfg[help:callback]="__optparser:help__"
  fi
}


__optparser:get_short_for__() {
  # function that returns short option for the long one
  # accepts three arguments:
  #   $1: the associative array optparser configuration
  #   $2: the long option
  #   $3: the variable to store the result
  local -n optcfg=$1
  local opt=$2
  local -n res=$3
  if [[ -n "${optcfg[$opt:long_only]}" ]]; then
    return 1
  elif [[ -n "${optcfg[${opt}]}" ]]; then
    res="${optcfg[${opt}]}"
  else
    res="${opt::1}"
  fi
}


__optparser:build_optline__() {
  # function that builds an optline for getopts from the array of long options
  # each long option first letter is considered as a short option
  # in case the letter is already used, only long option will be available
  # accepts three arguments:
  #   $1: the associative array optparser configuration
  #   $2: the string used as an argument for getopts
  #   $3: the associative array with short and long opts, keys and values respectively
  local -n optcfg=$1
  local -n line=$2
  local -n sal=$3
  local opt opts short
  utils:is_array "${!optcfg}" && opts="${optcfg[*]}"
  utils:is_map "${!optcfg}" && opts=("${!optcfg[@]}")

  for opt in "${opts[@]}"; do
    [[ "$opt" == *:* ]] && continue
    if ! __optparser:get_short_for__ "$1" "$opt" short; then
      continue
    fi
    if [[ $line =~ .*${short}.* ]]; then
      logging:warn "$(utils:get_module_name): option '${short}' is already used"
      continue
    else
      sal[$short]="$opt"
      line+="${short}"
    fi

    [[ -n "${optcfg[${opt}:with_argument]}" ]] && line+=":"
  done

  __optparser:setup_help__ "$1" "$2" "$3"

  line=":${line}-:"
  logging:debug "$(utils:get_module_name): optline: ${line}"
}

__optparser:help__() {
  # function that generates a help message
  echo -e "Usage: ${0} OPTIONS [ARGUMENTS]"
  echo -e "${options[help:app_description]+${options[help:app_description]}\n}"
  local opt short
  for opt in "${!options[@]}"; do
    [[ "$opt" == *:* ]] && continue
    __optparser:get_short_for__ options "$opt" short
    echo -en "\t${short:+-${short}, }"
    echo -n "--${opt}"
    echo -n "${options[${opt}:with_argument]:+ {ARGUMENT\}}"
    echo "${options[${opt}:help]:+  ${options[${opt}:help]}}"
    unset short
  done
  exit 0
}

__optparser:parse_opt__() {
  local var_name var_value short=$1 long=$2
  if [[ -n "${options[${long}:var]}" ]]; then
    var_name="${options[${long}:var]}"
  else
    var_name="${long^^}"
  fi

  if [[ -n "${options[${long}:with_argument]}" ]]; then
    var_value="${OPTARG}"
  else
    if [[ -n "${options[${opt}:count]}" ]]; then
      # shellcheck disable=SC2004
      (( var_value++ ))
    else
      var_value=1
    fi
  fi

  # shellcheck disable=SC2163
  if [[ -n "${options[${long}:callback]}" ]]; then
    logging:debug "$(utils:get_module_name): calling to '${options[${long}:callback]}' for '$long' option"
    "${options[${long}:callback]}" "$var_name" "$var_value"
  fi
  logging:debug "$(utils:get_module_name): [$long${short:+:$short}] setting variable '$var_name' to '$var_value'"
  declare -gx "$var_name"="$var_value"
}

optparser:parse() {
  # function that parses the options using getopts
  # it takes either an associative or an indexed array of options as an argument
  # example
  # declare -A options=(
  #   [myopt]=               <- key is the long option, value is optional and indicates explicit short option,
  #                             else the first letter will be tried to be set.
  #                             if the letter is already used, only long option will be available.
  #   [myopt:long_only]=     <- force the option to be long only
  #   [myopt:with_argument]= <- whether the option requires an argument (optional)
  #   [myopt:description]=   <- description of the option in the help message (optional)
  #   [myopt:var]=           <- variable to set when the option is parsed (optional)
  #   [myopt:count]=         <- whether to count number of times the option is parsed (optional)
  #   [myopt:callback]=      <- callback function to call when the option is parsed (optional)
  # )
  #
  # By default the option sets up a variable named after the long option name, in upper case
  # Special configs:
  # [help:app_description]      <- description of the application (optional)
  local -n options="${1?:optparser: config is required}"; shift

  local OPTIND OPTARG OPTERR opt optline opts=("${@}")
  declare -A shorts_and_longs
  __optparser:build_optline__ options optline shorts_and_longs

  while getopts "${optline}" opt; do
    OPT=$((OPTIND-1))
    OPT=${!OPT}
    case "$opt" in
      -) __optparser:parse_long_opt__ options "${OPTARG}";;
      \?) logging:fatal "$(utils:get_module_name): option $OPT is unknown";;
      :) logging:fatal "$(utils:get_module_name): argument is required for $OPT option";;
      *) __optparser:parse_opt__ "$opt" "${shorts_and_longs[$opt]}";;
    esac
  done
}
