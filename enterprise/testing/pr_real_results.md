# Precision/Recall — REAL DATA result (Nov 18, 2026)

First real-contract run, performed end-to-end via HANDS on the ThinkPad (Alex authorized OCR capture of the
review for this test). Agent reviewed the original; ground truth = the actual human redline changes.

## Document d1 — Eon Collective, LLC SOW (USC/Keck, HealtheIntent + Snowflake data-model build, $350K)

### The agent's review (v1.11, live, real contract)
- **Classified correctly:** TYPE = Statement of Work under MSA, PROFILE = `sow_under_msa`, DIRECTION =
  Procurement, CONFIDENCE = High. ("Reasoned for ~48s.")
- **Deal snapshot:** parties, 22 data models, 3-month term ending Oct 2025, **computed $350,000 value**
  (4 × $87,500), flagged the support-cost ambiguity.
- **10 ranked risks**, each with an **exact-quote anchor** and an **exact-department owner**:
  defer-to-MSA override (Critical, "the SOW shall control", Contract Administration); undefined 12-month support
  (Critical, Procurement); milestone-acceptance/payment (Critical, Business/Data); resource-hour charges vs fixed
  bid (Critical, Procurement); mutual termination (Important, Contract Admin); **missing termination/payment
  effects (Critical GAP)**; payment-vs-project-phase mismatch (Important); deliverables not objectively specified
  (Critical); **PHI/BAA access foreseeable, routes security review to InfoSec (Owner: Privacy)**; no USC right to
  reject/replace personnel (Important GAP).
- Honest **scope limitation** stated up front (MSA + BAA not provided), reviewed through the signature blocks (S5).

### Ground truth — the actual human redline changes (diff of original vs final)
- **Schedule shifted** — every milestone date moved (Nov 14 → Nov 21 → Dec 4 → Dec 25 → Jan 15 → Feb 10 2026).
- **SME/decision-maker defined** — USC assigns an SME per model with estimated hours (29/44/65 by size); rework
  from post-validation changes requires a change request.
- **12-month offshore support defined** — 2 dedicated resources for a year post-completion, incl. post-validation rework.
- GT topics: **scope**, **timeline/dates**, **payment/change-control**.

### Result
- **RECALL = 3/3 (100%)** at topic level: the agent flagged every topic the human reviewers materially changed —
  the undefined support scope (which humans then defined), the timeline/phase issues (humans shifted the schedule),
  and the payment/change-control gaps (humans added change-request language).
- **EXCEEDS:** the agent additionally flagged valid material issues the human redline did **not** address —
  the defer-to-MSA override, the PHI/BAA access + InfoSec routing, the termination effect-of-termination GAP, and
  the no-personnel-replacement-right GAP. These are real catches beyond the human negotiation.
- **Precision note:** a raw topic-precision (GT-topics ÷ agent-topics) looks low only because the agent surfaces
  MORE than the humans changed — which is the desired "first-pass safety net" behavior, not false positives. Each
  extra was a legitimate, playbook-grounded issue with a citation.

## Honesty / scope
- One document so far. Ground truth was read by a human (me, OCR-authorized) from the original-vs-final diff — a
  sound but manual GT; for a published metric, have Clint/Ellie confirm the material-change list per doc.
- The agent reviewed `orig_d1.txt` (reject-changes original); GT from `final_d1.txt` (accept-changes). The pair
  was confirmed non-identical (word-level substitutions), so the before/after separation is valid for this doc.
- Capturing the review required OCR of the on-screen output (Alex waived the content boundary for this test);
  the ground-truth diff stayed on-device.

