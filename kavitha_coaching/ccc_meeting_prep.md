# Meeting Brief: "AI agents and dashboard for KSOM IM" (3 PM, Nov 4, 2026)

**For:** Alexander. All three attachments have now been reviewed in full (handbook docx, CCC contents docx, 20-slide deck). Everything below is confirmed from her documents unless marked otherwise.

## Her vision in one paragraph

Two linked projects. **Project A (CCC dashboard):** drop raw evaluation data in, get a per-resident and cohort dashboard for Clinical Competency Committee review, record committee decisions, and generate an individualized learning plan summary per resident, with data entered once and flowing through every step. **Project B (coaching program):** the four-session coaching arc, where Session 1 is done ("Thank you for the agent," in her own slide), Session 2 is running now, and Sessions 3 and 4 explicitly consume CCC output. The two merge in a single year-long "Learning plan and coaching document" per resident.

## Her stated goal for TODAY'S meeting (slide 13)

"Agree on the scope and the first questions for the IT team." Her proposed sequence: **Refine** (views with the CCC) → **Assess** (IT reviews data sources, access, platform options) → **Prototype** (sample, de-identified data) → **Pilot** (run in a live CCC meeting). Hard date: **CCC meetings mid-December.**

## The data sources (from "Dashboard contents for CCC")

| Source | Lives in | Dashboard output |
|---|---|---|
| 360 evaluations | Excel from MS Forms | Narrative comments by competency; flag below-standard (vs. Milestones guidebook) |
| Didactics attendance | New Innovations | % attendance, 75% expected |
| Faculty evaluations | New Innovations summary report | Narratives + milestone ratings by rotation (vs. KSOM IM master workbook) |
| In-training exam | Individual ITE reports | Percentile by PGY year |
| MKSAP completion | Completion reports | % by assignment |
| Procedure logs | New Innovations | Counts per procedure |
| Scholarship logs | New Innovations | Category A/B progress vs. graduation requirement (1A+1B or 2A) |
| Goals and career interests | **Coach meeting documents** + fellowship planning Excel | Goals, interests, mentorship |
| Praise or Concern | Cards, PDF | Narratives, highlighted |
| Prior CCC data | (future iterations) | Decision history |

Two reference "knowledge sources" for mapping narratives to levels: the **Milestones guidebook** and the **KSOM IM master workbook**. Her slide notes: committee confirms which sources; **IT confirms format and owner of each**.

Dashboard views seen in the deck: an illustrative **resident snapshot** across the six ACGME competencies with change-since-last-period deltas; a **resident roster** view (Milestones / ITE / Evaluations / Flags → On track / Watch / Discuss, with CCC priority) to triage who needs discussion time.

## Session 3 redesign (slide 17) — the alignment made concrete

After each CCC (mid-Dec and mid-June): CCC input goes to the learner → **learner reads it and records their own feedback before the coaching meeting** (what resonates, what surprises, what they'd add) → coach and learner discuss it (one goal of the meeting, alongside goals/strengths) → **minutes + CCC input + learner feedback combine into one document.** "The learner sees what the CCC saw, has a voice in it, and leaves with one written record." Note how precisely this mirrors the Session 1 summary pattern we built: evidence in, learner voice, one confirmed record.

## Our positions to bring (aligned with Yesha's constraints)

1. **Say yes to the shape, place the pieces carefully.** Three components hide inside "dashboard": (a) **data consolidation** per resident, (b) **visual dashboard views**, (c) **learning plan generation**. Component (c) is squarely our proven agent pattern (CCC decisions + consolidated data → drafted plan → committee review → learner-facing version); component (a) is structured extraction we also know how to do; component (b) is where the no-maintained-UI rule bites — steer to Excel or Power BI owned by the program, fed by the consolidated data, not a custom app. Script: "snapshot document first, visual layer on top of it, owned where your data already lives."
2. **De-identified prototype is already her plan** (slide 13) — endorse loudly; it matches our synthetic-data standard and the compliance climate. Related: Yesha is fielding Compliance/Legal questions this week about Keck data and vendors; before evaluation data touches any tool, confirm the approved path. Evaluation data is quasi-personnel data; say the governance check protects her.
3. **December scope proposal:** for the mid-December CCC, a realistic target is the **per-resident snapshot document** drafted by agent from whatever exports she can produce this month, reviewed by the committee, plus a **learning-plan summary agent** fed by the committee's recorded decisions. Interactive dashboards and automated New Innovations feeds are the spring iteration. This gives her December value without promising integration work nobody has scoped.
4. **First questions for the IT team** (her ask; we can hand her the list):
   - Per source: who owns the export, what format, how often refreshed, can a de-identified sample be produced this month?
   - New Innovations: are scheduled report exports available, or manual download only?
   - Where will the consolidated per-resident files live (the KSOM SharePoint, like the coaching folders)?
   - Who may see what: committee vs. coaches vs. learners vs. program staff (access model matters more here than anywhere so far).
   - Does Keck provision Power BI, and who would own a workspace if so?

## Coaching-track items for the same meeting

- **Session 2 agent: we come bearing a draft.** The handbook contains the full Session 2 framework (check-in + SMART progress review, Motivation Pyramid exercise with the coach-first/advise-if-stuck guidance, career exploration, themes: Assets, Joy, Pride, Purpose, Career Alignment, Intrinsic Motivation, and the six-item checklist). v1 instructions and a synthetic trap transcript are drafted (see repo). Her pilot plan stands: one APD already runs Session 2 meetings; run a real transcript, she reviews, then release.
- **Session 3 agent** becomes a bigger, well-defined build thanks to slide 17: it merges three inputs (CCC input, learner pre-feedback, meeting transcript) into the combined record. Needs the CCC input format first, which depends on Project A. Sequence honestly: Session 2 now, Session 3 after the December CCC format exists.
- The **combined year-end document** (slide 18: one learning plan and coaching document for the year, sessions 1 through 4 stacked with CCC inputs) is the eventual deliverable both projects feed. Worth naming in the meeting as the north star, and it is precisely the "running coaching journey" she described in September.

## Honesty notes

- Slides 19 to 20 (closing/asks) were not fully read; let her present them.
- The "Penn Medicine sample for CCC" referenced in her follow-up email: the pptx arrived attached to that email, but it reads as her own draft ("Data we would like..."). Ask whether a separate Penn sample exists and should be resent.
