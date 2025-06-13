#!/bin/sh

####
## Note: this is a special script that is designed 
##       to run stand-alone (no location on local 
##       file-system) and on un-prepared OS. 
####

: "${TGT_APP_PATH:=${1:?ERROR: 'TGT_APP_PATH' env must be set or passed in the first argument}}"

ROOT_LIST="$( tr -s '[:space:]' ' ' \
<<ROOT_LIST

	lib
	myx

ROOT_LIST
)" # ROOT_LIST

REPO_LIST="$( cat \
<<REPO_LIST

	myx/util.workspace-myx.devops	git@github.com:myx/util.workspace-myx.devops.git	main

REPO_LIST 
)" # REPO_LIST

set -e

export MMDAPP="$( eval echo $TGT_APP_PATH )"
mkdir -p "$MMDAPP"
cd "$MMDAPP"


echo "$0: Workspace root: $( pwd )" >&2

if [ ! -d ".local/myx" ] ; then
	echo "Install: .local system, pulling system packages..." >&2
	mkdir -p ".local/myx" ; ( cd ".local/myx" ; rm -rf "myx.distro-.local" ; git clone git@github.com:myx/myx.distro-.local.git ) 
fi
if [ ! -d "source" ] ; then
	echo "Install: DistroLocalTools.fn.sh --install-distro-source..." >&2
	bash .local/myx/myx.distro-.local/sh-scripts/DistroLocalTools.fn.sh --install-distro-source
fi

sed -e 's/^[[:space:]]*//' -e '/^#/d' -e '/^$/d' | ./DistroSourceConsole.sh --non-interactive \
<<SOURCE_SETUP

	echo "SourceInstall: Running task within Source Cnsole..."  >&2

	DistroSourceTools.fn.sh --register-repository-roots $ROOT_LIST
  
	echo "SourceInstall: Pull Initial Repositories..."  >&2
	DistroImageSync.fn.sh --execute-from-stdin-repo-list <<REPO_LIST
		$REPO_LIST
	REPO_LIST

	echo "SourceInstall: Sync All Known Projects..." >&2
	DistroImageSync.fn.sh --all-tasks --execute-source-prepare-pull
	
SOURCE_SETUP


############
echo "Done."
