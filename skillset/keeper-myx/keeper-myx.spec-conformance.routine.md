---
executors: keeper-myx
maintainers: magic-coordinator, magic-librarian, magic-architect
invitees: none
---
# keeper-myx.spec-conformance.routine — the actual procedure

# Summary

`keeper-myx`'s idle-run routine that checks one project's `project.inf`/builder declarations against its real behavior and layout.

## Goals

- Pick one project and check whether its `project.inf`/builder set actually matches what it declares (`Requires`/`Provides`/`Declares`/etc.) against its real behavior and file layout, and report any mismatch found.

## Scope

- Does:
  - Verify one project's declared metadata against its real behavior/layout.
- Doesn't:
  - Rewrite the `project.inf`/builders unattended — it reports the mismatch.

# Steps

Exact instructions. Execute in order, every step, literally as written — not less, not more. If a step cannot execute as written: escalate, or fail loud.

1. **pick-one-project**: Pick one project.
2. **check-declares-vs-reality**: Check whether its `project.inf`/builder set actually matches what it declares (`Requires`/`Provides`/`Declares`/etc.) against its real behavior and file layout.
3. **report-mismatch**: Report any mismatch found.

# Closure steps

1. **log-outcome**: Log the activity and its outcome as a new dated file under `processed/` — `processed/<board-item-type>-<date>-<short-topic>.md`. Then run this member's own post-activity reflection (`--member-inbox-reflection-upsert`), per `keeper-myx.armed.md`.

# Routine's local procedures

Named procedure blocks. Steps above call them by name. Not separate routines — not visible outside this file.

None currently defined.

# Routine's local rules

All statements apply at the same time, always. These rules override a participant's own general `.armed.md` rules while this routine is active.

- This routine's own executor (`keeper-myx`) is permitted and obliged to execute every step exactly as written.
- Participants obey this routine's own rules over their normal `.armed.md` rules while participating.
- Use `ListDistroProjects.fn.sh`'s live no-cache query for `--provides`/`--projects` truth rather than the cached index, per `keeper-myx.armed.md`'s myx.distro-* conventions.
- Idle-run scheduling (weight, min-interval, scope) is not set here — it lives in `keeper-myx.armed.md`'s `## Idle-Tasks` section, which the `daily-idle-task` procedure reads.

# Routine-specific tooling

Every `magic-tooling` operation this routine uses. Full syntax and behavior here. Steps use its name only.

## DistroAgentsTools magic-tooling operations

- `--console-start [--override-workspace <path>] [--console DistroSourceConsole.sh|DistroDeployConsole.sh] [--ttl <seconds>]` (**check-declares-vs-reality**)
- `--console-send <channel> [-- <command...>]` (**check-declares-vs-reality**)
- `--member-inbox-note-upsert <member> <item-filename> [--from-file <path>|--edit-patch-from-stdin]` (**report-mismatch**)

## `--console-start` Operation Reference

`DistroAgentsTools.fn.sh --console-start [--override-workspace <path>] [--console DistroSourceConsole.sh|DistroDeployConsole.sh] [--ttl <seconds>]` — starts (or reuses) a Keep-Alive console session. Default `--ttl`: 3600 seconds.

## `--console-send` Operation Reference

`DistroAgentsTools.fn.sh --console-send <channel> [-- <command...>]` — sends one command line into an open channel's FIFO. Command-only, not a data-transport.

## `--member-inbox-note-upsert` Operation Reference

`DistroAgentsTools.fn.sh --member-inbox-note-upsert <member> <item-filename> [--from-file <path>|--edit-patch-from-stdin]` — writes a note into `<member>`'s own inbox. `<item-filename>` is a bare filename.

# Maintainer Notes

Used to check this file's own definitions against its own goals when it is updated, assessed, or tested — resolved against the whole skillset, not this file alone. **IMPORTANT**: not applied during normal work!

## Verbatim-goals (intents)

- A project's declared `Requires`/`Provides`/`Declares` must match its real behavior and layout; this check catches drift.

## Verbatim-tests (benchmarks)

- A conformant project is a valid "no mismatch" outcome, reported as such.

## Librarian Comments

### Reference

- `keeper-myx.armed.md`'s `## Idle-Tasks` section — the scheduling policy governing when this routine fires.

### Conventions

- None currently known beyond this file's own Local rules.
