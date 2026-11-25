# Contract Review intake - next steps checklist

*What's left to stand up the SharePoint intake Flow. Status as of Nov 25 2026.*

**Two replies gate everything below:** (1) an AI capability in Power Automate (or an Azure OpenAI endpoint),
(2) a SharePoint team site URL + permission. The request drafts are in `IT_requests_contract_agent.md`.

## Already done (no action)
- [x] All artifacts built: provisioning script, folder manifest, result schema, Flow 1 build runbook, review prompt.
- [x] Artifacts staged on the ThinkPad at `C:\Users\NE1002766\dev\contract_agent\sharepoint\`.
- [x] PnP.PowerShell 1.12.0 installed on the ThinkPad (the PS5.1-compatible version).

## A. When the SITE URL arrives (can start before the AI answer)
- [ ] **Provision the library (~5 min).** On the ThinkPad (Windows PowerShell), one interactive sign-in:
  ```
  cd C:\Users\NE1002766\dev\contract_agent\sharepoint
  powershell -ExecutionPolicy Bypass -File .\provision_sharepoint.ps1 -SiteUrl "https://keckmedicine.sharepoint.com/sites/<yoursite>"
  ```
- [ ] **If the default PnP sign-in app is blocked** (common): either get an admin to consent it, or just create the
  library + folders + columns **by hand in the SharePoint UI** (exact structure in `folder_manifest.json`).
- [ ] Confirm the folders exist: `Inbox`, `Reviews`, `Reference` (Originals/Redlines), `Scorecards`, and the
  columns Vendor / DocType / Status / ReviewLink.

## B. When the AI CAPABILITY answer arrives
- [ ] **If AI Builder is enabled:** the Flow's review step uses the "Create text with GPT" action with
  `flow1_review_prompt.txt`.
- [ ] **If instead they give an Azure OpenAI endpoint + key:** the review step is an HTTP action to that endpoint.
  **Bonus:** that same endpoint also lets you finish the full precision/recall number:
  ```
  .\run_pr_harness.ps1 -Endpoint "<chat completions url>" -ApiKey "<key>" -InstrFile .\contract_agent_paste_block.txt -From 1 -To 56
  .\aggregate_pr.ps1
  ```

## C. Build Flow 1 (needs A + B)
- [ ] Build in Power Automate per **`flow1_intake_build.md`**: trigger on a file dropped in `Inbox` -> extract the
  text -> run the review -> write it into `Reviews/` as a file -> mark the item Reviewed + link it -> optional
  Teams/email notify. (GUI build, best done screen-sharing or by whoever owns Power Platform.)
- [ ] Turn the Flow on.

## D. Test
- [ ] Drop the synthetic termination-trap contract into `Inbox`; confirm a review file lands in `Reviews/` and
  flags the effect-of-termination / make-whole issue as **Critical** (the v1.12 check).

## E. Validate before trusting it in production (red-team must-dos, do not skip)
- [ ] **Re-score the Flow's output through the evaluation framework.** The Flow uses an AI Builder/endpoint *proxy*,
  not the validated v1.12 Copilot agent, so the ~98% does **not** automatically transfer. Confirm it clears the bar
  on its own.
- [ ] **Verify the hardcoded thresholds** in `flow1_review_prompt.txt` (Net 45, CPI/3% cap, insurance baselines)
  against the authoritative Keck playbook - they were transcribed from the instruction block and will drift.

---
**Net:** site URL -> provision; AI answer -> pick the review step (and maybe unblock the full P/R run); both ->
build + test the Flow, then re-validate it. The site-URL half can start before the AI answer arrives.
