# Terraform Bootstrap example

Example solution for :egg: vs :chicken: problem - how to create infrastructure for remote Terraform backend with Terraform?

## Assumptions

* [Terraform](https://www.terraform.io/) installed (approach tested against `v0.11.2`)
* [AWS S3 backend](https://www.terraform.io/docs/backends/types/s3.html) with DynamoDB table for locking will be used
* operator should have [AWS credentials in profile](https://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html) - for the purpose of this repo we use `terraform` profile

## Development

Before applying you should update `modules/backend/policy.json` to your needs and update backend bucket name in the `policy.json`, `modules/backend/main.tf` and in the main `backend.tf`.

If you want to use workspaces per environment (as we and [Hashicorp recommends](https://www.terraform.io/docs/enterprise/guides/recommended-practices/part1.html#one-workspace-per-environment-per-terraform-configuration)) it might be convenient to leave `default` for backend infrastructure only.

## Explanation

When you run `setup.sh` the script will create required S3 bucket and DynamoDB table with local backend and then it will setup remote backend where it will migrate the local state. Terraform will ask for confirmation during creation of required resources and if operator wants to migrate the state.

## Problems not solved

* Backend config cannot use interpolations so `BUCKET_NAME` cannot yet be extracted to variable
* AWS S3 policies doesn't support groups so each operator must be added explicit to the policy file
* `-backend=false` doesn't work, so "hack" with separated `setup` directory must be used to run Terraform without S3 backend
