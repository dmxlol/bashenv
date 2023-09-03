utils:is_input_from_stdin() {
  [[ -p /dev/stdin ]]
}


utils:result_to_var() {
  local -n __result__="$1"
  shift
  local fifo fd slug
  slug="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13)"
  fifo="$(mktemp -u)"
  if mkfifo "$fifo"; then
    # shellcheck disable=SC2064
    trap "rm '$fifo'" EXIT INT TERM
    exec {fd}<>"$fifo"
    "$@" >&$fd 2>&1
    local result=$?
    echo -e "$slug" >&$fd
    read -ru $fd __result__
    exec {fd}<&-
    __result__="${__result__/$slug/}"
  else
    bashenv:fatal "failed to create fifo at '$fifo'"
  fi
  return $result
}
