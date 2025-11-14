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

1. Update Termux and upgrade packages (recommended non-interactive):
   ```
   apt-get update
   DEBIAN_FRONTEND=noninteractive \
   apt-get upgrade -y \
     -o Dpkg::Options::="--force-confdef" \
     -o Dpkg::Options::="--force-confold"
   ```

2. Make sure core tools are installed:
   ```
   apt-get install wget proot git tar openssh -y
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

6. Run the installer (interactive):
   ```
   ./installer.sh
   ```
   or non-interactively (no prompt):
   ```
   ./installer.sh -y
   ```

7. Start Alpine Linux:
   ```
   ./startalpine.sh
   ```

---

### Common Issues

#### 1) `proot error: '/usr/bin/env' not found`

If you encounter the following error while starting Alpine:
```
./startalpine.sh
proot warning: can't sanitize binding "alpine-fs/tmp": No such file or directory
proot warning: can't chdir("/root/.") in the guest rootfs: No such file or directory
proot info: default working directory is now "/"
proot error: '/usr/bin/env' not found (root = /data/data/com.termux/files/home/alpine-fs, cwd = /, $PATH=(null))
fatal error: see proot --help.
```

This usually means the Alpine rootfs did not extract correctly or is incomplete.

How to Fix It:

1. Clean the broken install (this removes the existing Alpine rootfs):
   ```
   rm -rf alpine-fs alpine.tar.gz startalpine.sh
   ```

2. Re-run the installer:
   ```
   ./installer.sh
   ```
   or:
   ```
   ./installer.sh -y
   ```

3. Start Alpine again:
   ```
   ./startalpine.sh
   ```

#### 2) Termux `wget` cannot start (linker error)

On some Termux setups you may see:

```
CANNOT LINK EXECUTABLE "wget": library "libandroid-posix-semaphore.so" not found: needed by ... libuuid.so in namespace (default)
```

This is a Termux environment issue (not specific to this script). Make sure your Termux is fully upgraded and install the missing library:

``` 
apt-get update
DEBIAN_FRONTEND=noninteractive \
apt-get upgrade -y \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold"
apt-get install -y libandroid-posix-semaphore
apt-get install -y wget git proot tar openssh
```

Then re-run the installer steps from above.

---

Credits

This project was inspired by the ubuntu-in-termux project. I would like to express my sincere gratitude to the creator of ubuntu-in-termux, MFDGaming, whose work inspired the creation of the alpine-in-termux project.

ubuntu-in-termux
https://github.com/MFDGaming/ubuntu-in-termux
