# Sprint Plan: Best-Case Path to the December CCC

**Drafted Nov 4 for the Nov 5 sprint.** Assumes two-week sprints aligned to the biweekly Kavitha syncs. Points on a 1/2/3/5/8 scale; adjust to team norms. Companion: contract_agent_backlog.md (full contract-agent epic), kavitha_coaching/meeting_notes_2026-11-04.md (decisions).

## The shape of the best case

Sprint 1 unblocks everyone else (Kayla's prototype, the program's folder loading, Kavitha's pilot) while building the two things with no dependencies (Session 2 agent, synthetic CCC cohort). Sprint 2 converges real data, the snapshot generator, and Kayla's visual layer, ending in a dry run the week before the CCC. Kayla leaves in early December, so her work must be front-loaded into Sprint 1.

## Sprint 1 (Nov 5 to Nov 18): unblock and build the independent pieces

### Alex

| ID | Task | Why now | Pts |
|---|---|---|---|
| A1 | **Kayla handoff package**: CCC deck summary, data source table, target snapshot/roster output spec, synthetic sample data file in the agreed format | Unblocks Kayla day 1; she has the shortest runway | 2 |
| A2 | **Session 2 agent**: build from drafted instructions, run trap test, deliver for the APD pilot | Kavitha's #1 ask; Session 2 meetings happening now | 2 |
| A3 | **Reply to Kavitha**: timeline, tool name proposal, license/knowledge-source update (premium licenses change what her agents can carry) | Owed from the meeting; keeps momentum | 1 |
| A4 | **SharePoint intake spec**: one-page file-naming and folder convention for Nancy (period, then source, learner identity in filenames); verify access once the folder and Teams group grant land | The folder structure only works if filenames are consistent; Nancy starts loading now | 2 |
| A5 | **Resident snapshot template** (the per-resident one-pager: six competency panels with narrative rollups, discrete metrics, flags) sent for Kavitha/committee approval | Output-first rule; gates the generator | 3 |
| A6 | **Synthetic CCC cohort**: 4 to 5 fictional residents with fake faculty evals, 360 comments, ITE percentiles, MKSAP/attendance numbers, procedure and scholarship logs, plus planted traps (a below-standard narrative that must flag; a comment matching no competency; conflicting ratings across rotations) | Feeds both the generator build and Kayla's prototype; no real-data dependency | 3 |
| A7 | *Stretch:* contract agent C1 (inputs inventory) + C2 (output design with a real lead) if Yesha's mock contracts arrive | Only if capacity remains | 2+3 |

**Alex core: 13 pts (+5 stretch)**

### Kayla (time-boxed; her last full sprint)

| ID | Task | Pts |
|---|---|---|
| K1 | Per-resident dashboard view in SharePoint/Teams from the standardized sample file (competency panels, metrics, flags) | 5 |
| K2 | Cohort roster view (On track / Watch / Discuss, CCC priority) | 3 |
| K3 | Refresh mechanic for a six-monthly cycle (file drop or manual refresh; nothing real-time) | 2 |

**Kayla: 10 pts**

### External dependencies to chase during Sprint 1 (no points, named owners)

1. Yesha: six premium licenses provisioned; mock contracts + ledgers for the contract agent.
2. Kavitha/Nancy: SharePoint folder created, Alex granted library + Teams group access, first real exports loaded.
3. Yesha/compliance: data-path confirmation for real evaluation data (the fallback is de-identified data through December, which her own plan already proposes).

## Sprint 2 (Nov 19 to Dec 2): converge on real data

| ID | Task | Depends on | Pts |
|---|---|---|---|
| B1 | **Snapshot generator agent v1**: per-source extraction (narratives to competencies via the Milestones guidebook as knowledge source, now viable with licensed users) + template fill; validated against the synthetic cohort traps | A5 approved, A6 | 5 |
| B2 | Run the generator on **real exports** from the program folders; iterate with Kavitha's feedback | B1 + folders populated + data-path OK | 3 |
| B3 | **Decision capture template** + learner-facing CCC-input package format, agreed with Kavitha at the Nov 18 sync | Sync meeting | 2 |
| B4 | **Session 3 agent v1** (CCC input + learner pre-feedback + transcript into one record) buildable as soon as B3 fixes the formats | B3 | 3 |
| B5 | Kayla: deploy prototype to the Keck residency SharePoint + handoff doc so coordinators own refreshes | Access granted, K1-K3 | 2+2 |
| B6 | Contract agent C3 (platform spike: Copilot vs HIPAA ChatGPT on one mock contract) | A7/C1 inputs | 3 |

**Alex core: 13 pts; Kayla: 4 pts**

## Week of Dec 8: freeze and dry run (2 pts)

Generate snapshots for a few real residents, walk one through with Kavitha exactly as a presenter would in the CCC, fix presentation-level issues only. Nothing new ships this week. CCC runs Dec 11-12 with agent-drafted snapshots, the roster table, and a decision-capture template in hand; learning plan generation follows the recorded decisions (late December, feeding Session 3 in January).

## What best-case requires to stay best-case

1. Kayla's A1 package on her desk by Nov 6.
2. Folder access + first exports by roughly Nov 12 (else B2 slips a week and the CCC runs on synthetic-plus-partial data; still workable).
3. Compliance answer by end of November (else December stays de-identified; also workable, by her own proposal).
4. Session 2 pilot transcript from the APD within Sprint 1 (else release slips past the sessions it serves).
