### [Lokales Ausführen von Builds mit dem AWS CodeBuild-Agenten](https://docs.aws.amazon.com/codebuild/latest/userguide/use-codebuild-agent.html)


#### 1. Build-Image installieren
1. Installieren von Docker auf dem lokalen Computer
	```bash
	sudo apt install docker.io
	```
2. Herunterladen des Amazon Linux 2 Docker-Images
	```bash
	docker pull public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:3.0
	```
3. Herunterladen des Agenten
	```bash
	docker pull public.ecr.aws/codebuild/local-builds:latest
	```

#### 2. Github-Projektordner holen
1. Git installieren
	```bash
	sudo apt install git
	```
2. Projektordner herunterladen
	```bash
	git clone https://github.com/mbHAW/ProjektC.git
	```
3. Zum branch 'lokal' wechseln
	```bash
	cd ProjektC          # In das Verzeichnis 'ProjektC' wechseln
	git checkout lokal   # Den aktuellen Branch wechseln
	```

#### 3. CodeBuild-Agent ausführen
1. Wechseln Sie in das übergeordnete Verzeichnis, das Ihren Projektquellordner "ProjektC" enthält.
2. Laden Sie das [codebuild_build.sh](https://github.com/aws/aws-codebuild-docker-images/blob/master/local_builds/codebuild_build.sh) Skript herunter:
	```bash
	wget https://raw.githubusercontent.com/aws/aws-codebuild-docker-images/master/local_builds/codebuild_build.sh
	chmod +x codebuild_build.sh
	```
3. Führen Sie das Skript `codebuild_build.sh` aus und geben Sie das Container-Image sowie das Ausgabeverzeichnis und das Quellverzeichnis an.
	```bash
	#./codebuild_build.sh -i <container-image> -a <output directory> -s <source directory>
	# Example:
	./codebuild_build.sh -i public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:3.0 -a /tmp/buildresult/ -s ProjektC
	```
4. Wenn alles gut geht, erhalten Sie am Ende einen Exit-Code von 0
	```bash
	echo $?
	```

