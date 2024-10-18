#!/bin/bash

e(){
   local o=()
   for p in "$@"; do o+=("${p}"); done
   echo " >>>: ${o[@]}"
   "${o[@]}"
   return $?
}

ns_name="wcs"
ns_args="namespace=${ns_name},prefix=v1"

src="/go/src"
proto="/proto"
out_dir="/out"
app_dir="$out_dir/$ns_name"
docs_dir="$app_dir/docs"

tmp_dir="/out/${ns_name}/deps/bin/generated"
tmp_gen_dir="$tmp_dir/protoc_gen_go_${ns_name}"

front_end_dir="/out/external"

docs_args="docs,$ns_args"
ai=0
for api in $APP_API_GATEWAY; do
  docs_args="${docs_args},server[客服${ai}]=$api"
  ((ai=ai+1))
done

gen_client(){
  if [ "$#" != "1" ] ; then
    echo ">>>: args not match: gen_service $@"
    exit 3
  fi
  local name="$1"
  local files_var="${name}_files"
  local files_arr="${files_var}[@]"
  if [[ "$(declare -p $files_var)" =~ "declare -a" ]] ; then
    local files=${!files_arr}
  else
    echo "no files for $files_var $(declare -p files)"
    exit 1
  fi
  if [ "1" -gt "${#files[@]}" ]; then
      echo "no files for array ${#files[@]}"
      exit 1
  fi
  files="${files[@]}"
  local rdir="/client/${name}"
  local adir="${app_dir}$rdir"
  if [  -e "$adir" ] ; then
    e rm -rf $adir || exit $?
  fi
  e mkdir $adir || exit $?
  local client_args=(
    --gox_out="$adir"
    --gox_opt "$ns_args,app=${name},mod=client/${name},out=$rdir"
  )
  e protoc --gox_opt "dapr,noimpl" "${client_args[@]}" "${include_args[@]}" ${files} || exit $?
  return 0
}

gen_service(){
  if [ "$#" != "1" ] ; then
    echo ">>>: args not match: gen_service $@"
    exit 3
  fi
  local name="$1"
  local files_var="${name}_files"
  local files_arr="${files_var}[@]"
  if [[ "$(declare -p $files_var)" =~ "declare -a" ]] ; then
    local files=${!files_arr}
  else
    echo "no files for $files_var $(declare -p files)"
    exit 1
  fi
  if [ "1" -gt "${#files[@]}" ]; then
      echo "no files for array ${#files[@]}"
      exit 1
  fi
  files="${files[@]}"
  local rdir="/service/${name}"
  local adir="${app_dir}$rdir"
  e rm -rf $adir/${name}_rpc $adir/internal/ipc $adir/internal/impl_*
  service_args=(
    --gox_out="$rdir"
    --gox_opt "$ns_args,app=${name},mod=service/${name},out=$rdir"
  )
  e protoc  --gox_opt "dapr" "${service_args[@]}" "${include_args[@]}" $files || exit $?
  e protoc  --gox_opt "go" "${service_args[@]}" "${include_args[@]}" $files || exit $?
  gen_client "$name" || exit $?
  return 0
}

gen_docs(){
  if [ "$#" != "2" ] ; then
    echo ">>>: args not match: gen_docs $@"
    exit 3
  fi
  local name="$1"
  local opt="$2"
  local files_var="${name}_files"
  local files_arr="${files_var}[@]"
  if [[ "$(declare -p $files_var)" =~ "declare -a" ]] ; then
    local files=${!files_arr}
  else
    echo "no files for $files_var $(declare -p files)"
    exit 1
  fi
  if [ "1" -gt "${#files[@]}" ]; then
      echo "no files for array ${#files[@]}"
      exit 1
  fi
  files="${files[@]}"
  e protoc --gox_opt "$docs_args,app=${name},mod=service/${name},$opt" --gox_out="$docs_dir" "${include_args[@]}" $files || exit $?
  return 0
}

include_args=(
    "-I$src"
    "-I$src/github.com/envoyproxy/protoc-gen-validate"
    "-I$proto"
)

common_files=("$proto/api/option.proto")
common_files+=("$proto/api/scylla.proto")
dir="$proto/api/common"
e cd $dir || exit $?
for i in $(find . -name "*.proto"); do
  common_files+=("$dir/${i:2}")
done
common_files=($(printf '%s\n' "${common_files[@]}"|sort))

# core service
core_files=()
dir="$proto/api/core"
e cd $dir || exit $?
for i in $(find . -name "*.proto"); do
  core_files+=("$dir/${i:2}")
done
core_files=($(printf '%s\n' "${core_files[@]}"|sort))

# asset service
asset_files=()
dir="$proto/api/asset"
e cd $dir || exit $?
for i in $(find . -name "*.proto"); do
  asset_files+=("$dir/${i:2}")
done
asset_files=($(printf '%s\n' "${asset_files[@]}"|sort))

# sentry service
sentry_files=()
dir="$proto/api/sentry"
e cd $dir || exit $?
for i in $(find . -name "*.proto"); do
  sentry_files+=("$dir/${i:2}")
done
sentry_files=($(printf '%s\n' "${sentry_files[@]}"|sort))

e cd $src || exit $?
e rm -rf $tmp_gen_dir
e rm -rf $front_end_dir

all_files="${common_files[@]} ${sentry_files[@]} ${core_files[@]} ${asset_files[@]}"

# generate go
out_args=(
    --go_out="/out"
    --go-grpc_out="/out"
    --validate_out="lang=go:/out"
)

wcs_out_args=(
    --go-wcs_out="/out"
    --go-wcs_opt "ts=${app_dir}/deps/bin/generate/api.ts,${ns_args},include_prefix=api.core:api.asset"
)

e rm -rf $app_dir/api
e protoc "${include_args[@]}" "${out_args[@]}" "${wcs_out_args[@]}" $all_files || exit $?

gen_client sentry || exit $?
gen_service core || exit $?
gen_service asset || exit $?

tags="tag[tenant]=商户"
tags="$tags,tag[worker]=客服"
#tags="$tags,tag[settings]=设置"
#tags="$tags,tag[message]=消息"
tags="$tags,tag[auto_reply]=自动回复"
tags="$tags,tag[entrance]=应用入口"
tags="$tags,tag[gateway]=消息网关"
tags="$tags,tag[note]=客户备注"
tags="$tags,tag[quick_reply]=快速回复"
tags="$tags,tag[worker_group]=客服分组"
tags="$tags,tag[chat]=会话"
tags="$tags,tag[metric]=统计信息"

gen_docs core "$tags,server[本地环境]=http://127.0.0.1:8887"
gen_docs asset "tag[asset]=资源"

# gateway service
# todo: move to _proto_gen_gateway.sh
gateway_include_args=(
    "-I$src"
    "-I$src/github.com/envoyproxy/protoc-gen-validate"
    "-I$proto"
)

gateway_out_args=(
    --go_out="/out/service/gateway/protocol"
    --validate_out="lang=go:/out/service/gateway/protocol"
)

gateway_files=()
dir="$proto/gateway"
e cd $dir || exit $?
for i in $(find . -name "*.proto"); do
  gateway_files+=("$dir/${i:2}")
done
gateway_files=($(printf '%s\n' "${gateway_files[@]}"|sort))

e rm -rf $app_dir/service/gateway/protocol
e protoc "${include_args[@]}" "${out_args[@]}" ${gateway_files[@]} || exit $?