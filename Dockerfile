FROM  nginx:stable
MAINTAINER  Neil Watson <neil@watson-wilson.ca>
COPY .statocles/build /usr/share/nginx/html
EXPOSE 80
LABEL site="www.watson-wilson.ca"
LABEL version="1.0"

# TODO add --drop-cap

# Howto:

# Build with  docker build -t www.watson-wilson.ca .

# View with   docker images

# Run with, where host port 8000 is mapped to conatiner port 80, exposed by
# Docker file
# docker run --cap-drop=all --cap-add=chown --cap-add=net_bind_service --cap-add=setgid --cap-add=setuid --detach --publish 8000:80 --name www.watson-wilson.ca -t www.watson-wilson.ca

# Stop with
# docker stop $(docker ps |awk '$2 ~ /^www.watson-wilson.ca/ { print $1 }')

# start with
# docker start $(docker ps |awk '$2 ~ /^www.watson-wilson.ca/ { print $1 }')

# Delete container
# docker rm $(docker ps -a |awk '$2 ~ /^www.watson-wilson.ca/ { print $1 }')

# Delete build image with 
# docker rmi $(docker images |awk '$1 ~ /^www.watson-wilson.ca$/ { print $3 }')

