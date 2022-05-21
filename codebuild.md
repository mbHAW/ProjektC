# AWS CodeBuild[^1]
- [fpm](https://github.com/mbHAW/ProjektC/blob/doc/fpm.md)
- [awscli](https://github.com/mbHAW/ProjektC/blob/doc/awscli.md)
- [terraform](https://github.com/mbHAW/ProjektC/blob/doc/terraform.md)
- [buildspec.yml](https://github.com/mbHAW/ProjektC/blob/doc/buildspec.md)

### About:
- [AWS CodeBuild Tutorial](https://youtu.be/qGgNyOkZEb0) Stephane Maarek - Youtube
- [Why Run Terraform inside AWS Codebuild](https://github.com/giuseppeborgese/run-terraform-inside-aws-codebuild) - github.com
- [Resource: aws_codebuild_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project) - registry.terraform.io
- [All the AWS CodeBuild You Can Stomach in 45 Minutes](https://youtu.be/yCVR-uqc4qk) - Youtube, [Github Code mit PDF-Präsentation](https://github.com/krimple/ptw-2020-codebuild-sample) - Github
- A cloud-based application builder
- Warum am Besten immer erst lokal ausprobieren?
Weil man so rechtzeitig Bugs diagnostizieren kann, bevor der Buildprozess auf Amazon Geld kostet und man erst danach merkt, dass etwas noch nicht funktioniert.
https://aws.amazon.com/codebuild/pricing/
- Als nachteilig ist z.B. die fehlende Unsterstützung für die Kompilierung von C# Scripten zu erwähnen. Diese werden von aws codebuild, zumindest von Haus aus, noch nicht unterstützt. Githubs CodeBuild-Alternative wiederum unterstützt auch C#, wodurch es für einige Entwickler vielleicht attraktiver erscheint, als AWS Services. Allerdings hat man natürlich nicht immer die Möglichkeit über die Wahl der Werkzeuge zu entscheiden, wenn die eigene Firma bereits Lizenzen für das eine oder andere Tool besitzt. Für die meisten Anwendungsfälle ist AWS allerdings ein hervorragendes Produkt. [Using GitHub Actions vs {AWS CodeBuild, CodePipeline and CodeDeploy} | Cloud Posse Explains](https://youtu.be/lV3BV5bkCj4) - Youtube
- Auch interessant: [CICD](https://youtu.be/N9KbmHhesmE)

### [Run builds locally with the AWS CodeBuild agent](https://docs.aws.amazon.com/codebuild/latest/userguide/use-codebuild-agent.html)
Wenn ich hier (Link von der Überschrift) ganz links durch die Abschnitte klicke, dann bekomme ich eigentlich alle Infos, die ich für CodeBuild in der Dokumentation benötige.
Einschließlich Erklärungsgrafiken: https://docs.aws.amazon.com/codebuild/latest/userguide/images/arch.png

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

___


### [buildspec.yml](https://github.com/mbHAW/ProjektC/blob/doc/buildspec.md)

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
    - ./helloapp-latest-amd64.rpm
    - ./helloapp-latest-amd64.deb
  discard-paths: yes
```

___

## Der Ordner "terraform-build" mit den [Terraform](https://github.com/mbHAW/ProjektC/blob/doc/terraform.md)-Dateien ist für das Deployment auf dem Remote-Server nötig. Für den lokalen Test mit Docker braucht man diesen allerdings nicht!
- [codebuild.tf](#codebuildtf)
- [iam.tf](#iamtf2)
- [main.tf](#maintf)
- [s3.tf](#s3tf)
- [vars.tf](#varstf)

### codebuild.tf
[CodeBuild-Type-ProjectArtifacts-packaging](https://docs.aws.amazon.com/codebuild/latest/APIReference/API_ProjectArtifacts.html#CodeBuild-Type-ProjectArtifacts-packaging) - docs.aws.amazon.com  
[Can AWS CodeBuild output unzipped artifacts?](https://stackoverflow.com/questions/57336854/can-aws-codebuild-output-unzipped-artifacts) - stackoverflow.com  
In diesem Fall (packaging = "NONE") und wenn mans tatsächlich auf AWS laufen lässt, dann braucht man auch keine secondary-artifacts mehr. Einfach alles zusammen packen. Es wird ja jetzt nicht mehr gezippt und liegt einfach alles nebeneinander.  
[How to set 'Source version' for AWS CodeBuild project in Terraform](https://stackoverflow.com/questions/58800912/how-to-set-source-version-for-aws-codebuild-project-in-terraform) - stackoverflow.com  
[Source version sample with AWS CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/sample-source-version.html) - docs.aws.amazon.com

```terraform
resource "aws_codebuild_project" "helloapp" {
  name         = "helloapp"
  service_role = aws_iam_role.builder_role.arn

  artifacts {
    type                   = "S3"
    location               = aws_s3_bucket.artifact_bucket.id
    packaging              = "NONE"
    override_artifact_name = true
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/myHAW/helloapp.git"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }

  source_version = "main"
}

data "aws_ssm_parameter" "github_access_token" {
  name = "/build/github-access-token"
}

resource "aws_codebuild_source_credential" "github_credential" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = data.aws_ssm_parameter.github_access_token.value
}
```
Die Angabe `source_version = "main"` bezieht sich auf den Github-Branch. Man könnte hier beispielsweise auch einen Branch `dev` verwenden.


### iam.tf[^2]
```terraform
resource "aws_iam_role" "builder_role" {
  name = "helloapp-builder"

  assume_role_policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "codebuild.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "builder_policy" {
  name = "helloapp-builder"
  role = aws_iam_role.builder_role.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
              "ssm:GetParameters"
            ],
            "Resource": [
                "arn:aws:ssm:eu-central-1:${var.account_id}:parameter/build/*"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
              "arn:aws:s3:::projektc-${var.environment}-helloapp-builds",
              "arn:aws:s3:::projektc-${var.environment}-helloapp-builds/*"
            ],
            "Action": [
                "s3:*"
            ]
        }
    ]
}
  EOF
}
```

Alternativ sollte eigentlich auch reichen: (dann braucht man auch die Variable *"account_id"* nicht mehr)
```terraform
resource "aws_iam_role" "builder_role" {
  name = "helloapp-builder"

  assume_role_policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "codebuild.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "builder_policy" {
  name = "helloapp-builder"
  role = aws_iam_role.builder_role.id

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": "*",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
              "arn:aws:s3:::projektc-${var.environment}-helloapp-builds",
              "arn:aws:s3:::projektc-${var.environment}-helloapp-builds/*"
            ],
            "Action": [
                "s3:*"
            ]
        }
    ]
}
  EOF
}
```

### main.tf
```terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.10.0"
    }
  }

  backend "s3" {
    encrypt        = true
    key            = "helloapp-build/terraform.state"
    bucket         = "projektc-dev-terraform-state"
    dynamodb_table = "terraform-state-lock"
    region         = "eu-central-1"
    profile        = "projektc-dev"
  }
}

