# New Reference Material — Analysis (Nov 16, 2026)

Seven files added to the ThinkPad reference folder (content stays on the ThinkPad per the data rule; this is derived analysis only).

## What arrived

**Two checklists (the "specific wants"):**
- **Top 5 SOW Checklist** — the team's concrete SOW review standard.
- **SOW & Quote Checklist** — a shorter companion list.

**Five redlined real agreements** (87–111 KB each, with tracked changes):
- Atwater/Soarian Support SOW, Keck MSA (proposed), Across Healthcare SaaS Agreement, Eon/Qlik Migration SOW, Deloitte AI Governance & MLOps SOW.
- Plus a multi-party redlined "CBA Amendments and Standard Ordering Document Terms."

Read: the real workload is **heavy on SOWs and redlines**, and the review standard for SOWs is distinct from the MSA playbook we already use.

## New requirements the checklists establish (SOW/Quote-specific)

1. **Defer to the MSA (the #1 SOW rule).** A SOW/Quote operates under a governing MSA and must defer to it; vendor T&Cs added into a SOW/Quote are to be removed because the MSA governs. Standard deferral language exists ("This SOW is governed by the Master Agreement... to the extent of any conflict, the Agreement prevails"). Our current agent has no SOW-vs-MSA awareness — this is the biggest gap.
2. **Detailed description of services.** Not acceptable to list "Service 1, Service 2" without detail; quotes that include services may require a separate detailed Scope.
3. **Term length.** 3–5 year initial term, 1-year renewal on written acceptance, **no auto-renewal** (consistent with the playbook).
4. **Cost & payment.** Cost breakdown + total; **milestone payments tied to deliverables, none on execution**; fee structure identified (one-time / recurring / T&M); no late fees; renewal increase ≤ lesser of CPI or 3% with 60 days' notice; **not-to-exceed language for T&M/hourly**. USC's preferred milestone split: **33% kickoff + staffing plan, 33% post-validation, 33% go-live acceptance** (50/50 acceptable in some cases).
5. **Maintenance & support.** Confirm maintenance, support, and SLAs are sufficient.

Most of these echo playbook positions already in the agent (CPI/3% cap, no auto-renewal, no payment on execution, milestone payments). The genuinely new, SOW-specific items are **defer-to-MSA / strip vendor T&Cs**, **detailed-scope enforcement**, and the **specific milestone split**.

## How this changes the agent design

- **Document-type detection becomes first-class.** The agent must tell a standalone agreement (MSA/SaaS) from a SOW/Order/Quote that runs under a governing MSA, because the review criteria differ.
- **SOW/Quote mode** applies the SOW checklist in addition to the playbook, leading with defer-to-MSA.
- **The SOW checklist should live as a reference document** the agent consults (exactly like the playbook), not hardcoded thresholds in the instructions — the instruction block is already at its 8,000-char ceiling, and keeping criteria in a maintained reference doc (ideally folded into Laura Madsen's playbook as a SOW section) is the extensible, lower-maintenance design. Shipped v1.6 adds compact SOW-mode method; the detailed numbers stay in the reference.
- **The redlined examples validate the v1.3 redline work** and give realistic long documents for the stress test.

## Actions taken
- v1.6 instructions: document-type detection + SOW/Quote handling (defer-to-MSA, detailed scope, milestone/no-execution-payment, not-to-exceed, maintenance/SLA), compact, fit under 8k.
- Long-document SOP (map → section sweep → synthesize) for contracts beyond a single pass.
- Synthetic long SOW stress test with traps planted through the tail, including SOW-specific traps.

## Recommended follow-up
- Fold the SOW/Quote checklist into the Keck playbook as a SOW section (Laura Madsen), so the agent's existing "consult the playbook" behavior covers SOWs automatically and the thresholds stay in one maintained place.
