# cloud9

### How-To Run
1. Create an empty folder, put your .jmx into that folder 
2. run `./create-stack.sh <stack-name> <jmx-path>
3. Check s3 URL produce by script above.  When your performance tesing finish the execution, dashboard report will display in s3 URL

### How-To Build AMI
1. awscli command is required for AMI build purpose.
2. Make sure you have configure aws credentials properly, to verify it. run `aws configure`
3. Run `packer build` . If you need to build AMI in region, modify packer.json
