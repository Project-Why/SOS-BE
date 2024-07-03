#!/bin/zsh

# Load environment variables from .env.production file
set -a  # Automatically export all variables
source .env.production
set +a

# Function to print and overwrite logs
function log() {
  tput cr   # Move to the beginning of the line
  tput el   # Clear the line
  echo "$1"
}

Function to print a command with log
function run_command() {
  echo -e "\n$1\n"
  eval $1
  if [ $? -eq 0 ]; then
    log "$2 succeeded."
  else
    log "$2 failed."
    exit 1
  fi
}

# Get current timestamp
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# Set Docker image tag
AWS_ACCOUNT_URL="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
DOCKER_IMAGE_TAG="${AWS_ACCOUNT_URL}/${ECR_REPOSITORY_NAME}:${TIMESTAMP}"

# Log all output to a file
LOG_FILE="deploy.log"
exec > >(tee -a $LOG_FILE) 2>&1

# Start logging
echo -e "\n\nDeployment started at $(date)\n\n"

# Login to AWS ECR
run_command "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_URL" "AWS ECR login"

# Build the Docker image
run_command "docker build -t $DOCKER_IMAGE_TAG ." "Docker image build" 

# Push the Docker image to ECR
run_command "docker push $DOCKER_IMAGE_TAG" "Docker image push"

# Update the ecr_app_repository_tag variable in the variables.tf file
run_command "sed -i.bak '/variable \"ecr_app_repository_tag\"/,/}/s|default.*=.*\".*\"|default     = \"${TIMESTAMP}\"|' $TF_VAR_FILE" "Updating Terraform variables file"

# Change to the Terraform directory and apply the changes
cd terraform || { log "Failed to change directory to terraform."; exit 1; }
run_command "terraform init" "Terraform init"
run_command "terraform apply -auto-approve" "Terraform apply"
cd - || exit 1

log "Deployment complete. ECS service updated with new Docker image: ${DOCKER_IMAGE_TAG}"
