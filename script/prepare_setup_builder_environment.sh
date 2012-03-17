#!/bin/bash
# Script used to prepare default environment for setup builder

DESTINATION_PATH=/tmp/setup_execs
TEMP_PATH=/tmp/tmp_build
TEMPLATE_PATH=/tmp/setup
INSTALL_CREATOR_PATH=/tmp/ic

function show_options () {
  echo
  echo 'SCRIPT USAGE:'
  echo
  echo 'prepare_setup_builder_environment.sh DESKTOP_APPLICATION_PATH INSTALL_CREATOR_PATH'
  echo
}

function create_directories () {
  mkdir -p "$TEMP_PATH" "$TEMPLATE_PATH" "$INSTALL_CREATOR_PATH" "$DESTINATION_PATH"
}

function copy_files () {
  cp -rf "$DESKTOP_APP/setup"/* "$TEMPLATE_PATH"
  cp -rf "$INSTALL_CREATOR"/* "$INSTALL_CREATOR_PATH"
}

function show_extra_information () {
  echo
  echo "REMBEMBER:"
  echo "Remember to install xvfb and wine package in order to get build service working"
}

function build_environment () {
  echo "Preparing build environment"
  echo "Creating directory structure"
  create_directories

  echo "Copying files"
  copy_files

  echo "Environment is ready"
  show_extra_information

}

if [ "${#@}" -ne 2 ] ; then
  show_options
  exit 1
else
  DESKTOP_APP=$1
  INSTALL_CREATOR=$2

  build_environment
fi


