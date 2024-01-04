#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/moby/buildkit/releases/download

# https://github.com/moby/buildkit/releases/download/v0.8.3/buildkit-v0.8.3.linux-amd64.tar.gz

dl()
{
    local ver=$1
    local os=$2
    local arch=$3
    local suffix=$4
    local platform="${os}-${arch}"
    local file=buildkit-v${ver}.${platform}.${suffix}
    local dlfile=$DIR/$file
    local url=$MIRROR/v${ver}/$file
    if [ ! -e $dlfile ]
    then
        curl -sSLf -o $dlfile $url
    fi
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform `sha256sum $dlfile | awk '{print $1}'`
}

dl_ver ()
{
    local ver=$1
    printf "  '%s':\n" $ver
    dl $ver darwin amd64 tar.gz
    dl $ver darwin arm64 tar.gz
    dl $ver linux amd64 tar.gz
    dl $ver linux arm-v7 tar.gz
    dl $ver linux arm64 tar.gz
    dl $ver linux ppc64le tar.gz
    dl $ver linux riscv64 tar.gz
    dl $ver linux s390x tar.gz
    dl $ver windows amd64 tar.gz
    dl $ver windows arm64 tar.gz
}

dl_ver ${1:-0.12.4}
