---
executors: keeper-myx
maintainers: magic-coordinator, magic-librarian, magic-architect
invitees: none
---
# routine-help-doc-point-test — the actual procedure

Normative contract: `magic-team/magic-team.shared.md`'s "Armed & Routine contracts" → Routine. This file is a derived skeleton; where the two disagree, `magic-team/magic-team.shared.md` wins.

# Summary

`keeper-myx`'s idle-run routine that point-tests one existing `help.md` against the command's real current behavior.

## Goals

- Pick one existing `help.md` and actually execute the command/flag/env-var combination it documents, confirming the output still matches what is written — re-confirming accuracy by running it, never by re-reading the source and assuming it is still right — and report any drift found.

## Scope

- Does:
  - Execute one documented command/flag/env-var combination and compare live output against the doc.
- Doesn't:
  - Trust a source-read as verification — the point is the live run; and it does not rewrite the doc unattended, only reports drift.

# Steps

Exact instructions. Execute in order, every step, literally as written — not less, not more. If a step cannot execute as written: escalate, or fail loud.

1. **pick-one-help-doc**: Pick one existing `help.md`.
2. **run-the-point-test**: Actually execute the command/flag/env-var combination it documents, and confirm the output still matches what is written. Re-confirm accuracy by running it — do not just re-read the source and assume it is still right.
3. **report-drift**: Report any drift found.

# Closure steps

1. **log-outcome**: Log the activity and its outcome as a new dated file under `processed/` — `processed/<board-item-type>-<date>-<short-topic>.md`, a real board-item type. Then run this member's own post-activity reflection (`--member-inbox-reflection-upsert`), per `keeper-myx.armed.md`.

# Routine's local procedures

Named procedure blocks. Steps above call them by name. Not separate routines — not visible outside this file.

None currently defined.

# Routine's local rules

All statements apply at the same time, always. These rules override a participant's own general `.armed.md` rules while this routine is active.

- This routine's own executor (`keeper-myx`) is permitted and obliged to execute every step exactly as written.
- Participants obey this routine's own rules over their normal `.armed.md` rules while participating.
- A multi-command investigation batches into one `--console-start`/`--console-send` session rather than one call per command, per `keeper-myx.armed.md`.
- Idle-run scheduling (weight, min-interval, scope) is not set here — it lives in `keeper-myx.armed.md`'s `## Idle-Tasks` section, which the `daily-idle-task` procedure reads.

# Routine-specific tooling

Every `magic-tooling` operation this routine uses. Full syntax and behavior here. Steps use its name only.

## DistroAgentsTools magic-tooling operations

- `--console-start [--override-workspace <path>] [--console DistroSourceConsole.sh|DistroDeployConsole.sh] [--ttl <seconds>]` (**run-the-point-test**: batch the live command run)
- `--console-send <channel> [-- <command...>]` (**run-the-point-test**: send the command into the session)
- `--member-inbox-note-upsert <member> <item-filename> [--from-file <path>|--edit-patch-from-stdin]` (**report-drift**: file the finding)

## `--console-start` Operation Reference

`DistroAgentsTools.fn.sh --console-start [--override-workspace <path>] [--console DistroSourceConsole.sh|DistroDeployConsole.sh] [--ttl <seconds>]` — starts (or reuses, for an already-alive channel on the same workspace+console) a Keep-Alive console session. Default `--ttl`: 3600 seconds.

## `--console-send` Operation Reference

`DistroAgentsTools.fn.sh --console-send <channel> [-- <command...>]` — sends one command line into an open channel's FIFO. With `-- <command...>`, that argument list (joined with spaces) is sent; with no command given, stdin is read and piped through as-is. Command-only, not a data-transport.

## `--member-inbox-note-upsert` Operation Reference

`DistroAgentsTools.fn.sh --member-inbox-note-upsert <member> <item-filename> [--from-file <path>|--edit-patch-from-stdin]` — writes (creates or overwrites) a note into `<member>`'s own inbox. `<item-filename>` is a bare filename.

# Maintainer Notes

Used to check this file's own definitions against its own goals when it is updated, assessed, or tested — resolved against the whole skillset, not this file alone. **IMPORTANT**: not applied during normal work!

## Verbatim-goals (intents)

- Accuracy is re-confirmed by actually running the command, never by re-reading the source and assuming.

## Verbatim-tests (benchmarks)

- A help doc whose live output still matches is a valid "no drift" outcome, reported as such.

## Librarian Comments

### Reference

- `keeper-myx.armed.md`'s `## Idle-Tasks` section — the scheduling policy governing when this routine fires.
- Migrated to routine form in the 2026-09 idle-task-to-routine refactor.

### Conventions

- None currently known beyond this file's own Local rules.
