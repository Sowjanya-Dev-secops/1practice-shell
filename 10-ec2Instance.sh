#!/bin/bash
AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0696dc92e81135eee"
ZONE_ID="Z09288351F1RG63CMSZ8A"
DOMAIN_NAME="msdevsecops.fun"
$(aws ec2 run-instances \
    --image-id $AMI_ID \
    --instance-type "t3.micro" \
    --security-group-ids $SG_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=test}]'
    --query 'Instances[0].InstanceId' \
    --output text)