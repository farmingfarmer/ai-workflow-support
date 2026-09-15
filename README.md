# AI Workflow Support

Working repo for the AI team's workflow-support engagements, currently the
IM Residency coaching program (Dr. Kavitha Bagavathy). Used to sync
deliverables, prompts, and process docs between machines.

## Ground rule: no institutional data in this repo

Real transcripts, learner/resident data, evaluations, and any documents from
the USC tenant **never** get committed here — this is a personal GitHub
account, not a sanctioned data store. Source data lives in the residency
SharePoint (Coaching Transcripts folder). If a machine needs local working
copies, put them in a `local_data/` directory — it is gitignored, along with
common transcript filename patterns, as a backstop.

## Contents

- `kavitha_coaching/` — Session 1 deliverables for the coaching workflow:
  - `session1_facilitator_agenda.{md,html,pdf}` — Teams Facilitator agenda
    text for Session 1 (Strengths & Vision), with setup steps and the
    post-meeting transcript workflow.
  - `session1_summary_template.{md,html,pdf}` — the learner-verified session
    summary: Part A template, Part B Copilot generation prompt, Part C ground
    rules (evidence-cited, missing-means-missing, learner approves before
    filing).

## Project context

Two tracks agreed at the Sept 15, 2026 kickoff:

1. **Lightest lift (active):** Teams Facilitator with embedded agendas +
   template-driven Copilot summaries, run by the program itself. Escalation
   path if they want more automation: shared Copilot agent → Power Automate
   for transcript routing → Teams Approvals for learner sign-off. Everything
   M365-native; we build capability and documentation, not hosted tools.
2. **Later:** biannual summative evaluation consolidation (multi-source →
   committee-reviewable draft), pending Kavitha's roadmap of sources and
   target output. First real source data lands ~November 2026.
