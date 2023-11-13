#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Use package mirror"
   echo
   echo "Syntax: ./package_mirror (mirror|download|upload) [-h|P|V|d|p]"
   echo "command:"
   echo "mirror   Mirror the python package by downloading and uploading"
   echo "download Download the python package"
   echo "upload  Upload the downloaded python package"
   echo "h     Print this Help."
   echo "P     Python packages to be Mirrored."
   echo "V     The Python interpreter version to use for wheel."
   echo "d     Download packages into <dir>."
   echo "p     The pod to copy packages to."
   echo
}

############################################################
# PrintLog                                                     #
############################################################
PrintLog()
{
  echo "Mirror is in progression:"
  echo "python package: $package";
  echo "python version: $python_version";
  echo "download dir: $download_dir";
  echo "pod name: $pod_name";
}

Download()
{
  # mandatory arguments
  if [ ! "$package" ] || [ ! "$python_version" ] || [ ! "$download_dir" ]; then
    echo "Arguments -P , -V and -d must be provided"
    echo "$usage" >&2; exit 1
  fi

  # Download the package with pip
  pip download $package --python-version $python_version --only-binary=:all: -d $download_dir
}

Upload()
{ 

  # mandatory arguments
  if [ ! "$pod_name" ] || [ ! "$download_dir" ]; then
    echo "Arguments -p and -d must be provided"
    echo "$usage" >&2; exit 1
  fi

  # Upload the package to pod
  for entry in "./$download_dir/"/*
  do
    echo "$entry"
    oc cp $entry $pod_name:/opt/app-root/packages
  done
}


############################################################
############################################################
# Main program                                             #
############################################################
############################################################

while getopts P:V:d:p:h option; do
    case "${option}" in
        P) package=${OPTARG};;
        V) python_version=${OPTARG};;
        d) download_dir=${OPTARG};;
        p) pod_name=${OPTARG};;
        h) # display Help
         Help
         exit;;
        \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
    esac
done

command=${@:$OPTIND:1}
echo -e "${GREEN}Command${NC}: $command"

if [ "$command" == "mirror" ]; then
  PrintLog
  Download
  Upload
elif [ "$command" == "download" ]; then
  PrintLog
  Download
elif [ "$command" == "upload" ]; then
  PrintLog
  Upload
elif [ ! "$command" ] ; then
  echo -e "Command needs to be ${RED}mirror${NC} or ${RED}download${NC} or ${RED}upload${NC}"
  echo "$usage" >&2; exit 1
else
  echo -e "Command needs to be ${RED}mirror${NC} or ${RED}download${NC} or ${RED}upload${NC}"
  echo "$usage" >&2; exit 1
fi
