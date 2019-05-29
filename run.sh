docker build -f ./Dockerfile -t OpenCVImage .

echo 'docker compose down .........................'

docker-compose down

echo 'docker compose up .........................'

docker-compose up