# alpine-in-termux

[![KitStudio Project](https://img.shields.io/badge/KitStudio%20Project-GitHub%20Projects-black?style=for-the-badge&logo=github&logoColor=white&labelColor=%232F2F2F)](https://github.com/Kitsuna31?tab=repositories)

## Overview

Small script to set up Alpine Linux under Termux without root.

Currently targets **Alpine Linux 3.22.2**.

---

## Features

- Alpine userspace inside Termux (no root)
- Simple one-shot installer script
- Uses the current 3.22 stable branch

---

## Install

1. Update Termux (the installer will also do this):
   ```
   apt-get update
   DEBIAN_FRONTEND=noninteractive \
   apt-get upgrade -y \
     -o Dpkg::Options::="--force-confdef" \
     -o Dpkg::Options::="--force-confold"
   ```

2. Install package:
   ```
   apt-get install wget proot git tar openssh -y
   ```

3. Clone the repo:
   ```
   git clone https://github.com/Kitsuna31/alpine-in-termux.git
   ```

4. Enter the directory:
   ```
   cd alpine-in-termux
   ```

5. Make the installer executable:
   ```
   chmod +x installer.sh
   ```

6. Run the installer:
   ```
   ./installer.sh
   ```
   or, to skip the prompt:
   ```
   ./installer.sh -y
   ```

7. Start Alpine:
   ```
   ./startalpine.sh
   ```

---

## Troubleshooting

### `proot error: '/usr/bin/env' not found`

Example output:
```
./startalpine.sh
proot warning: can't sanitize binding "alpine-fs/tmp": No such file or directory
proot warning: can't chdir("/root/.") in the guest rootfs: No such file or directory
proot info: default working directory is now "/"
proot error: '/usr/bin/env' not found (root = /data/data/com.termux/files/home/alpine-fs, cwd = /, $PATH=(null))
fatal error: see proot --help.
```

Usually means the rootfs didn't unpack properly.

Fix:

1. Remove the broken install:
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

### `wget` fails with linker error

On some Termux setups you may see:

```
CANNOT LINK EXECUTABLE "wget": library "libandroid-posix-semaphore.so" not found: needed by ... libuuid.so in namespace (default)
```

That's a Termux environment issue, not specific to this script.

To fix it:

``` 
apt-get update
DEBIAN_FRONTEND=noninteractive \
apt-get upgrade -y \
  -o Dpkg::Options::="--force-confdef" \
  -o Dpkg::Options::="--force-confold"
apt-get install -y libandroid-posix-semaphore
apt-get install -y wget git proot tar openssh
```

Then re-run the installer.

---

## Credits

Inspired by the ubuntu-in-termux project by **MFDGaming**:

- https://github.com/MFDGaming/ubuntu-in-termux
