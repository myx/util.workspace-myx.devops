# util.workspace-myx.devops


Installer script, from zero to a fully configured workspace: [install-myx.devops-workspace.sh](https://github.com/myx/util.workspace-myx.devops/blob/main/sh-scripts/install-myx.devops-workspace.sh). Set `TGT_APP_PATH`, or pass the install path as the first argument.

Examples:

 Mac OSX (using `curl` and `~/Workspaces/ws-myx.devops` as workspace root):
 
	export TGT_APP_PATH=~/Workspaces/ws-myx.devops ; curl --silent -L https://raw.githubusercontent.com/myx/util.workspace-myx.devops/refs/heads/main/sh-scripts/install-myx.devops-workspace.sh | sh -e
	
 FreeBSD (using `fetch` and `~/Workspaces/ws-myx.devops` as workspace root):

	export TGT_APP_PATH=~/Workspaces/ws-myx.devops ; fetch -o - https://raw.githubusercontent.com/myx/util.workspace-myx.devops/refs/heads/main/sh-scripts/install-myx.devops-workspace.sh | sh -e
	
 Linux (using `wget` and `~/Workspaces/ws-myx.devops` as workspace root)
 
	export TGT_APP_PATH=~/Workspaces/ws-myx.devops ; wget --quiet -O - https://raw.githubusercontent.com/myx/util.workspace-myx.devops/refs/heads/main/sh-scripts/install-myx.devops-workspace.sh | sh -e

