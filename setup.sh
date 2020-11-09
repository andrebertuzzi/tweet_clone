export AWS_PROFILE=YOUR_PROFILE
export AWS_DEFAULT_REGION=us-west-2
LAMBDA=tweet_clone
ROLE=lambda-role-test
POLICY=lambda-SimpleDynamoAccess

# CREATES ROLE
ROLE_RETURN=$(aws iam create-role \
--role-name ${ROLE} \
--assume-role-policy-document file://infra/trust-policy.json)

ROLE_ARN=$(jq -r '.Role.Arn' <<< "${ROLE_RETURN}")

# CREATES POLICY
POLICY_RETURN=$(aws iam create-policy \
--policy-name ${POLICY} \
--policy-document file://infra/service-role-policy.json)

POLICY_ARN=$(jq -r '.Policy.Arn' <<< "${POLICY_RETURN}")

# ATTACHS POLICY TO ROLE
aws iam attach-role-policy \
--role-name ${ROLE} \
--policy-arn ${POLICY_ARN}

# CREATES LAMBDA
aws lambda create-function \
--function-name ${LAMBDA} \
--runtime "python3.7" \
--role ${ROLE_ARN} \
--handler "port_tweet.handler" \
--timeout 300 \
--memory-size 256 \
--zip-file "fileb://function.zip"

