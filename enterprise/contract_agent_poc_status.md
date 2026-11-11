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

**Version note:** v1.1 instructions (the three MEETS (v1.1) rows) are committed and staged on the ThinkPad clipboard; the live agent still runs v1.0 pending a 2-minute paste in the builder (blocked at session end by a persistent IT services overlay on screen).

**Also discovered in reference/:** a second vendor contract set (BD: BAA, DSA, NDA) for additional testing, and the one-pager image itself.

## Remaining for POC (by Nov 20)

1. Complete the DSA end-to-end run; score it against the playbook rules the DSA actually implicates (termination rights, audit, security incident notice, indemnification, LoL, third parties).
2. Run the NDA as the second test; note multi-document package behavior.
3. Build a synthetic trap contract (per C5 ticket): a missing standard clause reported absent, an unusual indemnity flagged, a defined term preserved verbatim.
4. BAA copy from Laura Madsen (unprotected) if in scope.
5. One-page POC readout for Yesha mapping results to her one-pager's success measures (citation accuracy, prioritization quality, usable submission language).
6. Decide knowledge-source attachment vs per-conversation playbook (POC evidence: baseline search finds the tenant playbook on its own, which may make explicit attachment unnecessary).
