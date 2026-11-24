# Flow 1 — Contract intake pre-review (build runbook)

**Goal:** a reviewer drops a contract into `Contract Review/Inbox`, and seconds later a plain-language pre-review
appears in `Contract Review/Reviews`, tracked in a register. This also gives the document-level **audit trail**
Essie asked for (who reviewed what, when, what came back) without any per-person surveillance, and fixes the
"I lost my chat history" problem — the review is a durable file, not a chat someone has to remember to export.

Build this in the tenant on the ThinkPad (Power Automate needs interactive sign-in). Everything below is the exact
click-path and config. Budget ~15-20 minutes.

---

## The one real decision: what calls the model
Our production reviewer is a **declarative M365 Copilot agent, which Power Automate cannot call directly.** So the
Flow needs its own model call. Two options:

- **(A) AI Builder "Create text with GPT" prompt action — recommended for the POC.** Self-contained, built into
  Power Automate, no separate endpoint. The review logic travels in the prompt (`flow1_review_prompt.txt`), which
  embeds the key playbook rules (including the new v1.12 effect-of-termination check). Needs AI Builder available.
- **(B) Copilot Studio agent — for full fidelity later.** Re-create the Contract Review Agent as a Copilot Studio
  agent (same instructions + the playbook as knowledge). A Copilot Studio agent IS flow-callable and can search the
  playbook, so the Flow's review equals the production agent's. More setup; do this when the POC graduates.

Build with **(A)** now. If AI Builder isn't enabled, request it, or substitute an HTTP action to the tenant Azure
OpenAI endpoint (same body as `run_pr_harness.ps1`).

> **Two caveats to say out loud about option (A), because they matter for production:**
> 1. **It is a *proxy*, so the 98% does not transfer to it.** Option (A) is an AI Builder GPT call, **not** the
>    validated v1.12 declarative agent reviewers see in Copilot. Before anyone trusts the Flow's output in
>    production, **re-score it through the evaluation framework** (`../agent_evaluation_framework.md`) and confirm it
>    clears the bar on its own. Do not assume parity with the Copilot agent.
> 2. **The embedded playbook rules go stale.** The live agent reaches the *full* playbook via tenant search and
>    picks up changes automatically; this prompt carries a hand-written *summary* of the rules, so when the playbook
>    changes, someone has to update the prompt. That reintroduces a maintenance/drift risk. Option (B) or the AWS
>    build (which reads the rule base live) is how that goes away.

---

## Prerequisite — the library (one-time)
Run `provision_sharepoint.ps1 -SiteUrl "https://<tenant>.sharepoint.com/sites/<yoursite>"` to create the
**Contract Review** library, folders (`Inbox`, `Reviews`, ...), and columns (`Vendor`, `DocType`, `CRStatus`,
`ReviewLink`). Confirm `Inbox` and `Reviews` exist before building the Flow.

---

## Build Flow 1 (make.powerautomate.com -> + Create -> Automated cloud flow)

Name it **"Contract Intake Pre-Review"**.

### Trigger — When a file is created (SharePoint)
- Connector: **SharePoint**, trigger **"When a file is created (properties only)"**.
- **Site Address:** your team site. **Library Name:** `Contract Review`.
- **Folder:** `/Inbox`.
- (This fires per file dropped in Inbox.)

### Step 1 — Get the contract text
A contract is usually a .docx or .pdf; the GPT action needs **text**. Pick the extraction path by file *type* — do
not OCR a clean digital file, you lose clause structure for no reason:
1. **SharePoint — Get file content** (Identifier = trigger `Identifier`).
2. **For clean digital .docx/.pdf (the common case):** extract text directly, which keeps clause structure and
   numbering. Best native option is a text-extraction connector (e.g. **Encodian / Plumsail "Get Text from
   Document"**, premium) or a small Azure Function doing python-docx/pdfplumber. OCR is the *wrong* tool here.
3. **Only for scanned/image PDFs:** **AI Builder — "Recognize text in an image or PDF document"** (OCR). Note OCR
   flattens structure and cannot see tracked changes, so it is a fallback, not the default.
   Store the result in a variable **`contractText`**. (For the quickest demo, dropping a text-based PDF and using a
   direct-extract connector is the least-moving-parts path; avoid the Convert-to-PDF-then-OCR chain.)

### Step 2 — Run the review (AI Builder)
- Action: **AI Builder — "Create text with GPT"** (a.k.a. "Create text with the GPT prompt").
- **Instructions / Prompt:** paste the full contents of **`flow1_review_prompt.txt`**, then append the dynamic
  content **`contractText`** at the end (the prompt ends with "CONTRACT TEXT TO REVIEW:").
- Keep temperature low if exposed. Output is the review text -> reference it as **`Outputs -> Text`**.
- **Before go-live, verify the hardcoded thresholds in that prompt** (Net 45, CPI/3% cap, insurance baselines,
  etc.) against the *authoritative* Keck playbook - they were transcribed from the agent's instruction block and
  must match the source of truth. These values will also drift as the playbook changes, which is a maintenance cost
  of the embedded-summary approach (see the caveats above).

### Step 3 — Write the review into Reviews/
- Action: **SharePoint — Create file**.
- **Site Address / Library:** same site, `Contract Review`. **Folder Path:** `/Reviews`.
- **File Name:** `Review - @{triggerOutputs()?['body/Name']} - @{triggerOutputs()?['body/Created']}.txt`
  (use the trigger's deterministic `Created` timestamp, not utcNow()).
- **File Content:** the AI Builder **`Text`** output.
  (.txt is simplest and reliable; for a Word doc, create an HTML/.docx via a Word-template "Populate a Word
  template" action instead.)

### Step 4 — Register + link (optional but recommended)
- Action: **SharePoint — Update file properties** on the trigger item: set **CRStatus = Reviewed**, and
  **ReviewLink** = the Create file step's **Link to item**. (Leave Vendor/DocType for the reviewer, or parse them
  from the AI output with a later enhancement.)

### Step 5 — Notify (optional)
- Action: **Microsoft Teams — Post message in a chat or channel** (or **Office 365 Outlook — Send an email**) to
  the person who dropped the file: "Your pre-review for @{triggerOutputs()?['body/Name']} is ready: <ReviewLink>."

Save. Turn the Flow **On**.

---

## Test it
Drop a contract (a PDF of one of the reference originals, or the synthetic termination-trap test) into
`Contract Review/Inbox`. Within ~30-60s a `Review - ...txt` should appear in `Reviews/`, and the Inbox item's
`CRStatus` should flip to Reviewed. Open the review and confirm it classified the contract and flagged the right
risks — including, for the test contract, the **effect-of-termination / make-whole** issue as Critical (the v1.12
check, now embedded in the prompt).

## Data boundary
Everything runs inside the Keck tenant under the existing Microsoft BAA/data-processing terms. The contract text
goes only to the tenant's own AI Builder/model. No contract text leaves; the Reviews library is the durable,
auditable record.

## After Flow 1: Flow 2 (batch P/R) reuses all of this
Flow 2 points the same review step at `Reference/Originals`, writes each review to a file, and
`capscore.ps1` / `aggregate_pr.ps1` score them against the paired human redlines in `Reference/Redlines` — the
automated path to the full-corpus number, with no manual grinding.
