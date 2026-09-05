# MAGIC.md — util.workspace-myx.devops

Team-owned notes for the magic-* team. This package is the workspace that hosts the whole `myx.distro-*` family, so what belongs here is the relationship between the packages, and what counts as work on the family at all. Each package's own `MAGIC.md` carries its own internals.

## What ships is the deliverable; this machine's own state is not

- Local config, allowlists, caches and settings exist only on this one computer. None of it reaches a client, so a change there fixes nothing and is not the work.
- Effort spent on it is taken from the released product. That trade never comes out ahead — it is negative work, not neutral work.
- It is also how this estate's real failure mode is produced: software that works on this machine and does not work on a client's, until clients cannot work and the company goes bankrupt. Local state that makes something work here is what hides the defect from review, so working here is evidence of nothing.
- Reading local state to diagnose a product defect is legitimate. Changing it instead of fixing the product is not.
- A tool writing local state through its own install or upgrade path is that tool's shipped behaviour and is normal. A session hand-editing that state is not — the distinction is who wrote it, not what changed.

## The family, and what each package owns

- `myx.distro-.local` — installs the other packages and generates the workspace's console launchers. What a workspace actually exposes is decided here.
- `myx.distro-system` — the shared engine: tool dispatch, the index, and the `Requires`/`Provides` sequence every other package builds on. It carries no pipeline builders and no console of its own.
- `myx.distro-source` — source sync, prepare and ingest, plus the source-side pipeline builders.
- `myx.distro-deploy` — SSH target selection and execution against hosts, plus the deploy-side pipeline builders.
- `myx.distro-remote` — drives a myx.distro workspace on another machine. Unfinished.
- `myx.distro-agents` — the magic-team skillset and the tooling the team routines call.
- `myx.common` is not a sibling of these. It is a separate project sharing only the name prefix: `myx.distro-*` calls its commands at runtime and takes none of its conventions.

## Where a convention comes from

- `myx.distro-source` and `myx.distro-deploy` are the authority for this family. Both are used daily, so their shape reflects decisions that were actually made and held.
- `myx.distro-remote` is unfinished and is never cited as an example of anything. It still receives every fix that sweeps the family, so it is never the package left out of a change.
- `myx.distro-agents` is the drifted package — newest, largely agent-written. A pattern found there is never precedent for anything else until a daily-used sibling confirms it.
- `myx.common` is a different codebase with its own style, and is never a source of distro conventions. Importing its idioms into a `myx.distro-*` package is how drift happens.

## Check the siblings before writing a form

When writing in one package, check how the sibling packages do that same thing. Never copy from whatever code sits nearest, and never from `myx.common`. What the drift looks like in practice:

- **Scratch paths.** The family uses either a literal `"$MMDAPP/.local/temp/<name>"` written out at each use site, or `mktemp -d -t "<prefix>-XXXXXXXX"` — both accepted sibling forms, the second in `myx.distro-deploy` and `myx.distro-source`. `mktemp -d "${TMPDIR:-/tmp}/..."` is `myx.common`'s own form and matches nothing in this family.
- **Console launcher generation.** Every package that generates a launcher has a dedicated `<Item>Tools.Make.Distro<Item>ConsoleShellScript.include` and sources it. The same script inlined as a long heredoc in the tool is drift, not a variant.
- **Dispatcher routes.** Every `Distro<Item>Tools.fn.sh` in the family routes `--make-*` in its own dispatcher. A dispatcher without a route its siblings all carry is missing it, not exercising a choice.

## Two halves of one command line can be two unrelated mechanisms

- A pipeline joining a `myx.common` command to a `myx.distro-*` tool joins a plain system install to a workspace-bound script. The first is on PATH anywhere and needs no workspace; the second resolves only inside a console session.
- A command line that reads as one operation therefore has two separate preconditions, and testing one half proves nothing about the other.

## Tests live in their own project, and this family does not have one yet

- **The estate's pattern is a distinct project holding a domain's tests**, separate from the packages under test and carrying what those tests need — testbed, harness, fake data, and the infra to run them. The established one is `/Volumes/workspace/myx/unit-test`, an Eclipse Java project whose `magic-tester/` subfolder is the dedicated home for magic-team testing tooling; it covers AE3 framework and rendering behaviour. Measured: `myx.distro-*` and `myx.common` are not in its scope — zero hits for `myx.distro`, `myx.common` or `distro-agents` anywhere under it.
- **So a `myx.distro-*` package carrying no test or build machinery is that pattern holding, not a gap in the package.** The workspace contains the project; the project does not depend on the workspace. Assets shipped inside a package would invert that — it would need a workspace around it to be verifiable, and stop being a thing that can be cloned and used on its own. Measured across the tree: not one test file, fixture, golden output or expected-result asset in any `myx.distro-*` package nor in `myx.common`; every `*test*`/`*spec*`/`fixture*` name under `source/myx/` is board prose, an inbox item or a skill's own idle-task filename, and the only in-package hits are the four `*Context.SetInputSpec.include` dispatch specs, which are code. `myx.distro-agents` is the public, specific artifact, and reading its emptiness as a defect points the fix at the wrong layer.
- **The gap is that this family has no such test project of its own, and its place would be `ws-myx-devops`.** That is the thing missing — not anything inside the packages.
- **What a session does in the meantime is a differential run, which is a harness built and thrown away.** Exercise the OLD file and the NEW file over the same input and compare the outputs byte for byte; that is what made the Slack-converter work's "additive only" claims checkable rather than asserted. The cost is the repetition: several sessions in one night each hand-built a scratch data root, a stub console, a throwaway git remote, a before/after driver and seeded fixtures, then discarded all of it. That is a better statement of what is missing than any count of absent files.
- **Keep the pre-change copy before editing**, and give a comment-only edit the same run. The first is a property of the method — once the file is overwritten the baseline is gone and cannot be reconstructed from the new one. The second is not about comments changing behaviour but about a line-range splice into a script doing so: the `AgentsSlackBlocksBuild.awk` header correction was verified this way and would have caught a mis-spliced range that reading the diff would not.

## A measurement is only as fresh as the session that took it

- **Several agent sessions edit the same files in this tree at the same time, with no lock between them.** A fact measured early in a session can be contradicted later in that same session by a file another session has since rewritten, and neither reading is wrong — they are readings of two different files that share a path.
- **When two measurements of the same thing disagree, the tiebreaker is the file's timestamp, not the more careful-looking reading.** Re-run the measurement rather than reasoning about which one to trust, and re-read the file immediately before writing a fact about it down. This is a property of how work reaches this tree, not an occasional accident, so it applies to every session here.
