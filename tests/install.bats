#!/usr/bin/env bats

@test "install with default macstrap-config works unattended" {
  run macstrap install
  [ "$status" -eq 0 ]
}
