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

## Model strategy: open vs. closed, and the fine-tune play

**Principle: model-agnostic + tiered + eval-decided.** Build behind one API so models are swappable, route by task
complexity to control cost, and let the Agent Evaluation Framework pick winners by the number, not by vibes.
Bedrock runs every model below in-account, HIPAA-eligible under the BAA, with no training on our inputs, so the
choice is about capability and cost, not compliance.

**"Reliability" cuts two ways.** Open-weight models win decisively on reliability-as-*control/consistency*: we own
the exact weights, so the model never changes under us (the opposite of the Copilot problem, and a direct hit on
Yesha's consistency driver). But reliability-as-*accuracy* on the hardest 10-20% (the "commercially reasonable"
trap, effect-of-termination tricks, and above all NOT hallucinating a number) is a verify-it claim, not a
trust-it claim - frontier closed models still tend to lead there. So we prove it on-task with the eval framework
rather than assuming parity.

**The fine-tune play - our unfair advantage.** We already have the human **redlines** (gold answers), the
**precision/recall harness**, and **16 scored contracts**. That is a training *and* evaluation dataset most teams
lack. A mid-size open model fine-tuned on our contracts/playbook/past reviews can match or beat a bigger general
model *on our distribution*, at a fraction of the cost - giving us consistency + cost savings + task-specialized
accuracy at once. This is the strongest open-source argument for us specifically.

### Decision table (tier x model x cost x when to use)

| Tier / role | Candidate models | Rel. cost | When to use |
|---|---|---|---|
| **Triage / classify** (contract type, thin-quote defer-to-MSA) | Claude Haiku 4.5; Amazon Nova Micro/Lite; small fine-tuned Llama/Qwen | Lowest | High volume, low-judgment steps; cheap and fast gatekeeping |
| **Standard review** (the bulk of contracts) | Fine-tuned open model (Llama 4 / Mistral Large / Qwen) OR Claude Sonnet 5 / Nova Pro | Low-Med | Where cost and volume dominate; the first place to deploy a fine-tuned open model and let eval prove it clears the bar |
| **Hard / high-value / redline-heavy** | Claude Opus 5 (or Sonnet 5) | Highest | The complex 10-20% where a miss is expensive; keep a frontier model here until a fine-tuned open model proves it can take it |
| **LLM judge** (for the eval gate) | A DIFFERENT family than the reviewer (Nova or Llama if reviewer is Claude; 2-3 votes on red lines) | Low | Scoring outputs without self-grading bias |
| **Embeddings / RAG grounding** | Amazon Titan Embeddings or Cohere Embed; Cohere Command R+ for citation-heavy grounding | Lowest | The playbook knowledge base and "cite the exact rule" step |

### Open-source: honest wins and caveats
- **Wins:** perfect version-pinning (never drifts); lower cost at volume (compute, not frontier margins);
  fine-tunable on our gold data; full data sovereignty (weights + data in-account, no external API); no
  deprecation or lock-in.
- **Caveats:** verify accuracy on the hard tier before trusting it; watch hallucination/citation discipline
  (mitigated by RAG + Bedrock Guardrails + the eval gate, but test it since it is our red line); more engineering
  (fine-tuning, serving, maintenance). Bedrock serverless open-weight removes the GPU-babysitting; SageMaker/EKS
  self-hosting gives maximum control but we own uptime and scaling.

### Recommended path
Start hybrid: a frontier model (Claude Sonnet 5 default, Opus 5 for hard ones) to establish the quality bar and
de-risk, while in parallel **fine-tuning a mid-size open model on our gold data** and running the bake-off through
the eval framework. Promote the open model into the standard-review tier the moment it clears the P/R + rubric bar
at a better cost, and keep pushing it up the tiers. Pin all versions for consistency; swap only when the number
improves. The eval framework is the referee for the whole thing.

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
