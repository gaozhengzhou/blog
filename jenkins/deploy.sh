docker build --tag=jenkins:2.182-centos .
docker-compose stop jenkins
docker-compose rm -f jenkins
docker-compose up -d jenkins