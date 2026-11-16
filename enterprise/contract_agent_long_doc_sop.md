# Long-Contract Review SOP (Chunked Map-Reduce)

**When to use:** any contract long enough that a single-pass review risks truncation — practically, anything beyond ~25–30 pages, or whenever the agent's coverage statement (per rule S5) says it could not reach the end. Short contracts need only a normal one-shot review.

**Why:** reviewing a long contract section-by-section is more reliable and more deterministic than one giant pass — each section gets full attention, nothing in the tail is dropped, and the synthesize step is where cross-section conflicts actually get caught. This runs in the existing agent today; no new infrastructure.

## The three stages

### Stage 1 — MAP (one message)
> "Before reviewing, list every Article/Section heading in this agreement in order, numbered, from the first to the signature block. Do not review yet — just produce the complete structural map and tell me the total count."

Check the map ends at the signature/execution section. If it stops early, the document was truncated on upload — split the file and restart. This map is your coverage checklist for Stage 3.

### Stage 2 — SWEEP (one message per section group)
Work through the map in order, a handful of sections at a time:
> "Review Sections [N]–[M] only, against the playbook (and the SOW/Quote checklist if this is a SOW). Give findings for these sections only: key terms, playbook deviations with cites, priority, and recommended position. Note anything that will need cross-checking against other sections."

Repeat until every section in the map is covered. Keep each pass small enough that the agent clearly processes the full text (if it starts summarizing instead of quoting, the group was too big — shrink it).

### Stage 3 — SYNTHESIZE (one message)
> "Now produce the full standard review (all output sections) consolidating the section-by-section findings above. Deduplicate. Run the cross-section checks explicitly: payment-term conflicts between body and exhibits; defined terms used before definition; precedence/hierarchy conflicts; and any obligation in one section contradicted in another. Confirm your coverage span matches the Stage-1 map."

The cross-section checks are the point of this stage — a chunked review will miss a Net-20-body-vs-Net-60-exhibit conflict unless the synthesize step is told to look across chunks.

## Guardrails
- **Same conversation throughout** so the agent retains the map and section findings.
- **The map is the coverage contract.** Stage 3 must account for every mapped section; if any was never swept, say so, don't paper over it.
- **Absence is still a finding.** A section that should exist (termination, insurance, data rights) but isn't in the map is a Critical gap, not a non-event.
- **Redlines:** if the document is a negotiation draft, run the redline analysis per section in Stage 2 and roll it up in Stage 3.

## Automation path (future)
Stages 1–3 are a manual map-reduce. The same loop can be automated by a Copilot Studio **agent flow** or a code-interpreter agent that splits the document, loops the per-section review, and aggregates — removing the human from the chunking. This is the layer to evaluate with Shivam's long-document work; the SOP above is the manual equivalent that works today and documents exactly what the automation must reproduce.
