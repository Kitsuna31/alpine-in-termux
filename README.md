# alpine-in-termux

[![KitStudio Project](https://img.shields.io/badge/KitStudio%20Project-GitHub%20Projects-black?style=for-the-badge&logo=github&logoColor=white&labelColor=%232F2F2F)](https://github.com/Kitsuna31?tab=repositories)

## What's This?

This is a script that allows you to install Alpine Linux in your Termux application without requiring a rooted device.

## Updates

**• Updated to Alpine Linux 3.18**

## Important

**• If you encounter issues during installation or runtime, please refer to the troubleshooting steps provided below.**

---

## Features

- Lightweight Linux distribution for Termux
- Easy installation process
- Updated to the latest stable version (3.18)

---

### Installation Steps

1. Update Termux:
   ```
   apt-get update && apt-get upgrade -y
   ```
   
2. Install required packages:
   ```
   apt-get install wget proot git tar -y
   ```

3. Download the installation script:
   ```
   git clone https://github.com/Kitsuna31/alpine-in-termux.git
   ```

4. Go to the script folder:
   ```
   cd alpine-in-termux
   ```

5. Give execution permissions to the installer:
   ```
   chmod +x installer.sh
   ```

6. Run the installer:
   ```
   ./installer.sh
   ```
   note: if an error occurs during installation run ./installer.sh again and it will be fixed

7. Start Alpine Linux:
   ```
   ./startalpine.sh
   ```



---

Common Issue: proot Errors

If you encounter the following error while starting Alpine:
```
./startalpine.sh
proot warning: can't sanitize binding "alpine-fs/tmp": No such file or directory
proot warning: can't chdir("/root/.") in the guest rootfs: No such file or directory
proot info: default working directory is now "/"
proot error: '/usr/bin/env' not found (root = /data/data/com.termux/files/home/alpine-fs, cwd = /, $PATH=(null))
fatal error: see proot --help.
```

How to Fix It:

1. Check if alpine.tar.gz exists:
   ```
   ls -lh alpine.tar.gz
   ```

    note: If the file is missing or an error occurs when running ./installer.sh, please download it again that will be fix:
   ```
   wget https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/aarch64/alpine-minirootfs-3.18.0-aarch64.tar.gz -O alpine.tar.gz
   ```


2. Manually extract alpine.tar.gz to the alpine-fs directory:
```
tar -xvzf alpine.tar.gz -C alpine-fs
```

3. Reinstall Alpine:
```
./installer.sh -y
```
4. Start
```
./startalpine.sh
```

---

Credits

This project was inspired by the ubuntu-in-termux project. I would like to express my sincere gratitude to the creator of ubuntu-in-termux, MFDGaming, whose work inspired the creation of the alpine-in-termux project.

ubuntu-in-termux
https://github.com/MFDGaming/ubuntu-in-termux
