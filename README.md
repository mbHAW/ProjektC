### [Run builds locally with the AWS CodeBuild agent](https://docs.aws.amazon.com/codebuild/latest/userguide/use-codebuild-agent.html)


#### Set up the build image
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

#### Run the CodeBuild agent
1. Change to the directory that contains your project source folder
2. Download the [codebuild_build.sh](https://github.com/aws/aws-codebuild-docker-images/blob/master/local_builds/codebuild_build.sh) script:
	```bash
	wget https://raw.githubusercontent.com/aws/aws-codebuild-docker-images/master/local_builds/codebuild_build.sh
	chmod +x codebuild_build.sh
	```
3. Run the `codebuild_build.sh` script and specify your container image and the output directory and the source directory
	```bash
	#./codebuild_build.sh -i <container-image> -a <output directory> -s <source directory>
	# Example:
	./codebuild_build.sh -i public.ecr.aws/codebuild/amazonlinux2-x86_64-standard:3.0 -a /tmp/buildresult/ -s project-directory
	```
4. If all goes well you’ll get an exit code of 0 at the end
	```bash
	echo $?
	```

