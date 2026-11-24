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
our inputs. To be precise: this is **not a cleaner compliance boundary than Copilot** (M365 is also BAA-covered) -
the win is **control and auditability** of where the data goes and what happens to it, which is the point. One
honest tradeoff to name up front: we trade Microsoft lock-in for AWS lock-in. The surrounding managed services
(Bedrock Knowledge Bases, OpenSearch, Textract, Guardrails) are AWS-proprietary; only the model *weights* are
portable (and only if we go open-weight). We are buying control, not provider independence.

---

## Target architecture (AWS Bedrock-centered)

A deterministic, logged pipeline rather than one opaque call. Each stage is inspectable and independently testable.

**1. Intake & extraction**
- Contract lands in **S3** (or via an API/upload UI, or the SharePoint drop we already scoped).
- **Extraction by file type, not one tool for everything.** For clean digital DOCX/PDF (the common case), use
  **direct extraction** (python-docx, pdfplumber) because it preserves clause structure, numbering, and defined
  terms, and can read **tracked changes** for redline mode. Reserve **Amazon Textract** for *scanned/image* PDFs
  (its OCR/layout strength), noting it flattens structure and cannot see tracked changes, and has page/size limits
  on large docs. (Earlier drafts overstated Textract as a universal fix - it is not.)
- Normalize into sections/clauses.

**2. Knowledge (the playbook + reference corpus)**
- **Default to deterministic rule injection, not fuzzy retrieval.** The playbook is a *bounded rulebook*, not a huge
  corpus. Classify the contract (type + domain), then load that profile's **full relevant rule set** via the
  classification -> profile -> rules mapping we already built, and put it in context. This avoids the real risk that
  semantic top-k retrieval silently *drops* a relevant rule - which would re-introduce the exact "misses 10-20%"
  problem at the retrieval layer, before the model even reasons.
- **Use RAG (Bedrock Knowledge Bases over OpenSearch Serverless; embeddings via Titan or Cohere) only for the long
  tail** that does not fit deterministically: prior reviewed contracts, precedent, and any corpus too large for
  context. RAG supplements the rulebook; it does not replace rule selection.
- Updating a rule = edit the rule base; the agent picks it up on the next run and cites the exact section - the
  "dynamic" property, now under our control instead of Copilot's tenant search.

**3. Reasoning pipeline (orchestrated, not a single prompt)**
- Orchestrate with **deterministic Step Functions + Lambda** stages: classify -> load the profile's rules -> review
  clause by clause -> emit **structured JSON findings** (clause, verbatim anchor, playbook rule cited, priority,
  direction, owner department, **confidence**) -> compute key dates -> assemble the review. *Prefer this over
  Bedrock Agents:* an agent framework that plans its own steps re-introduces the agentic opacity we are leaving
  Copilot to escape. Determinism here is a feature, not a limitation.
- Foundation model: **Claude on Bedrock** recommended (strong at long-doc reasoning, citations, and instruction
  following; the same class we validated).
- **On "consistency," be precise:** pinning a model version + versioned rules gets us *consistent enough*, not
  bit-identical - LLMs are stochastic, and even at temperature 0 there is some non-determinism. The honest promise
  is "the same contract reviews *equivalently* tomorrow, and we *measure* that via the consistency benchmark," not
  "the same words every time."
- The current 8,000-char instruction block becomes the system prompt + the rule base; nothing is thrown away.

**4. Guardrails & safety (a layer, not the whole enforcement)**
- **Bedrock Guardrails** reliably handle content filtering, PII, denied topics, and some prompt-injection detection.
  They do **not**, on their own, enforce the *semantic* never-allow behaviors (no legal advice, never approve, do not
  invent a standard). Those need **prompt design + structured-output validation + the eval red-line gate** working
  together. So treat the never-allow list as enforced by the *combination*, with Guardrails as one layer - not by
  Guardrails alone (an earlier draft overstated this).

**5. Output, transparency & human-in-the-loop**
- Structured JSON + a rendered review with **clickable citations** (the linked-review prototype we already built)
  to **DynamoDB/S3** and a review UI.
- **Transparency layer:** every stage logged - retrieved rules, model reasoning, citations, per-finding
  confidence - so a reviewer (or an auditor) can see exactly why each flag fired. This is the "control and
  transparency" Yesha wants, and it is impossible to get from Copilot.
- A human reviewer confirms; their edits feed back into the rule base and new training examples (the learning loop).
  **Keep the evaluation test set held out** from this loop - if reviewer feedback flows into both the rules and the
  eval set, we end up grading on what we trained on and the confidence number becomes fiction.

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

