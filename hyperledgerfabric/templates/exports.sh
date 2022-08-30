#!/bin/bash

# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# or in the "license" file accompanying this file. This file is distributed 
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either 
# express or implied. See the License for the specific language governing 
# permissions and limitations under the License.

echo Updating AWS CLI to the latest version
sudo pip install awscli --upgrade
cd ~

export REGION=us-east-1
export STACKNAME=$(aws cloudformation describe-stacks --region $REGION --query 'Stacks[?Description==`evoting hyperledger fabric network`] | [0].StackName' --output text)
export NETWORKNAME=$(aws cloudformation describe-stacks --stack-name $STACKNAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`NetworkName`].OutputValue' --output text)
export MEMBERNAME=$(aws cloudformation describe-stacks --stack-name $STACKNAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`MemberName`].OutputValue' --output text)
export NETWORKVERSION=$(aws cloudformation describe-stacks --stack-name $STACKNAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`FrameworkVersion`].OutputValue' --output text)
export ADMINUSER=$(aws cloudformation describe-stacks --stack-name $STACKNAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`MemberAdminUsername`].OutputValue' --output text)
export ADMINPWD=$(aws cloudformation describe-stacks --stack-name $STACKNAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`MemberAdminPassword`].OutputValue' --output text)
export NETWORKID=$(aws cloudformation describe-stacks --stack-name $STACKNAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`NetworkId`].OutputValue' --output text)
export MEMBERID=$(aws cloudformation describe-stacks --stack-name $STACKNAME --region $REGION --query 'Stacks[0].Outputs[?OutputKey==`MemberId`].OutputValue' --output text)

VpcEndpointServiceName=$(aws managedblockchain get-network --region $REGION --network-id $NETWORKID --query 'Network.VpcEndpointServiceName' --output text)
OrderingServiceEndpoint=$(aws managedblockchain get-network --region $REGION --network-id $NETWORKID --query 'Network.FrameworkAttributes.Fabric.OrderingServiceEndpoint' --output text)
CaEndpoint=$(aws managedblockchain get-member --region $REGION --network-id $NETWORKID --member-id $MEMBERID --query 'Member.FrameworkAttributes.Fabric.CaEndpoint' --output text)
nodeID1=$(aws managedblockchain list-nodes --region $REGION --network-id $NETWORKID --member-id $MEMBERID --query 'Nodes[?Status==`AVAILABLE`] | [0].Id' --output text)
#nodeID2=$(aws managedblockchain list-nodes --region $REGION --network-id $NETWORKID --member-id $MEMBERID --query 'Nodes[?Status==`AVAILABLE`] | [1].Id' --output text)
#nodeID3=$(aws managedblockchain list-nodes --region $REGION --network-id $NETWORKID --member-id $MEMBERID --query 'Nodes[?Status==`AVAILABLE`] | [2].Id' --output text)
peerEndpoint1=$(aws managedblockchain get-node --region $REGION --network-id $NETWORKID --member-id $MEMBERID --node-id $nodeID1 --query 'Node.FrameworkAttributes.Fabric.PeerEndpoint' --output text)
#peerEndpoint2=$(aws managedblockchain get-node --region $REGION --network-id $NETWORKID --member-id $MEMBERID --node-id $nodeID2 --query 'Node.FrameworkAttributes.Fabric.PeerEndpoint' --output text)
#peerEndpoint3=$(aws managedblockchain get-node --region $REGION --network-id $NETWORKID --member-id $MEMBERID --node-id $nodeID3 --query 'Node.FrameworkAttributes.Fabric.PeerEndpoint' --output text)
peerEventEndpoint1=$(aws managedblockchain get-node --region $REGION --network-id $NETWORKID --member-id $MEMBERID --node-id $nodeID1 --query 'Node.FrameworkAttributes.Fabric.PeerEventEndpoint' --output text)
#peerEventEndpoint2=$(aws managedblockchain get-node --region $REGION --network-id $NETWORKID --member-id $MEMBERID --node-id $nodeID2 --query 'Node.FrameworkAttributes.Fabric.PeerEventEndpoint' --output text)
#peerEventEndpoint3=$(aws managedblockchain get-node --region $REGION --network-id $NETWORKID --member-id $MEMBERID --node-id $nodeID3 --query 'Node.FrameworkAttributes.Fabric.PeerEventEndpoint' --output text)
export ORDERINGSERVICEENDPOINT=$OrderingServiceEndpoint
export ORDERINGSERVICEENDPOINTNOPORT=${ORDERINGSERVICEENDPOINT::-6}
export VPCENDPOINTSERVICENAME=$VpcEndpointServiceName
export CASERVICEENDPOINT=$CaEndpoint
export PEERNODEID1=$nodeID1
#export PEERNODEID2=$nodeID2
#export PEERNODEID3=$nodeID3
export PEERSERVICEENDPOINT1=$peerEndpoint1
#export PEERSERVICEENDPOINT2=$peerEndpoint2
#export PEERSERVICEENDPOINT3=$peerEndpoint3
export PEERSERVICEENDPOINTNOPORT1=${PEERSERVICEENDPOINT1::-6}
#export PEERSERVICEENDPOINTNOPORT2=${PEERSERVICEENDPOINT2::-6}
#export PEERSERVICEENDPOINTNOPORT3=${PEERSERVICEENDPOINT3::-6}
export PEEREVENTENDPOINT1=$peerEventEndpoint1
#export PEEREVENTENDPOINT2=$PEEREVENTENDPOINT2
#export PEEREVENTENDPOINT3=$peerEventEndpoint3

