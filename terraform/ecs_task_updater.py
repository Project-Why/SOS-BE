import boto3
import os

ecs_client = boto3.client('ecs')

def handler(event, context):
    # ECR 푸시 이벤트에서 이미지 URI 가져오기
    image_tag = event['detail']['image-tag']
    repository_name = event['detail']['repository-name']
    account_id = event['account']
    region = event['region']
    
    image_uri = f'{account_id}.dkr.ecr.{region}.amazonaws.com/{repository_name}:{image_tag}'
    
    # ECS 서비스 업데이트
    response = ecs_client.update_service(
        cluster=os.environ['ECS_CLUSTER_NAME'],
        service=os.environ['ECS_SERVICE_NAME'],
        forceNewDeployment=True,
        taskDefinition=os.environ['ECS_TASK_DEFINITION']
    )
    
    return response