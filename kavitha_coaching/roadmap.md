# KSOM IM Residency: AI Workflow Roadmap

**Coaching Program + Clinical Competency Committee (CCC) · November 2026 through June 2027**
Prepared by the Data Science & AI team. Companion to the Nov 4 scoping discussion.

## Where things stand

| Done | In flight | Not started |
|---|---|---|
| Session 1 Summarizer agent live; in use by the program | Session 2 agent (instructions and test data drafted) | Session 3 and 4 agents |
| Facilitator meeting workflow + troubleshooting guidance | CCC data-source scoping (roadmap received) | Snapshot generator, learning plan agent |
| Licensing validated (coaches need no premium license for agents) | Compliance review of data handling (via Yesha) | Dashboard visual layer, year-end combined document |

## Guiding principles

1. **Design the output first.** Every build starts from an approved blank template.
2. **Synthetic data before real data.** Every agent passes planted-trap tests before touching program data; CCC prototyping uses de-identified samples, matching Dr. Bagavathy's own proposal.
3. **Humans decide.** Agents draft; coaches, the committee, and learners review and confirm. Nothing is auto-filed.
4. **Program-owned tooling.** Deliverables are templates, agents, and M365-native surfaces (SharePoint, Excel, Power BI) that the residency program owns and operates after handoff. No custom-built interfaces requiring long-term maintenance by the AI team.
5. **Governance before real data.** No resident evaluation data enters any AI tool until the approved data path is confirmed.

## Workstream 1: Coaching agents (Sessions 2 to 4 and the year-end document)

| Item | Detail | When |
|---|---|---|
| 1.1 Session 2 Summarizer v1 | Built from the handbook framework (check-in and goal progress, Motivation Pyramid, career exploration, six-theme table, checklist). Validate on the synthetic trap transcript, then pilot on one APD's real transcript, Dr. Bagavathy reviews, release to all APDs. | **November** (Session 2 meetings are running now) |
| 1.2 Learner pre-feedback mechanism for Session 3 | Decide how learners record reactions to their CCC input before the meeting (short template or MS Form). Small decision, needed before 1.3. | Early December |
| 1.3 Session 3 Summarizer | Merges three inputs into one record: CCC input, learner pre-feedback, meeting transcript. Blocked until the CCC input format exists (Workstream 2). | Late December, live for Dec-Jan Session 3 meetings |
| 1.4 Session 4 Summarizer | PERMA reflection, year-in-review, themes, next-year goals; also reviews June CCC input. | April, live for May-June sessions |
| 1.5 Year-end combined document | Assembly agent: four confirmed session summaries + CCC records per learner, producing the single "Learning plan and coaching document" for the year. | May-June |
| 1.6 Coach instruction sheets | Session 2-4 one-pagers mirroring the Session 1 sheet; versioning loop per agent (feedback thread, revised instructions, vN+1, rerun trap test). | Rolling, with each agent release |

## Workstream 2: CCC data consolidation

| Item | Detail | When |
|---|---|---|
| 2.1 Data access groundwork | Per source (360 evals, New Innovations faculty evals / attendance / procedures / scholarship, ITE, MKSAP, Praise/Concern cards, coaching documents): confirm owner, export format, refresh cadence; obtain a de-identified sample. **New Innovations export capability is the schedule's long pole; chase first.** | **Immediately** |
| 2.2 Resident snapshot template | One page per resident: six ACGME competencies with narrative rollups and milestone comparisons, numeric panels (ITE percentile, attendance %, MKSAP %, procedure counts, scholarship A/B progress), flags, goals and career interests from coaching. Committee approves the blank template before any build. | November |
| 2.3 Snapshot generator | Per-source extraction (narratives matched to competencies against the Milestones guidebook; below-standard flagging; milestone comparison via the KSOM master workbook) feeding template fill. Tested on a synthetic cohort with planted traps (a below-standard narrative that must be flagged, a comment matching no competency, conflicting ratings across rotations). Agent-assisted for the first cycle, not fully automated. | Prototype by early December |
| 2.4 Roster triage table | On track / Watch / Discuss per resident with CCC priority, derived from the snapshots. A generated summary table for December; a visual view later (Workstream 4). | Mid-December |

## Workstream 3: CCC meeting workflow and learning plans

| Item | Detail | When |
|---|---|---|
| 3.1 Decision capture format | Structured per-resident record of committee decisions, concerns, and recommended actions (template, or Facilitator-supported meeting plus structured recap). Agreed with Dr. Bagavathy before the December meetings; without it, nothing downstream works. | Early December |
| 3.2 Learning plan summary agent | Inputs: snapshot + recorded decisions. Output: individualized plan, committee-reviewed, with a learner-facing version aligned to the Session 3 conversation. Reuses the proven two-document pattern. | Late December / January |
| 3.3 CCC input package for learners | The subset of committee output shared with each learner ahead of Session 3, per the program's Session 3 design. Format decided with 3.1. | December |

## Workstream 4: Dashboard visual layer (after the December cycle proves the documents)

| Item | Detail | When |
|---|---|---|
| 4.1 Consolidated data table | The pipeline's structured per-resident data, maintained in the program's SharePoint/Excel. | January |
| 4.2 Cohort and individual views | Excel or Power BI (if provisioned) report owned by the program: competency snapshot with change-since-last-period, roster triage, trend views. One-time build, program-operated. | February-April |

## Workstream 5: Governance and access (gates all real-data work)

| Item | Detail | When |
|---|---|---|
| 5.1 Data-handling sign-off | One-page note (what data, which tools, where it lives, who sees it) confirmed with education-data governance / compliance. Already in motion. | **November, before any real evaluation data is processed** |
| 5.2 Access model | Committee vs. coaches vs. learners vs. staff see different slices; implemented as SharePoint structure, sharing rules, and explicit filing instructions in every agent. | November-December |
| 5.3 Agent data-scope statements | Every agent's instructions state what work data it may not consult (agents retain baseline access to the owner's work data by default). | Rolling |

## Timeline at a glance

```
NOV      Session 2 agent live · data samples + governance answer · snapshot template approved
EARLY DEC  Snapshot generator prototyped (de-identified) · decision-capture format agreed
MID-DEC    CCC meetings run with agent-drafted snapshots · decisions recorded
DEC-JAN    Learning plan agent + Session 3 agent live for Session 3 meetings
FEB-APR    Visual dashboard layer · intake automation · v2 iterations
APR-MAY    Session 4 agent · year-end combined document
JUNE       Second CCC cycle runs the full loop end to end  ←  all goals demonstrated
```

## Top risks

1. **New Innovations export access** decides whether consolidation is smooth or manual. Identify the report owner this week.
2. **Compliance sign-off timing**: if it slips past November, the December cycle falls back to de-identified or manually handled data.
3. **December compression**: snapshot template approval, samples, and prototype all land in a five-week window; the mitigation is the agent-assisted (not fully automated) first cycle.
4. **Decision capture adoption**: if the committee does not record decisions in the agreed structure during the December meetings, learning plan generation has no input. Keep the format minimal.
