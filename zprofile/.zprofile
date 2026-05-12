if [[ "$(tty)" == "/dev/tty1" ]]; then
    # exec sway
    exec dbus-run-session sway
fi

