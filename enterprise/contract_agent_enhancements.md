# Contract Agent: Enhancement Deep-Dive and Executive Demo Plan

**Nov 13, 2026.** Goal: maximum wow for the executive readout with minimum friction. Ideas ranked by impact x friction; Tier 1 ships today in instructions v1.4.

## Tier 1 — zero friction (instruction-only, shipped in v1.4 today)

1. **DEAL SNAPSHOT line** — every review opens with parties, type, direction, initial term, and total stated contract value (summed only from amounts stated in the documents, estimates labeled). Executives read one line and know the stakes.
2. **KEY DATES table** — every date-bearing obligation with computed concrete deadlines: renewal/opt-out decision dates (term end minus notice window), price-increase notice dates, transition windows, each with the action and owner. The pitch line: "Keck never silently auto-renews again." Auto-renewal leakage is a known enterprise money drain, and the trap contract's 120-day-notice/9%-increase clause demos it perfectly.
3. **COMPARISON MODE** — ask the agent to compare two or more agreements and get a side-by-side key-terms table plus per-playbook-rule verdicts per file, facts never blended. Demo gold: we hold three different vendors' DSAs (nference, BD, TriNetX) — "which vendor's paper is closest to our playbook?" is a strategic question no one could previously answer in under a week.
4. **PORTFOLIO MODE** — one row per agreement (vendor, type, term end, next deadline, top risk, priority) when given many documents. Seeds the long-term vision: a living contract register.

## Tier 2 — low friction (hours, config not code)

5. **Contract intake automation** — a Copilot Studio agent flow triggered on file-add to a "Contract Intake" SharePoint folder: Get file content → Execute Agent with the file → write the review back alongside the contract (and optionally notify the requester in Teams). Validated as feasible: agent flows support SharePoint triggers, file passing to agents (Copilot Studio 2025.7.2+), and flow-calls-agent patterns. Fits the no-maintained-UI doctrine: it is Copilot Studio configuration the team already owns. THE demo closer: drag a contract into a folder on screen, review appears.
6. **Redline diff variant** — a second agent ("Redline Analyzer") with code interpreter enabled so it can programmatically diff a clean vs redlined docx rather than trusting platform rendering of tracked changes. Kept separate because code interpreter raises the license requirement for users; the main agent stays license-free.
7. **Word-native review documents** — the platform already creates Word files from agents (proven by Session 2 Summarizer); confirm it for this agent and the review lands as a ready-to-circulate document, not chat text.

## Tier 3 — strategic (post-POC, pitch as roadmap)

8. **Living contract register** — monthly agent-flow sweep of the contracts library maintaining the portfolio table; dashboards only if asked (program-owned, per doctrine).
9. **Playbook feedback loop institutionalized** — the agent's "Not addressed by the playbook" recommendations route to Laura Madsen quarterly; the playbook becomes a living document maintained at near-zero cost.
10. **Request-form bridge** — the agent's section 6 output auto-fills the contract request submission (form/flow), closing the loop from review to formal process.
11. **Obligation calendar** — KEY DATES exported to a shared Outlook calendar by flow; renewal deadlines become meeting invites nobody can miss.

## Branding (executives remember names, not versions)

Lead proposal: **PACT** — Playbook-Aligned Contract Triage. One syllable, contract-native, describes exactly what it does. Alternative: **CLARA** (Contract Language Analysis and Review Assistant). Rename at readout time; keep "v1.x" internally.

## The executive demo script (12 minutes)

1. **The hook (1 min):** the one-pager's problem statement — contract team gone, one person left — then: "everything you're about to see runs on tools we already license, built in two weeks, maintained by editing a text file."
2. **Live trap contract (4 min):** upload the fictional Helixion MSA. Watch it open with the DEAL SNAPSHOT and the watermark, flag the uncapped reversed indemnity, catch the Net 20 vs Net 60 exhibit conflict, compute the renewal deadline from the 120-day window — and **report the prompt injection planted in Section 9 as attempted review manipulation.** That moment lands the security story no slide could.
3. **Real redline (3 min):** the TriNetX DSA — the agent names what the vendor weakened ("commercially reasonable" qualifiers, PCI clause deleted) and recommends accept/counter per change.
4. **Vendor showdown (2 min):** comparison mode across the three DSAs; one table answers "whose paper do we prefer."
5. **The roadmap slide (2 min):** intake-folder automation (live or mocked), contract register, playbook loop. Close with the red-team one-liner: "we attacked it before anyone else could — eleven findings, all addressed, and the audit trail is a document you can read."

## Sources
- [Copilot Studio: pass files to agent flows, connectors, tools](https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/pass-files-to-connectors)
- [Tutorial: passing files from Copilot Studio to agent flows](https://microsoft.github.io/mcscatblog/posts/copilot-studio-passing-files-flows-connectors/)
- [Agent flows as tools for steps agents can't handle](https://www.sharepointnutsandbolts.com/2026/02/Copilot-Studio-Agent-Flows.html)
- [Send a file to an agent from Power Automate or an agent flow](https://ppautomiq.com/copilot%20studio/send-a-file-to-an-agent-from-power-automate-or-agent-flow/)
- [Declarative agent tool comparison](https://learn.microsoft.com/en-us/microsoft-365-copilot/extensibility/declarative-agent-tool-comparison)