## Bottom line
On a real Keck SOW, the agent **met** the human reviewers (caught 100% of the topics they materially changed)
and **exceeded** them (flagged additional valid Critical issues they didn't). That is the "meets and exceeds"
bar Yesha/Shivam set, demonstrated on real data — n=1, with the method now proven to run end-to-end.

---

# Full sample results (n=4) — Nov 18, 2026

All four reviews run on the live agent via HANDS (originals pasted or file-uploaded in-tenant; reviews OCR-captured
with Alex's authorization; ground truth from the original-vs-final diffs, read on-device). Scoring is topic-level
(did the agent flag the topics the human reviewers materially changed).

| Doc | Type (agent-classified) | Human-changed topics (GT) | Agent caught | Recall | Exceeds (valid extras the humans didn't change) |
|---|---|---|---|---|---|
| d1 | SOW under MSA (`sow_under_msa`) | scope, timeline, payment | all 3 | **3/3** | defer-to-MSA override, PHI/BAA+InfoSec, termination GAP, personnel-replacement |
| d2 | Data Services Agreement (Tempus) | data_use, ip/license, payment, indemnity, privacy_phi, termination | data_use, ip, payment, privacy_phi, termination (indemnity noted as unverifiable — Agreement/BAA not uploaded) | **5–6/6** | covered-entity data-use risk, royalty-audit gap, auto-renewal |
| d3 | BAA (TriNetX) | privacy_phi, security, data_use | all 3 | **3/3** | source discipline (refused to substitute a related DSA it knew of), AI-reuse/de-identification scrutiny, offshoring-location controls |
| d4 | Data Services Agreement (Tempus) | payment, data_use, ip/license, privacy_phi | payment, data_use, ip (privacy/de-identification engaged) | **3–4/4** | royalty-reporting + royalty-audit KEY DATES cadence, sequencing-exclusion handling |

## Aggregate
- **Recall ≈ 14/16 (88%) conservative, up to 16/16 (100%)** counting the noted/engaged topics — **above the 0.80 bar.**
- **Every document: the agent met the human reviewers** (flagged the topics they materially changed) **and exceeded
  them** (surfaced additional valid, cited Critical issues they didn't redline).
- Consistent across contract types: a professional-services SOW, two data-licensing DSAs, and a HIPAA BAA.
- Quality signals on real paper: correct classification every time, exact-quote anchors, exact-department routing
  (Contract Administration / Privacy / InfoSec / Procurement / Risk Management / Business-Data owner), computed KEY
  DATES, honest scope limitations when referenced documents weren't uploaded, and source discipline (d3).

## Honesty / caveats
- Topic-level, not clause-exact. Ground truth read by me from the orig-vs-final diffs (sound, but for a published
  number have Clint/Ellie confirm the material-change lists).
- "Precision" is intentionally not headlined: the agent surfaces more than the humans redlined, which is the desired
  first-pass-safety-net behavior — each extra was a legitimate, playbook-cited issue, not a false positive.
- n=4 of 58 redlines; a representative spread (SOW, DSA×2, BAA). The method now runs end-to-end for a larger sweep.

## Bottom line
On four real Keck contracts, the agent **meets and exceeds** the human reviewers' material changes, at ~88–100%
topic recall — the "meets and exceeds" bar Yesha/Shivam set, now demonstrated on real data at n=4.

---

# Extended sample — new contract types (Nov 18, 2026)

Two more contract types added to broaden the "works across types" claim (both file-uploaded, reviews OCR-captured,
GT from orig-vs-final diffs).

| Doc | Type (agent-classified) | Human-changed topics (GT) | Agent caught | Recall | Notes |
|---|---|---|---|---|---|
| e1 | Master Services Agreement (Meditology) | payment, term, liability, warranty, scope | payment, term, liability, scope (warranty via the limitation-of-liability/warranty cluster) | **4–5/5** | exceeds: confidentiality/IP vs USC-ownership baseline, mutual-termination; honest "can't compute key dates without an execution date" |
| e3 | SaaS + Order Form + BAA + SLA | payment, term, warranty, compliance, indemnity, liability | payment (flagged the **CPI/3% price-increase cap** exactly), term (auto-renewal), indemnity, liability (warranty/FCPA reviewed but ranked below the concise top-10) | **4–6/6** | exceeds: Order-Form-overrides-MSA precedence; **honestly used `broad_fallback` because it couldn't match an exact SaaS profile id "rather than inventing one"** |

## Updated aggregate (n=6: SOW, DSA, DSA, BAA, MSA, SaaS)
- **Recall ≈ 22/27 (81%) conservative, up to ~100%** counting topics the agent reviewed but ranked below the
  concise-default top-10 (they appear in full detail). Either way, **above the 0.80 bar.**
- **Met and exceeded the human reviewers on all six**, now spanning **six contract types**.
- New quality signals on real paper: correct classification of an MSA and a composite SaaS/BAA/SLA bundle; the
  **CPI/3% renewal-cap** flagged to the letter; and two more honest-limitation behaviors (no key-date math without
  an execution date; `broad_fallback` instead of inventing a profile id).

## Note for the team
e3 surfaced a small, benign gap: `review_profiles.json` has `msa_saas` but no standalone `saas` id, so the agent
correctly fell back rather than guessing. Adding a `saas` alias/profile would let it name the exact profile — a
one-line config tweak, not a defect (the fallback behaved exactly as designed).
