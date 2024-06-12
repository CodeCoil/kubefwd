#!/bin/bash

function log()
{
	echo "${@}"
}

docker="podman.exe"
if command -v "$docker" &> /dev/null; then
    log "[run.sh] use podman.exe."
elif command -v podman &> /dev/null; then
    log "[run.sh] use podman."
    docker="podman"
elif command -v docker &> /dev/null; then
    log "[run.sh] use docker."
    docker="docker"
elif command -v docker.exe &> /dev/null; then
    log "[run.sh] use docker.exe."
    docker="docker.exe"
else
    log "[run.sh][ERROR] docker or podman not found (tested for podman, podman.exe, docker and docker.exe)."
    exit 1
fi

$docker run -it --rm \
    -v "go-pkg-mod-cache:/go/pkg/mod" \
    -v "go-cache:/root/.cache/go-build" \
    -v "${PWD}:/usr/src/myapp" \
    -w /usr/src/myapp \
    -e GOOS=windows \
    -e GOARCH=386 \
    golang:1.18 \
    bash -c "go mod tidy && go build -o ./dist/ -v ./cmd/kubefwd/kubefwd.go && echo 'Binary can be found under \$/dist'"
