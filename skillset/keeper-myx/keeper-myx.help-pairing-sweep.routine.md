---
executors: keeper-myx
maintainers: magic-coordinator, magic-librarian, magic-architect
invitees: none
---
# routine-help-pairing-sweep — the actual procedure

Normative contract: `magic-team/magic-team.shared.md`'s "Armed & Routine contracts" → Routine. This file is a derived skeleton; where the two disagree, `magic-team/magic-team.shared.md` wins.

# Summary

`keeper-myx`'s idle-run routine that sweeps `myx.common`'s commands for help-pairing gaps.

## Goals

- Sweep `bin/*.Common`/OS-variant commands across `myx.common`'s packages for help-pairing gaps — a command missing its `help/<name>.help.include` + `<name>.help.md` pair — and report the findings as a short list.

## Scope

- Does:
  - Enumerate commands and flag any missing help pair.
- Doesn't:
  - Author the missing help pair unattended — it reports; authoring is separate assigned work.

# Steps

Exact instructions. Execute in order, every step, literally as written — not less, not more. If a step cannot execute as written: escalate, or fail loud.

1. **sweep-for-gaps**: Sweep `bin/*.Common`/OS-variant commands across `myx.common`'s packages for help-pairing gaps (a command missing its `help/<name>.help.include` + `<name>.help.md` pair).
2. **report-list**: Report findings as a short list.

# Closure steps

1. **log-outcome**: Log the activity and its outcome as a new dated file under `processed/` — `processed/<board-item-type>-<date>-<short-topic>.md`. Then run this member's own post-activity reflection (`--member-inbox-reflection-upsert`), per `keeper-myx.armed.md`.

# Routine's local procedures

Named procedure blocks. Steps above call them by name. Not separate routines — not visible outside this file.

None currently defined.

# Routine's local rules

All statements apply at the same time, always. These rules override a participant's own general `.armed.md` rules while this routine is active.

- This routine's own executor (`keeper-myx`) is permitted and obliged to execute every step exactly as written.
- Participants obey this routine's own rules over their normal `.armed.md` rules while participating.
- A multi-command sweep batches into one `--console-start`/`--console-send` session, per `keeper-myx.armed.md`.
- Idle-run scheduling (weight, min-interval, scope) is not set here — it lives in `keeper-myx.armed.md`'s `## Idle-Tasks` section, which the `daily-idle-task` procedure reads.

# Routine-specific tooling

Every `magic-tooling` operation this routine uses. Full syntax and behavior here. Steps use its name only.

## DistroAgentsTools magic-tooling operations

- `--console-start [--override-workspace <path>] [--console DistroSourceConsole.sh|DistroDeployConsole.sh] [--ttl <seconds>]` (**sweep-for-gaps**)
- `--console-send <channel> [-- <command...>]` (**sweep-for-gaps**)
- `--member-inbox-note-upsert <member> <item-filename> [--from-file <path>|--edit-patch-from-stdin]` (**report-list**)

## `--console-start` Operation Reference

`DistroAgentsTools.fn.sh --console-start [--override-workspace <path>] [--console DistroSourceConsole.sh|DistroDeployConsole.sh] [--ttl <seconds>]` — starts (or reuses) a Keep-Alive console session. Default `--ttl`: 3600 seconds.

## `--console-send` Operation Reference

`DistroAgentsTools.fn.sh --console-send <channel> [-- <command...>]` — sends one command line into an open channel's FIFO. Command-only, not a data-transport.

## `--member-inbox-note-upsert` Operation Reference

`DistroAgentsTools.fn.sh --member-inbox-note-upsert <member> <item-filename> [--from-file <path>|--edit-patch-from-stdin]` — writes a note into `<member>`'s own inbox. `<item-filename>` is a bare filename.

# Maintainer Notes

Used to check this file's own definitions against its own goals when it is updated, assessed, or tested — resolved against the whole skillset, not this file alone. **IMPORTANT**: not applied during normal work!

## Verbatim-goals (intents)

- Every `bin/` command carries its mandatory help pair; this sweep is how a gap is caught.

## Verbatim-tests (benchmarks)

- A clean sweep (no gaps) is a valid, reportable outcome.

## Librarian Comments

### Reference

- `keeper-myx.armed.md`'s `## Idle-Tasks` section — the scheduling policy governing when this routine fires.

### Conventions

- None currently known beyond this file's own Local rules.
