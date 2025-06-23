#!/usr/bin/env sh

####
## Note: this is a special script that is designed to run stand-alone
##        (no location on local file-system) and on unprepared unix machine. 
####

WorkspaceBootstrap() {
	bash -ec 'bash -xe <(
		url="https://raw.githubusercontent.com/myx/myx.distro-.local/refs/heads/main/sh-scripts/workspace-install.sh"
		command -v curl >/dev/null 2>&1 && curl -fsSL "$url" && exit 0
		command -v fetch >/dev/null 2>&1 && fetch -q -o - "$url" && exit 0
		command -v wget >/dev/null 2>&1 && wget -qO- "$url" && exit 0
		echo "⛔ ERROR: need curl, fetch or wget" >&2; exit 1;
	)' -- "$@"
}

WorkspaceBootstrap --git-clone --config-stdin \
<<'WORKSPACE_CONFIG'

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
