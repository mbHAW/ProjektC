# Service Management using systemd and systemctl
- [systemd with multiple execstart](https://github.com/mbHAW/ProjektC/blob/doc/systemd%20with%20multiple%20execstart.md)

```bash
    # showing info about the boot process
    systemd-analyze
    systemd-analyze blame

    # listing all active units systemd knows about
    systemctl list-units
    systemctl list-units | grep ssh

    # listing Service Unit Files
    systemctl list-unit-files --type=service

    # listing all the loaded services including the inactive ones '--all'
    systemctl list-units --all --type=service

    # checking the status of a service
    sudo systemctl status nginx.service

    # stopping a service
    sudo systemctl stop nginx

    # starting a service
    sudo systemctl start nginx

    # restarting a service
    sudo systemctl restart nginx

    # reloading the configuration of a service
    sudo systemctl reload nginx
    sudo systemctl reload-or-restart nginx

    # enabling to start at boot time
    sudo systemctl enable nginx

    # disabling at boot time
    sudo systemctl disable nginx

    # checking for specific status
    sudo systemctl is-active nginx
    sudo systemctl is-enabled nginx
    sudo systemctl is-failed nginx

    # masking a service (stopping and disabling it)
    sudo systemctl mask nginx

    # unmasking a service
    sudo systemctl unmask nginx

    # edit a service
    sudo systemctl edit nginx --full

    # view the list of all available target-units with their status and a brief description
    systemctl list-units --type=target --all
```

```bash
    # Confirm Sleep Status with systemd
    systemctl status sleep.target

    # Disable Sleep in Ubuntu with systemd
    sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

    # (re) Enabling Sleep in Ubuntu with systemctl
    sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```

```bash
    # Creating Custom Systemd Service
    # https://www.howtogeek.com/687970/how-to-run-a-linux-program-at-startup-with-systemd/
    # https://www.devdungeon.com/content/creating-systemd-service-files
    # https://youtu.be/fYQBvjYQ63U

    # We need to create a unit file for our new service, but it is prudent to make sure none of the existing unit files have the name we want to give our new service.
    sudo systemctl list-unit-files --type=service

    # Create service file
    sudo nano /etc/systemd/system/program_name.service

    ### An example might look like this:
    [Unit]
    Description=Crunchify Java Process Restart Upstart Script
    After=auditd.service systemd-user-sessions.service time-sync.target
 
    [Service]
    EnvironmentFile=-/etc/default/crunchify
    User=root
    TimeoutStartSec=0
    Type=simple
    KillMode=process
    WorkingDirectory=/tmp/crunchify
    ExecStart=/opt/java/jdk-9/bin/java -cp /tmp/crunchify CrunchifyAlwaysRunningProgram
    Restart=always
    RestartSec=2
    LimitNOFILE=5555
 
    [Install]
    WantedBy=multi-user.target
    
    ### Or just like this.
    [Service]
    ExecStart=/usr/local/bin/program.sh

    # Tipp: "ExecStart=infinite-loop-script.sh"
    # using a script to start other programs gives you more room for long execution lines or multiple line instructions. Stopping the script will usually also stop the programs.
    # check the process tree with the "pstree -c" command.

    ### Further Options (https://www.commandlinux.com/man-page/man5/systemd.service.5.html)
    # Description: This is a text description of your service.
    # Wants:       Our service wants — but doesn’t require — the network to be up before our service is started.
    # After:       A list of unit names that should be started after this service has been successfully started, if they’re not already running.
    # Type:        Simple. systemd will consider this service started as soon as the process specified by ExecStart has been forked.
    # ExecStart:   The path to the process that should be started.
    # Restart:     When and if the service should be restarted. no, on-success, on-failure, on-abnormal, on-watchdog, on-abort, or always
    # RestartSec:  How long to wait before attempting to restart the service. This value is in seconds.
    # KillMode:    Defines how systemd should kill the process if we ask systemctl to stop the service. “process” causes systemd to use the SIGTERM signal on the main process only.
    #              If our service was a non-trivial program instead of a simple script, we would set this to “mixed” to ensure that any spawned processes were also terminated.
    # WantedBy:    We have this set to “multi-user.target”, which means the service should be started as long as the system is in a state where multiple users can log in,
    #              whether or not a graphical user interface is available.

    # Give the owner read and write permissions, and read permissions to the group. Others will have no permissions.
    sudo chmod 640 /etc/systemd/system/program_name.service

    # Check status
    systemctl status program_name.service

    # However (using telegraf as an example), even if your service is running, it does not guarantee that it is correctly sending data to InfluxDB.
    # To verify it, check your journal logs.
    sudo journalctl -f -u telegraf.service

    # When you add a new unit file or edit an existing one, you should tell systemd to reload the unit file definitions.
    sudo systemctl daemon-reload

    # If you want a service to be launched at startup you must enable it
    sudo systemctl enable program_name

    # Start the service
    sudo systemctl start program_name

    # (Optional) After manually starting the service or after rebooting the computer, we can verify that our service is running correctly
    sudo systemctl status program_name.service
```

## Links
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
