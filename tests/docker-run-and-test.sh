#! /bin/sh

# take down any existing deployments and remove volumes
( ( docker volume rm petinvent_db_data ) > /dev/null 2>&1 )

docker compose --file "./docker-compose-testing.yml" down \
|| docker-compose --file "./docker-compose-testing.yml" down \
|| echo "docker-compose-plugin not installed" | exit 1

( ( docker volume rm petinvent_db_data ) > /dev/null 2>&1 )

if [ "$1" ]; then
  PYTHON_TAG=$( echo "$1" | cut -f2 -d ":" )
else
  PYTHON_TAG='3.11-alpine'
fi

if [ "$2" ]; then
  POSTGRES_TAG=$( echo "$2" | cut -f2 -d ":" )
else
  POSTGRES_TAG='15-alpine'
fi

APP_TAG="test-${PYTHON_TAG}"

# Generate random passwords
PASSGEN="head /dev/urandom | tr -dc A-Za-z0-9 | head -c64"
SECRET_KEY=$( eval "$PASSGEN" )
POSTGRES_PASSWORD=$( eval "$PASSGEN" )

POSTGRES_USER=root
DB_HOSTNAME=root
POSTGRES_DB=tasks_db
POSTGRES_PORT=5432

# create .env file
cat > .env <<EOF
# Docker environment
APP_TAG=${APP_TAG}
PYTHON_TAG=${PYTHON_TAG}
POSTGRES_TAG=${POSTGRES_TAG}
WSGI_PORT=5000
TZ=Etc/UTC

# Database connection
POSTGRES_USER=${POSTGRES_USER}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
DB_HOSTNAME=${DB_HOSTNAME}
POSTGRES_DB=${POSTGRES_DB}
POSTGRES_PORT=${POSTGRES_PORT}

# Flask configuration
SQLALCHEMY_DATABASE_URI=postgresql+psycopg2://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${DB_HOSTNAME}:${POSTGRES_PORT}/${POSTGRES_DB}
SECRET_KEY=${SECRET_KEY}
EOF

# convert .env file to UTF-8 with BOM encoding
sed -i '1s/^\(\xef\xbb\xbf\)\?/\xef\xbb\xbf/' .env


# deploy stack using docker-compose.yml
docker compose --file "./docker-compose-testing.yml" --env-file "./.env" up -d --build \
|| docker-compose --file "./docker-compose-testing.yml" --env-file "./.env" up -d --build \
|| echo "docker-compose-plugin not installed" | exit 1

## test application health
#printf "\n"
#echo "Checking server status... Please wait"
#server_up=false
#while [ ${server_up} = false ]
#do
#sleep 1s
#connect=$( (curl --silent --location --request GET "http://localhost:5000/health") )
#if [ -n "${connect}" ]; then
#    server_up=true
#fi
#done
#printf "\n"
#echo "PetInvent is up and available at http://localhost:5000"

# run end-to-end tests
/usr/bin/env bash ./tests/e2e-tests.sh

# bring down containers
docker compose --file "./docker-compose-testing.yml" down \
|| docker-compose --file "./docker-compose-testing.yml" down \
|| echo "docker-compose-plugin not installed" | exit 1

( ( docker volume rm petinvent_db_data ) > /dev/null 2>&1 )

exit 0
