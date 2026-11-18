# Precision & recall testing — methodology

Agreed in the Shivam/Yesha sync (Nov 17): quantify the agent with **precision and recall**, target **≥ 80%**
each, as the "good to go by Friday" bar. This document defines the protocol so the numbers are reproducible and
defensible — and draws the data boundary so we never leak real contract text.

## The two metrics (as defined in the meeting)
- **Recall** = of the things that *should* have been caught, how many did the agent catch?
  `recall = (expected findings the agent caught) / (total expected findings)`.
  Low recall = the agent misses issues a human reviewer would flag. (Shivam: "10 things to review, caught 4 → poor.")
- **Precision** = of the things the agent asserted, how many are correct?
  `precision = (agent findings that are correct) / (total agent findings)`.
  A specific, important case: **compliance precision** — when the agent calls a clause acceptable/compliant, is it
  actually acceptable (i.e., the human redliners did *not* change it)? A "compliant" call on a clause the humans
  rewrote is a false positive (and a recall miss).

## Ground truth — where it comes from (Alex's method, confirmed in the meeting)
The red-lined agreements in the reference directory are the **finished products the reviewers wanted**. So:
1. Take a red-lined document. Its tracked changes = **what human reviewers decided needed to change** =
   the gold-standard set of **expected findings** (each insertion/deletion/qualifier = one expected finding).
2. Revert the redline to its **original** (the pre-redline vendor draft — recoverable, the base text is in the doc).
3. Run the agent on the **original** only.
4. Compare the agent's findings + proposed edits to the gold set:
   - Each expected finding the agent flags (same clause + same direction) → **true positive (recall hit)**.
   - Each expected finding the agent misses → **false negative (recall miss)**.
   - Each agent finding with no matching redline change → check against the playbook: a valid playbook-grounded
     flag is a **true positive (precision hit, possibly a *catch the humans missed* — an EXCEED)**; a spurious or
     wrong flag is a **false positive (precision miss)**.
5. "Meets or exceeds": the agent should flag **every** change the humans made (recall) and ideally surface valid
   issues they didn't (precision-positive extras), while keeping false alarms low.

## Scoring
Per document we build two lists and run `score_redline.py`:
- `ground_truth` — expected findings derived from the redline (id, clause, direction, short description).
- `agent_findings` — the agent's actual findings (id, clause, direction, verdict).
Matching is by (clause, direction) with a short alias list per finding. The script prints per-document and
aggregate **precision, recall, F1**, lists misses and false positives, and flags any **EXCEED** extras.

## Scoping test (does classification help?)
Run each document twice: once with the **whole playbook** and once with the **classified profile**
(`../classification/review_profiles.json`). Compare precision/recall and output length. Hypothesis (Shivam's):
the scoped profile holds or improves recall, raises precision (fewer irrelevant/generic flags), and cuts length.

## DATA BOUNDARY (non-negotiable)
The reference contracts are real, tenant-resident, and sensitive. We had a prior incident (≈1.5KB of real DSA
text reached Bing during remote driving). Therefore:
- **Real documents are run only inside the corporate environment** — the Copilot agent on the ThinkPad, or the
  SharePoint-folder automation Yesha proposed. Real contract text does **not** come onto a personal machine or any
  external service.
- **Only the derived scorecard leaves** — counts and metric values (e.g., "DSA #3: recall 9/10"), with findings
  referred to by clause number, **never verbatim contract language**.
- The harness, templates, and synthetic validation (next section) are built outside the tenant; the real-data run
  uses them in-place.

## Real-data run — runbook (in-environment)
For each reference document (target set: the MSA/SOW/DSA redline pairs in the reference directory; most are
10–20 pages, Microsoft-type outliers excepted):
1. In Copilot with the agent, upload the **original** (reverted) version.
2. Prompt: `Review this against the playbook, then give the redline / proposed edits.`
3. Record the agent's findings into `agent_findings` (clause + direction + verdict) — numbers and clause refs only.
4. Build `ground_truth` from the actual redline (clause + direction + one-line description).
5. Run `score_redline.py`; log the scorecard to `scorecards/<doc-id>.json` (metrics only).
6. Aggregate across documents; report precision/recall vs the 80% bar.
If the SharePoint-folder automation is wired, steps 1–3 can be batched (point the agent at the folder rather than
re-uploading each doc).

## Synthetic validation (proof the harness works — runnable here, no real data)
`ground_truth_synthetic_dsa.json` + `agent_output_synthetic_dsa.json` encode the synthetic before/after DSA pair
(the same one in `before_after_redline_trinetx.html`, fully fictional) and its recorded agent output. Running
`score_redline.py` on them demonstrates the exact scorecard the real run will produce. See `synthetic_result.md`.
