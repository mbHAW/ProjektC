# Dokumentation

## Projekttitel
Infrastruktur als Code - Automatische Kompilierung und Paketierung eines Programms aus Quellcode mit Hilfe von AWS und Terraform

## Erläuterungen zum  Projekt
Erstellung eines Terraform-Projektes, das selbstständig einen Quellcode kompiliert und zu einem Debian-Installationspaket verpackt.  
Vorkenntnisse sind der allgemeine Umgang mit dem Linux-Betriebssystems und der Kommandozeile Bash.  
Im Zentrum des Projekts stehen der Terraform Programmcode, Codebuild und die Erstellung von Installationspaketen für Linux.

Ein in C, Rust oder Go geschriebenes Programm soll kompiliert werden und automatisch direkt in einem Installationspaket (deb, rpm) verpackt werden.
Das soll möglichst vollständig auf dem AWS-Server ablaufen können, der sich selbstständig die Quelldateien von einem Gibhub-Repository holt und auf diese Weise immer mit der aktuellesten Version arbeitet.

Für eine bessere thematische Trennung und auch der Übersichtlichkeit wegen ist dieses Repository in drei Branches unterteilt.

1. In dem aktuellen Branch **main** befinden sich die Quelldateien mitsamt dem Terraform-Ordner. Dieser wird benötigt um das Projekt auf dem Amazon-Server zu deployen.
2. Der Branch **[doc](https://github.com/mbHAW/ProjektC/tree/doc)** enthält die ausführliche Dokumentation zu den einzelnen Unterthemen.
3. Der Branch **[lokal](https://github.com/mbHAW/ProjektC/tree/lokal)** enthält Dateien und Anleitung für einen Codebuild-Testrun auf dem lokalen PC. Der kompabilität wegen wird dafür ein Docker-Container verwendet, den Amazon für diesen Zweck bereitstellt.

Als Testprogramm wird hier ein kleiner Go-Server verwendet.
```go
package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", HelloServer)
	http.ListenAndServe(":8080", nil)
}

// HelloServer expose endpoint to greet
func HelloServer(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello %s!", r.URL.Path[1:])
}
```

Codebuild kompiliert dieses Script und erstellt ein Installationspaket, das mit dem folgenden Kommandozeilenbefehl installiert werden kann:
```bash
# Debian, Ubuntu, Linux Mint
sudo apt install ./helloapp-latest-amd64.deb
# Fedora
sudo dnf install ./helloapp-latest-amd64.rpm
# RedHat
sudo yum install ./helloapp-latest-amd64.rpm
# openSUSE
sudo zypper install ./helloapp-latest-amd64.rpm
```

Um den Aktivitätsstatus vom Server einzusehen, eignet sich der Kommandozeilenbefehl
```bash
systemctl status helloapp.service
```
Eventuell muss man den Service[^1] erst noch mit `systemctl start helloapp.service` aktivieren. Das kann von Betriebssystem zu Betriebssystem variieren.
Natürlich könnte man das Executable auch direkt mit dem Befehl `helloapp` starten, da es in dem Dateipfad `/usr/bin/` liegt und daher von der PATH-Variable des Betriebssystems erkannt wird.

Um den Server aufzurufen, gibt man einfach `localhost:8080/ausgedachter Benutzername` in die URL-Zeile des eigenen Webbrowsers ein. Im Browserfenster sollte nun `Hello ausgedachter Benutzername` erscheinen.

Um den Server wieder von dem Betriebssystem zu löschen, verwende einfach folgenden Befehl:
```bash
sudo apt purge helloapp
```

[^1]: https://github.com/mbHAW/ProjektC/blob/doc/systemd.md
