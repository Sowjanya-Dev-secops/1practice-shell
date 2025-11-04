#!/bin/bash
AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-0696dc92e81135eee"
ZONE_ID="Z09288351F1RG63CMSZ8A"
DOMAIN_NAME="msdevsecops.fun"

for instance in $@
do
    instance_id=$(aws ec2 run-instances --image-id "ami-09c813fb71547fc4f"  --instance-type "t3.micro" --security-group-ids "sg-0696dc92e81135eee" --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" --query 'Instances[0].InstanceId' --output text)

    if [ $instance != "frontend" ];then
        ip=$(  aws ec2 describe-instances  --instance-ids $instance_id --query 'Reservations[*].Instances[*].[PrivateIpAddress]' --output text)
    else
        ip=$(  aws ec2 describe-instances  --instance-ids $instance_id --query 'Reservations[*].Instances[*].[PublicIpAddress]' --output text)
    fi
    echo "$instance : $ip"


    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '{
     "Changes": [
      {
        "Action": "UPSERT",
        "ResourceRecordSet": {
          "Name": "'$DOMAIN_NAME'",
          "Type": "A",
          "TTL": 1,
          "ResourceRecords": [
            {
             "Value":"'$ip'"
            }
           ]
         }
        }
      ]
    }'
done
