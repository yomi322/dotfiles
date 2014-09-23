#!/bin/bash

main() {
  local dir="$(cd $(dirname $0); pwd)"
  local file=
  local targ=

  for file in ${dir}/dot.*; do
    file="$(basename ${file})"
    targ="${HOME}/${file/dot/}"

    if [[ -f "${targ}" && ! -L "${targ}" ]]; then
      mv -fv "${targ}" "${targ}.orig"
    fi

    ln -fsv "${dir}/${file}" "${targ}"
  done
}

main
