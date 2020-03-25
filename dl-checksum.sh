#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/sonatype-nexus-community/nancy/releases/download

dl()
{
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}.${arch}"
    local file=nancy-${platform}-${ver}.${archive_type}
    local url=$MIRROR/$ver/$file

    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(fgrep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1

    local rchecksums=$MIRROR/${ver}/nancychecksums.txt
    local lchecksums=$DIR/nancy-${ver}-checksums.txt

    if [ ! -e $lchecksums ];
    then
        wget -q -O $lchecksums $rchecksums
    fi

    printf "  %s:\n" $ver
    dl $ver $lchecksums darwin amd64
    dl $ver $lchecksums darwin 386
    dl $ver $lchecksums linux amd64
    dl $ver $lchecksums linux 386
    dl $ver $lchecksums windows 386 zip
    dl $ver $lchecksums windows amd64 zip
}

dl_ver ${1:-v0.1.14}