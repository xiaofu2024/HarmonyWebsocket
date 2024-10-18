#!/usr/bin/env bash

cd $dir/proto || exit $?
source  $dir/dapr/.env_default.sh

local_compose="./.local-compose.yml"
remote_compose="./docker-compose.yml"
if [ -e "$local_compose" ] ; then
  e docker-compose -f $local_compose down
else
  e docker-compose down
fi

protoc_gox_version="20230308"
protoc_gen_wcs_version="20230113b"
tools_version="v_20220401"

bin_dir="$dir/deps/bin"
e cd $bin_dir || exit $?

bin="./protoc-gen-gox"
zip="${bin}${protoc_gox_version}.tar.gz"
if [[ ! -e "$zip" || ! -e "$bin"  ]] ; then
  if [ -e "$bin" ] ; then e rm -rf "$bin" || exit $?; fi
  find . -name "$(basename $bin)*.tar.gz" -exec rm -rf {} \;
  e curl -o $zip -L "$XDEV_URL/$XDEV_NS/$(basename $zip)" || rm $zip $bin
  e tar xvf $zip || exit $?
fi

if [[ "$UNAME" == CYGWIN* || "$UNAME" == MINGW* ]] ; then
  e $dir/deps/sbin/gox.exe --dos2unix ../../proto/_proto_gen.sh || exit $?
fi

protoc_gen_go_wcs_dir="$dir/service/tools/protoc_gen_go_wcs"
bin="protoc-gen-go-wcs"
bin_v=".protoc-gen-go-wcs_$protoc_gen_wcs_version"
if [ -d "$bin" ] ; then
  e rm -rf $bin || exit $?
fi
if [[ ! -e "$bin" || ! -e "$bin_v" ]] ; then
  export GOOS="linux"
  export GOARCH="amd64"
	export CGO_ENABLED=0
	e go mod tidy || exit $?
	e cd $protoc_gen_go_wcs_dir || exit $?
	e go build . || exit $?
	e mv protoc_gen_go_wcs $bin_dir/protoc-gen-go-wcs
	e cd $bin_dir || exit $?
#  e go build -o $bin $protoc_gen_go_wcs_dir || exit $?
  e rm -f .protoc-gen-go-wcs_*
  e touch $bin_v || exit $?
fi

tools_version_file="../deps/bin/.$tools_version"
e cd ${dir}/proto || exit $?
if [ ! -e "$tools_version_file" ] ; then
        e docker pull harbor.77devops.com/wangwang-public/wangwang-wng_protoc:latest || exit $?
        e touch $tools_version_file || exit $?
fi

if [ -e "$local_compose" ] ; then
  e docker-compose -f $local_compose up -d || exit $?
else
  # e docker-compose -f $remote_compose build || exit $?
  e docker-compose up -d || exit $?
fi


export orig_dir="$dir"
dir="$dir/dapr"
cd $dir || exit $?
source $dir/.env_default.sh

dir="$orig_dir"
unset orig_dir
