#!/usr/bin/env bash

#
# this script is used for bootstraping the project base infrastructure
#

# create base infra
terraform init setup
terraform apply setup

# migrate local state to the remote with the s3 bucket and dynamodb table
terraform init
