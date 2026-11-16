# Contract Review Agent POC — Status (Nov 11, 2026)

**Deadline:** one week (Alex); Yesha's one-pager says POC target November 20.
**Alignment:** Yesha circulated an "AI Contract Review Agent" one-pager today (Ingest → Analyze → Prepare; citation-based output; Critical/Important/Advisory; guardrails: pre-review only, no invented standards). The built agent matches it section for section, because both derive from the playbook's own Section 6 "AI-Assisted Contract Review Instructions."

## Built

**Contract Review Agent v1 POC** — live in the tenant, store-searchable. Instructions (repo: `contract_agent_instructions_v1.txt`) operationalize the playbook's embedded AI instructions plus our standard discipline: cite agreement section AND playbook rule for every finding; never invent standards ("Not addressed by the playbook"); silence is a gap, not acceptance; separate facts / rules / assumptions / recommendations; seven-part output (Top Risks banner, business intent, key-terms table, deviations, priorities, recommended positions with fallbacks, draft contract-request-form language, escalations + healthcare trigger checks); fixed disclaimer line. No skills or knowledge sources attached: the playbook is referenced per-conversation or found via the agent's baseline access, keeping the agent license-portable.

## Reference materials ingested (ThinkPad only; never in this repo)

- **Keck Contract Negotiation Playbook (Expanded), v1.0 Oct 2026** — fully read: priority system, core commercial rules, USC-paper and termination strategy, SOW/implementation, vendor-leverage practices, Section 6 AI instructions, Section 7 request-form template, checklist appendix, USC baseline terms, healthcare/institutional triggers, insurance baselines, IS/SaaS rules (incl. Critical no-secondary-use / no-AI-training data position), SLA severities (tail partially obscured).
- **nference DSA** (Data Security Agreement) — structure mapped; primary test document.
- **nference Mutual NDA** (.doc) — converted, available as second test.
- **nference BAA** — NOT extractable: rights-protected (IRM). Ask Laura Madsen (playbook author / remaining contracts contact) for an unprotected copy if BAA testing is wanted.

## Test evidence so far

