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

