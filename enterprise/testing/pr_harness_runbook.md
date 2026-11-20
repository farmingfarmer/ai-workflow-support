# Batch precision/recall harness — runbook

## Why this instead of a Power Automate flow
Our production reviewer is a **declarative M365 Copilot agent**. Power Automate / Copilot Studio cannot call a
declarative agent headlessly in a clean, supported way (the standup guide flagged this). Fighting the Copilot
Studio GUI over the remote link is also what kept breaking. So the reliable way to finish the P/R testing is a
**scripted harness** that runs the agent's exact logic — its instruction block plus the Keck playbook — against
every reference original through the tenant's own model endpoint. No GUI, no OCR, fully reproducible, and it
finishes all 55 unattended.

This is the **Flow 2 (batch P/R)** objective from `../automation/sharepoint_automation_standup.md`, implemented as
code. (Flow 1, the "drop a contract in Inbox" intake front door, is a separate production nicety and not needed
for the numbers Yesha asked for.)

## What's faithful, what's a proxy (state this when presenting)
- **Faithful:** same instruction block the live agent runs on, same Keck playbook, same model class, in-tenant.
- **Proxy, not the exact surface:** the live agent reaches the playbook via tenant search; here we hand it the
  playbook text explicitly (more controlled/reproducible). Cross-check: `a13` was also run through the **live**
  agent manually — compare `review_a13.txt` (harness) to that to confirm parity.
- **Scoring is a keyword proxy** (`pr_topics.ps1`): a topic is ground-truth if its keyword appears in the human
  redline diff, and covered if it also appears in the review. Coarser than human judgement, but consistent and
  auditable. Confirm the change-lists with Contracting (Clint/Ellie) before publishing an official number.

## Data boundary
Contract text goes only to the tenant's own model endpoint (BAA/DPA-covered). Reviews stay on the ThinkPad. The
only exportable artifact is `scores_all.txt` / `scorecard_all.*` — numbers, no contract text.

## Prerequisites
1. **Ground truth** — already on the ThinkPad: `pr_work\orig_a01..a56.txt`, `gtdiff_a01..a56.txt` (55 of 56).
2. **Instruction block** — `contract_agent_paste_block.txt` (fetch from the repo, below).
3. **Playbook text (recommended)** — export the *Keck Contract Negotiation Playbook (Expanded)* to a `.txt`
   (e.g. `playbook.txt` in `dev\contract_agent\`). Optional but makes reviews match production.
4. **A tenant chat-model endpoint + key** — the HIPAA/enterprise Azure OpenAI (or equivalent) the org already has.
   You supply the URL + key; nothing is hard-coded.

## Setup (on the ThinkPad terminal)
```
cd C:\Users\NE1002766\dev\contract_agent
$B="https://raw.githubusercontent.com/farmingfarmer/ai-workflow-support/<SHA>/enterprise/testing/"
foreach($f in 'pr_topics.ps1','run_pr_harness.ps1','aggregate_pr.ps1','score_file.ps1'){ iwr -UseBasicParsing ($B+$f) -OutFile $f }
iwr -UseBasicParsing "https://raw.githubusercontent.com/farmingfarmer/ai-workflow-support/<SHA>/enterprise/contract_agent_paste_block.txt" -OutFile contract_agent_paste_block.txt
```

## Run
```
# Azure OpenAI style (api-key header):
.\run_pr_harness.ps1 `
  -Endpoint "https://<resource>.openai.azure.com/openai/deployments/<deployment>/chat/completions?api-version=2024-02-15-preview" `
  -ApiKey   "<key>" `
  -InstrFile    .\contract_agent_paste_block.txt `
  -PlaybookFile .\playbook.txt `
  -From 1 -To 56
```
It writes `review_aNN.txt` for each doc and appends `aNN RECALL=m/n ...` to `pr_work\scores_all.txt`.
Start with `-From 13 -To 13` as a one-doc smoke test, compare to the live-agent a13 review, then run the full range.

For OpenAI-compatible gateways: add `-AuthHeader Authorization -Model "<model>"`.

## Already-captured reviews
`a13` was captured from the live agent. Score it into the set without re-running:
```
.\score_file.ps1 13
```

## Aggregate → the scorecard
```
.\aggregate_pr.ps1
type pr_work\scorecard_all.md
```
Produces `scorecard_all.md` / `.json`: documents scored, aggregate recall, how many clear the 80% bar, per-doc
table. That is the Yesha deliverable — the full-corpus number.
```
```
