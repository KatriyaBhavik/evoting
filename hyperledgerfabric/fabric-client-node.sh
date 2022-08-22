echo Creating EC2 Client node, Security Group VPC, subnet, VPC endpoint
echo Creating keypair

#STACKNAME=$(aws cloudformation describe-stacks --region $REGION --query 'Stacks[?Description==`evoting hyperledger fabric network`] | [0].StackName' --output text)
echo $STACKNAME
NETWORKNAME=$(aws cloudformation describe-stacks --stack-name $STACKNAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`NetworkName`].OutputValue' --output text)
echo $NETWORKNAME
export NETWORKNAME=$NETWORKNAME
NETWORKID=$(aws cloudformation describe-stacks --stack-name $STACKNAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`NetworkId`].OutputValue' --output text)
echo $NETWORKID
export NETWORKID=$NETWORKID
VPCENDPOINTSERVICENAME=$(aws managedblockchain get-network --region $REGION --network-id $NETWORKID --query 'Network.VpcEndpointServiceName' --output text)
echo $VPCENDPOINTSERVICENAME
export VPCENDPOINTSERVICENAME=$VPCENDPOINTSERVICENAME

echo Searching for existing keypair named $NETWORKNAME-keypair
keyname=$(aws ec2 describe-key-pairs --key-names $NETWORKNAME-keypair --region $REGION --query 'KeyPairs[0].KeyName' --output text)
if [["$keyname" == "$NETWORKNAME-keypair"]]; then
    echo $NETWORKNAME-keypair already exists
    exit 1
fi 

echo Creating $NETWORKNAME-keypair
aws ec2 create-key-pair --key-name $NETWORKNAME-keypair --query 'KeyMaterial' --region $REGION --output text > ~/$NETWORKNAME-keypair
if [ $? - gt 0 ]; then  
    echo could not create $NETWORKNAME-keypair
    exit $?
fi

chmod 400 ~/$NETWORKNAME-keypair
sleep 5

echo create VPC, VPC Endpoint and Favric client node
aws cloudformation deploy --stack-name $NETWORKNAME-fabric-client-node --template-file fabric-client-node.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameter-overrides KeyName=$NETWORKNAME-keypair EvotingVpcServiceEndpointName=$VPCENDPOINTSERVICENAME \
--region $REGION