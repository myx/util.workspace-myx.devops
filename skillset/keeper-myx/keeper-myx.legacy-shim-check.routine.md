---
executors: keeper-myx
maintainers: magic-coordinator, magic-librarian, magic-architect
invitees: none
---
# keeper-myx.legacy-shim-check.routine — the actual procedure

# Summary

`keeper-myx`'s idle-run routine that checks legacy shims for a missing execute bit.

## Goals

- Check `include/obsolete/user/bin/*` legacy shims for a missing `+x` bit — a shim with no execute permission is silently unreachable through the dispatcher (which does `[ -x "$COMMAND" ]`) — and report any found.

## Scope

- Does:
  - Enumerate legacy shims and flag any lacking the execute bit.
- Doesn't:
  - Silently `chmod` unattended — it reports; the fix is deliberate assigned work.

# Steps

Exact instructions. Execute in order, every step, literally as written — not less, not more. If a step cannot execute as written: escalate, or fail loud.

1. **check-shim-exec-bit**: Check `include/obsolete/user/bin/*` legacy shims for a missing `+x` bit (a shim with no execute permission is silently unreachable through the dispatcher).
2. **report-any-found**: Report any found.

# Closure steps

1. **log-outcome**: Log the activity and its outcome as a new dated file under `processed/` — `processed/<board-item-type>-<date>-<short-topic>.md`. Then run this member's own post-activity reflection (`--member-inbox-reflection-upsert`), per `keeper-myx.armed.md`.

# Routine's local procedures

Named procedure blocks. Steps above call them by name. Not separate routines — not visible outside this file.

None currently defined.

# Routine's local rules

All statements apply at the same time, always. These rules override a participant's own general `.armed.md` rules while this routine is active.

- This routine's own executor (`keeper-myx`) is permitted and obliged to execute every step exactly as written.
- Participants obey this routine's own rules over their normal `.armed.md` rules while participating.
- Idle-run scheduling (weight, min-interval, scope) is not set here — it lives in `keeper-myx.armed.md`'s `## Idle-Tasks` section, which the `daily-idle-task` procedure reads.

# Routine-specific tooling

Every `magic-tooling` operation this routine uses. Full syntax and behavior here. Steps use its name only.

## DistroAgentsTools magic-tooling operations

- `--console-start [--override-workspace <path>] [--console DistroSourceConsole.sh|DistroDeployConsole.sh] [--ttl <seconds>]` (**check-shim-exec-bit**)
- `--console-send <channel> [-- <command...>]` (**check-shim-exec-bit**)
- `--member-inbox-note-upsert <member> <item-filename> [--from-file <path>|--edit-patch-from-stdin]` (**report-any-found**)

## `--console-start` Operation Reference

`DistroAgentsTools.fn.sh --console-start [--override-workspace <path>] [--console DistroSourceConsole.sh|DistroDeployConsole.sh] [--ttl <seconds>]` — starts (or reuses) a Keep-Alive console session. Default `--ttl`: 3600 seconds.

## `--console-send` Operation Reference

`DistroAgentsTools.fn.sh --console-send <channel> [-- <command...>]` — sends one command line into an open channel's FIFO. Command-only, not a data-transport.

## `--member-inbox-note-upsert` Operation Reference

`DistroAgentsTools.fn.sh --member-inbox-note-upsert <member> <item-filename> [--from-file <path>|--edit-patch-from-stdin]` — writes a note into `<member>`'s own inbox. `<item-filename>` is a bare filename.

# Maintainer Notes

Used to check this file's own definitions against its own goals when it is updated, assessed, or tested — resolved against the whole skillset, not this file alone. **IMPORTANT**: not applied during normal work!

## Verbatim-goals (intents)

- A legacy shim without its `+x` bit is silently broken; this check is how it is caught before a user hits it.

## Verbatim-tests (benchmarks)

- All shims executable is a valid, reportable "no findings" outcome.

## Librarian Comments

### Reference

- `keeper-myx.armed.md`'s `## Idle-Tasks` section — the scheduling policy governing when this routine fires.

### Conventions

- None currently known beyond this file's own Local rules.
