#!/bin/sh

####
## Note: this is a special script that is designed to run stand-alone
##        (no location on local file-system) and on unprepared unix machine. 
####

set -e

WORKSPACE_INSTALLER_URL="https://raw.githubusercontent.com/myx/myx.distro-.local/refs/heads/main/sh-scripts/workspace-install.sh"

FetchStdout() {
    : "${1:?"⛔ ERROR: FetchStdout: The URL is required!"}"
    command -v curl  >/dev/null 2>&1 && { curl --silent -L "$1"; return 0; }
    command -v fetch >/dev/null 2>&1 && { fetch -o - "$1"; return 0; }
    command -v wget  >/dev/null 2>&1 && { wget --quiet -O - "$1"; return 0; }
    echo "⛔ ERROR: 'curl', 'fetch', or 'wget' were not found, do not know how to download!" >&2
    exit 1
}

FetchStdout $WORKSPACE_INSTALLER_URL \
| sh -es -- --git-clone --config-stdin \
<<WORKSPACE_CONFIG

    ## Workspace config for: myx/util.workspace-myx.devops ##

    # Repository roots for source projects:
        source root lib
        source root myx

    # Initial list of source projects to pull
        source pull myx/util.workspace-myx.devops:main:git@github.com:myx/util.workspace-myx.devops.git

    # Executable commands to setup source sub-system
        source exec Source DistroSourceTools --system-config-option --upsert-if MDLT_CONSOLE_ORIGIN source ""
        source exec Source DistroImageSync --all-tasks --execute-source-prepare-pull

WORKSPACE_CONFIG
