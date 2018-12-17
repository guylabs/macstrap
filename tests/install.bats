#!/usr/bin/env bats

@test "install with default macstrap-config works unattended" {
  run macstrap install
  echo "Test output: "
  echo $output
  [ "$status" -eq 0 ]
}