**The fine-tune play - real, but size the data honestly.** We already have the human **redlines** (gold answers),
the **precision/recall harness**, and **16 scored contracts**. Be clear about what that is and is not: it is a
strong **evaluation set** and good **few-shot** material today - it is **not** a fine-tuning corpus. Fine-tuning an
LLM for a task this nuanced needs on the order of **hundreds to low-thousands** of high-quality labeled examples, so
**building that corpus is itself a project, and the expensive part** (curating reviewed contracts with correct
findings and citations). The payoff is real once it exists: a mid-size open model fine-tuned on our own
contracts/playbook can match or beat a bigger general model *on our distribution*, at a fraction of the cost. So the
sequence is: use the 16 for eval and few-shot now, grow a labeled corpus from the human-in-the-loop reviews over
time, and fine-tune when there is enough to clear the eval bar.

### Decision table (tier x model x cost x when to use)

| Tier / role | Candidate models | Rel. cost | When to use |
|---|---|---|---|
| **Triage / classify** (contract type, thin-quote defer-to-MSA) | Claude Haiku 4.5; Amazon Nova Micro/Lite; small fine-tuned Llama/Qwen | Lowest | High volume, low-judgment steps; cheap and fast gatekeeping |
| **Standard review** (the bulk of contracts) | Fine-tuned open model (Llama 4 / Mistral Large / Qwen) OR Claude Sonnet 5 / Nova Pro | Low-Med | Where cost and volume dominate; the first place to deploy a fine-tuned open model and let eval prove it clears the bar |
| **Hard / high-value / redline-heavy** | Claude Opus 5 (or Sonnet 5) | Highest | The complex 10-20% where a miss is expensive; keep a frontier model here until a fine-tuned open model proves it can take it |
| **LLM judge** (for the eval gate) | A DIFFERENT family than the reviewer (Nova or Llama if reviewer is Claude; 2-3 votes on red lines) | Low | Scoring outputs without self-grading bias |
| **Embeddings / RAG grounding** | Amazon Titan Embeddings or Cohere Embed; Cohere Command R+ for citation-heavy grounding | Lowest | The playbook knowledge base and "cite the exact rule" step |

*Treat the specific model names as "a model of this class," and **verify the live Bedrock catalog** before quoting
any of them to leadership - exact Claude/Nova version names move, and some open models (e.g. Qwen, DeepSeek) may be
SageMaker/self-host rather than Bedrock-native in our region.*

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
1. **Copilot POC (done)** - validated the logic and a directional number (16 real contracts, ~98% on the automated
   scorer, pending Contracting co-sign; v1.12). This de-risks the AWS build: we already know the behavior we are
   reproducing, and we have the eval harness to prove parity.
2. **AWS prototype** - stand up the pipeline above on a handful of contract types; prove parity with the Copilot
   agent using the eval framework as the acceptance test.
3. **Pilot with Contracting** - Clint/Ellie run real work through it; measure against the 15-day SLA.
4. **Production first-line-of-defense** - roll across contract types, with the eval scorecard as the standing
   confidence metric for leadership.

Reused as-is: the playbook, the instruction/rule logic, the classification profiles, the clickable-citation UI, the
precision/recall harness, and the evaluation framework. The AWS build is a re-platforming for control, not a
restart.

## Rough shape of effort (for sizing the conversation, not a commitment)
These are order-of-magnitude, deliberately conservative - the integration and especially the data work usually run
longer than the happy-path estimate.
- A thin prototype (direct extraction + deterministic rule injection + single-pass review + structured output +
  basic eval) on one or two contract types: on the order of a few weeks of focused work, *assuming* Bedrock access,
  roles, and a landing account are already sorted (they are not free - see open questions).
- Guardrails, transparency UI, redline mode, the full eval gate, and hardening: a following phase of comparable or
  greater size.
- **The expensive, time-dominant parts are data/rule curation, building the fine-tuning corpus, and the held-out
  eval set** - the POC started the rule logic and eval harness, but the labeled training corpus is largely still to
  be built.

## Open questions to settle with Yesha / infra
- Which AWS account/region and BAA scope for contract data; who owns the Bedrock enablement.
- Model choice and whether to pin one or allow a small panel.
- Vector store sizing and how the playbook/rule base is governed and versioned.
- Where the review UI lives and how reviewers give structured feedback into the learning loop.
