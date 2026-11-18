# Shivam / Yesha sync (Nov 17, 2026) — asks & delivery

Second sync of the day (after the Ellie demo). Shivam proposed a classification approach to cut hallucination;
Yesha pushed on verbosity, exact departments, and a precision/recall bar for Friday readiness.

## Asks → what was built

| Ask (who) | Status | Where |
|---|---|---|
| **Classify contracts so only the relevant playbook slice is applied** — reduce hallucination & verbosity (Shivam) | BUILT (framework) | `classification/contract_category_taxonomy.md`, `review_profiles.json` |
| **Classify document components to prevent hallucination** — no finding without a located clause/gap (Shivam/Alex) | BUILT | `classification/component_types.json` |
| **Use JSON config + Copilot's code/if-else to pick the right profile** (Shivam) | DESIGNED (Option A) | taxonomy doc, "two ways to wire this in" |
| **Precision/recall testing, target ≥80%, as the Friday bar** (Shivam/Yesha) | BUILT + VALIDATED | `testing/precision_recall_methodology.md`, `score_redline.py`, `synthetic_result.md` |
| **Ground truth from the redline directory** (Alex's method) | METHOD + RUNBOOK | methodology doc, "Real-data run" |
| **Exact departments, not "Contracting/X" catch-alls** (Yesha) | DEFAULT MAP (confirm) | `classification/escalation_departments.md` |
| **Less verbose, checklist/distilled, review shorter than the doc** (Yesha/Ellie) | ADDRESSED in v1.9 + profiles | v1.9 (snapshot+top-10, collapse nulls) + scoped profiles cut length |

## Synthetic P/R proof (runnable now, no real data)
`score_redline.py` on the fictional DSA before/after → **recall 86%, precision 100%, F1 92%, PASS**; it localized
one real miss and one valid EXCEED. This is the exact scorecard the real run will produce per document.

## What needs real data / other people (and why it's not done here)
- **Real precision/recall on the reference directory** must run **inside the tenant** (ThinkPad Copilot or the
  SharePoint-folder automation Yesha offered). We do **not** pull real contract text onto a personal machine —
  prior Bing leak incident. Runbook is ready; only clause-referenced scorecards leave the tenant.
- **Requirement sets per profile** are a sensible first cut from the playbook + checklists — confirm with
  **Clint/Ellie** ("what do you look for, who do you route to"). Yesha's advice: be prescriptive, ask them boom-boom.
- **Exact department names** — default map provided; confirm the real Keck group names.
- **Playbook authority** — came from Laura + Copilot; treat as swappable (agent pins which copy it used). Ellie to vet.

## Honest read of the meeting (for Alex)
Substantive and worth doing: classification-to-scope (real anti-hallucination win), the P/R bar (gives us a
defensible "meets+exceeds" number), exact departments. Already-built-but-re-raised: the Top-5/quote checklists are
already ingested; v1.9 already made owners departments and added snapshot/top-10. The verbosity concern is real but
is now addressed two ways — v1.9 output shape and the scoped profiles. Net: the agent can be shown to **meet and
exceed** the stated bar once the real-data P/R run is done in-environment.

## Decisions for Alex
1. Wire classification as **attached JSON knowledge** (Option A, recommended) vs inline in the 8k instructions (Option B)?
2. Fold exact-department routing + classify-then-scope into **v1.10 instructions**, or keep profiles as attached knowledge and leave instructions at v1.9?
3. Who runs the real-data P/R pass — you via Copilot, or set up the SharePoint-folder automation first?
