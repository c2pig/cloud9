#!/bin/sh

[ $# -ne 1 ] && {
  echo "Usage: $0 <cloudformation-stack-name> "
  exit 1
}

stack_name=$1

aws cloudformation delete-stack --stack-name ${stack_name}
#aws cloudformation wait stack-delete-complete --stack-name ${stack_name}
