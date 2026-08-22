# util.workspace-myx.devops

The reference myx.devops workspace: one installer script that goes from an empty
directory to a fully configured workspace with every `myx.distro-*` toolset
installed and every console launcher generated.

## Install

Set `TGT_APP_PATH` to the directory the workspace should live in, then pipe the
installer to a shell. `TGT_APP_PATH` is required — there is no positional form.

macOS, with `curl`:

	export TGT_APP_PATH=~/Workspaces/ws-myx.devops
	curl --silent -L https://raw.githubusercontent.com/myx/util.workspace-myx.devops/refs/heads/main/sh-scripts/install-myx.devops-workspace.sh | sh -e

FreeBSD, with `fetch`:

	export TGT_APP_PATH=~/Workspaces/ws-myx.devops
	fetch -o - https://raw.githubusercontent.com/myx/util.workspace-myx.devops/refs/heads/main/sh-scripts/install-myx.devops-workspace.sh | sh -e

Linux, with `wget`:

	export TGT_APP_PATH=~/Workspaces/ws-myx.devops
	wget --quiet -O - https://raw.githubusercontent.com/myx/util.workspace-myx.devops/refs/heads/main/sh-scripts/install-myx.devops-workspace.sh | sh -e

The installer clones over git, so the machine needs `git` and an SSH key that can
read the configured repositories.

## What you get

Five console launchers in the workspace root, each entering a different context:

- `./DistroLocalConsole.sh` — install, upgrade and configure the toolsets.
- `./DistroSourceConsole.sh` — sync sources, build and ingest the distro index.
- `./DistroDeployConsole.sh` — prepare and run deploys against SSH targets.
- `./DistroRemoteConsole.sh` — drive a workspace on another machine.
- `./DistroAgentsConsole.sh` — start an AI-agent CLI session against the workspace.

Every console takes `--non-interactive`, so a single command can be piped in:

	echo "Distro DistroImageSync --all-tasks --execute-source-prepare-pull" \
		| ./DistroSourceConsole.sh --non-interactive

## First tasks after installing

Pull every configured source repository:

	echo "Distro DistroImageSync --all-tasks --execute-source-prepare-pull" \
		| ./DistroSourceConsole.sh --non-interactive

Pick up a local source edit:

	echo "Distro DistroSourcePrepare --ingest-distro-index-from-source" \
		| ./DistroSourceConsole.sh --non-interactive

List what the workspace now contains:

	echo "Distro ListDistroProjects --all-projects" \
		| ./DistroSourceConsole.sh --non-interactive

## Custom team members

`skillset/` holds this workspace's own `magic-team` members, declared in
`project.inf` and registered with `myx.distro-agents`. See
[skillset/README.md](skillset/README.md).

## Getting help

- Open a console and run `<Tool>.fn.sh --help` for any command.
- Press TAB after a command name and a space for shell completion.

## Related packages

- [myx.distro-.local](https://github.com/myx/myx.distro-.local) — install and launch the toolsets.
- [myx.distro-system](https://github.com/myx/myx.distro-system) — shared indexing and query tools.
- [myx.distro-source](https://github.com/myx/myx.distro-source) — build source into a distro image.
- [myx.distro-deploy](https://github.com/myx/myx.distro-deploy) — deploy a distro image to hosts.
- [myx.distro-remote](https://github.com/myx/myx.distro-remote) — drive a workspace on another machine.
- [myx.distro-agents](https://github.com/myx/myx.distro-agents) — the magic-team agents and their tooling.
