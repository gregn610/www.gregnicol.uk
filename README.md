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

## Build
```shell script
cd src/terraform/env/prod
terragrunt init
terragrunt plan
terragrunt apply -auto-approve

```

## Features 

### Github repo
Using branching etc. Maybe semver commit messages. 

### Basic S3 hosted site
Using AWS S3 to host a static website securely. Route 53 for DNS & Certicate Manager for SSL.

### Terraform + Terragrunt
Setup & deploy Terraform with Terragrunt DRY, reusable modules, multi-environment & flexible stack deployments etc.

### Static WWW with generator
 

### Cloudfront


### CI/CD for static site


### Blue / Green deployments


### CI/CD for infrastructure


### Cognito Authentication


### Maintain Readme
