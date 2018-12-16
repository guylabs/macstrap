#!/usr/bin/env bats

@test "install with default macstrap-config works unattended" {
  run macstrap
  [ "$status" -eq 0 ]
  [ "${lines[6]}" = "                                 v 0.3.0  | |    " ]
}
