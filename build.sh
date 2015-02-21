# Will build a new container
#
#

cp -R ~/.ssh .
docker build -t dev .
