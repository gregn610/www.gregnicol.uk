# www.gregnicol.uk
An extremely over-engineered serverless portfolio type side project [website](http://www.gregnicol.uk).

[Source code](https://github.com/gregn610/www.gregnicol.uk/tree/main/src) on Github.

# Features 

### Github repo
 - [x] Using [branching](https://github.com/gregn610/www.gregnicol.uk/branches) etc. 
 - [x] Semver commit messages.
 - [ ] Semver generating changelog & bumping version.


### Basic S3 hosted site
 - [x] AWS S3 to [securely](https://github.com/gregn610/www.gregnicol.uk/blob/main/src/terraform/modules/www-site/templates/www-bucket-policy.json) host a basic static [website](http://www.gregnicol.uk). 
 - [x] Route 53 for DNS.


### Terraform + Terragrunt
 - [x] Setup [Terraform](https://github.com/gregn610/www.gregnicol.uk/tree/main/src/terraform/modules/www-site). 
 - [x] Terragrunt [DRY](https://github.com/gregn610/www.gregnicol.uk/blob/main/src/terraform/terragrunt.hcl), reusable modules, multi-environment & flexible stack deployments etc.
 - [ ] Resource tags for everything.
 - [ ] [TFSec](https://github.com/tfsec/tfsec) linting.
 - [ ] CodePipeline & CodeBuild CI/CD for site infrastructure etc. 


### Static WWW with generator
 - [x] [Pelican](https://blog.getpelican.com/) to host a basic blog.
 - [ ] Documentation & Content.
 - [ ] Design.
 - [x] [Cloudfront](d1sfgyi6drx6fe.cloudfront.net).
 - [x] [HTTPS](https://www.ssllabs.com/ssltest/analyze.html?d=www.gregnicol.uk).
 

### CI/CD for static site
 - [x] Separate CodeCommit repo for static CMS.
 - [x] Codebuild pipeline for site content publishing. 
 - [x] Cloudfront origin path for revertable deployments [[Article]({filename}/cloudfront-originpath.md)] [[Github](https://github.com/gregn610/www.gregnicol.uk/blob/main/src/terraform/modules/www-cicd/templates/buildspec.yml#L26-L35)]. 


### Monitoring & Logs
 - [ ] Lifecycle rules for S3 logs.
 - [ ] Cloudwatch & dashboards.
 - [ ] Analytics


### Cognito Authentication
Use Cognito, Lambda@Edge & Cloudfront to provide serverless authentication & authorization.

 - [x] Fork https://github.com/Widen/cloudfront-auth and apply [Cognito PR](https://github.com/Widen/cloudfront-auth/compare/master...gregn610:gn1-cognito).
 - [ ] Terraform + AWS SAM packaging.
 - [ ] TF Templates vs Lambda layers for config.
 - [x] Terraform deployed.

 
.


## Build
### Terraform
```shell script
cd ./src/terraform/env/prod
terragrunt init
terragrunt plan
terragrunt apply -auto-approve

```

### www-site
Build & preview. Pelican comes with support for [Invoke](http://docs.pyinvoke.org/en/stable/) tasks and build.
```shell script
cd ./www/
invoke publish
invoke serve

```
Upload to S3
```shell script
aws s3 sync --dryrun --delete ./output/ s3://www.gregnicol.uk/  # dry run

aws s3 sync --delete ./output/ s3://www.gregnicol.uk/

```