echo Useful information stored in EXPORT variables
echo REGION: $REGION
echo NETWORKNAME: $NETWORKNAME
echo NETWORKVERSION: $NETWORKVERSION
echo ADMINUSER: $ADMINUSER
echo ADMINPWD: $ADMINPWD
echo MEMBERNAME: $MEMBERNAME
echo NETWORKID: $NETWORKID
echo MEMBERID: $MEMBERID
echo ORDERINGSERVICEENDPOINT: $ORDERINGSERVICEENDPOINT
echo ORDERINGSERVICEENDPOINTNOPORT: $ORDERINGSERVICEENDPOINTNOPORT
echo VPCENDPOINTSERVICENAME: $VPCENDPOINTSERVICENAME
echo CASERVICEENDPOINT: $CASERVICEENDPOINT
echo PEERNODEID1: $PEERNODEID1
#echo PEERNODEID2: $PEERNODEID2
#echo PEERNODEID3: $PEERNODEID3
echo PEERSERVICEENDPOINT1: $PEERSERVICEENDPOINT1
#echo PEERSERVICEENDPOINT2: $PEERSERVICEENDPOINT2
#echo PEERSERVICEENDPOINT3: $PEERSERVICEENDPOINT3
echo PEERSERVICEENDPOINTNOPORT1: $PEERSERVICEENDPOINTNOPORT1
#echo PEERSERVICEENDPOINTNOPORT2: $PEERSERVICEENDPOINTNOPORT2
#echo PEERSERVICEENDPOINTNOPORT3: $PEERSERVICEENDPOINTNOPORT3
echo PEEREVENTENDPOINT1: $PEEREVENTENDPOINT1
#echo PEEREVENTENDPOINT2: $PEEREVENTENDPOINT2
#echo PEEREVENTENDPOINT3: $PEEREVENTENDPOINT3

# Exports to be exported before executing any Fabric 'peer' commands via the CLI
cat << EOF > peer-exports.sh
export MSP_PATH=/opt/home/admin-msp
export MSP=$MEMBERID
export ORDERER=$ORDERINGSERVICEENDPOINT
export PEER1=$PEERSERVICEENDPOINT1
#export PEER2=$PEERSERVICEENDPOINT2
#export PEER3=$PEERSERVICEENDPOINT3
export CHANNEL=mychannel
export CAFILE=/opt/home/managedblockchain-tls-chain.pem
export CHAINCODENAME=mycc
export CHAINCODEVERSION=v0
export CHAINCODEDIR=github.com/chaincode_example02/go
EOF
