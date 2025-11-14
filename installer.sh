#!/data/data/com.termux/files/usr/bin/bash

# quick alpine installer for termux

set -e

time1="$(date +"%r")"

is_alpine_installed() {
    [ -d alpine-fs ] && [ -x alpine-fs/usr/bin/env ]
}

termux_bootstrap() {
    echo "[${time1}] updating termux packages..."
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold"
    apt-get install -y libandroid-posix-semaphore wget git proot tar openssh
}

install1() {
    directory="alpine-fs"
    ALPINE_BRANCH=3.22
    ALPINE_VERSION=3.22.2

    if is_alpine_installed; then
        echo "[${time1}] alpine already installed, skipping."
        first=1
    else
        # just checking tools
        if ! command -v proot >/dev/null; then
            echo "proot missing."
            exit 1
        fi
        if ! command -v wget >/dev/null; then
            echo "wget missing."
            exit 1
        fi
    fi

    if [ "${first-0}" != 1 ]; then
        [ -f alpine.tar.gz ] && rm -f alpine.tar.gz

        echo "[${time1}] grabbing alpine rootfs..."
        ARCHITECTURE=$(dpkg --print-architecture)
        case "$ARCHITECTURE" in
            aarch64) ARCHITECTURE=aarch64 ;;
            arm)     ARCHITECTURE=armhf ;;
            amd64|x86_64) ARCHITECTURE=x86_64 ;;
            *)
                echo "unsupported arch: $ARCHITECTURE"
                exit 1
                ;;
        esac

        wget "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_BRANCH}/releases/${ARCHITECTURE}/alpine-minirootfs-${ALPINE_VERSION}-${ARCHITECTURE}.tar.gz" \
            -q -O alpine.tar.gz || {
                echo "failed to download rootfs."
                exit 1
            }

        if [ ! -s alpine.tar.gz ]; then
            echo "rootfs file empty?"
            exit 1
        fi

        mkdir -p "$directory"
        echo "[${time1}] extracting..."
        if ! tar -xvzf alpine.tar.gz -C "$directory"; then
            echo "extract failed."
            exit 1
        fi

        # basic dns
        echo "nameserver 8.8.8.8" > "$directory/etc/resolv.conf"
        echo "nameserver 8.8.4.4" >> "$directory/etc/resolv.conf"
    fi

    echo "[${time1}] writing start script..."
    cat > startalpine.sh <<EOF
#!/bin/bash
unset LD_PRELOAD
cmd="proot --link2symlink -0 -r $directory"
cmd="\$cmd -b /dev -b /proc -b /sys -b /sdcard -w /root"
cmd="\$cmd /usr/bin/env -i HOME=/root PATH=/bin:/usr/bin TERM=\$TERM /bin/sh --login"
\$cmd
EOF

    chmod +x startalpine.sh
    echo "done. run ./startalpine.sh"
}

termux_bootstrap

if [ "${1-}" = "-y" ]; then
    install1
else
    echo -n "Install Alpine? [Y/n] "
    read cmd
    [[ "$cmd" =~ ^[Yy]$ ]] && install1 || echo "cancelled."
fi