provider "aws" {
  profile = "projektc-dev"
  region  = "eu-central-1"
}
```

### s3.tf
```terraform
resource "aws_s3_bucket" "artifact_bucket" {
  bucket = "projektc-${var.environment}-helloapp-builds"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "artifact_bucket" {
  bucket = aws_s3_bucket.artifact_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

### vars.tf
```terraform
variable "environment" {
  type    = string
  default = "dev"
}

variable "account_id" {
  type    = string
  default = "121212121212"
}
```

### .gitignore
```bash
# files to ignore
.terraform
*.tfstate

# except this file
!.gitignore
```

___

## Ordnerstruktur des vollständigen Projekts:
```sh
ProjektC/
├── buildspec.yaml
├── config.json
├── helloapp.service
├── main.go
├── makefpm
├── post-remove.sh
├── pre-install.sh
└── terraform-build
    ├── codebuild.tf
    ├── iam.tf
    ├── main.tf
    ├── s3.tf
    ├── vars.tf
    └── .gitignore
```


## Erstellungsprozess auf AWS mit Terraform

#### Voraussetzungen:
Gehe zur Webseite https://console.aws.amazon.com/  
![menu.png](pics/menu.png)

**Auf dem AWS-Server müssen ein paar Voreinstellungen getroffen worden sein:**  
- Der AWS-Account muss erstellt worden sein und auch ein *"IAM Benutzer"* mit vorzugsweise beschränkten Rechten angelegt worden sein. Gib dafür *"iam"* in die AWS-Suchzeile ein und wähle "Identity and Access Management (IAM)" aus. Unter dem Reiter *"Users"* kann man einen neuen Benutzer anlegen. Danach logt man sich mit dem neuen Benutzer (oder mit dem alten Administrator-Benutzer) auf der Webkonsole erneut ein und gelangt dann über einen Mausklick auf den Benutzernamen (rechts oben) zu dem Menüpunkt *"Security credentials"*. Dort einmal draufgeklickt, öffnet sich die Seite *"My security credentials"*, auf der sich neue *"access keys"* für die Verwendung von AWS-CLI und Terraform erstellen lassen.
    ![accesskey.png](pics/accesskey.png)
Das Profil wird anschließend auf dem PC des Benutzers mit Hilfe des [AWS-Clienten](https://github.com/mbHAW/ProjektC/blob/doc/awscli.md) angelegt, damit der Benutzer diese Daten nicht jedes Mal erneut angeben muss.
Terraform benutzt dann das angelegte Profil um sich auf AWS zu verifizieren. (Siehe main.tf)

- Ein S3-Bucket mit dem Namen *"projektc-dev-terraform-state"* für das State-File *"terraform.tfstate"* muss erstellt werden. (Siehe main.tf)
    ![buckets.png](pics/buckets.png)

- Eine DynamoDB-Tabelle *"terraform-state-lock"* mit dem Partition key *"LockID"* sollte vorher erstellt werden. (Siehe main.tf)
    ![dynamoDB.png](pics/dynamoDB.png)

- Damit CodeBuild auf die Projektdateien auf dem Github-Account zugreifen kann muss zuerst ein [personal-access-token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token) auf Github erstellt werden. Um CodeBuild das Token mitzuteilen, gib in die AWS-Suchzeile "ssm" ein und wähle den Service "Systems Manager" aus. Unter dem Reiter "Parameter Store" lässt sich nun der Github-Token eingeben.
    ![github_access_token.png](pics/github_access_token.png)


#### Erste Projektinitialisierung:
In dem Projektordner befindet sich ein Ordner *"terraform-build"*, der alle Terraformdateien enthält. In diesen wechseln wir nun zuerst hinein.  
Das Erste, was wir tuen müssen, ist das Projekt zu initialisieren. Ganz ähnlich, wie es auch bei der Erstellung eines neuen Githubprojekts gemacht wird:
```bash
terraform init
```

Ist das Projekt initialisiert, können wir den aktuellen Projektstand jetzt auf den Server anwenden.
```bash
terraform apply
```
Der Befehl ist dabei zum Glück recht ungefährlich, da alle neuen Veränderungen, die durch die Terraform-Dateien bewirkt werden sollen, zuerst in der Konsole angezeigt werden und eine Bestätigung durch den Benutzer erwartet wird, bevor tatsächlich etwas zum Server gesendet wird. Für weitere Terraform-Befehle siehe [hier](https://github.com/mbHAW/ProjektC/blob/doc/terraform.md).
Wurde kein Remote-S3-Container für die Speicherung der Datei *"terraform.tfstate"* angegeben, so wird diese lokal im Ordner *"terraform-build"* erstellt.
Dabei ist zu beachten, dass man das State-File möglichst niemals auf Github mitveröffentlicht, da diese Datei sensible Daten enthält. Am einsfachsten ist es da, eine *".gitignore"*-Datei im Projektordner anzulegen, die die Zeile `.terraform` enthält (s.o.). Damit wird dieser Ordner von Git ignoriert.

Das Projekt wurde jetzt automatisch auf dem AWS-Server erstellt und CodeBuild sollte sich ganz einfach über einen Klick auf den *"Start build"*-Button in der Webansicht starten lassen. Das kompilierte Programm liegt danach in dem dafür eigens generierten S3-Bucket. CodeBuild holt sich ab jetzt bei jedem Build immer den jeweils aktuellsten Stand aus dem Github-Repository.
![codebuild.png](pics/codebuild.png)

## Anlegen von Workspaces[^3] (optional)
Workspaces sind teilweise vergleichbar mit der Idee von Branches auf Github. Durch die Nutzung von einem Workspace "dev" und einem Workspace "prod" lassen sich die Arbeitsumgebungen "Entwicklung" und "Produktion/Release" in unterschiedliche Accounts trennen, allerdings mit dem Vorteil, dass man nicht für jeden Account einen eigenen Projektordner anlegen muss. Die Dateien bleiben ja die Selben. Nur der Destinationsort auf dem Server ist ein anderer. (Der Workspace "default" ist übrigens immer da und lässt sich auch nicht löschen.)
Der einzige Unterschied zwischen diesen Umgebungen sind dabei lediglich das State-File und die Variablenwerte.
```bash
# Erstellung von Workspace "dev"
terraform state pull > default.tfstate   # Erstelle eine Datei mit dem Abbild aus dem aktiven State auf dem Remote Server
terraform workspace new dev              # Erstelle einen neuen Workspace mit der Bezeichnung 'dev' und wähle diesen aus
terraform state list                     # Liste den aktuellen State in dem neuen Workspace. Erwartet wird eine leere Ausgabe, da noch nichts enthalten sein sollte
terraform state push default.tfstate     # Kopiere den State aus der Datei in den aktuellen dev-Workspace
terraform state list                     # Kontrolle: jetzt sollte etwas angezeigt werden
terraform apply -var-file=dev.tfvars     # Den Variablen in 'dev.tfvars' können andere Daten zugewiesen werden als in 'prod.tfvars' - ob man nun zum Development-Account applied oder zum Production-Account kann man so sauber voneinander trennen.
terraform workspace select default       # Gehe zum Workspace 'default' zurück
terraform state list | xargs -n 1 terraform state rm   # Lösche alle State-Daten aus dem Workspace 'default'
rm default.tfstate                       # Lösche das manuell erzeugt State-File
```
Es wird allerdings im Internet häufig lieber empfohlen, dass man Produktions- und Entwicklungsumgebung möglichst immer strikt voneinander trennt. Also je einen Account für die Entwicklung und für die Produktion und zudem getrennte Ordner für die Dateien beider Umgebungen.





[^1]: https://docs.aws.amazon.com/de_de/codebuild/latest/userguide/welcome.html Was ist AWS Codebuild?
[^2]: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project
[^3]: https://stackoverflow.com/questions/66979732/in-terraform-is-it-possible-to-move-to-state-from-one-workspace-to-another https://dev.to/igordcsouzaaa/migrating-resources-from-the-default-workspace-to-a-new-one-3ojc https://docs.aws.amazon.com/workspaces/latest/adminguide/amazon-workspaces.html https://betterprogramming.pub/managing-multiple-environments-in-terraform-5b389da3a2ef
