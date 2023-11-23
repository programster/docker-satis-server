proc handleOutput { spawn_id user password  } {
    expect {
        {*re you sure you want to continue connecting*} {
            send "yes\n"
            handleOutput $spawn_id
        } {*Username:*} {
            send "$user\n"
            handleOutput $spawn_id $user $password
        } {*Password*} {
            send "$password\n"
            handleOutput $spawn_id $user $password
        } {*Should Subversion cache these credentials*} {
            send "no\n"
            handleOutput $spawn_id $user $password
        } {*The authenticity of host*} {
            send "yes\n"
        } {*Writing web view*} {
            sleep 1
            exit
        } timeout {
           puts "timed out"
        }
    }
}


proc updateSatis { user password } {

    cd /root
    set SCRIPT_PATH [ file dirname [ file normalize [ info script ] ] ]
    spawn /usr/bin/php "satis/bin/satis" build -- "/config/satis.json" "/var/www/html"
    handleOutput $spawn_id $user $password
}


set timeout 60


if {$argc < 2} {
    puts "Error - you need to provide at least 2 arguments"
    puts "* user"
    puts "* password"
} else {
    set user [lindex $argv 0];
    set password [lindex $argv 1];

    updateSatis $user $password
}
