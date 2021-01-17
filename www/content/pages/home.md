Title: Home
Date: 2021-01-17 17:00
Category: Home 
URL:
save_as: index.html

A deliberately over-engineered portfolio type side project.

[Source code](https://github.com/gregn610/www.gregnicol.uk/tree/main/src) on Github.

# Features 

### Github repo
 - [x] Using [branching](https://github.com/gregn610/www.gregnicol.uk/branches) etc. 
 - [ ] Semver commit messages generating changelog & bumping version.


### Basic S3 hosted site
 - [x] AWS S3 to [securely](https://github.com/gregn610/www.gregnicol.uk/blob/main/src/terraform/modules/www-site/templates/www-bucket-policy.json) host a basic static [website](http://www.gregnicol.uk). 
 - [x] Route 53 for DNS.


### Terraform + Terragrunt
 - [x] Setup & deploy Terraform with Terragrunt DRY, reusable modules, multi-environment & flexible stack deployments etc.
 - [ ] Resource tags for everything
 - [ ] [TFSec](https://github.com/tfsec/tfsec) linting


### Static WWW with generator
 - [x] [Pelican](https://blog.getpelican.com/) to host a basic blog.
 - [ ] Content
 - [ ] Design


### Cloudfront
 - [ ] Cloudfront + HTTPS
 
 
### Cognito Authentication
Use Cognito, Lambda@Edge & Cloudfront to provide serverless authentication & authorization.
 - [x] Fork https://github.com/Widen/cloudfront-auth and apply Cognito PR
 - [ ] Terraform + AWS SAM packaging
 - [ ] TF Templates vs Lambda layers for config
 - [ ] Terraform deployed


### CI/CD for static site
 - [ ] Separate repo for static CMS
 - [ ] Codebuild pipeline etc. for git 
 - [ ] Cloudfront origin path + pipeline for blue/green deployments


### CI/CD for infrastructure
 - [ ] CodePipeline & CodeBuild etc.


### Monitoring & Logs
 - [ ] Lifecycle rules for S3 logs
 - [ ] Cloudwatch & dashboards
 
 .