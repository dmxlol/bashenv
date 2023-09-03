utils:int_enum() {
  local i x
  for i in "${@}"; do
    readonly "${i}"=$((x++))
  done
}

utils:str_enum() {
  local i x
  for i in "${@}"; do
    readonly "${i}"="${i,,}"
  done
}

utils:enum() {
  utils:int_enum "${@}"
}
