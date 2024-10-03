[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/OLgAZwRQ)
# Contents
- [AWS / AWS Command Line Interface (CLI)](#aws--aws-command-line-interface-cli)
  - [Step 1: Install awscli tool](#step-1-install-awscli-tool)
  - [Step 2: Setup IAM Identity Center](#step-2-setup-iam-identity-center)
  - [Step 3: Configure SSO Profile](#step-3-configure-sso-profile)
  - [Step 4: Install aws-nuke](#step-4-install-aws-nuke)
- [Terraform](#terraform)
  - [Install tfenv](#install-tfenv)
  - [Install stable Terraform](#install-stable-terraform)
  - [Create using Terraform](#create-using-terraform)
  - [Verify your deployment succeeded](#verify-your-deployment-succeeded)
  - [Destroy using Terraform](#destroy-using-terraform)
- [Extra credit opportunity](#extra-credit-opportunity)
- [Lab deliverables](#lab-deliverables)
  - [Files](#files)
  - [Self study](#self-study)
  - [Knowledge check](#knowledge-check)
- [Reference docs](#reference-docs)

In today's lab, we are going to setup our AWS account, SSO auth, Docker, and Terraform.

# AWS / AWS Command Line Interface (CLI)

Create an AWS account before doing the following steps.

## Step 1: Install awscli tool

**macOS**

```
brew install awscli
```

**Ubuntu/wsl2**

```
sudo apt install awscli
```


## Step 2: Setup IAM Identity Center

[Docs to setup IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/getting-started.html)

## Step 3: Configure SSO Profile

[Steps to configure SSO for aws cli](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html#cli-configure-sso-configure)

Take a screenshot after setting this up.

## Step 4: Install aws-nuke

This tool is useful to ensure that all dangling resources are deleted and do not incur any expenses. Hopefully it won't find anything since terraform should catch everything it creates. 

**macOS**

```
brew install aws-nuke
```

**Linux/wsl2**

```
sudo apt install aws-nuke
```

# Terraform

For our labs, we will use Terraform to manage our deployed AWS resources. Read more about [Terraform Basics](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/infrastructure-as-code) here.

## Install tfenv
Tfenv is essentially a package manager for Terraform. This will be very helpful in the future if you ever find yourself managing different Terraform projects with different versions as tfenv makes it very easy to switch between versions. 

**macOS**

```
brew install tfenv
```

**Linux/wsl2**

[tfenv Ubuntu installation guide ](https://maxat-akbanov.com/how-to-install-tfenv-terraform-version-manager-on-ubuntu-os)

## Install stable Terraform 

```
tfenv install 1.9.5 && tfenv use 1.9.5
```  

You should now be able to run Terraform. See help for list of commands.  

```
terraform -help
```

## Create using Terraform

Copy the code from [Terraform tutorial](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build) into a file named `main.tf` in the base directory, then run

```
terraform init && terraform plan
```

You will see the output of what Terraform plans on creating.

To deploy this, run

```
terraform apply
```


## Verify your deployment succeeded

Go to the AWS console in your SSO user account and find the server we deployed in EC2 > instances.

Take a screenshot and save it in your repository.

## Destroy using Terraform

Once you have taken a screenshot of your running instance in AWS, it's time to destroy it using,

```
terraform destroy
```

Take a screenshot of the resources being destroyed.

# Extra credit opportunity

Use any method to shell into your instance. Take a screenshot and add it to your repository. describe your method of shelling into it.

# Lab deliverables

## Files

- `main.tf`
- screenshot of SSO configure
- screenshot of running AWS instance
- screenshot of `terraform destroy`
- (optional) screenshot of shell into instance

## Self study

Figure out how to run [aws-nuke](https://github.com/rebuy-de/aws-nuke) to ensure that nothing gets left behind. Run it on your account for extra measure.

## Knowledge check

Answer the following questions in a text file named `lab1.txt`.

1. What are the advantages of cloud computing?
2. Why did we set up sso instead of using access keys?
3. What is IaC?
4. Name one advantage of IaC.
5. Briefly describe the purposes of the following "blocks" in terraform language: terraform, provider, resource blocks
6. What's the importance of aws-nuke? How did you setup aws-nuke?
8. (optional) How did you shell into your instance?

# Reference docs

- [Docs to setup IAM Identity Center](https://docs.aws.amazon.com/singlesignon/latest/userguide/getting-started.html)
- [Steps to configure SSO for AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html#cli-configure-sso-configure)
- [Terraform Basics](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/infrastructure-as-code)
- [Tfenv Ubuntu installation guide ](https://maxat-akbanov.com/how-to-install-tfenv-terraform-version-manager-on-ubuntu-os)
- [Terraform tutorial](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build)
- [aws-nuke](https://github.com/rebuy-de/aws-nuke)
- [Configuring SSO on CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html)
