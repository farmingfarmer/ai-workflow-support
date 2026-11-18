# Synthetic validation result — proof the P/R harness works

Run here, on fully fictional data, to prove the methodology produces a real, discriminating number
before it ever touches a real contract. No tenant data involved.

## Inputs
- `ground_truth_synthetic_dsa.json` — the 7 changes the vendor made in the synthetic DSA redline
  (the same fictional pair in `../before_after_redline_trinetx.html`): two "commercially reasonable"
  insertions, an unnamed security team swap, three "Intentionally Omitted" deletions (PCI, indemnity,
  liability cap), and a deadline softened to "promptly."
- `agent_output_synthetic_dsa.json` — the agent's recorded findings on that redline.

## Result (`python3 score_redline.py ground_truth_synthetic_dsa.json agent_output_synthetic_dsa.json`)
```
recall    86%  (6/7 expected findings caught)
precision 100% (7 agent findings)
F1        92%   -> PASS (target >= 80% each)
MISSED (recall gaps): ['gt-2.4']   # the subtle Security-Coordinator -> unnamed-team swap
EXCEED (valid catches humans did not make): ['ag-7']   # flagged missing incident-report content
```

## Why this matters
- The harness is **discriminating, not a rubber stamp**: it caught a genuine miss (the subtle §2.4 swap the
  agent did not flag) and separately credited a valid **EXCEED** (an issue the agent raised that the human
  redline never addressed). A test that always returns 100% proves nothing; this one localizes exactly where
  recall leaks and where the agent adds value.
- It yields the **same scorecard shape** the real-data run will produce — so Friday's numbers on the reference
  directory are just this, repeated per document and aggregated.
- `scorecards/synthetic_dsa.json` is the saved scorecard; `score_redline.py --aggregate scorecards/*.json`
  rolls many documents into one precision/recall figure.

## To run on the real reference directory (in-environment only)
Follow the runbook in `precision_recall_methodology.md`. Real contract text stays in the tenant; only the
clause-referenced scorecards (numbers) come out. Target: aggregate recall and precision each ≥ 80%.
