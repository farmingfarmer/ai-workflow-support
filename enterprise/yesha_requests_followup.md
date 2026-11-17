# Yesha Sync — Requests & Status (Nov 17, 2026)

Every ask from the sync, what was done, and the honest engineering notes.

## 1. Clickable citations that jump to the exact location — PROTOTYPED

**Ask:** click a citation and jump to that exact point in the contract under review, or in the Playbook/SOP/checklist that drives the policy — "go right to that sentence, highlight it," not just open the document.

**Honest engineering reality:** the raw Copilot chat cannot natively deep-link to an exact sentence in an uploaded document — its reference footnotes open the source, not a precise location. True click-to-jump lives in a **rendering layer** on top of the agent's findings, not in the agent instructions.

**Delivered:** `linked_review_prototype.html` — a working prototype of that layer. Findings on the left; the contract and the Playbook/SOPs on the right as tabs. Every citation is a chip: **blue chips jump to and highlight the exact contract clause; gold chips jump to the exact Playbook/SOW-checklist/SOP rule.** This is precisely the "jump to the sentence and highlight it" behavior, demonstrated on the synthetic SOW. Productionizing it is a small build: take the agent's cited output + the uploaded contract, render this view automatically.

## 2. Before/after with real contracts — DELIVERED

**Ask:** run an original contract through the agent, then compare the output to the actual redline, to see how well it matches.

**Delivered:** `before_after_redline_trinetx.html` — uses the real **TriNetX USC Health DSA** vendor redline. Side by side: the original USC clause vs. what the vendor changed, with the agent's finding under each. The vendor used two weakening patterns the agent is built to catch — inserting "commercially reasonable" qualifiers, and deleting whole protections (PCI compliance, indemnification, the liability carve-out) as "Intentionally Omitted." The agent independently flags every one with direction and playbook tie. A clean demonstration that the agent's findings match what a human redliner did.

## 3. "No premium license" bolded + Word caveat — DONE
Overview updated: the no-premium-license point is now bold and called out, with the second caveat — if someone opens a Word doc and asks Copilot to review it, that is general Copilot, **not** this agent; the review must run in a chat with the agent.

## 4. Model transparency — DOCUMENTED, needs Microsoft confirmation
Added to the overview: the model is managed/obscured by Microsoft; generally understood to be a GPT-4-class model via the Microsoft/OpenAI stack, but **not confirmed by Microsoft and subject to change**. Action: Yesha + Brian to raise with Microsoft/CloudFlare contact; we keep a dated record, since a model change can change behavior. This is a real governance item for enterprise-wide rollout.

## 5. Output length / wordiness — OPEN DECISION
Yesha (as devil's advocate for adoption) is concerned the output is long; Alex noted users may want section-by-section depth and that it's all cited and searchable. Open question for the first reviewers. Options when we decide: a **concise mode** (top risks + one-line-per-deviation, details on request), de-duplicating Top Risks against the section detail, or a toggle. Not changed yet — best decided with the pilot reviewer, not guessed.

## 6. Word-document comments idea — PARKED
Yesha floated having the agent write comments directly into the Word doc (like a redline). Technically possible via a separate flow but duplicates the review and adds a maintenance surface. Parked; the linked-review prototype (#1) arguably delivers the same "see the note next to the clause" value without editing the source document.

## 7. Enterprise-wide rollout & first reviewer — NEXT
The CFO framing is enterprise-wide, not IT-only. Next step Yesha owns: pick the first/best reviewer to poke at it (she has candidates in mind, holding for now). Jason to make a one-pager. Our side: keep curating; the agent is a proof of concept that meets+exceeds the asks.

## Quick reference: what to open in the meeting
- **`linked_review_prototype.html`** — the clickable-citations answer (open it, click a finding's chips).
- **`before_after_redline_trinetx.html`** — the before/after with a real contract.
- **`contract_agent_overview_for_yesha.html/.pdf`** — the updated meets/exceeds overview (now with the license + model notes).
- **`demo_test_inputs.html`** — copy-paste console for live runs.
