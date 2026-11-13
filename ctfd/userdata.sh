
#!/bin/bash
set -e

# Update package lists and install dependencies.
apt-get update
apt-get install -y docker.io docker-compose-v2 awscli jq python3

# Enable and start Docker.
systemctl enable --now docker

# Create the CTFd application directory.
mkdir -p /opt/ctfd
cd /opt/ctfd

# Write the Docker Compose configuration.
cat > docker-compose.yml <<'COMPOSE'
${docker_compose}
COMPOSE

# Retrieve the RDS password from Secrets Manager.
DB_SECRET=$(aws secretsmanager get-secret-value \
  --secret-id "${secret_arn}" \
  --region "${aws_region}" \
  --query SecretString \
  --output text)

DB_PASSWORD=$(echo "$DB_SECRET" | jq -er '.password')

# URL-encode the database password.
DB_PASSWORD=$(DB_PASSWORD="$DB_PASSWORD" python3 -c \
  'import os, urllib.parse; print(urllib.parse.quote(os.environ["DB_PASSWORD"], safe=""))')

# Configure database and Redis connections.
export DATABASE_URL="mysql+pymysql://${db_user}:$DB_PASSWORD@${db_host}:3306/${db_name}"
export REDIS_URL="redis://${redis_host}:6379"

# Retrieve the shared CTFd secret key.
SECRET_KEY=$(aws ssm get-parameter \
  --name "/ctfd/secret_key" \
  --with-decryption \
  --region "${aws_region}" \
  --query "Parameter.Value" \
  --output text)

test -n "$SECRET_KEY"
export SECRET_KEY

# Start the CTFd application.
docker compose up -d
