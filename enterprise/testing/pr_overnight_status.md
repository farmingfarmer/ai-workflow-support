# Precision/Recall — overnight autonomous status (Nov 17→18, 2026)

Honest account of how far the real-data P/R run got autonomously, what's proven, what's blocked, and why.

## Proven and working
- **Synthetic P/R harness: recall 86%, precision 100%, F1 92% (PASS).** `score_redline.py` on the fictional DSA
  before/after, with the harness correctly localizing one miss and one exceed. The *methodology* is sound and
  reproducible. (`synthetic_result.md`)

## Fully prepared (boundary-safe, automated, in-tenant)
- **Corpus sized:** 74 .docx, 58 with tracked changes, ~14,137 raw changes (max 1,380/doc). Key insight recorded:
  raw changes overcount findings, so scoring must be at the material/topic level.
- **Representative sample selected (7):** 2 Amendment, 1 BAA, 2 MSA, 1 NDA, 1 Other (`sample_manifest.csv`).
- **Originals extracted:** Word COM rejected tracked changes → `orig_1..7.txt`; also produced `final_1..7.txt`.
- **Scorer ready:** `score_topics.ps1` (topic-level recall/precision, numbers only).
- Scripts (all fetched to the ThinkPad via raw-GitHub-by-SHA): `extract_redline_groundtruth.ps1`,
  `select_and_extract_originals.ps1`, `build_pairs_and_gt.ps1`, `gt_xml.ps1`, `score_topics.ps1`.

## Two blockers that stopped a fully-automated real number

### 1. Automated topic-ground-truth was unreliable on this sample
Four extraction methods were tried (per-revision COM text, reject/accept diff, paragraph-diff, raw-XML tag-strip).
Only idx1 ever yielded topics (3); idx2–7 came back ~0. Likely cause: the sampled docs (Amendments/NDA/BAA) change
dates, amounts, and names more than the substantive clauses (indemnity, liability, data-use) the topic map keys on;
the **data-sharing/DSA contracts** — where the rich, topic-level negotiations live (the TriNetX/nference pattern,
same as the synthetic DSA) — were not in this sample. **Recommendation:** re-sample toward DSA/data-sharing
agreements, and/or let the **agent's own REDLINE ANALYSIS** produce the ground truth (it reads a redline far better
than a regex). The agent-GT path is reliable but needs Copilot runs (see blocker 2).

### 2. The agent review runs on real contracts are Alex's step *by design* (data boundary)
Running the agent on a real original requires driving the Copilot UI, and my only "eyes" on that machine is
OCR/screen-reading. While a real contract is on screen (input, or the agent's streamed review), any screen read
pulls **real tenant contract text into this session** — exactly the leak we agreed to prevent after the Bing
incident. Staging input from a file and pressing keys blindly is safe; *reading the screen to navigate or capture
the output is not.* So the in-Copilot runs must happen with a human in-tenant (you), not via my screen automation.
This is the architecture working as intended, not a bug to hack around.

## The clean path to the number (minimal human-in-loop)
For each sample doc (start 2–3), in Copilot, you do two quick runs and save each output to `pr_work\`:
1. Review `orig_<idx>.txt` → `review_<idx>.txt`.
2. Redline-analyze the redline `.docx` → `redline_<idx>.txt`  (this is the reliable ground truth).
Then `score_topics.ps1` prints recall/precision + `pr_scorecard.csv` (numbers only). Full steps: `pr_pilot_runbook.md`.

Better still for a topic-rich result: pick 2–3 **DSA/data-sharing** redlines (the ones with deleted indemnity/
liability/PCI and "commercially reasonable" insertions) — those will exercise the topic scorer the way the
synthetic DSA did.

## Ready for the morning (did this after hitting the blockers)
Re-sampled toward the topic-rich **data-sharing/DSA** contracts and extracted their originals:
`pr_work\orig_d1.txt … orig_d4.txt` (+ `manifest_data.csv`). **Use these, not orig_1..7**, for the first
meaningful P/R — they carry the indemnity/liability/data-use/PCI changes the topic scorer is built to catch.
Per doc: review `orig_d<n>.txt` → `review_d<n>.txt`; redline-analyze the matching redline → `redline_d<n>.txt`;
then `score_topics.ps1` (point it at the d-files or just run it — it scans redline_*/review_* pairs).

## What I did NOT do (and won't fake)
I did not produce a real-data precision/recall number, because doing it autonomously would have required either
scoring against unreliable ground truth or reading real contract text off the screen. A fabricated 0.8-something
would be worse than an honest "the harness is proven on synthetic; the real run needs the two Copilot runs per doc,
which are yours by the data boundary."
