# Contract Review Agent - deliverables index

Everything in this folder, grouped. Open the `.html` files in a browser; the `.md` files read best in a
markdown viewer or VS Code (they are plain text, so Notepad works too).

## Stakeholder-facing (the Nov 20 briefing)
- **stakeholder_presentation.html** - the 13-slide deck (open full-screen, arrow keys to advance).
- **stakeholder_speaker_notes.html** - the speaker script, with analogies and anticipated Q&A.

## Strategy & design (for Yesha / the group)
- **agent_evaluation_framework.html** - the polished, shareable framework page (two signals, must/nice/never
  rubric, benchmarks, model strategy). Live link: https://claude.ai/code/artifact/3882937b-3915-44b6-8e33-55dfbf61e679
- **agent_evaluation_framework.md** - the same framework in document form (more detail, red-team hardened).
- **contract_agent_aws_architecture.md** - the custom non-Copilot build on AWS/Bedrock, including the open-vs-closed
  model strategy and decision table (red-team hardened).

## Build / automation
- **flow1_intake_build.md** - click-by-click build runbook for the SharePoint intake Flow.
- **flow1_review_prompt.txt** - the review prompt that runs inside the Flow.
- **playbook_entry_effect_of_termination.md** - ready-to-paste playbook rule from Essie's feedback (v1.12).

## Reference
- **meeting_optimizations_2026-11-20.md** - the actionable optimizations from the Nov 20 stakeholder meeting.

## Where the rest lives
The agent instructions (v1.12), the precision/recall harness and results, classification profiles, and the full
history are in the repo at `github.com/farmingfarmer/ai-workflow-support` under `enterprise/`. This folder is the
curated "easy to find" subset.
