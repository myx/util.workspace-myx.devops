#!/bin/sh

####
## Note: this is a special script that is designed 
##       to run stand-alone (no location on local 
##       file-system) and on un-prepared OS. 
####

set -e


if false ; then
FetchStdout() {
    local URL="$1"
    [ -n "$URL" ] || { echo "⛔ ERROR: FetchStdout: The URL is required!" >&2; exit 1; }
    set -e

    command -v curl  >/dev/null 2>&1 && { curl --silent -L "$URL"; return 0; }
    command -v fetch >/dev/null 2>&1 && { fetch -o - "$URL"; return 0; }
    command -v wget  >/dev/null 2>&1 && { wget --quiet -O - "$URL"; return 0; }

    echo "⛔ ERROR: curl, fetch, or wget were not found, do not know how to download!" >&2
    exit 1
}

set -x
FetchStdout https://raw.githubusercontent.com/myx/myx.distro-.local/refs/heads/main/sh-scripts/DistroLocalTools.fn.sh \
| sh -xes -- --install-workspace-from-stdin-config <<WORKSPACE

	# Repository roots for source projects:
	source root lib
	source root myx

	# Initial list of source projects to pull
	source pull myx/util.workspace-myx.devops:main:git@github.com:myx/util.workspace-myx.devops.git

	# Executable commands to setup source sub-system
	source exec Source DistroSourceTools --system-config-option --upsert-if MDLT_CONSOLE_ORIGIN source ""
	source exec Source DistroImageSync --all-tasks --execute-source-prepare-pull

WORKSPACE
fi


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

EXTRA_CMD="$( cat \
<<REPO_LIST

	# Run Distro tools from source folder, so we can edit source files and feel 
	# the change without commiting and updating the system via public repository.

	Distro DistroSourceTools --system-config-option --upsert-if MDLT_CONSOLE_ORIGIN source ""

REPO_LIST
)" # REPO_LIST

: "${TGT_APP_PATH:=${1:?⛔ ERROR: TGT_APP_PATH env must be set or call as: $0 <workspace-path>}}"
MMDAPP=$TGT_APP_PATH
case $MMDAPP in
  "~"*) MMDAPP=$HOME${MMDAPP#\~} ;;	# expand ~
esac
case $MMDAPP in
  /*) ;;							# already absolute
  *)  MMDAPP=$PWD/$MMDAPP ;;		# make absolute
esac

export MMDAPP

mkdir -p "$MMDAPP"
cd "$MMDAPP"

echo "$0: Workspace root: $PWD" >&2

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

	set -ex

	echo "SourceInstall: Running task within Source Console..."  >&2

	Source DistroSourceTools --register-repository-roots $ROOT_LIST
  
	echo "SourceInstall: Pull Initial Repositories..."  >&2
	Source DistroImageSync --execute-from-stdin-repo-list <<REPO_LIST
		$REPO_LIST
	REPO_LIST

	echo "SourceInstall: Sync All Known Projects..." >&2
	Source DistroImageSync --all-tasks --execute-source-prepare-pull
	
	echo "SourceInstall: All Source Console tasks done."  >&2

SOURCE_SETUP

############
echo "Done."
