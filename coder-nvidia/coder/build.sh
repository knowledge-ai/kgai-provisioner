#!/bin/bash

# IMPORTANT: always source this script when executing
# this script sets environment variables, so the variables will
# be available in the current environment
function _bump() {
  setopt local_options BASH_REMATCH
  version="$1"
  # do not suppress with quote
  version_arr=(${version//./ })
  major="${version_arr[0]}"
  minor="${version_arr[1]}"
  build="${version_arr[2]}"

  # break down the version number into it's components

  echo "current version ${major}.${minor}.${build}"

  # check paramater to see which number to increment
  if [[ "$2" == "feature" ]]; then
    minor=$(echo $minor + 1 | bc)
    echo "bumping up minor"
  elif [[ "$2" == "bug" ]]; then
    build=$(echo $build + 1 | bc)
    echo "bumping up build"
  elif [[ "$2" == "major" ]]; then
    major=$(echo $major+1 | bc)
    echo "bumping up major"
  else
    echo "usage: _bump version_number [major/feature/bug]"
  fi

  # set the app version environment variable
  export APP_VERSION=${major}.${minor}.${build}
  # echo the new version number
  echo "new app version: ${APP_VERSION}"

}

function version_bump() {
  cur_ver=$(cat "./version.md")
  echo "current version: ${cur_ver}"
  # master -> increment major
  # ft/* -> increment minor (feature branch)
  # bg/* -> increment build (bug branch)
  case $(git branch | sed -n '/\* /s///p') in

  master)
    _bump "${cur_ver}" major
    ;;

  ft/*)
    _bump "${cur_ver}" feature
    ;;

  bg/*)
    _bump "${cur_ver}" bug
    ;;

  *)
    echo "no defined spec for branch: $(git branch | sed -n '/\* /s///p')"
    echo "not updating version"
    ;;
  esac

  echo "updating version in version.md file"
  echo "${APP_VERSION}" >'./version.md'

}

function compile_source() {
  if [[ -z "${APP_RELEASE}" ]]; then
    echo "APP_RELEASE is not set"
    export APP_VERSION=$(cat "./version.md")
  else
    echo "APP_RELEASE is set doing a release from current branch.."
    # check and update version
    version_bump
  fi

}

function build_docker() {
  compile_source

  echo "building docker image with APP_VERSION: ${APP_VERSION}"

  docker build -f Dockerfile -t knowledgeai/kgai-coder:"${APP_VERSION}" .
  #docker push knowledgeai/kgai-jupyter:"${APP_VERSION}"
}

build_docker
