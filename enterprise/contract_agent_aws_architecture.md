# Custom Contract Review Agent on AWS (design, not a build yet)

**The ask (Yesha).** "If we had to take this away from Copilot into a custom build, what does that look like in AWS
(Bedrock, services, data sets)? Start thinking it through." Not build it yet - design the idea and structure for a
**more transparent, more consistent, more controllable, enterprise-wide** version that does not depend on Copilot.

**Why move off Copilot (her three drivers + the business case).**
- **Customization** - Copilot caps how far we can shape behavior, output, and integrations. A wider rollout across
  *all* contracts needs rules, formats, and routing we fully control.
- **Consistency** - it "misses 10-20% of the time," and Microsoft can change the underlying model under us without
  notice. We need a pinned model + versioned rules so the same contract reviews the same way tomorrow.
- **Control / transparency** - we want to curate the output and *show our work*: what rule fired, what was cited,
  how confident. Copilot is a black box we can't fully audit.
- **The business forcing function** - contracting must now turn a request in **under 15 days** (it used to take
  months). This agent is meant to be the **first line of defense** that makes that SLA achievable at volume. For
  that, it has to work well and provably, which is exactly where the 10-20% miss and the lack of transparency hurt.

Everything below runs in **Keck's own AWS account, in-region, under the existing BAA**; Bedrock does not train on
our inputs, so the data boundary is cleaner than the Copilot story, not worse.

---

## Target architecture (AWS Bedrock-centered)

A deterministic, logged pipeline rather than one opaque call. Each stage is inspectable and independently testable.

**1. Intake & extraction**
- Contract lands in **S3** (or via an API/upload UI, or the SharePoint drop we already scoped).
- **Amazon Textract** extracts text + layout from PDF/DOCX (tables, signature blocks, exhibits). This fixes the
  text-extraction problem we hit with Copilot and handles any file size.
- Normalize into sections/clauses; detect tracked changes for redline mode.

**2. Knowledge (the playbook + reference corpus)**
- **Bedrock Knowledge Bases** (managed RAG) over an **OpenSearch Serverless** vector store; embeddings via Bedrock
  (Titan or Cohere). Ingest the Keck Contract Negotiation Playbook, the SOW/quote checklists, the
  classification profiles, and prior reviewed contracts.
- Updating a rule = re-ingest one document; the agent picks it up immediately and cites the exact section - the
  "dynamic" property, now under our control instead of Copilot's tenant search.

**3. Reasoning pipeline (orchestrated, not a single prompt)**
- Orchestrate with **Step Functions + Lambda** (or **Bedrock Agents** for tool use). Explicit stages:
  classify -> retrieve the profile's relevant rules -> review clause by clause -> emit **structured JSON findings**
  (clause, verbatim anchor, playbook rule cited, priority, direction, owner department, **confidence**) -> compute
  key dates -> assemble the review.
- Foundation model: **Claude on Bedrock** recommended (strong at long-doc reasoning, citations, and instruction
  following; the same class we validated). Pinned version = consistency.
- The current 8,000-char instruction block becomes the system prompt + the rule base; nothing is thrown away.

**4. Guardrails & safety**
- **Bedrock Guardrails** enforce the **never-allow list** from the evaluation framework: no legal advice, no
  approval/decision, PII handling, prompt-injection defense (document text is data, not instructions), no inventing
  standards. These run on every call regardless of the prompt.

**5. Output, transparency & human-in-the-loop**
- Structured JSON + a rendered review with **clickable citations** (the linked-review prototype we already built)
  to **DynamoDB/S3** and a review UI.
- **Transparency layer:** every stage logged - retrieved rules, model reasoning, citations, per-finding
  confidence - so a reviewer (or an auditor) can see exactly why each flag fired. This is the "control and
  transparency" Yesha wants, and it is impossible to get from Copilot.
- A human reviewer confirms; their edits feed back into the rule base and the eval test set (the learning loop).

**6. Evaluation baked in (not bolted on)**
- The **Agent Evaluation Framework** (`agent_evaluation_framework.md`) runs as a CI-style gate: every rule or model
  change is scored (precision/recall vs the redline gold + the must/nice/never rubric) **before** it is promoted.
  Nothing ships that drops the number. This is the observability+evaluation stack Yesha wants, native to the system.

---

## How each piece answers the "why leave Copilot" drivers

| Driver | Copilot today | AWS build |
|---|---|---|
| Transparency | Black box, no reasoning trace | Every stage logged, every finding cited + confidence-scored |
| Consistency | Model can change under us; ~10-20% miss | Pinned model + versioned rules; deterministic orchestration; eval gate catches regressions |
| Customization | Capped | Any rule, format, routing, integration, department logic |
| Control / curation | Limited | We shape output exactly; Guardrails enforce the never-allow list |
| Closing the 10-20% gap | Hard to diagnose | Dedicated retrieval, clause-by-clause coverage, continuous eval surfacing misses |

---

## Migration path (low-risk, reuses everything)
1. **Copilot POC (done)** - validated the logic and the number (16 real contracts, ~98% recall, v1.12). This
   de-risks the AWS build: we already know the behavior we are reproducing.
2. **AWS prototype** - stand up the pipeline above on a handful of contract types; prove parity with the Copilot
   agent using the eval framework as the acceptance test.
3. **Pilot with Contracting** - Clint/Ellie run real work through it; measure against the 15-day SLA.
4. **Production first-line-of-defense** - roll across contract types, with the eval scorecard as the standing
   confidence metric for leadership.

Reused as-is: the playbook, the instruction/rule logic, the classification profiles, the clickable-citation UI, the
precision/recall harness, and the evaluation framework. The AWS build is a re-platforming for control, not a
restart.

## Rough shape of effort (for sizing the conversation, not a commitment)
- Prototype (intake + KB + single-pass review + structured output + basic eval): a few weeks.
- Guardrails, transparency UI, redline mode, full eval gate: the following phase.
- The expensive parts are data/rule curation and the eval test set - both of which the Copilot POC already started.

## Open questions to settle with Yesha / infra
- Which AWS account/region and BAA scope for contract data; who owns the Bedrock enablement.
- Model choice and whether to pin one or allow a small panel.
- Vector store sizing and how the playbook/rule base is governed and versioned.
- Where the review UI lives and how reviewers give structured feedback into the learning loop.
