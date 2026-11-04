# Backlog Tickets: Contract Review Agent + KSOM Dashboard (Kayla)

Draft tickets for the Nov 5 sprint, per Yesha's Nov 4 asks. Copy into the board and adjust points to team scale.

## Epic: Contract Review Agent (enterprise)

**Why:** The contract office is gone; department leads now review contracts themselves. An agent that reads a contract, flags risk items, and pulls key terms with citations saves every lead hours per contract. Must generalize across the enterprise (Copilot or the HIPAA-compliant ChatGPT, whichever proves most dependable). Pattern: retrieval over the contracting team's ledgers/knowledge base + extraction with automatic citations and hallucination guards. Start with small, low-risk contracts.

| # | Ticket | Notes | Pts (suggest) |
|---|---|---|---|
| C1 | Inputs inventory: obtain mock contracts + contracting-team ledgers/knowledge base from Yesha; catalog contract types, lengths, formats | Blocked on Yesha's access; defines everything downstream | 2 |
| C2 | Output design: one-page "contract review summary" template approved by 1-2 actual leads (key terms table, obligations, dates/renewals, risk flags, citations to page/clause) | Playbook step 2: output before agent | 3 |
| C3 | Platform spike: Copilot agent vs. HIPAA ChatGPT for long-document handling (context limits, file upload, citation fidelity) on one mock contract | Decision memo, half day each | 3 |
| C4 | v1 instructions: evidence rules adapted to contracts (cite clause/page for every claim; "Not present in this contract" for missing standard terms; never paraphrase defined terms) | Reuses our instruction pattern | 3 |
| C5 | Synthetic trap contract: planted traps (a missing standard clause that must be reported absent; an unusual indemnity that must be flagged; a defined term that must survive verbatim) + pass/fail checklist | Reuses trap-testing pattern | 2 |
| C6 | Pilot with one lead on 2-3 real small contracts; feedback loop to v2 | After C1-C5 | 3 |
| C7 | Knowledge-base security question: document the published-agent data-separation issue (whose contracts does a shared agent see) and hand to compliance/infosec with specific scenarios | Yesha's open question; not ours to answer, ours to frame | 2 |

## Story: KSOM CCC Dashboard prototype (Kayla, time-boxed to early December)

**Why:** The residency program needs a per-resident, six-monthly dashboard in Teams/SharePoint, maintained by the program after handoff. Kayla prototypes the visual layer in the DS&AI space with sample data while program SharePoint access is provisioned; our pipeline supplies standardized extracted data.

| # | Ticket | Notes | Pts (suggest) |
|---|---|---|---|
| K1 | Handoff package to Kayla: CCC deck, data source table, expected final output description, synthetic sample data | Alex, immediately | 1 |
| K2 | Prototype: per-resident view in SharePoint/Teams (competency panels, discrete metrics, flags) from a standardized data file | Kayla; DS&AI space | 5 |
| K3 | Cohort roster view (On track / Watch / Discuss + CCC priority) | Kayla | 3 |
| K4 | Refresh mechanic: simplest repeatable update path for a six-monthly cycle (file drop triggers or manual refresh; no real-time anything) | Kayla, using her REI automation patterns | 2 |
| K5 | Deploy plan: port prototype to the Keck residency SharePoint once access lands; document handoff so coordinators own updates | Kayla + Alex | 2 |

## PowerPoint agent (placeholder)

Named by Yesha as an existing need; no spec yet. Single discovery ticket: collect 2-3 concrete use cases and an output example from the people who asked; decide if it is an agent or a saved prompt. (1 pt)
