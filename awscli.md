Um mit dem Amazon-Server kommunizieren zu können, müssen vorher dem AWS-Client auf dem Betriebssystem die Rechte vergeben werden.
Auch wenn es oft möglich ist, dass man die Zugangsdaten manuell angeben kann, so vereinfacht die Verwendung von Profilen die Arbeit mit AWS doch sehr.  

[Installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html):
```bash
# Ubuntu repository version:
sudo apt install awscli
```

Wenn man AWS für nur ein Projekt verwendet, dann kann man das default-Profil verwenden:
```bash
aws configure
```

Andernfalls lohnt es sich direkt ein Profil anzulegen, das man später im Terraform-Projekt spezifizieren kann. Das ist besonders hilfreich, wenn man an mehreren Projekten mit unterschiedlichen Accounts gleichzeitig arbeitet, z.B. weil man unterschiedliche Instanzen betreibt um die Entwicklungsumbegung von der öffentlichen Version zu trennen. [Creating named profiles:](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html)
```bash
aws configure --profile projektc-dev
aws configure --profile projektc-prod
```

Die Einstellungsdateien sind danach zu finden unter:  
**`~/.aws/credentials`** (Linux & Mac) oder **`%USERPROFILE%\.aws\credentials`** (Windows)
```
[default]
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[projektc-dev]
aws_access_key_id=AKIAI44QH8DHBEXAMPLE
aws_secret_access_key=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY

[projektc-prod]
aws_access_key_id=AKIAI44QH8DHBEXAMPLE
aws_secret_access_key=je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
```
**`~/.aws/config`** (Linux & Mac) oder **`%USERPROFILE%\.aws\config`** (Windows)
```
[default]
region=eu-central-1

[profile projektc-dev]
region=eu-central-1

[profile projektc-prod]
region=eu-central-1
```
