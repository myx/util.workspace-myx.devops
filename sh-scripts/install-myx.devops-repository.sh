#!/bin/sh

####
## Note: this is a special script that is designed 
##       to run stand-alone (no location on local 
##       file-system) and on un-prepared OS. 
####

TGT_APP_PATH="${TGT_APP_PATH:-$1}"
test -z "$TGT_APP_PATH" && echo "ERROR: 'TGT_APP_PATH' env must be set" >&2 && exit 1

##########################

export MMDAPP="$TGT_APP_PATH"
mkdir -p "$MMDAPP"

# rm -rf "/Users/myx/test-ws/*" ; export MMDAPP="/Users/myx/test-ws"
set -e

echo "$0: Working in: $( pwd )"  >&2
if [ ! -d "$MMDAPP" ] ; then
	[ -d "$MMDAPP/source" ] || ( echo "ERROR: expecting 'source' directory." >&2 && exit 1 )
fi

cd "$MMDAPP"
echo "Workspace root: $( pwd )" >&2

if [ ! -d ".local/myx" ] ; then
	echo "Install: .local system, pulling system packages..." >&2
	mkdir -p ".local/myx" ; ( cd ".local/myx" ; rm -rf "myx.distro-.local" ; git clone git@github.com:myx/myx.distro-.local.git ) 
fi

bash .local/myx/myx.distro-.local/sh-scripts/DistroLocalTools.fn.sh --install-distro-source
echo "Install: .local system packages (re-)installed." >&2

( 
sed -e 's/^[[:space:]]*//' -e '/^#/d' -e '/^$/d' <<\SOURCE_SETUP

	DistroSourcePrepare.fn.sh --prepare-register-repository-root myx
  
	echo "SourceInstall: Pull Repositories..."  >&2
	(
		cat <<\INITIAL_REPOSITORIES
			myx/util.workspace-myx.devops git@github.com:myx/util.workspace-myx.devops.git
		INITIAL_REPOSITORIES
	) | DistroImageSync.fn.sh --execute-from-stdin-repo-list

	echo "SourceInstall: Sync Projects..." >&2

	DistroImageSync.fn.sh --all-tasks --execute-source-prepare-pull

	echo "SourceInstall: Done." >&2

	exit 0
	
SOURCE_SETUP
) | ./DistroSourceConsole.sh --non-interactive


############
echo "Done."