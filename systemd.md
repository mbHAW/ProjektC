# Service Management using Systemd[^1]
- [systemd with multiple execstart](https://github.com/mbHAW/ProjektC/blob/doc/systemd%20with%20multiple%20execstart.md)
- [systemd custom service](https://github.com/mbHAW/ProjektC/blob/doc/systemd%20custom%20service.md)

Most systemd commands can work with these unit types:  
`services, paths, slices, snapshots, sockets, swaps, targets, timers`  

Units can be written both like this `unit_name.service` or like this `unit_name`. You can usually find them at `/etc/systemd/system/` and `/usr/lib/systemd/system/`.
```bash
# Show all running services:
systemctl status

# List failed units:
systemctl --failed

# Start/Stop/Restart/Reload a service:
systemctl start|stop|restart|reload unit
systemctl reload-or-try-restart unit

# Show the status of a unit:
systemctl status unit

# Show properties of a unit:
systemctl show unit

# Enable/Disable a unit to be started on bootup:
systemctl enable|disable unit

# Mask/Unmask a unit to prevent enablement and manual activation:
systemctl mask|unmask unit

# Reload systemd, scanning for new or changed units:
systemctl daemon-reload

# Check for specific status:
systemctl is-active|is-enabled|is-failed unit

# Edit a service
systemctl edit unit --full

# showing info about the boot process
systemd-analyze
systemd-analyze blame

# Show units required and wanted by the specified units. This recursively lists units following the Requires=, Requisite=, ConsistsOf=, Wants=, BindsTo= dependencies.
# If no units are specified, default.target is implied.
systemctl list-dependencies

# List socket units currently in memory, ordered by listening address
systemctl list-sockets

# List jobs that are in progress
systemctl list-jobs

# List Service Unit Files
systemctl list-unit-files --type=service

# List all active units systemd knows about
systemctl list-units

# List all active units and filter for 'ssh'
systemctl list-units | grep ssh

# List all the loaded services including the inactive ones '--all'
systemctl list-units --all --type=service

# View the list of all available target-units with their status and a brief description
systemctl list-units --type=target --all

# Display the default target file
systemctl get-default
```

Changing System States
```bash
# Reboot the system (reboot.target)
systemctl reboot

# Power off the system (poweroff.target)
systemctl poweroff

# Put in emergency mode (emergency.target)
systemctl emergency

# Back to default target (multi-user.target)
systemctl default
```

Viewing Log Messages
```bash
# Show all collected log messages
journalctl

# See network service messages
journalctl -u network.service

# Follor messages as they appear
journalctl -f

# Show only kernel messages
journalctl -k
```

Managing sleep behavior in Ubuntu
```bash
# Confirm Sleep Status with systemd
systemctl status sleep.target

# Disable Sleep in Ubuntu with systemd
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# (re) Enabling Sleep in Ubuntu with systemctl
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```


[^1]: https://www.freedesktop.org/software/systemd/man/systemctl.html  
https://www.commandlinux.com/man-page/man5/systemd.service.5.html  
https://linuxhandbook.com/systemd-list-services/  
https://www.flatcar-linux.org/docs/latest/setup/systemd/  
https://www.freedesktop.org/software/systemd/man/systemd.service.html  
https://www.linode.com/docs/guides/start-service-at-boot/  
https://crunchify.com/systemd-upstart-respawn-process-linux-os/  
https://cdn.crunchify.com/wp-content/uploads/2017/10/Linux-Systemd-Command-CheatSheet.png  
https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units  
https://www.systutorials.com/change-systemd-boot-target-linux/  
https://documentation.suse.com/smart/linux/html/reference-managing-systemd-targets-systemctl/index.html  
https://www.computernetworkingnotes.com/linux-tutorials/systemd-target-units-explained.html  
https://unix.stackexchange.com/questions/126009/cause-a-script-to-execute-after-networking-has-started/126146#126146  
