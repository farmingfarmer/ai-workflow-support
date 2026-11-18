# Contract classification taxonomy — scope the playbook, cut hallucination

**Problem (from the Shivam/Yesha sync, Nov 17):** dumping the *entire* playbook over *any* contract
makes the agent reach for rules that do not apply — which reads as verbosity and, worse, invites
hallucinated or generic requirements. The playbook is full of conditional nuance ("if infrastructure do X,
if HR do Y"). The fix is **classify first, then review against only the slice that applies.**

This is a two-axis classification, done as the agent's first step, announced in the output so a human can
sanity-check it:

## Axis 1 — document TYPE (what kind of paper is this?)
Already partly handled by v1.6 type-detection; formalized here.

| Type | Signals | Governing relationship |
|---|---|---|
| MSA / master agreement | "Master Services Agreement", broad T&Cs, no specific deliverables | governs SOWs/orders under it |
| SOW / order form / quote | "Statement of Work", "Order", "Quote", references an MSA | **defers to MSA** |
| DSA (data security addendum) | "Data Security", safeguards, incident response | rides on MSA/BAA |
| BAA | "Business Associate", HIPAA, PHI | compliance doc |
| NDA / CDA | "Confidentiality", "Non-Disclosure" | standalone |
| Inbound license | USC is **licensee** of data/software | licensee posture |
| Amendment / addendum | "Amendment No.", changes a prior agreement | modifies parent |

## Axis 2 — subject DOMAIN (what is it about?)
This is the axis Shivam flagged — the one that changes *which requirements matter*.

| Domain | Typical subject | Requirement emphasis |
|---|---|---|
| IT infrastructure / equipment | hardware, hosting, networking, goods | security review, SLAs, acceptance, warranty |
| Software / SaaS | subscriptions, platform access | data rights, uptime SLAs, auto-renewal, price caps |
| Data / research | data sharing, de-identified data, research use | **data-use/AI-training, BAA/DSA, secondary use, IRB** |
| Clinical / professional services | staffing, clinical services, consulting | credentialing, insurance, COI, licensure |
| HR / staffing | personnel, temp labor | employment terms, insurance, background checks |
| Marketing / publicity | use of name/logo | publicity rights, approvals |

## How classification prevents hallucination (the mechanism)
1. **Scope the rules.** Each (type × domain) maps to a **review profile** (`review_profiles.json`) listing only
   the requirement categories that apply. Topics outside the profile are marked *Not applicable to this contract
   type*, not invented or padded.
2. **Anchor every finding to a real clause.** The agent classifies each section of the uploaded document into a
   known **component type** (`component_types.json`) — indemnity, limitation-of-liability, payment, term, data-use,
   IP, insurance, SLA, etc. A requirement can only be reported as met/unmet **against a located component or a named
   gap** — never against an imagined clause. This is the core anti-hallucination guard: no finding without either a
   located component or an explicit "absent but required" gap.
3. **Announce the profile.** The review header states the detected type, domain, and profile used, plus confidence.
   If classification is uncertain, the agent says so and reviews against the broad profile rather than guessing.

## Two ways to wire this into the agent (Shivam's point: Copilot can run code)
- **Option A — attached JSON knowledge (recommended, Shivam's suggestion).** Attach `review_profiles.json` and
  `component_types.json` as knowledge. Instruction: classify the doc, select the matching profile by `id`, review
  only its `requirements`. Keeps the instruction text small and the profiles maintainable without touching the 8k block.
- **Option B — inline in instructions.** Fold a compressed profile table into the instruction block. Simpler to
  deploy, but costs characters against the 8,000 limit and is harder to maintain.

See `../testing/precision_recall_methodology.md` for how we prove the scoped review actually catches more
(recall) with fewer wrong calls (precision) than the whole-playbook approach.