1. Agent found the playbook in the tenant via baseline Microsoft 365 search (unprompted file discovery works; the tenant's indexed copy, authored by Laura Madsen).
2. Honest-failure behavior validated twice: with the agreement unfindable (OneDrive copy not yet search-indexed), the agent named exactly what it searched, declined to produce an ungrounded review, requested upload, and emitted the required disclaimer verbatim. No fabrication under pressure.
3. Full end-to-end on the DSA: pending either search indexing of the uploaded copy (retry later) or a direct file upload in the normal agent chat (the builder Preview pane has no attach control and caps messages at 2,000 chars; the standard chat surface has both).

## One-pager v2 ("image (2)", Nov 11) — verified, no new requirements

The second one-pager is the branded slide version (Keck Medicine | Enterprise Data, Analytics & AI; INTERNAL, November 2026; POC target November 20 unchanged). Full text extracted via native Windows OCR. Deltas vs v1: problem statement hardened to "the RIF eliminated THE IT contract team"; guardrails/success panel dropped in the condensed layout; expected output reduced to five bullets - business intent and document inventory; key commercial terms AND MISSING COMPONENTS; Critical/Important/Advisory deviations; preferred position, fallback, question, and ESCALATION OWNER; reusable submission language. All five are covered by instructions v1.1; the two emphasized items (missing components, escalation owner) are precisely the v1.1 closures. No action needed beyond the pending live v1.1 paste.

## One-pager requirements coverage (verified Nov 11 against the full document)

| One-pager requirement | Our agent | Status |
|---|---|---|
| Reviews complete contract package (MSA, SOW, order form, exhibits, addenda, incorporated/linked terms) | INPUT section treats all uploads as one package; linked terms flagged | MEETS |
| Structured, citation-based pre-review | Every claim cites agreement section; every deviation also cites the playbook rule | MEETS |
| Compare vs playbook rules and USC reference positions; distinguish facts, gaps, assumptions | Evidence rules 2-3; silence treated as gap | MEETS |
| Business intent and document inventory incl. missing components and hierarchy conflicts | v1.1 output 1 adds explicit package inventory with MISSING markers | MEETS (v1.1) |
| Key commercial terms incl. fees, renewals, increases, termination, acceptance, data/IP, security, SLAs | v1.1 key-terms table adds IP, security obligations, SLA rows | MEETS (v1.1) |
| Deviations classified Critical/Important/Advisory with dual citations | Output 3-4, playbook definitions only | MEETS |
| Preferred position, supported fallback, negotiation question, appropriate escalation owner | v1.1 output 5 adds per-finding escalation owner | MEETS (v1.1) |
| Concise reusable submission language | Output 6 fills the playbook request-form sections | MEETS |
| Guardrails: pre-review only, no approval/legal advice/invented standards, respect functional judgment | Role statement + decline rule + fixed disclaimer + "Not addressed by the playbook" | MEETS |
| POC success: consistent citation output, accurate prioritization, useful language, fewer cycles, time savings | Fixed 7-part format drives consistency; accuracy/time measured in the readout | SUPPORTED |

**Exceeds:** Top Risks banner; healthcare/institutional trigger checklist (BAA, Stark/COI, Open Payments, REPtrax, access-to-records, insurance, no-AI-training data rule); proven honest-failure behavior; native Word output; multi-document conflict flagging as a standing rule.

**Version note:** v1.1 is LIVE in the tenant as of Nov 11 (pasted and saved in the builder; opening line, both v1.1 markers, and the closing disclaimer verified in the box before saving). The coverage matrix is now fully in effect.

**Also discovered in reference/:** a second vendor contract set (BD: BAA, DSA, NDA) for additional testing, and the one-pager image itself.

## Red team completed (Nov 11) — see red_team_findings.md

Eleven findings. Agent-level fixes shipped as instructions v1.2 (injection defense with manipulation-reporting, uploaded-documents-only source discipline with per-file citations and mixed-vendor stop, citation self-verification, partial-document honesty, playbook pinning in the output header, AI PRE-REVIEW DRAFT watermark, playbook-gap recommendations). New assets: synthetic_contract_trap.txt (fictional Helixion Dynamics MSA, seven planted traps including an embedded prompt injection, with pass/fail checklist) and contract_agent_user_guide.md. Process findings (RT-10) documented with hard rules adopted for remote driving after a real incident: ~1.5KB of DSA text was accidentally submitted to Bing as a search query during remote navigation (disclosed; Microsoft-internal but outside tenant boundary).

**Deployment state: live agent runs v1.1; v1.2 is committed and awaiting the two-minute builder paste.** Acceptance gate for v1.2 = the trap-contract run (upload synthetic_contract_trap.txt in the agent chat; score against its checklist, T6 injection especially).

## v1.6 (Nov 16) — SOW/Quote awareness, long-doc SOP, stress test

New reference material (two SOW/Quote checklists + five real redlined MSAs/SOWs) analyzed in new_reference_analysis_2026-11-16.md. v1.6 adds document-TYPE detection (standalone agreement vs SOW/order/quote under a governing MSA) and SOW/Quote handling led by DEFER-TO-MSA (SOW defers to the MSA, strip vendor T&Cs it covers), plus detailed-scope enforcement, milestone-payments/no-execution, not-to-exceed for T&M, no auto-renewal, maintenance/SLA sufficiency. SOW criteria treated as a reference doc the agent consults (like the playbook) - recommended follow-up: fold the SOW checklist into Laura Madsen's playbook so thresholds live in one maintained place. Instruction block re-fit to 7,979/8,000 by trimming. Also shipped: contract_agent_long_doc_sop.md (map -> section sweep -> synthesize chunked review for long contracts, runnable today) and testdata/synthetic_long_sow_trap.txt (long SOW, ~30 sections, 14 traps incl. three in the TAIL and a tail-planted prompt injection, to validate S5 coverage + v1.6 SOW rules). LIVE-PASTE PENDING for v1.6 (pencil-toggle + Ctrl+A/Ctrl+V; supersedes v1.5).

## v1.5 shipped to repo (Nov 16) — long-document coverage hardening

Added rule S5 (FULL COVERAGE): review the whole document in order, never rely on retrieving only salient excerpts (absence is a finding), outline structure, confirm the final section was reached and state coverage span, and on over-length documents say so and recommend splitting rather than silently sampling. Fit under the 8,000-char ceiling by trimming verbose phrasings (paste block now 7,987). Rationale and the instruction-vs-orchestration split in contract_agent_long_docs.md. **v1.5 is LIVE** in the tenant (Nov 16; pasted via pencil-toggle + Ctrl+A/Ctrl+V, saved - "created successfully", S5 FULL COVERAGE confirmed in the box). The live agent now carries all hardening through v1.5. Shivam's long-doc orchestration is the complementary layer for contracts beyond a single pass, to evaluate when he reaches out.

## DEPLOYMENT: v1.4 LIVE (Nov 13)

v1.4 is saved and live in the tenant — verified in the box before saving (COMPARISON/PORTFOLIO modes and the v1.4 closing line present; opening confirmed "give legal advice"). The live agent now carries all red-team hardening (v1.2), redline + inbound-license handling (v1.3), and the four executive features (v1.4: deal snapshot, key dates, comparison, portfolio). KEY BUILDER LESSON: the Instructions box is read-only until you click the little PENCIL edit-toggle button on it; that is why every prior HANDS Ctrl+V silently failed. Always click the pencil before pasting.

## DEPLOYMENT STATE CORRECTION (Nov 13, superseded by the entry above)

Direct inspection of the live agent's instructions box (fresh open in the builder) shows it already runs **v1.2-class hardened content** — the injection defense, uploaded-documents-only source discipline, and mixed-vendor STOP rule are all present. Earlier status saying "v1.1 live" was wrong; the live agent is safe and hardened. What is NOT yet live: v1.3 (redline/inbound handling) and v1.4 (deal snapshot, key dates, comparison/portfolio modes) — both are in the repo instruction file (v1.4 supersedes all). The 2-minute paste is still pending because the builder's instructions textarea does not reliably accept Ctrl+V under HANDS remote control; this needs a human paste.

HUMAN PASTE STEPS (Alex): builder > My agents > Contract Review Agent v1 POC > click into the Instructions box > Ctrl+A > Ctrl+V from enterprise/contract_agent_instructions_v1.txt (copy between the === markers) > confirm the opening line now reads "give legal advice" (v1.4) not "provide legal advice" (v1.2) > Create/Update to save.

## New sample set coverage (Nov 12) — v1.3

Yesha added three files: TriNetX DSA and BAA carrying ACTIVE REDLINES (94/50 and 49/49 insertions/deletions — classic vendor weakening: "commercially reasonable" qualifiers throughout, PCI clause replaced with "Intentionally Omitted," named Security Coordinator diluted to "internal security team"), and an Avandra INBOUND Data License (Keck as Licensee of imaging data WITH onward sublicensing to Clients; schedules incl. a BAA embedded in one file; Delaware law + jury waiver; licensor insurance $2M/$5M). Gap analysis: v1.2 had no redline awareness (platform may read tracked changes as accepted — silently reviewing the vendor's preferred text), no direction awareness, and file-level-only inventory. v1.3 (committed) adds: S4 redline rule (detect/confirm negotiation state; admit when changes are invisible and request clean version or change list; REDLINE ANALYSIS subsection with per-change direction, playbook impact, accept/counter; qualifier-insertion and deleted-obligation weakening patterns), agreement-direction detection with licensee posture for inbound licenses, and embedded-schedule inventory. User guide gained a Special Cases section. Instruction block: 7,921/8,000 chars. DEPLOYMENT: live agent now one more version behind (runs v1.1; v1.2 and v1.3 both pending the builder paste — paste v1.3 directly, it contains everything).

## Remaining for POC (by Nov 20)

1. Paste v1.3 into the live agent (2 min, builder editor; supersedes the v1.2 paste).
2. Trap-contract acceptance run (synthetic_contract_trap.txt) — pass all seven traps, T6 injection mandatory.
3. Complete the DSA end-to-end run; score it against the playbook rules the DSA actually implicates (termination rights, audit, security incident notice, indemnification, LoL, third parties). NOTE: upload via the agent CHAT attach button — the ThinkPad has no local org-OneDrive sync, so file-drop/indexing paths do not work on that machine, and the builder Preview cannot attach.
4. Run the NDA and BD set as consistency tests; run the TriNetX redlined DSA (state "contains vendor redlines" in the prompt) and the Avandra inbound license as the new-use-case tests.
5. (done — see trap contract above)
6. BAA copy from Laura Madsen (unprotected) if in scope.
7. One-page POC readout for Yesha mapping results to her one-pager's success measures (citation accuracy, prioritization quality, usable submission language).
8. Decide knowledge-source attachment vs per-conversation playbook (POC evidence: baseline search finds the tenant playbook on its own, which may make explicit attachment unnecessary).
