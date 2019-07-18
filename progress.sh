acquire_build_lock() {

    lock_name="build_running_lock"
    lock="$HOME/${lock_name}"

    exec 200>${lock}

    printf "%s\n" "**************************"
    printf '%s\n' "Building"
    printf "%s\n" "**************************"

    # loop if we can't get the lock
    while true; do
        flock -n 200
        if [ $? -eq 0 ]; then
            break
        else
            printf "%c" "."
            sleep 5
        fi
    done

    # set the pid
    pid=$$
    echo ${pid} 1>&200

    printf "%s\n" "**************************"
    printf '%s\n' "Starting Build!"
    printf "%s\n" "**************************"
}

remove_build_lock() {
    printf "%s\n" "**************************"
    printf '%s\n' "Build Finished!"
    printf "%s\n" "**************************"
    exec 200>&-
}

if [ "$1" = "lock" ]; then
  acquire_build_lock
  acquire_build_lock
elif ["$1" = "unlock"]; then
  remove_build_lock
fi
