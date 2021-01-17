# www.gregnicol.uk
An exremely over-engineered demo website.

## ToDo
 1. [x] Github repo 
 1. [x] Basic S3 hosted site 
 1. [x] Terraform + Terragrunt
 1. [ ] Static WWW with generator 
 1. [ ] HTTPS & Cloudfront
 1. [ ] CI/CD for static site
 1. [ ] Blue / Green deployments
 1. [ ] CI/CD for infrastructure
 1. [ ] Cognito Authentication
 1. [ ]
 1. [ ]
 1. [ ]
 1. [ ] Git commit hooks for linting & formatting
 1. [x] Maintain Readme

## Features 

### Github repo
Using branching etc. Maybe semver commit messages. 

### Basic S3 hosted site
Using AWS S3 to host a static website securely. Route 53 for DNS & Certicate Manager for SSL.

### Terraform + Terragrunt
Setup & deploy Terraform with Terragrunt DRY, reusable modules, multi-environment & flexible stack deployments etc.
 - [ ] Resource tags for everything

### Static WWW with generator
 

### Cloudfront


### CI/CD for static site
 - [ ] Separate repo for CMS
 - [ ] Codebuild pipeline etc. for git 

### Blue / Green deployments
 - [ ] Cloudfront origin path + pipeline for blue/green deployments

### CI/CD for infrastructure


### Cognito Authentication


### Maintain Readme



## Build
### Terraform
```shell script
cd ./src/terraform/env/prod
terragrunt init
terragrunt plan
terragrunt apply -auto-approve

```

### www-site
```shell script
cd ./site
aws s3 sync --dryrun --delete . s3://www.gregnicol.uk/  # dry run

```

