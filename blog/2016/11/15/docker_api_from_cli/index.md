---
title: Docker API from CLI
tags: docker, containers, jq, json, cli
---

<a href="https://docker.com/"><img style='float:right' alt='Docker website' width='120px' src='/static/images/docker-logo.png'></a>

Docker has command line programs, but they are not well suited to automation.
Return values and pars-able output are both lacking, but there is an
[API](https://docs.docker.com/engine/reference/api/docker_remote_api/) that you
can use instead. The Dockerd api can listen on a local socket or even a
remote accessible port, but in these examples I'll show local socket only.

---

## Raw

Use [curl](https://curl.haxx.se/) to connect to the docker socket, and give a
URL related to Docker's API. In this example you'll get compressed and
unreadable JSON about all installed Docker images.

### List all docker images

%= highlight Bash => begin
curl --unix-socket /run/docker.sock http://docker/images/json
% end

## Pretty and practical

Pretty the input using [jq](https://stedolan.github.io/jq/).

%= highlight Bash => begin
curl --unix-socket /run/docker.sock http://docker/images/json| jq .
% end

Here's an excerpt, one image:

%= highlight Javascript => begin
{
    "Id": "sha256:25e41e468c9cb4351dbbeedf2a9d266bcdf2257d3b1188a73b421b2035513f01",
    "ParentId": "",
    "RepoTags": [
          "perl:5.24"
    ],
    "RepoDigests": [
      "perl@sha256:6c589d851fed973cf7e1285abc13f4f92d31665f6acf4e094819d5292160e5c7"
    ],
    "Created": 1477122199,
    "Size": 655927650,
    "VirtualSize": 655927650,
    "Labels": {}
},
% end

We can further use jq to search and return selected information.

### Return just the image ids

%= highlight Bash => begin
curl -s --unix-socket /run/docker.sock http://docker/images/json \\
    | jq '.[]|.Id'
% end

### Return image ids and creation epoch time

%= highlight Bash => begin
curl -s --unix-socket /run/docker.sock http://docker/images/json \\
    | jq '.[]|.Id,.Created'
% end

### Search for a given image and return created epoch time

%= highlight Bash => begin
curl -s --unix-socket /run/docker.sock http://docker/images/json \\
    | jq '.[]| select( .Id \\
    == \\
    "sha256:52c080433dada462d6c7fbaa7f84f96a20448a23cdcec115cf17deaee8d3c4a8" )\\
    |.Created'
% end

### Search for images created earlier than 10 minutes ago

%= highlight Bash => begin
curl -s --unix-socket /run/docker.sock http://docker/images/json \\
    | jq '.[]| select( .Created < ( now - 600 ))|.Id'
% end

### Search for images that contain given RepoTags and return the created epoch time

%= highlight Bash => begin
curl -s --unix-socket /run/docker.sock http://docker/images/json \\
    | jq '.[] | select( .RepoTags[] == "perl:5.24" )|.Created'
% end

## References:

1. [Bash that JSON (with jq)](http://blog.librato.com/posts/jq-json)
1. [Docker API](https://docs.docker.com/engine/reference/api/docker_remote_api/)

