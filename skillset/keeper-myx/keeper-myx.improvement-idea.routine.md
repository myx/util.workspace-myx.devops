---
executors: keeper-myx
maintainers: magic-coordinator, magic-librarian, magic-architect
invitees: none
---
# keeper-myx.improvement-idea.routine — the actual procedure

# Summary

`keeper-myx`'s idle-run routine that surfaces one genuine small improvement idea in `myx.common`/`myx.distro-*` source and reports it.

## Goals

- Find one genuine, small improvement idea in the `myx.common`/`myx.distro-*` source — a missing help pair, a convention violation, an inconsistency between a README and actual behavior — and report it, so the team accumulates a grounded backlog of real, source-verified improvements rather than guessed ones.

## Scope

- Does:
  - Surface exactly one real, source-grounded improvement candidate per pass and report it.
- Doesn't:
  - Fix it unattended — the fix happens only once the idea is promoted to assigned work, never self-approved into action from this idle pass.

# Steps

Exact instructions. Execute in order, every step, literally as written — not less, not more. If a step cannot execute as written: escalate, or fail loud.

1. **find-one-idea**: Find one genuine small improvement idea in the `myx.common`/`myx.distro-*` source: a missing help pair, a convention violation, or an inconsistency between a README and actual behavior. Ground it in real source, not a guess.
2. **report-not-fix**: Report the idea — do not fix it unattended unless it is promoted to assigned work.

# Closure steps

1. **log-outcome**: Log the activity and its outcome as a new dated file under `processed/` — `processed/<board-item-type>-<date>-<short-topic>.md`, a real board-item type, never an invented word. Then run this member's own post-activity reflection (`--member-inbox-reflection-upsert`), per `keeper-myx.armed.md`.

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

- `--member-inbox-note-upsert <member> <item-filename> [--from-file <path>|--edit-patch-from-stdin]` (**report-not-fix**: file the reported idea to this member's own inbox)

## `--member-inbox-note-upsert` Operation Reference

`DistroAgentsTools.fn.sh --member-inbox-note-upsert <member> <item-filename> [--from-file <path>|--edit-patch-from-stdin]` — writes (creates or overwrites) a note into `<member>`'s own inbox. Content via stdin by default, or `--from-file <path>`. `<item-filename>` is a bare filename, no path separators.

# Maintainer Notes

Used to check this file's own definitions against its own goals when it is updated, assessed, or tested — resolved against the whole skillset, not this file alone. **IMPORTANT**: not applied during normal work!

## Verbatim-goals (intents)

- One real, source-grounded improvement idea per pass — never a guess, never a self-approved fix.

## Verbatim-tests (benchmarks)

- A pass turning up nothing worth reporting is a normal, reportable outcome, not a failure.

## Librarian Comments

### Reference

- `keeper-myx.armed.md`'s `## Idle-Tasks` section — the scheduling policy (weight/min-interval/scope) that governs when this routine fires.

### Conventions

- None currently known beyond this file's own Local rules.
