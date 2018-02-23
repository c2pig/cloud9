#!/bin/sh

[ $# -ne 2 ] && {
  echo "Usage: $0 <stack-name> <jmeter-jmx-path>"
  exit 1;
}

stack_name=${1:-"performance-test"}
jmx_path=$2
test_case_dir=`dirname $jmx_path`
report_bucket=`basename ${test_case_dir}`-`date +%Y%m%d-%M%S`

region=ap-southast-1


[ ! -e $jmx_path ] && {
  echo "$jmx_path does not exist"
  exit 2;
}

tmp_dir=.tmp
mkdir -p $tmp_dir
cp $jmx_path $tmp_dir/jmeter.jmx
cp -r utils/* $tmp_dir
. utils/utils.sh

## if s3 bucket exist, ignore the creation error
create_bucket $report_bucket
websify_bucket ${report_bucket}

## upload local works to s3
echo upload ${test_case_dir} to s3 bucket - ${report_bucket}
local_to_bucket ${tmp_dir} ${report_bucket}

rm -rf $tmp_dir

aws cloudformation create-stack --stack-name $stack_name \
  --template-body file://performance-test.yml \
  --capabilities CAPABILITY_NAMED_IAM \
  --region ap-southeast-1 \
  --parameters ParameterKey=BucketName,ParameterValue=$report_bucket \
    ParameterKey=TestCaseDir,ParameterValue=$test_case_dir \
    ParameterKey=InstanceType,ParameterValue=t2.medium

aws cloudformation wait stack-create-complete --stack-name ${stack_name}
echo Get report from : http://${report_bucket}.s3-website-us-east-1.amazonaws.com
