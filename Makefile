.PHONY: puppetmaster

puppetmaster: 
	aws-2.7 cloudformation create-stack --stack-name PuppetMaster$(shell date "+%Y%m%d%H%M") --template-body file://aws/templates/puppetmaster-template.yaml --capabilities CAPABILITY_IAM --parameters "ParameterKey=KeyName,ParameterValue=Macbook"

