#!/usr/bin/expect
set timeout -1
spawn buildozer -v android debug
expect "Accept? (y/N):"
send -- "y\n"
expect eof
lassign [wait] pid spawnid os_error_flag value
if {$os_error_flag == 0} {
    exit $value
} else {
    puts "errno: $value"
    exit 1
}
