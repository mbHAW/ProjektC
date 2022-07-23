# Terraform[^1]

Hier eine Liste gängigster Terminalbefehle:
```bash
terraform init         # Initialize Project...get terraform.tfstate file from remote server if being used

terraform fmt          # Format/Beautify code

terraform state list   # List the state
terraform state mv     # Move an item in the state (or rename)
terraform state pull   # Pull current state and output to stdout
terraform state push   # Overwrite state by pushing local file to statefile
terraform state replace-provider # Replace a provider (e.g. aws) in the state file
terraform state rm ...    # Remove item from state
terraform state show ...  # Show item in state

terraform workspace new test # Create and switch to the new workspace 'test'
terraform workspace select default # Go to workspace 'default'
terraform workspace list  # List all available workspaces
terraform workspace show  # Show current active workspace

terraform validate     # Verify terraform code syntax
terraform plan         # Check out the process which will later be applied by the 'apply' command
terraform apply        # Apply the new changes in your project -> This is save to do as Terraform will first show the list of changes and will also wait for permission to execute
terraform apply --auto-approve  # Apply the new changes in your project without waiting for approval -> f.e. when used in automated processes inside of a docker container
```



## Using Shell script in Terraform "user_data"

Die Option "user_data" eröffnet die Möglichkeit, zusammen mit der AWS-Instance-Erstellung ein ShellScript ausführen lassen, das alle nötigen Abhängigkeiten nachinstalliert und sonstige Einstellungen vornimmt.
Dies erlaubt Systemadministratoren, die bereits Erfahrung mit einer Linux-Konsole haben, Teile des Setups in gewohnten Umgebung zu erstellen, bzw. die letzte Feinjustierung vorzunehmen.
Wenn mit Terraform nur noch eine ganz simple Standard-Instance erstellen braucht und man alle weiteren Optionen mit einem Shellscript bewerkstellen kann, so vereinfacht es dem Terraform-Neuling etwas den Einstieg.  

**Beispiele:**  
[Terraform AWS EC2 user_data example](https://www.middlewareinventory.com/blog/terraform-aws-ec2-user_data-example/) - middlewareinventory.com  
[Terraform Course demo-10](https://github.com/wardviaene/terraform-course/tree/master/demo-10) - github.com  
[How to use terraform with user_data and cloudinit() on AWS](https://linuxinuse.com/devopsblog/use-terraform-modules/) - linuxinuse.com  


## Terraform s3 Bucket
Alle Terraform-Optionen auswendig zu kennen ist geradezu unmöglich. Nicht nur deswegen, weil sich die Optionen mit der Zeit verändern können.  
Wenn man ein AWS S3 Bucket für die Aufbewahrung von "state"-Files benutzen will, dann ist der schnellste Weg Folgender:  
[Terraform Settings -> Backends -> Available Backends](https://www.terraform.io/language/settings/backends/s3)  
Dort finden sich auch die Infos für eine Reihe anderer Service-Provider.  



[^1]: [Beginners Tutorial to Terraform with AWS - Wahl Network](https://youtu.be/XxTcw7UTues) - Youtube  
[Terraform AWS Example – Create EC2 instance with Terraform](https://www.middlewareinventory.com/blog/terraform-aws-example-ec2/) - middlewareinventory.com  
[ec2-instance-connect](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-connect-set-up.html) - docs.aws.amazon.com  
[Terraform AWS EC2 user_data example](https://www.middlewareinventory.com/blog/terraform-aws-ec2-user_data-example/) - middlewareinventory.com  
[user_data - using templates in Terraform](https://github.com/wardviaene/terraform-course/tree/master/demo-10) - github.com  
[Install Packer](https://www.packer.io/docs/install) - packer.io  
[Devops blog - How to use terraform with user_data and cloudinit() on AWS](https://linuxinuse.com/devopsblog/use-terraform-modules/) - linuxinuse.com  
[SSM - Resource: aws_sqs_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) - registry.terraform.io  
[Using Terraform Workspace on AWS for multi account, multi environment deployments](https://alessandromarinoac.com/posts/iac/terraform/terraform-workspaces-multiple-accounts/) - alessandromarinoac.com  
[Named profiles for the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html) - docs.aws.amazon.com  
[Terraform workspaces](https://jhooq.com/terraform-workspaces/#5-how-to-use-the-name-of-current-workspace-using-terraformworkspace-interpolation) - jhooq.com  
[wardviaene-terraform-course - Github](https://github.com/wardviaene/terraform-course) - github.com  
[Modules](https://registry.terraform.io/browse/modules) - registry.terraform.io  
[Terraform Get Started - AWS](https://learn.hashicorp.com/collections/terraform/aws-get-started) - learn.hashicorp.com  
[backend](https://www.terraform.io/language/settings/backends/configuration#partial-configuration) - terraform.io  
[State](https://www.terraform.io/language/state) - terraform.io  
[Terraform Workspaces](https://www.bitslovers.com/terraform-workspaces/) - bitslovers.com  
[How To Use Terraform and Remote State with S3](https://medium.com/hootsuite-engineering/how-to-use-terraform-and-remote-state-with-s3-ed4320ee324a) - medium.com  
[Terraform State](https://www.bitslovers.com/terraform-state/) - bitslovers.com  
[Terraform Installation](https://www.terraform.io/cli/install/apt) - terraform.io  
[Terraform workspace to deploy multiple environment stack](https://tech.david-cheong.com/terraform-workspace-to-deploy-multiple-environment-stack/) - tech.david-cheong.com  
[What are Terraform Workspaces](https://pilotcoresystems.com/insights/what-are-terraform-workspaces) - pilotcoresystems.com  
[Terraform Language Documentation](https://www.terraform.io/language) - terraform.io  
[describe-images](https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html) - docs.aws.amazon.com  
[Terraform examples from YouTube course - WillBrock](https://github.com/WillBrock/terraform-course-examples) - github.com  
[Terraform - Official](https://www.terraform.io/) - terraform.io  
[Expressions](https://www.terraform.io/language/expressions) - terraform.io  
[Build Infrastructure - Terraform AWS Example](https://learn.hashicorp.com/tutorials/terraform/aws-build) - learn.hashicorp.com  
[Managing Workspaces](https://www.terraform.io/cli/workspaces) - terraform.io  
[Moving resources from the default workspace to a new one on Terraform.](https://dev.to/igordcsouzaaa/migrating-resources-from-the-default-workspace-to-a-new-one-3ojc) - dev.to  
[In Terraform is it possible to move to state from one workspace to another](https://stackoverflow.com/questions/66979732/in-terraform-is-it-possible-to-move-to-state-from-one-workspace-to-another) - stackoverflow.com  
[Terraform Tutorial - Playlist - Will Brock](https://www.youtube.com/playlist?list=PL8HowI-L-3_9bkocmR3JahQ4Y-Pbqs2Nt) - youtube.com  
[IAM - Resource: aws_iam_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) - registry.terraform.io  
[AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs) - registry.terraform.io  
[Amazon EC2 AMI Locator](https://cloud-images.ubuntu.com/locator/ec2) - cloud-images.ubuntu.com  
[A Beginner's Guide to Terraform | Infrastructure as Code - Linode](https://youtu.be/C3ptdKC9-EQ) - youtu.be  
[Build specification reference for CodeBuild](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) - docs.aws.amazon.com  
[Run builds locally with the AWS CodeBuild agent](https://docs.aws.amazon.com/codebuild/latest/userguide/use-codebuild-agent.html) - docs.aws.amazon.com  

