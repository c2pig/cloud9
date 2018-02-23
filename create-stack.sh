#!/bin/sh

[ $# -ne 2 ] && {
  echo "Usage: $0 <stack-name> <test-case-dir>"
  exit 1;
}

stack_name=${1:-"performance-test"}
report_bucket=`basename ${2:-"jmeter-dir"}-date +%Y%m%d-%M%S`
test_case_dir=${2:-"jmeter-dir"}

region=ap-southast-1

test_file=${test_case_dir}/jmeter.jmx

[ ! -e $test_file ] && {
  echo "$test_file does not exist"
  exit 2;
}

cp -r utils/* $test_case_dir

. utils/utils.sh

## if s3 bucket exist, ignore the creation error
create_bucket $report_bucket
websify_bucket ${report_bucket}

## upload local works to s3
echo upload ${test_case_dir} to s3 bucket - ${report_bucket}
local_to_bucket ${test_case_dir} ${report_bucket}

rm ${test_case_dir}/*.sh && rm ${test_case_dir}/*.html

aws cloudformation create-stack --stack-name $stack_name \
  --template-body file://performance-test.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --region ap-southeast-1 \
  --parameters ParameterKey=BucketName,ParameterValue=$report_bucket \
    ParameterKey=TestCaseDir,ParameterValue=$test_case_dir \
    ParameterKey=InstanceType,ParameterValue=t2.medium 

aws cloudformation wait stack-create-complete --stack-name ${stack_name}
echo Get report from : http://${report_bucket}.s3-website-us-east-1.amazonaws.com
