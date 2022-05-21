- [deb](https://github.com/mbHAW/ProjektC/blob/doc/deb.md)
- [systemd](https://github.com/mbHAW/ProjektC/blob/doc/systemd.md)

Das Programm "FPM" reduziert den Arbeitsaufwand für die Erstellung von Installationspaketen enorm, da man sich nur noch auf den Inhalt konzentrieren muss und nicht auf Unterschiede und Eigenheiten zwischen Betriebssystemen.
FPM wird inzwischen von vielen Entwicklerstudios verwendet. Z.B. von InfluxData für die Kompilierung von [Telegraf](https://github.com/influxdata/telegraf/blob/577c0462b8a0c0f98e822672091d9cf6916427d9/Makefile) in unterschiedliche Formate gleichzeitig.
Das Anlegen einer Ordnerstruktur ist ebenfalls nicht nötig. Alle Quelldateien werden zusammen in einen Ordner gelegt und das Programm FPM von dort aus gestartet.

### Installation

```bash
# RedHat based distros (sometimes 'dnf' instead of 'yum')
yum update
yum install -y squashfs-tools
gem install fpm
fpm --version

# Just to feel save that all rpm-build packages are installed
yum install -y rpm-build
yum install -y rpm* gcc gpg* rng-tools
```

```bash
# Ubuntu/Debian based distros
apt update
apt install squashfs-tools
gem install fpm
fpm --version

# On Ubuntu you will need the rpm library to create rpm packages
apt install rpm

# If the program can't be found, then it's possible that the PATH variable just hasn't been updated yet. See `echo $PATH`
# You can either restart the system or just reload the .profile file `source ~/.profile`
```

```bash
# For OSX/macOS:
brew install rpm squashfs
gem install fpm
fpm --version
```

### Benutzung
```bash
#!/bin/bash
# https://fpm.readthedocs.io/en/latest/cli-reference.html
# Value 1: program-name
# Value 2: architecture -> valid values are: x86_64/amd64, aarch64, native (current architecture), all/noarch/any

PROGRAM_NAME=helloapp
ARCH=amd64
#ARCH=${uname -m}
#ARCH=${dpkg --print-architecture}

# Debian/Ubuntu
fpm --force \
  --log info \
  --architecture ${ARCH} \
  --input-type dir \
  --output-type deb \
  --package ${PROGRAM_NAME}-latest-${ARCH}.deb \
  --name ${PROGRAM_NAME} \
  --version 0.1.0 \
  --license MIT \
  --description "${PROGRAM_NAME}" \
  --maintainer "The Maintainer" \
  --url "https://www.the_maintainer.de/" \
  --deb-systemd ${PROGRAM_NAME}.service \
  --deb-systemd-enable \
  --deb-systemd-auto-start \
  --after-remove post-remove.sh \
  --before-install pre-install.sh \
  ${PROGRAM_NAME}=/usr/bin/${PROGRAM_NAME} \
  config.json=/etc/${PROGRAM_NAME}/config.json

# Fedora/RedHat/openSUSE
fpm --force \
  --log info \
  --architecture ${ARCH} \
  --input-type dir \
  --output-type rpm \
  --package ${PROGRAM_NAME}-latest-${ARCH}.rpm \
  --name ${PROGRAM_NAME} \
  --version 0.1.0 \
  --license MIT \
  --description "${PROGRAM_NAME}" \
  --maintainer "The Maintainer" \
  --url "https://www.the_maintainer.de/" \
  --after-remove post-remove.sh \
  --before-install pre-install.sh \
  ${PROGRAM_NAME}=/usr/bin/${PROGRAM_NAME} \
  config.json=/etc/${PROGRAM_NAME}/config.json \
  ${PROGRAM_NAME}.service=/etc/systemd/system/${PROGRAM_NAME}.service

# Installation using the console on:
# - Debian: sudo apt install ./helloapp-latest-amd64.deb
# - Ubuntu: sudo apt install ./helloapp-latest-amd64.deb
# - Fedora: sudo dnf install ./helloapp-latest-amd64.rpm
# - RedHat: sudo yum install ./helloapp-latest-amd64.rpm
# - openSUSE: sudo zypper install ./helloapp-latest-amd64.rpm
```
**Notiz:** Die fpm-Zeile für das Binary wird in der codebuild-Version dann manchmal auch so aussehen `target/release/${PROGRAM_NAME}=/usr/bin/${PROGRAM_NAME} \`. Je nach Projekt kann der Zielordner für das fertige Binary ein anderer sein.

#### post-remove.sh
```bash
userdel helloapp >/dev/null || true
```

#### pre-install.sh
```bash
if ! id helloapp &>/dev/null; then
    useradd helloapp -s /sbin/nologin -M
fi
```

#### [[systemd|helloapp.service]]
```bash
[Unit]
Description=Example Description
Documentation=https://github.com/somewhere
ConditionPathExists=/etc/helloapp/config.json
After=network.target

[Service]
ExecStart=/usr/bin/helloapp
Type=simple
User=helloapp
Group=helloapp

Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### Links:
https://fpm.readthedocs.io/en/latest/index.html  
https://fpm.readthedocs.io/en/latest/installation.html  
https://fpm.readthedocs.io/en/latest/cli-reference.html  
https://github.com/jordansissel/fpm  
https://www.digitalocean.com/community/tutorials/how-to-use-fpm-to-easily-create-packages-in-multiple-formats  

