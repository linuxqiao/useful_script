#!/usr/bin/expect
# auto ssh login beaker machine with root

set timeout 120
set PASSWORD {Qiao_2013}
set USER root
set SERVER [lindex $argv 0]
spawn ssh -X -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -l $USER $SERVER
expect {
    "password:" { send "${PASSWORD}\r" }
    "*#" {send "\r"}
}
expect {
    "password:" { send "redhat\r" }
    "*#" {send "\r"}
}
expect {
    "password:" { send "fo0m4nchU\r" }
    "*#" {send "\r"}
}
expect {
    "password:" { send "hatred\r" }
    "*#" {send "\r"}
}
interact
