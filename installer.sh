#!/data/data/com.termux/files/usr/bin/bash

# Script to install Alpine Linux in Termux
# Written with comments to help GitHub users understand each step

# Save the current time for logging purposes
time1="$(date +"%r")"

# Main function to install Alpine Linux
install1() {
    directory="alpine-fs"
    ALPINE_VERSION='3.18'

    # Check if the installation directory already exists
    if [ -d "$directory" ]; then
        first=1
        echo -e "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;227m[WARNING]:\e[0m \x1b[38;5;87m Skipping download and extraction as Alpine is already installed."
    elif [ -z "$(command -v proot)" ]; then
        echo -e "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;203m[ERROR]:\e[0m \x1b[38;5;87m Please install proot and try again."
        exit 1
    elif [ -z "$(command -v wget)" ]; then
        echo -e "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;203m[ERROR]:\e[0m \x1b[38;5;87m Please install wget and try again."
        exit 1
    fi

    # If not installed, begin the installation process
    if [ "$first" != 1 ]; then
        # Remove any previous Alpine rootfs file if it exists
        [ -f "alpine.tar.gz" ] && rm -rf alpine.tar.gz

        # Download the Alpine rootfs based on the system architecture
        echo -e "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[INFO]:\e[0m \x1b[38;5;87m Downloading Alpine rootfs..."
        ARCHITECTURE=$(dpkg --print-architecture)
        case "$ARCHITECTURE" in
            aarch64) ARCHITECTURE=arm64;;
            arm) ARCHITECTURE=armhf;;
            amd64|x86_64) ARCHITECTURE=x86_64;;
            *)
                echo -e "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;203m[ERROR]:\e[0m \x1b[38;5;87m Unsupported architecture: $ARCHITECTURE"
                exit 1
                ;;
        esac
        wget https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/releases/${ARCHITECTURE}/alpine-minirootfs-${ALPINE_VERSION}-${ARCHITECTURE}.tar.gz -q -O alpine.tar.gz
        echo -e "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[INFO]:\e[0m \x1b[38;5;87m Download complete!"

        # Extract the rootfs file
        mkdir -p $directory
        echo -e "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[INFO]:\e[0m \x1b[38;5;87m Decompressing rootfs..."
        tar -xvzf alpine.tar.gz -C $directory || {
            echo -e "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;203m[ERROR]:\e[0m \x1b[38;5;87m Extraction failed. Please verify the integrity of the rootfs file."
            exit 1
        }
        echo -e "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[INFO]:\e[0m \x1b[38;5;87m Decompression complete!"
        
        # Configure DNS for internet access in Alpine
        echo "nameserver 8.8.8.8" > $directory/etc/resolv.conf
        echo "nameserver 8.8.4.4" >> $directory/etc/resolv.conf
    fi

    # Create a start script for Alpine
    echo -e "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[INFO]:\e[0m \x1b[38;5;87m Creating start script..."
    cat > startalpine.sh <<- EOM
#!/bin/bash
unset LD_PRELOAD
command="proot"
command+=" --link2symlink -0 -r $directory"
command+=" -b /dev -b /proc -b /sys -b /sdcard -w /root"
command+=" /usr/bin/env -i HOME=/root PATH=/bin:/usr/bin TERM=\$TERM /bin/sh --login"
\$command
EOM
    chmod +x startalpine.sh
    echo -e "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;83m[INFO]:\e[0m \x1b[38;5;87m Start script created! Use './startalpine.sh' to launch Alpine."
}

# Prompt the user before starting the installation
if [ "$1" = "-y" ]; then
    install1
else
    echo -ne "\x1b[38;5;214m[${time1}]\e[0m \x1b[38;5;127m[QUESTION]:\e[0m Do you want to install Alpine Linux? [Y/n] "
    read cmd
    [[ "$cmd" =~ ^[Yy]$ ]] && install1 || echo "Installation aborted."
fi
