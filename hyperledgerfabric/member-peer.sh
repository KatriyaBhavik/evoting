export REGION=us-east-1
export STACKNAME=evoting
aws cloudformation deploy --stack-name $STACKNAME --template-file member-peer.yaml \
--parameter-overrides PeerNodeAvailabilityZone=${REGION}a \
--capabilities CAPABILITY_NAMED_IAM \
--region $REGION
