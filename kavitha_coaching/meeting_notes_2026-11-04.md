# Meeting Notes: Nov 4, 2026 — "AI agents and dashboard for KSOM IM"

**Attendees:** Dr. Bagavathy, Nancy (program coordinator, 20+ years GME), Yesha, Alex. Follow-up sync: Yesha + Alex.
**These notes supersede the matching items in roadmap.md; roadmap v2 after the timeline answer is sent.**

## Decisions made in the meeting

1. **Platform: pure Copilot + Teams/SharePoint.** Yesha proposed a "light dashboard within Teams" using built-in capabilities rather than anything fancy; everyone agreed. Not real time; refreshed every six months ahead of each CCC.
2. **Data centralization: the existing Keck residency SharePoint.** The program will create a folder (likely under the admin area restricted to APDs + coordinators) and grant Alex access to the library and the underlying Teams group. The agent works directly from that folder.
3. **Folder structure: by time frame (six-month review period), then subfolders by source type** (new innovations reports, praise/concern cards, score reports, etc.), all learners batched together inside. NOT by learner (20 to 60 learner folders was explicitly rejected as too much manual labor). Naming conventions carry the learner identity; the agent parses learners out. Principle agreed: the least manual lift for the program, simplest structure first.
4. **New Innovations stays manual.** It is a separate system with no integration; coordinators will run/export reports (per learner or batch) and drop them into the SharePoint folders on a cycle (roughly monthly or per period). Accepted as a known manual step.
5. **Premium Copilot licenses for all six program users.** Yesha is provisioning licenses for the four APDs AND coordinators Nancy and Monique (names/emails provided in meeting chat; Kavitha sending emails separately). Must be named med.usc.edu accounts, not a generic program account: HIPAA-compliant tenant, infosec reviews prompt usage, minimal-necessary data guidance. NOTE: this materially relaxes our no-knowledge-sources constraint for THIS user group, and moots the License-Required store issue for them.
6. **Milestones guidebook as agent knowledge source** for the CCC/eval agent: Kavitha explicitly wants it attached so narrative comments can be mapped to competencies ("this sounds like professionalism"). Also relevant: the program's internal 7-point scale (consolidated from 10-point) and known faculty misuse of scales (treating milestones like Likert; "5 on day five").
7. **Dashboard shape (per resident, every six months):** evals parsed by competency with numeric scores linked to narrative comments; compliance items as discrete values (didactics %, MKSAP completion, procedure/scholarship logs); plus an end-of-meeting cohort summary view ("keep an eye on these people" flags: doing well on exams but off-track on evaluations, etc.). Penn Medicine sample shown as illustration only (evals, peer ranking, completion counts, work hours).
8. **Two outputs after each CCC:** (a) accreditation-facing data (board forms), (b) learner-facing summary that feeds the Session 3 coaching discussion. Idea noted: capture CCC deliberations with a transcription tool feeding the summary.
9. **Coaching cadence clarified:** year 1 = four coaching meetings; subsequent years = only two required (synced to the two CCC cycles), rest ad hoc.
10. **Biweekly sync meetings** established (Wednesdays, next in two weeks).
11. **CCC dates: December 11-12** (two-hour meeting; presenters assigned per resident with ~1 day lead time).

## Parked / future ideas (Nancy's input)

- Peer-comparison views ("spider web" ranking vs. peers per competency) that residency management platforms provide.
- Residents' evaluations OF faculty (de-identified; compliance tracking; maybe under professionalism). No clear metrics; can't penalize non-completion; revisit after core build. ACGME requires program evaluation, not faculty evals by residents.
- Admin-task compliance tracking as its own category (no defined metrics yet).
- Complaints arriving by email/text get consolidated into learner folders today; a data source eventually.

## Immediate priorities (Kavitha's own ranking)

1. **Session 2 agent** (sessions happening right now). Note: she is happily using Summarizer v1 and never applied v2.
2. **Session 3 agent** (consumes CCC output; December).
3. December experimentation with the dashboard if feasible; we owe her a **timeline answer** after Alex/Yesha sync.
4. She and Nancy start **building the SharePoint folders and loading data now**; demo folders welcome.
5. She wants a **catchy name** for the tool and handed naming to Alex.

## Yesha follow-up sync (enterprise direction)

1. **Kayla (Schwefler)** — strong on SharePoint/hub capabilities, supported REI, available only until early December ("now or never") — to prototype the Teams/SharePoint dashboard using DS&AI's own space and data first, deployed to the program space once access lands. Story points at tomorrow's sprint. Alex to share the CCC deck and the expected final output with her. Architecture: our pipeline produces standardized, key-point-extracted data; Kayla's layer visualizes it; small SharePoint automations (she has built "if this happens trigger that" flows for REI) glue it.
2. **Hands-off delivery doctrine reaffirmed:** the program runs it themselves post-delivery; the residency work is goodwill with no direct ROI, so the VALUE is what's repeatable for others.
3. **New enterprise agent backlog (Yesha's asks):**
   - **Contract review agent** — the contract office is gone; leads now review contracts themselves. Agent to read, flag, evaluate, and pull out key terms based on the contracting team's existing ledgers/knowledge base. Must be enterprise-generalizable (Copilot or the HIPAA ChatGPT, whichever is most dependable). Essentially RAG + automatic citations with hallucination guards. Start with small/low-risk contracts; Yesha obtaining mock contracts and backend access. Alex to create backlog tickets.
   - **PowerPoint agent** (mentioned as an existing need; no spec yet).
4. **Open enterprise question (compliance-owned, not ours):** knowledge-base security layering for published agents — if an agent is published across Keck, does one user's data (my contracts vs. yours) leak to another? Separation vs. cross-learning tension. Came up in today's enterprise Copilot review; unresolved; feeds the same compliance thread as the data-access questions.

## Action items

| # | Action | Owner | When |
|---|---|---|---|
| 1 | Provision 6 premium licenses (4 APDs + Nancy + Monique) | Yesha | This week |
| 2 | Create SharePoint folder structure (by period, then source) and start loading data; grant Alex library + Teams group access | Kavitha + Nancy | Starting now |
| 3 | Build + trap-test Session 2 agent, pilot with APD transcript | Alex | This week |
| 4 | Timeline answer to Kavitha (what is feasible before Dec 11-12) | Alex + Yesha | Within days |
| 5 | Sprint: story points for Kayla (dashboard prototype); share deck + target output with her | Alex | Tomorrow |
| 6 | Sprint: backlog tickets for contract review agent | Alex | Tomorrow |
| 7 | Propose tool name options | Alex | Next sync |
| 8 | Session 3 agent design (CCC input + learner pre-feedback + transcript) | Alex | After folder/CCC format lands |
| 9 | Biweekly sync (Wednesday, two weeks) | All | Recurring |
