#!/usr/bin/env bash

# arg1: $?
# arg2: success_message
# arg3: failure_message
report_success_or_failure () {
  if [ $1 -eq 0 ]
  then
    echo
    echo $2
  else
    echo
    echo $3 >&2
  fi
}

# export -f report_success_or_failure
