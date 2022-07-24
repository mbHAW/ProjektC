# Creating Custom Systemd Service[^1]

Wir müssen eine Datei für unseren neuen Service erstellen, aber es ist ratsam, sicherzustellen, dass keine der vorhandenen Units den Namen hat, den wir unserem neuen Service geben möchten.
```bash
    # Check Services
    sudo systemctl list-unit-files --type=service

    # Check the process tree
    pstree -c
```

Danach wird die .service Datei erstellt.
```bash
    # Create service file
    sudo nano /etc/systemd/system/program_name.service

    # An example might look like this:
    [Unit]
    Description=Example Description
    Documentation=https://github.com/somewhere
    After=network.target

    [Service]
    ExecStart=/usr/bin/program_name
    Type=simple

    Restart=always
    RestartSec=10

    [Install]
    WantedBy=multi-user.target
```

Anschließend muss der Service gestartet werden.
```bash
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

Weitere Optionen für die Service-Datei:[^2]
```bash
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
```

[^1]: https://www.howtogeek.com/687970/how-to-run-a-linux-program-at-startup-with-systemd/  
https://www.devdungeon.com/content/creating-systemd-service-files  
[Creating systemd Service Files](https://youtu.be/fYQBvjYQ63U) - Youtube  
[^2]: https://www.commandlinux.com/man-page/man5/systemd.service.5.html

