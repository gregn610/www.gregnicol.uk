# www.gregnicol.uk
An exremely over-engineered demo [website](http://www.gregnicol.uk).

## ToDo
 - [x] Github repo 
 - [x] Basic S3 hosted site 
 - [x] Terraform + Terragrunt
 - [x] Static WWW with generator 
 - [ ] HTTPS & Cloudfront
 - [ ] CI/CD for static site
 - [ ] Blue / Green deployments
 - [ ] CI/CD for infrastructure
 - [ ] Cognito Authentication
 - [ ]
 - [ ]
 - [ ]
 - [ ] Git commit hooks for linting & formatting
 - [ ] Maintain Readme

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

