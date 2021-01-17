# www.gregnicol.uk
An exremely over-engineered demo [website](http://www.gregnicol.uk).

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
 1. [ ] Maintain Readme

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

