# Personal and Meloscope infrastructure (prv/cloud.mel, prv/cloud.myx)

Read this when working on the user's own real infrastructure — `ws-myx.prv-farm`, namespace root `prv`. Same stakes as `partner-ndm-infra`'s domain: real hosts, real domains, real money. Advisory/planning work is free; provisioning, decommissioning, or backup-plan changes need explicit confirmation before acting.

## Shape

Built and operated by the same `Distro*Console.sh` machinery as every other non-Eclipse workspace (all four consoles present — Remote was added via `DistroLocalTools --install-distro-remote`; previously only Source + Local + Deploy existed). Its `MDLT_ORIGIN` resolves to the sibling `ws-myx-devops/source` tree, not its own `.local/` copy — prv-farm is a consumer of `ws-myx-devops`'s tooling, not an independent copy. Two subtrees:

- **`prv/cloud.mel`** — Meloscope (the user's company, a real registered entity). Real hosts under `setup.host-<name>.<domain>` (`roach1`/`roach2`/`roach3.myx.nz`, `l6b1h1`/`l6b2h1.myx.co.nz`, `l6v2f1.myx.ru`, `acm1h1`/`acm2h1.myx.ru`, `bhv1h1`/`bhv2h1.myx.co.nz`, `ae31h1.myx.nz`), hosted sites under `setup.site-<domain>`, an `accounts/` tree, `farm-actions`/`farm-structure` (fleet-management scripts and a `myx-structure.json` topology file), and `deploy.client-mel`. Virtualization is **FreeBSD bhyve** — a different stack from the Ubuntu/Ceph/Nebula hosts in the ndm/knt/ncz family. Don't assume conventions transfer between the two tenants.
- **`prv/cloud.myx`** — the user's personal infra: `web.acmcms-sites` (personal AxiomCMS-hosted sites) and `web.cdn-static.myx`.

## Command/topology reference

`cloud.mel/farm-actions` + `cloud.mel/farm-structure` is this tenant's equivalent of the ndm-side `cloud-infra/recipes` cookbook — real scripts, not documentation. `farm-actions/sh-scripts` and `farm-actions/actions/farm/` hold the actual deploy/routing/DNS/export commands (`DeployRouting.fn.sh`/`Deploy-Routing.sh`, `DeploySettings.fn.sh`/`Deploy-Settings.sh`, `rsync-dns-from-acm2h1.sh`, `XPRT-farmpkgs.sh`, `XPRT-myx.ru.sh`). `farm-structure/myx-structure.json` is a real, populated declarative topology file — each location entry has a `name`, `title` (datacenter/provider), WAN/LAN addresses, and a `zone` matching the `bhv1`/`bhv2`-style suffix in hostnames. Read this file to answer "where does this host actually live" rather than guessing from the hostname alone — but don't copy real WAN IPs or other host-identifying specifics out of it into chat, commits, or other files without checking sensitivity first.

## Confirmed live fleet selector and identities

`Deploy ExecuteParallel --select-projects setup.host- ...` (a project-name substring mask) is the simple, correct selector for the full 11-host fleet (`acm1h1`, `acm2h1`, `ae31h1`, `bhv1h1`, `bhv2h1`, `l6b1h1`, `l6b2h1`, `l6v2f1`, `roach1`, `roach2`, `roach3`) — matches every `prv/cloud.mel/setup.host-*` project directly, no need for `--select-provides 'deploy-ssh-target:'`. Each project's default SSH identity is baked into its `project.inf`/`ssh/` dir: `dpcm` for `acm1h1`/`acm2h1`/`roach1-3` and `l6rdpl` for `bhv1h1`/`bhv2h1`/`l6b1h1`/`l6b2h1`/`l6v2f1` (both via `deploy.client-mel/ssh`), `melkimsufi` for `ae31h1` — override to root with `--ssh-user root --ssh-home ~/.ssh` (the invoking user's own default identity), confirmed working end-to-end. `roach1-3` are the most likely to be unreachable at any given moment: they're the only guests using `grub`/type `ae3bsd` behind a NAT-forwarded port on their host rather than a direct address — check `myx.common vm/list` on the relevant `bhv*h1` host first (state `Bootloader` instead of `Running` means it never came up far enough to bring its network stack online, which looks identical to a firewall/routing problem from the SSH side).

## Publishing the routing structure, confirmed working live

`DeployRouting.fn.sh --select-merged-keywords l6route.mel` (run through the console — its task-list build goes through `Distro ListDistroProvides`, not `Require`) pushes `farm-structure/myx-structure.json` to exactly the 5 L6ROUTE nodes (`bhv1h1`, `bhv2h1`, `l6b1h1`, `l6b2h1`, `l6v2f1`) via `sudo /usr/local/sbin/beaver-apply-configuration` over SSH, reloading nginx/IPFW/`named`/`tincd`/DHCP/SSL. Real selection is a `project.inf` Provides join (`deploy-ssh-target:` × merged `image-execute:deploy-l6route-config:`, owned by `farm-structure` itself), not the keyword — the keyword just narrows the candidate set, matching the same script's use for other tenants (see `partner-ndm-infra`'s recipes cookbook) with a different keyword (`cloud.knt`). Full chain traced in `prv/cloud.mel/CLAUDE.md`. A live run reported `Diff: No changes` on all 5 nodes — safe to re-run as a verification/idempotency check.

## Known incident pattern: stuck rsync on the myx.ru publish leg

`deploy-myx.ru.sh` (→ `export-myx.ru-to-host-port-group.sh`) publishing to `acm1h1`/`acm2h1` has stalled repeatedly on the `ae3` leg (`FIXME: temp while ws-2017 can't build AE3` block) sending `ae3-axiom.tbz`. Root cause: no `ServerAliveInterval`/`ServerAliveCountMax` on the `SSH=` line, so a dead client-side link leaves the server-side `rsync --server`/`sshd-session` sitting `ESTABLISHED` forever instead of erroring. Fix not yet applied: add `-o ServerAliveInterval=10 -o ServerAliveCountMax=3` to that line. Recovery: kill the stuck `sshd-session: myx@notty` parent PID (not just rsync children) as root via `ShellTo` on each affected host, then have the user retry the publish.

## Daily iteration

- **Live-fleet health sweep**: `uptime` + `uname -a` across the `prv/cloud.mel` + `prv/cloud.myx` VM fleet, using the confirmed selector above. Read-only, safe to re-run; report what came back including any host that didn't answer.
- **Future candidate, not yet actionable**: an OVH dedicated VM is planned as a test target and eventual home for a standalone (non-laptop) NDCI node — once that host exists, its health/role belongs in this sweep too.

(Help-pairing gaps across `myx.common` packages and legacy-shim `+x`-bit checks moved to `keeper-myx`'s idle-task menu — those are source-content concerns, not fleet operations.)

Report findings as a short list; fix nothing unattended, and don't touch `myx.distro-*` live infra beyond the read-only checks above.
