# Precision/Recall pilot — runbook (real reference contracts)

Everything automatable is done and lives on the ThinkPad in `C:\Users\NE1002766\dev\contract_agent\pr_work\`.
Only the agent runs need you in Copilot (no agent API). Real contract text never leaves the tenant; only the
final scorecard numbers do.

## What's already prepared (in `pr_work\`)
- `sample_manifest.csv` — the 7 sampled contracts (idx, file, type, change-count). Types: 2 Amendment, 1 BAA,
  2 MSA, 1 NDA, 1 Other.
- `orig_1.txt … orig_7.txt` — each contract with the human tracked changes **rejected** (the pre-redline
  **original**), extracted by Word. These are what the agent reviews.

## Your part — 2 Copilot runs per doc (start with 2–3 docs for the first number)
For each idx you want to score:
1. **Agent review of the original.** New chat with the Contract Review Agent → upload/paste **`orig_<idx>.txt`**
   → send `Review this against the playbook`. Save the output as **`pr_work\review_<idx>.txt`**.
2. **Agent redline analysis = ground truth.** New chat → upload the **redline** `.docx` for that idx (the file named
   in `sample_manifest.csv`, in the reference folder) → send `Give me the redline analysis: list the material
   changes the reviewer made, grouped by topic`. Save as **`pr_work\redline_<idx>.txt`**.

(Why the agent produces the ground truth: the programmatic extraction was unreliable — it found 0 topics on 6/7
docs because the material topic lives in the clause context, not the few changed words. The model reads a redline
far better, so its redline analysis is the trustworthy gold standard. If you'd rather, you or Clint can eyeball
each redline and jot the material topics instead — the scorer just needs the `redline_<idx>.txt` text.)

## Then I score (or you run it)
`powershell -ExecutionPolicy Bypass -File score_topics.ps1` →
- per-doc **recall** (did the agent flag the topics the humans changed?) and **precision** (of what it flagged,
  how much the humans also changed), plus `missed_topics`
- an **AGGREGATE RECALL / PRECISION** vs the 0.80 bar
- `pr_work\pr_scorecard.csv` (numbers + clause-free topic labels — safe to share)

## Scope
Doing 2–3 docs gives the first defensible number for Friday; run the remaining sample docs (up to all 7) as time
allows, then the full 58 later via the automation once flow→agent callability is confirmed.

## Methodology notes
- Scoring is **topic-level** (indemnity, liability, data-use, payment, security, etc.) — robust across varied real
  contracts, unlike exact clause-number matching.
- "Meets or exceeds" = the agent flags the topics the humans materially changed (recall) and ideally surfaces valid
  topics they didn't (those show up as precision "extras" to eyeball, not auto-failures).
- See `precision_recall_methodology.md` for the full method and the data boundary.
