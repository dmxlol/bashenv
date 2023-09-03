set -o pipefail
shopt -s extglob

declare -A __bashenv__config__=(
  [log_format]='{"datetime": "$datetime", "level":"$level", "logger":"bashenv", "message":"$message"}'
  [datetime_format]='%Y-%m-%d %H:%M:%S'
  [colors]=1
)
declare -A __bashenv__colors__=(
  [red]=$(tput setaf 1)
  [yellow]=$(tput setaf 3)
  [green]=$(tput setaf 2)
  [blue]=$(tput setaf 4)
  [nocolor]=$(tput sgr0)
)
declare -A __bashenv__modules__

declare -g __bashenv__pwd__="$( dirname -- "${BASH_SOURCE[0]}" )"

bashenv:get_color() {
  echo "${__bashenv__colors__[${1:?bashenv: color is missing}]}"
}


__bashenv:colorify__() {
  local color="$1"; shift
  (($# > 1)) && { declare -n ref=$1; shift; }

  if [[ "${__bashenv__config__[colors]}" == 1 ]]; then
    [[ -z "${ref}" ]] \
      && echo -ne "${color}${*}$(bashenv:get_color nocolor)" \
      ||  ref="${color}${*}$(bashenv:get_color nocolor)"
  else
    [[ -z "${ref}" ]] \
      && echo -ne "$*" \
      || ref="$*"
  fi
}


bashenv:redify() {
  __bashenv:colorify__ "$(bashenv:get_color red)" "$@"
}


bashenv:yellowify() {
  __bashenv:colorify__ "$(bashenv:get_color yellow)" "$@"
}


bashenv:greenify() {
  __bashenv:colorify__ "$(bashenv:get_color green)" "$@"
}


bashenv:blueify() {
  __bashenv:colorify__ "$(bashenv:get_color blue)" "$@"
}


__bashenv:log__() (
  # shellcheck disable=SC2155
  export datetime=$(date +"${__bashenv__config__[datetime_format]}")
  export format="${__bashenv__config__[log_format]}"
  export message="$1"
  export level="$2"
  case "$level" in
    fatal) color="redify";;
    warn) color="yellowify";;
    info) color="greenify";;
  esac
  bashenv:$color "$(envsubst <<< "$format")"
)


bashenv:fatal() {
  __bashenv:log__ "$1" "fatal" >&2
  exit 1
}


bashenv:warn() {
  __bashenv:log__ "$1" "warn" >&2
}


bashenv:info() {
  __bashenv:log__ "$1" "info"
}
