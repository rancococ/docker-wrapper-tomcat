#!/usr/bin/env bash

set -e
set -o noglob

#
# font and color 
#
bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
white=$(tput setaf 7)

#
# header and logging
#
header() { printf "\n${underline}${bold}${blue}> %s${reset}\n" "$@"; }
header2() { printf "\n${underline}${bold}${blue}>> %s${reset}\n" "$@"; }
info() { printf "${white}➜ %s${reset}\n" "$@"; }
warn() { printf "${yellow}➜ %s${reset}\n" "$@"; }
error() { printf "${red}✖ %s${reset}\n" "$@"; }
success() { printf "${green}✔ %s${reset}\n" "$@"; }
usage() { printf "\n${underline}${bold}${blue}Usage:${reset} ${blue}%s${reset}\n" "$@"; }

trap "error '******* ERROR: Something went wrong.*******'; exit 1" sigterm
trap "error '******* Caught sigint signal. Stopping...*******'; exit 2" sigint

set +o noglob

#
# entry base dir
#
pwd=`pwd`
base_dir="${pwd}"
source="$0"
while [ -h "$source" ]; do
    base_dir="$( cd -P "$( dirname "$source" )" && pwd )"
    source="$(readlink "$source")"
    [[ $source != /* ]] && source="$base_dir/$source"
done
base_dir="$( cd -P "$( dirname "$source" )" && pwd )"
cd ${base_dir}

# registry
registry_host="registry.cn-hangzhou.aliyuncs.com"
registry_username="rancococ@qq.com"
registry_password=""

# images
images=(
wrapper-tomcat:1.0.0-alpine,registry.cn-hangzhou.aliyuncs.com/rancococ/wrapper-tomcat:1.0-alpine
wrapper-tomcat:1.0.0-alpine,registry.cn-hangzhou.aliyuncs.com/rancococ/wrapper-tomcat:1.0.0-alpine
)

# build image
fun_build_image() {
docker build --rm \
             --no-cache \
             --add-host github.com:192.30.253.112 \
             --add-host github.com:192.30.253.113 \
             --add-host codeload.github.com:192.30.253.120 \
             --add-host codeload.github.com:192.30.253.121 \
             --add-host assets-cdn.github.com:151.101.72.133 \
             --add-host assets-cdn.github.com:151.101.76.133 \
             --add-host github.global.ssl.fastly.net:151.101.73.194 \
             --add-host github.global.ssl.fastly.net:151.101.77.194 \
             --add-host raw.githubusercontent.com:151.101.72.133 \
             --add-host raw.githubusercontent.com:151.101.228.133 \
             --add-host s3.amazonaws.com:52.216.100.205 \
             --add-host s3.amazonaws.com:52.216.130.69 \
             --add-host github-cloud.s3.amazonaws.com:52.216.64.104 \
             --add-host github-cloud.s3.amazonaws.com:52.216.166.91 \
             --add-host github-production-release-asset-2e65be.s3.amazonaws.com:54.231.114.66 \
             --add-host github-production-release-asset-2e65be.s3.amazonaws.com:52.216.165.147 \
             --build-arg wrapper_version=3.5.41.1 \
             -t wrapper-tomcat:1.0.0-alpine \
             -f Dockerfile .
}

# login registry
fun_login_registry() {
    header "login registry : ${registry_host}"
    info "Please enter your password for [${registry_username}]:"
    read -s registry_password
    if [ "x${registry_password}" == "x" ]; then
        error "Please enter you password."
        exit 0
    fi
    echo "${registry_password}" | docker login --username="${registry_username}" --password-stdin "${registry_host}"
    return 0
}

# push image
fun_push_image() {
    header "push images to registry : ${registry_host}"
    for data in ${images[@]}; do
        source=${data%%,*}
        target=${data#*,}
        info "push image [${target}] start...";
        docker tag ${source} ${target}
        docker push ${target}
        success "push image [${target}] success."
    done
    return 0
}

# clean images
fun_clean_images() {
    header "clean images:"
    none_images=$(docker images -f "dangling=true" -q)
    if [ "x${none_images}" != "x" ]; then
        docker rmi -f $(docker images -f "dangling=true" -q);
    fi
    success "clean image success."
    return 0
}

#
# main
#
# login registry
fun_login_registry

# build image
fun_build_image

# push image
fun_push_image

# clean images
fun_clean_images

success "build image complete."

exit $?
