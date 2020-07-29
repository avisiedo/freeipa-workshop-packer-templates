#!/bin/bash

##
# This script is intended to be executed from the root repository path.
# It is a wrapper to make easier the interactions for the developers.
##

[ -e "${PWD}/.git" ] || ( echo "ERROR:Run this script from repository root path." >&2 && exit 1 )

# shellcheck source=./include/verbose.inc
source "./devel/include/verbose.inc"

[ -e credentials.env ] && source "credentials.env"

VAGRANT_CLOUD_VERSION="${VAGRANT_CLOUD_VERSION-:TIMESTAMP}"


function cmd-build
{
    local _reto
    local _build_path

    _build_path="$1"
    shift 1
    [ "${_build_path}" != "" ] || die "System template path must be specified (e.g. './devel/helper.sh build fedora/32')."

    pushd "${_build_path}" 1>/dev/null 2>/dev/null || die "The build path '$_build_path' is not found."
    # packer build --only=virtualbox-iso template.json; _reto=$?
    rm -rf ../../builds
    export VAGRANT_CLOUD_BOXTAG
    export VAGRANT_CLOUD_VERSION
    export VAGRANT_CLOUD_TOKEN
    basename="${VAGRANT_CLOUD_BOXTAG##*/}"
    verbose packer build -only qemu \
                         -var "version=${VAGRANT_CLOUD_VERSION}" \
                         -var "box_basename=${basename}" \
                         "$@" template.json
    _reto=$?
    # FIXME: Uncomment the line when finish debugging
    # rm -f .template.json
    popd 1>/dev/null 2>/dev/null
    return $_reto
}


function cmd-install-dependencies
{
    ./devel/install-dependencies.sh
}



function cmd-help
{
    cat <<EOF
Usage: ./devel/helper.sh <subcommand> . . .

    help 
    install-dependencies
        Run script which install the dependencies for running the subcommands
        properly.
    build <path/template> ...
        Build and push the image to vagran-cloud. It uses the environment vars
        below:
          - VAGRANT_CLOUD_TOKEN: The vagrant cloud tokent to be used to store
            the image.
          - VAGRANT_CLOUD_BOXTAG: The tag to use for uploading the box.
          - VAGRANT_CLOUD_VERSION: The version to be used for the box.
        Usage: ./helper.sh build fedora/32
EOF
}


SUBCMD="$1"
shift 1

case "$SUBCMD" in
    "install-dependencies" | "help" | "build" )
        try cmd-${SUBCMD} "$@"
        ;;
    * )
        die "'$SUBCMD' is an unknown subcommand. Type in './devel/helper.sh help' for some help."
        ;;
esac
