# skillset

This workspace's own `magic-team` members. Each subdirectory is one member, and
holds that member's `SKILL.md` plus its typed definition files.

## Adding a member

1. Create the member's directory here, with its own `SKILL.md`.
2. Declare it in this project's `project.inf`:

		Declares: \
			magic-team:team-member:skillset/<member-name>:<host-glob> \

3. Register it, so agent clients pick it up:

		DistroAgentsTools.fn.sh --install-skillset-symlinks --scope workspace
		DistroAgentsTools.fn.sh --install-skillset-symlinks --scope user-home

Re-run step 3 after removing a member too — it reconciles this workspace's
registered set rather than only adding to it.

See [myx.distro-agents](https://github.com/myx/myx.distro-agents) for the team
itself and its tooling.
