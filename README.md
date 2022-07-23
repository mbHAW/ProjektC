### [Lokales Ausführen von Builds mit dem AWS CodeBuild-Agenten](https://docs.aws.amazon.com/codebuild/latest/userguide/use-codebuild-agent.html)


#### 1. Build-Image installieren
1. Installing Docker on your local machine
	```bash
	sudo apt install docker.io
	```
2. Downloading the Amazon Linux 2 Docker Image
	```bash
	docker pull public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:3.0
	```
1. Downloading the agent
	```bash
	docker pull public.ecr.aws/codebuild/local-builds:latest
	```

#### 2. Github-Projektordner holen

```bash
sudo apt install git    # Git installieren
git clone https://github.com/mbHAW/ProjektC.git     # Projektordner herunterladen
git checkout lokal      # Zum branch 'lokal' wechseln
cd ..                   # Aus dem Projektordner zum übergeordneten Ordner wechseln
```

#### 3. CodeBuild-Agent ausführen
1. (Sofern nocht nicht geschehen) In das Verzeichnis wechseln, das den Projektquellordner "ProjektC" enthält
2. Download the [codebuild_build.sh](https://github.com/aws/aws-codebuild-docker-images/blob/master/local_builds/codebuild_build.sh) script:
	```bash
	wget https://raw.githubusercontent.com/aws/aws-codebuild-docker-images/master/local_builds/codebuild_build.sh
	chmod +x codebuild_build.sh
	```
3. Run the `codebuild_build.sh` script and specify your container image and the output directory and the source directory
	```bash
	#./codebuild_build.sh -i <container-image> -a <output directory> -s <source directory>
	# Example:
	./codebuild_build.sh -i public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:3.0 -a /tmp/buildresult/ -s ProjektC
	```
4. If all goes well you’ll get an exit code of 0 at the end
	```bash
	echo $?
	```

