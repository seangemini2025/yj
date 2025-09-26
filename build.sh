#!/bin/bash

set -e

version=${1:-0.0.0}
out=build-v${version}
cd "$(dirname "${BASH_SOURCE[0]}")"
mkdir -p "$out"

# Build yj binary
GOOS=darwin GOARCH=amd64 go build -ldflags "-X main.Version=$version" -o "$out/yj-macos-amd64" main.go flags.go
GOOS=darwin GOARCH=arm64 go build -ldflags "-X main.Version=$version" -o "$out/yj-macos-arm64" main.go flags.go
GOOS=linux GOARCH=amd64 go build -ldflags "-X main.Version=$version" -o "$out/yj-linux-amd64" main.go flags.go
GOOS=linux GOARCH=arm64 go build -ldflags "-X main.Version=$version" -o "$out/yj-linux-arm64" main.go flags.go
GOOS=linux GOARCH=arm GOARM=5 go build -ldflags "-X main.Version=$version" -o "$out/yj-linux-arm-v5" main.go flags.go
GOOS=linux GOARCH=arm GOARM=7 go build -ldflags "-X main.Version=$version" -o "$out/yj-linux-arm-v7" main.go flags.go
GOOS=windows GOARCH=amd64 go build -ldflags "-X main.Version=$version" -o "$out/yj.exe" main.go flags.go

# Build ty binary (TOML to YAML)
GOOS=darwin GOARCH=amd64 go build -tags ty -ldflags "-X main.Version=$version" -o "$out/ty-macos-amd64" main_ty.go flags.go
GOOS=darwin GOARCH=arm64 go build -tags ty -ldflags "-X main.Version=$version" -o "$out/ty-macos-arm64" main_ty.go flags.go
GOOS=linux GOARCH=amd64 go build -tags ty -ldflags "-X main.Version=$version" -o "$out/ty-linux-amd64" main_ty.go flags.go
GOOS=linux GOARCH=arm64 go build -tags ty -ldflags "-X main.Version=$version" -o "$out/ty-linux-arm64" main_ty.go flags.go
GOOS=linux GOARCH=arm GOARM=5 go build -tags ty -ldflags "-X main.Version=$version" -o "$out/ty-linux-arm-v5" main_ty.go flags.go
GOOS=linux GOARCH=arm GOARM=7 go build -tags ty -ldflags "-X main.Version=$version" -o "$out/ty-linux-arm-v7" main_ty.go flags.go
GOOS=windows GOARCH=amd64 go build -tags ty -ldflags "-X main.Version=$version" -o "$out/ty.exe" main_ty.go flags.go

# Build yt binary (YAML to TOML)
GOOS=darwin GOARCH=amd64 go build -tags yt -ldflags "-X main.Version=$version" -o "$out/yt-macos-amd64" main_yt.go flags.go
GOOS=darwin GOARCH=arm64 go build -tags yt -ldflags "-X main.Version=$version" -o "$out/yt-macos-arm64" main_yt.go flags.go
GOOS=linux GOARCH=amd64 go build -tags yt -ldflags "-X main.Version=$version" -o "$out/yt-linux-amd64" main_yt.go flags.go
GOOS=linux GOARCH=arm64 go build -tags yt -ldflags "-X main.Version=$version" -o "$out/yt-linux-arm64" main_yt.go flags.go
GOOS=linux GOARCH=arm GOARM=5 go build -tags yt -ldflags "-X main.Version=$version" -o "$out/yt-linux-arm-v5" main_yt.go flags.go
GOOS=linux GOARCH=arm GOARM=7 go build -tags yt -ldflags "-X main.Version=$version" -o "$out/yt-linux-arm-v7" main_yt.go flags.go
GOOS=windows GOARCH=amd64 go build -tags yt -ldflags "-X main.Version=$version" -o "$out/yt.exe" main_yt.go flags.go

docker build . --build-arg "version=$version" -t "sclevine/yj:$version"
docker tag "sclevine/yj:$version" "sclevine/yj:latest"