import os
import sys
import boto3


def init_boto_client(endpoint_url, region, service_name):
    try:
        batch = boto3.client(service_name=service_name, region_name=region, endpoint_url=endpoint_url)
    except Exception as e:
        print('boto3 client exception ' + str(e))
        sys.exit(2)
    return batch


def lambda_handler(event, context):

    batch = init_boto_client(os.environ.get("endpoint_url"), os.environ.get("region"), os.environ.get("service_name"))

    try:
        response = batch.register_job_definition(
            jobDefinitionName=os.environ.get("job_definition_name"),
            type="multinode",
            parameters={},
            nodeProperties={
                "numNodes": int(os.environ.get("num_nodes")),
                "mainNode": int(os.environ.get("main_node")),
                "nodeRangeProperties": [
                    {
                        "targetNodes": os.environ.get("target_nodes"),
                        "container": {
                            "image": os.environ.get("image"),
                            "executionRoleArn": "arn:aws:iam::607694952559:role/acct-managed/AWS-PDBatch-lab-us-east-1-ecs-exec-role",
                            "vcpus": int(os.environ.get("vcpus")),
                            "memory": int(os.environ.get("memory")),
                            "command": ["ls", "-la"],
                            "instanceType": os.environ.get("instance_type"),
                            "jobRoleArn": os.environ.get("job_role_arn"),
                            "secrets": [{
                                    "name": "ECS-Artifactory-Credentials",
                                    "valueFrom": "arn:aws:secretsmanager:us-east-1:607694952559:secret:ECS-Artifactory-Credentials-fPQ1KF"
                            }],
                        }
                    }
                ],
            },
            timeout={
                'attemptDurationSeconds': 480
            },
        )
    except Exception as e:
        print('register_job_definition error: ' + str(e))
        sys.exit(2)

    print('Created job definition %s' % response['jobDefinitionName'])
    return response
