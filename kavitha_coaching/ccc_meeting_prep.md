# Meeting Prep: Kavitha's Two-Project Vision (Coaching + CCC)

**For:** Alexander, ahead of the Wednesday (Nov 4, 2026) meeting with Dr. Bagavathy
**Basis:** her Nov 2 emails, the project history, and partial reads of the open CCC deck. Full attachment review was interrupted; claims below are marked confirmed vs. inferred.

## What she sent (Nov 2)

1. **KSOM Internal Medicine Residency Coaching Program.docx** (not yet reviewed)
2. **"Dashboard contents for CCC"** (a link in the email body, likely SharePoint; not yet reviewed)
3. **CCC dashboard development.pptx** (20 slides, marked "Draft for discussion") on the follow-up email that says "Sorry meant to attach this sample from Penn medicine as well (for CCC)" — so this deck either IS the Penn Medicine sample or is her draft modeled on it. **Confirm in the meeting which it is**, and if the Penn sample is still missing, ask her to resend.

Her framing: these documents share her vision for the two projects, **Coaching meetings and CCC (Clinical Competency Committee)**, "and how they align."

## What the deck fragments reveal (partial, from on-screen reads)

- Title concept: **"From raw data to a CCC dashboard."**
- A slide titled **"Data we would like the dashboard to consolidate."**
- An **"Illustrative Resident snapshot"** organized by the **six ACGME core competencies** (Patient Care, Medical Knowledge, Professionalism, Interpersonal & Communication Skills, Systems-Based Practice visible; Practice-Based Learning presumably the sixth).
- A workflow phrase: **"committee review and generating individualized learning plan summaries"** and **"Discuss, decide, generate learning plan."**

Inference (consistent with everything since May): the CCC project is the **biannual summative evaluation track finally activating**. Pipeline shape: multi-source raw data (faculty/nurse/peer/patient evaluations, scores, possibly coaching outputs) → consolidated per-resident snapshot across the six competencies → CCC meets, discusses, decides → individualized learning plan summary generated per resident → reported to ACGME. First real cycle: **December 2026**, so this is time-sensitive.

## How the two projects align (her stated question)

The alignment is already in her own prior words: **Session 3 of coaching (Jan–Feb) includes "discussion of learner evaluations and decisions from the competency committee."** So:

- The coaching track **produces** structured, learner-confirmed goals each session.
- The CCC track **consumes** multi-source evaluations and produces decisions and learning plans.
- CCC outputs become **inputs to coaching Session 3**, where the coach walks the learner through the committee's findings; and coaching goals plausibly feed the CCC's picture of each resident.
- Both tracks share the same architecture we've already proven: multi-source data → structured per-resident document → human committee/coach review → learner-facing version. The coaching agents are the small-scale rehearsal of the CCC machine.

This is the story to tell in the meeting: one pipeline, two products, and the work done since September de-risks the bigger one.

## Strategic tensions to navigate carefully

1. **"Dashboard" vs. the no-maintenance rule.** Yesha's standing constraint: no UI the AI team must own long-term. A true dashboard implies one. Steer toward: (a) the **per-resident snapshot document** as the core deliverable (an agent can draft it; the CCC reviews it; this is 80% of the value), and (b) if visual dashboards are genuinely needed, M365-native surfaces owned by the program (SharePoint lists, Excel, or Power BI if Keck provisions it) rather than anything custom-built. Frame it as "snapshot first, dashboard later if the snapshot isn't enough."
2. **Compliance and legal are actively in play.** Yesha is this week fielding Compliance/Legal concerns about sharing proprietary Keck knowledge with vendors. Resident evaluation data is far more sensitive than coaching transcripts: it is quasi-personnel data feeding accreditation decisions. Whatever is proposed must stay inside the tenant, follow the baseline-access discovery (agents can see the owner's work data by default), and probably deserves an explicit check with whoever owns education-data governance **before** a pilot. Do not promise tooling before that clears.
3. **Data intake is the hard part, again.** Same as the coaching transcripts: where do the evaluations live, in what format, and who routes them? Her September plan was that source data accrues weekly with a November check on completion. Ask for the current state and an export sample (synthetic or redacted first, per our standard practice).

## Suggested meeting agenda / questions

1. Let her walk the deck (it is her vision; she enjoys presenting it).
2. Confirm: is the pptx the Penn Medicine sample or her draft? Get the missing sample resent if real.
3. The alignment story above: validate that CCC outputs feed Session 3.
4. Scope the snapshot: which data sources, which competencies map to which sources, what does one resident's page look like (she has a "mental map" from her LA General fellowship; get it on paper, per playbook step 2: design the output before anything else).
5. December reality check: what must exist for the December CCC cycle vs. what is the nice-to-have dashboard later? Propose: December = manually assisted pilot with agent-drafted snapshots for a few residents; spring = scaled version.
6. Raise data governance gently: "before we feed evaluation data to any tool, we will confirm the approved path with compliance; this protects you." (Aligns with Yesha, protects everyone.)
7. Status items on the coaching track: how is the Session 1 agent performing with APDs; does she have the Session 2 template + motivation pyramid docs ready for us (still outstanding).

## Status honesty for the meeting

Full review of the three attachments was not completed before this brief was written (ThinkPad session paused). If the meeting happens before a full read, say so plainly: "we've been through your emails and the deck's direction, and we'll do a line-by-line pass on the documents right after this conversation." Do not claim detailed knowledge of the docx or the dashboard-contents link.
