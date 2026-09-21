# VSCode palette entries: what each one runs, and what it moves

What the generated VSCode task palette exposes for a `myx.distro-*` workspace, and for each entry whether it rebuilds the distro indices and whether it advances `build-time-stamp.txt`. Measured 2026-09-21.

**This file records what the entries do. What any of them *should* do is not settled here** — whether `🛫 Ingest Source Changes` is meant to be a stamp-advancing publish of unrebuilt indices is an open question with the human-owner. A reader meeting a complete-looking map must not read it as a settled design.

## Read the generated file, not the fragments

The palette is assembled from four `*.Make.VSCodeTasksFragment.include` fragments (`SourceTools`, `DeployTools`, `RemoteTools`, `AgentsTools`), but **a workspace renders only the fragments whose packages it has installed.** Enumerating the fragments therefore answers a different question from enumerating the workspace's own generated `*.code-workspace`, and nothing in either result says which question was answered. The generated file is the palette a user is actually presented with, and is the one to read.

Worked example of the trap: a workspace carrying only `DistroSourceConsole.sh` renders five entries; one carrying all four consoles renders nine. Same fragments, same tooling version, different palettes.

## The entries

Nine in a workspace with all four consoles installed.

| # | Label | Runs | Rebuilds indices | Advances `build-time-stamp.txt` |
|---|---|---|---|---|
| 1 | 🖥️ Start Source Console | `DistroSourceConsole.sh` | no | no |
| 2 | ⬇️ Pull/Sync All Known Sources | `DistroImageSync --all-tasks --execute-source-prepare-pull` | no | no |
| 3 | 📥 Re-Build Source Index Snapshot | `BuildCachedFromSource.fn.sh` | yes | yes, when something changed |
| 4 | 🛫 Ingest Source Changes | `DistroSourcePrepare --ingest-distro-index-from-source` | no | yes, when something changed |
| 5 | 🛠️ Update Local Tools | `DistroLocalTools.fn.sh --upgrade-installed-tools` | no | no |
| 6 | 🖥️ Start Deploy Console | `DistroDeployConsole.sh` | no | no |
| 7 | 🏋️ Re-Build Deploy Data from Source | `BuildDistroFromSource.fn.sh` | yes | yes, when something changed |
| 8 | 🖥️ Start Remote Console | `DistroRemoteConsole.sh` | no | no |
| 9 | 🤖 Start Agents Console | `DistroAgentsConsole.sh` | no | no |

Three of the nine reach an ingest at all: 3, 4 and 7.

Anchors for the non-obvious rows: `BuildDistroFromSource.fn.sh:43-62` runs three staged subshells whose first is `BuildCachedFromSource`, which is where 7 inherits its ingest. `DistroLocalTools.fn.sh:363-372` expands `--upgrade-installed-tools` into `--install-distro-{deploy,source,remote,agents}`. Entry 2 is git clone/pull via `DistroImage.SyncScriptMaker.include:115`.

## Two markers, and why "doesn't rebuild" is not one category

Entries 2 and 4 both leave the indices unrebuilt, and collapsing them loses the distinction that matters:

- **Entry 2 leaves the tier consistent with itself and behind `source/`.** No marker in the tier claims to track `source/`, so nothing is misreporting — the tier correctly describes itself as current as of the last ingest. Staleness relative to source is what entries 3, 4 and 7 exist to resolve.
- **Entry 4 is the only one that can leave the tier internally inconsistent** — the stamp says ingested-at-T while the contents predate T — because it advances the stamp and rebuilds nothing.
- **Entries 3 and 7 can disagree in the opposite direction.** A no-change run returns early before writing the stamp (`DistroSourcePrepare.fn.sh:55-58`) but still runs the `source-prepare` builders, so the indices come out newer than the stamp. The indices really are fresh.

## Age

**Entry 4 predates 2026-07-18** and is long-standing behaviour rather than a recent change. Three `*.code-workspace` files generated that day, four minutes apart and each carrying its own workspace's absolute paths, all render it in fourth position with the same command text as today's.

Limits of that, all three clauses and not to be trimmed into a cleaner claim:

- The entry is **≥ Jul 18**, on rendered-output evidence.
- Its implementation as measured is **≥ Aug 24**: `DistroSourcePrepare.fn.sh` is byte-identical across every available vendored copy and live source, and the source file was last written then, so every copy postdates that write.
- **Whether the stamp-and-publish behaved on Jul 18 as it does now is outside what these artifacts can show.** No available snapshot predates the Aug 24 write.

A vendored `.local` copy's age is the whole basis of such a comparison, so establish when each was last upgraded rather than treating "vendored" as "old" — a workspace upgraded last week is evidence about nothing earlier. A workspace whose `MDLT_ORIGIN` resolves to a sibling source tree still carries a vendored copy; being unused is what makes it a frozen snapshot rather than useless.

## This table is not an explanation for a stale-index symptom

Entry 2 reads as an obvious cause for any stale-index symptom — source changed, nothing ingested, stale data served — and **it is not one**. A tier behind `source/` after a pull is the system working as designed. Establishing that entry 4 is long-standing likewise makes it *less* available as a recent-regression story, not more available as a cause. Reaching a state is a different claim from that state producing a given symptom, and the two do not merge.
