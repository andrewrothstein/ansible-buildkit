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
    local suffix=${4:-tar.gz}
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
    dl $ver darwin amd64
    dl $ver darwin arm64
    dl $ver linux amd64
    dl $ver linux arm-v7
    dl $ver linux arm64
    dl $ver linux ppc64le
    dl $ver linux riscv64
    dl $ver linux s390x
    dl $ver windows amd64
    dl $ver windows arm64
}

dl_ver ${1:-0.21.0}
