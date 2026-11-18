# SharePoint automation — standup guide

Turns the validated design (enhancements item 5) into a build-ready package. Two flows on one SharePoint
library: **(1) production intake pre-review** and **(2) batch precision/recall over the reference directory**.
Everything lives inside the tenant, which also satisfies the data boundary — real contract text never leaves M365.

> Build target: Copilot Studio **agent flows** (Power Automate under the hood). Needs Copilot Studio
> **2025.7.2+** for file-passing to agents. Build it on the ThinkPad in the tenant (interactive auth). This guide
> is the click-path + every config value; `folder_manifest.json` and `review_result_schema.json` are the artifacts.

## 0. Prerequisite — attach the classification JSON as agent knowledge (Option A, your call)
Before the flows are useful, give the agent its profiles:
1. Open the Contract Review Agent in the agent builder → **Knowledge** → add files.
2. Upload `../classification/review_profiles.json` and `../classification/component_types.json`.
3. Deploy **v1.10 instructions** (see `../contract_agent_instructions_v1.txt`, revision v1.10) — they tell the
   agent to classify, select the profile by `id`, and review only its requirements. (v1.10 is the companion to this.)
4. Sanity check in chat: upload a SOW and confirm the header names the detected profile (e.g. `sow_under_msa`).

## 1. SharePoint library + folders
Create a document library **"Contract Review"** in the team site with this structure (see `folder_manifest.json`):
```
Contract Review/
  Inbox/            <- reviewers drop a contract here (triggers Flow 1)
  Reviews/          <- agent review documents land here
  Reference/
    Originals/      <- reverted-to-original reference contracts (Flow 2 input)
    Redlines/       <- the matching human redlines (ground-truth source)
  Scorecards/       <- P/R scorecards (numbers only) from Flow 2
  Config/           <- review_profiles.json, component_types.json (optional copy for reference)
```
Columns to add to Inbox/Reviews (optional but useful for the register): `Vendor` (text), `DocType` (choice:
MSA/SOW/DSA/BAA/NDA/License/Amendment), `Status` (choice: Received/Reviewed/Escalated), `ReviewLink` (hyperlink).

## 2. Flow 1 — Production intake pre-review
**Trigger:** SharePoint — *When a file is created* in `Contract Review/Inbox`.
**Steps:**
1. **Get file content** (SharePoint) — identifier = trigger file.
2. **Run the Contract Review agent** — Copilot Studio action "Run a prompt / Execute agent", pass the file as
   input. Prompt (store as the flow's constant):
   > Review this agreement against the playbook. Classify it first and use the matching review profile. Give the
   > snapshot, ranked top risks, key terms, key dates, and the escalation checklist with exact departments. Keep it
   > scannable.
3. **Create file** (SharePoint) in `Contract Review/Reviews` — name `Review - <FileNameWithoutExt> - <triggerTimestamp>.docx`
   (pass the timestamp from the trigger; do **not** use utcNow() expressions you cannot reproduce — the trigger's
   `Created` field is deterministic), content = agent output.
4. *(optional)* **Post a message** (Teams) to the requester: "Your pre-review for <FileName> is ready: <ReviewLink>."
5. *(optional)* **Update item** — set Status = Reviewed, ReviewLink.

**Caveat to verify in-tenant (flagged honestly):** our main agent is a **declarative agent** from the M365 agent
builder. Copilot Studio agent flows invoke **Copilot Studio** agents/prompts most cleanly. Two viable paths — pick
whichever your tenant exposes:
- **(a)** Recreate/mirror the agent as a Copilot Studio agent (same instructions + attached JSON) and call it; or
- **(b)** Use a Copilot Studio **prompt action** (AI Builder / "Create text with GPT") seeded with the instruction
  block + the uploaded file, if the declarative agent is not directly callable from the flow.
Verify callability first with a one-file test before wiring the trigger. See Sources in `../contract_agent_enhancements.md`.

## 3. Flow 2 — Batch precision/recall over the reference directory
**Trigger:** Manual (button) or Scheduled.
**Steps:**
1. **List files** in `Contract Review/Reference/Originals`.
2. **Apply to each** file:
   a. Get file content.
   b. Run the agent with the review+redline prompt:
      > Review this against the playbook using the matching profile, then give the redline / proposed edits.
   c. Parse the agent's findings into the `agent_findings` shape (clause, direction, verdict, playbook_grounded).
      Save as `Scorecards/<docId>.agent.json`.
3. For scoring, pair each with its human redline in `Reference/Redlines` to build `ground_truth` (clause,
   direction, desc). Building ground truth from a redline is a **human/offline step** per document (or a second
   flow that extracts tracked-changes); then run `../testing/score_redline.py` on the pair to produce
   `Scorecards/<docId>.json`.
4. Aggregate: `python3 ../testing/score_redline.py --aggregate Scorecards/*.json` → the Friday number.

**Data boundary:** Flow 2 runs entirely in-tenant. Only the **scorecards** (counts + clause refs, no verbatim
contract text) are the exportable artifact. See `../testing/precision_recall_methodology.md`.

## 4. What to demo Friday
Drag a contract into `Inbox` → the review appears in `Reviews` seconds later (the "front door" Yesha described).
Then show an aggregate scorecard from Flow 2: "recall X%, precision Y% across N reference contracts, target 80%."

## Standup checklist
- [ ] Attach `review_profiles.json` + `component_types.json` as agent knowledge
- [ ] Deploy v1.10 instructions
- [ ] Create the "Contract Review" library + folders (`folder_manifest.json`)
- [ ] Verify agent callability from a flow (path a or b) with one test file
- [ ] Build Flow 1 (intake) and test end-to-end with a synthetic contract
- [ ] Build Flow 2 (batch P/R) and run on the reference originals
- [ ] Aggregate scorecards; confirm ≥80% recall & precision
