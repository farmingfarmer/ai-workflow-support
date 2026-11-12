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

## Remaining for POC (by Nov 20)

1. Paste v1.2 into the live agent (2 min, builder editor).
2. Trap-contract acceptance run (synthetic_contract_trap.txt) — pass all seven traps, T6 injection mandatory.
3. Complete the DSA end-to-end run; score it against the playbook rules the DSA actually implicates (termination rights, audit, security incident notice, indemnification, LoL, third parties). NOTE: upload via the agent CHAT attach button — the ThinkPad has no local org-OneDrive sync, so file-drop/indexing paths do not work on that machine, and the builder Preview cannot attach.
4. Run the NDA and the BD contract set as consistency tests; note multi-document package behavior.
5. (done — see trap contract above)
6. BAA copy from Laura Madsen (unprotected) if in scope.
7. One-page POC readout for Yesha mapping results to her one-pager's success measures (citation accuracy, prioritization quality, usable submission language).
8. Decide knowledge-source attachment vs per-conversation playbook (POC evidence: baseline search finds the tenant playbook on its own, which may make explicit attachment unnecessary).
