The buildspec.yml has the following syntax:
```yaml
version: 0.2

run-as: Linux-user-name

env:
  shell: shell-tag
  variables:
    key: "value"
    key: "value"
  parameter-store:
    key: "value"
    key: "value"
  exported-variables:
    - variable
    - variable
  secrets-manager:
    key: secret-id:json-key:version-stage:version-id
  git-credential-helper: no | yes

proxy:
  upload-artifacts: no | yes
  logs: no | yes

batch:
  fast-fail: false | true
  # build-list:
  # build-matrix:
  # build-graph:
        
phases:
  install:
    run-as: Linux-user-name
    on-failure: ABORT | CONTINUE
    runtime-versions:
      runtime: version
      runtime: version
    commands:
      - command
      - command
    finally:
      - command
      - command
  pre_build:
    run-as: Linux-user-name
    on-failure: ABORT | CONTINUE
    commands:
      - command
      - command
    finally:
      - command
      - command
  build:
    run-as: Linux-user-name
    on-failure: ABORT | CONTINUE
    commands:
      - command
      - command
    finally:
      - command
      - command
  post_build:
    run-as: Linux-user-name
    on-failure: ABORT | CONTINUE
    commands:
      - command
      - command
    finally:
      - command
      - command
reports:
  report-group-name-or-arn:
    files:
      - location
      - location
    base-directory: location
    discard-paths: no | yes
    file-format: report-format
artifacts:
  files:
    - location
    - location
  name: artifact-name
  discard-paths: no | yes
  base-directory: location
  exclude-paths: excluded paths
  enable-symlinks: no | yes
  s3-prefix: prefix
  secondary-artifacts:
    artifactIdentifier:
      files:
        - location
        - location
      name: secondary-artifact-name
      discard-paths: no | yes
      base-directory: location
    artifactIdentifier:
      files:
        - location
        - location
      discard-paths: no | yes
      base-directory: location
cache:
  paths:
    - path
    - path
```


Rust:
```yaml
version: 0.2

env:
  parameter-store:
    build_ssh_key: "/build/github-deploy-key"

phases:
  pre_build:
    commands:
      - yum -y install cmake3 clang squashfs-tools
      - gem install fpm
      - ln -s /usr/bin/cmake3 /usr/bin/cmake
      - chmod 755 /usr/bin/cmake
      - mkdir -p ~/.ssh
      - echo "$build_ssh_key" > ~/.ssh/id_ed25519
      - chmod 600 ~/.ssh/id_ed25519
      - eval "$(ssh-agent -s)"
      - ssh-add ~/.ssh/id_ed25519
      - curl -sSf https://sh.rustup.rs | sh -s -- -y
      - . ~/.cargo/env
  build:
    commands:
      - echo Build started on `date`
      - cargo build --release --verbose
      - strip ./target/release/helloapp
      - cargo build
      - ./makefpm-debug
      - ./makefpm-release
  post_build:
    commands:
      - echo Build completed on `date`
artifacts:
  files:
    - ./helloapp-release.deb
    - ./helloapp-debug.deb
    - ./target/debug/helloapp
  name: $(date +%Y-%m-%d)
  discard-paths: yes
```

Rust:
```yaml
version: 0.2

phases:
  pre_build:
    commands:
      - yum -y install cmake3 clang squashfs-tools
      - gem install fpm
      - ln -s /usr/bin/cmake3 /usr/bin/cmake
      - chmod 755 /usr/bin/cmake
      - curl -sSf https://sh.rustup.rs | sh -s -- -y
      - . ~/.cargo/env
  build:
    commands:
      - echo Build started on `date`
      - cargo build --release --verbose
      - strip ./target/release/helloapp
      - ./makefpm
  post_build:
    commands:
      - echo Build completed on `date`
artifacts:
  files:
      - ./target/release/helloapp
  discard-paths: yes
  secondary-artifacts:
      rpm:
        files:
          - ./helloapp-amd64.rpm
        discard-paths: yes
      deb:
        files:
          - ./helloapp-amd64.deb
        discard-paths: yes
```

Go:
```yaml
version: 0.2

phases:
  install: 
    runtime-versions:
      golang: 1.13
    commands:
      - go get -u golang.org/x/lint/golint
      - yum -y install squashfs-tools
      - gem install fpm

  pre_build: 
    commands:
      - golint -set_exit_status
      - go test

  build:
    commands:
      - echo Build started on `date`
      - go build -o helloapp
      - ./makefpm

  post_build:
    commands:
      - echo Build completed on `date`

artifacts:
  files:
    - helloapp
    - buildspec.yml
  discard-paths: yes
  secondary-artifacts:
      rpm:
        files:
          - ./helloapp-latest-amd64.rpm
        discard-paths: yes
      deb:
        files:
          - ./helloapp-latest-amd64.deb
        discard-paths: yes
```

C: Beispiel für manuelle Paketierung ohne FPM für ein .rpm build aus einem .c file.[^3]
```yaml
version: 0.2

env:
  variables:
    build_version: "0.1"

phases:
  install:
    commands:
      - yum install rpm-build make gcc glibc -y
  pre_build:
    commands:
      - curr_working_dir=`pwd`
      - mkdir -p ./{RPMS,SRPMS,BUILD,SOURCES,SPECS,tmp}
      - filename="cbsample-$build_version"
      - echo $filename
      - mkdir -p $filename
      - cp ./*.c ./*.h Makefile $filename
      - tar -zcvf /root/$filename.tar.gz $filename
      - cp /root/$filename.tar.gz ./SOURCES/
      - cp cbsample.rpmspec ./SPECS/
  build:
    commands:
      - echo "Triggering RPM build"
      - rpmbuild --define "_topdir `pwd`" -ba SPECS/cbsample.rpmspec
      - cd $curr_working_dir

artifacts:
  files:
    - RPMS/x86_64/cbsample*.rpm
  discard-paths: yes
```

[Build environment compute types](https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html) - docs.aws.amazon.com  
Check syntax by using [yaml-validator](https://codebeautify.org/yaml-validator/). - codebeautify.org  
[Buildspec syntax](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) - docs.aws.amazon.com  

```yaml
# In order to use the folder name as defined, the semantic versioning needs to be enabled. You can do that in the Artifacts section of the CodeBuild project.
artifacts:
  files:
    - "*.whl"
  name: $(date +%Y-%m-%d)
  #discard-paths: yes
  base-directory: 'dist'
```
[Change Artifact Names](https://docs.aws.amazon.com/codebuild/latest/userguide/sample-buildspec-artifact-naming.html) - docs.aws.amazon.com  
[Change Artifact Names - first enable the option on AWS](https://stackoverflow.com/questions/65589025/how-to-store-codebuild-output-artifact-in-s3-bucket-folder-with-the-folder-name) - stackoverflow.com  
Dass der Artifact-Name verändert werden kann muss erst noch auf AWS erlaubt werden. Aber auch das geht mit Terraform. Hier ein Beispiel aus der Datei codebuild.tf:  
```json
resource "aws_codebuild_project" "helloapp" {
	
  artifacts {
    override_artifact_name = true
  }

...
```



[^3]: https://aws.amazon.com/blogs/devops/create-multiple-builds-from-the-same-source-using-different-aws-codebuild-build-specification-files/
