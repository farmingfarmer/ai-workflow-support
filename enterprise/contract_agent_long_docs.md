# Long-Document Handling: Strategy and v1.5

**Nov 16, 2026.** Context: Shivam has a Copilot agent built to handle long documents (a different, non-contract problem) and offered it as a reusable component. This note captures how long-document handling splits into two layers, what v1.5 ships, and where Shivam's work fits.

## The two layers

1. **Instruction layer (ours, v1.5 — shipped).** The real failure mode long contracts cause is SILENT TRUNCATION: the agent reviews the first portion of a long contract and presents it as complete. v1.5 adds rule S5 (FULL COVERAGE): review the whole document in order start-to-finish, never rely on retrieving only salient excerpts (because absence of a clause is itself a finding), outline the section structure first, confirm it reached the final section and state its coverage span, and if the document exceeds a single pass, say so and recommend splitting rather than silently sampling. This turns a hidden risk into a visible, honest coverage statement and builds on S3 (partial-document honesty).

2. **Orchestration layer (not instructions).** Contracts that genuinely exceed Copilot's single-pass token limit need map-reduce: split into sections, review each against the playbook, aggregate and dedupe. This is an agent flow / code interpreter, not prompt text - and the instruction block is already at its 8,000-char ceiling, which is itself the signal that further capability must move to this layer. This is almost certainly what Shivam built, and it is a COMPLEMENT to v1.5, not a competitor: v1.5 guarantees honesty about coverage; orchestration extends the coverage itself.

## Why not retrieval (RAG) for contracts

Retrieval-based long-doc handling surfaces only "relevant" chunks. For contract review that is actively harmful: a missing termination or insurance clause is a finding, cross-section conflicts (e.g., Net 20 body vs Net 60 exhibit) need both halves in view, and "silence is a gap, not acceptance" is core. v1.5 explicitly forbids relying on retrieved excerpts.

## Recommendation

Ship v1.5 now (done). Evaluate Shivam's orchestration when he reaches out, as the engine for oversized contracts. The exec narrative is stronger as "we hardened full-coverage guarantees AND we're integrating a reusable long-document engine from across the team" - the reusable-building-blocks story, demonstrated - than as a solo race.
