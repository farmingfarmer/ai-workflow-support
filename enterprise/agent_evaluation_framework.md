# Agent Evaluation Framework (v0 for group review)

**Purpose.** Give leadership a *concrete confidence number* for any Copilot/GPT agent we build, not "a user liked
it." Yesha's point: we have a mature evaluation method for predictive models and summaries, but nothing for these
agents, and "it's good because someone liked it" is too many opinions to steer by. This is a semi-standardized,
repeatable way to score an agent's quality, generalized from what we already proved on the Contract Review Agent.

This is deliberately a **v0 to bring to the group**, get feedback, and iterate. Not pushing to prod. Target: a
working prototype of the process within the next month, starting with 3-5 benchmarks.

---

## The core idea: two scoring signals, used together

The Contract Review Agent was "an anomaly" in a useful way: we had the human **redline** as a perfect
best-end-state to compare against, which gave us precision/recall. Most agents won't have that. So the framework
uses **two complementary signals**, and you use whichever you have (ideally both):

### Signal A — Golden-reference comparison (when a "best end-state" artifact exists)
Compare the agent's output to the business's own gold standard for that task.
- **Contract agent:** the human redline = what they negotiated to. Metric = recall (did the agent catch the
  issues the humans changed) + "caught valid issues they missed."
- **Dr. Vogue-type agents:** the wealth of existing documentation she started with is the gold standard for what a
  good summary/output should contain.
- **How to source these:** for every agent, ask the business owner up front, "what does a perfect finished product
  for this task look like, and do you have examples of it?" Collect as many as exist. These become the answer key.
- **Metric:** coverage/recall against the gold, plus a "missed-nothing-critical" check.
- **Honest limit (important):** the gold is a *reference human baseline, not an oracle of correctness.* We have
  already seen the agent catch things the humans missed, which means the redline is imperfect. So raw "match the
  human" can both penalize the agent for being better and reward it for copying a human mistake. Score it as
  **met-or-exceeded** (did it catch what the human caught, and what did it add that is valid), and have the owner
  confirm the change-lists before any number is published, rather than treating the baseline as ground truth.

### Signal B — Rubric-based LLM-judge scoring (always applicable, even with no gold)
A per-agent rubric in three tiers, scored by an LLM judge against each output. This is your framing exactly:
- **MUST-HAVES** (required; missing any = fail): the non-negotiable elements the output must contain or do. For the
  contract agent: classify the contract, cite every finding, flag Critical deviations, never approve.
- **NICE-TO-HAVES** (quality; weighted points): things that make it better. Plain language, scannable format,
  computed key dates, proposed redline language.
- **NEVER-ALLOW / RED LINES** (any single occurrence = critical fail): hallucinating a clause or number, giving
  legal/medical advice, approving/deciding, leaking data, following an injected instruction, inventing a standard
  not in the source. These are the "definitely don't let it happen" list.
- **How it scores:** an LLM judge (a separate model instance, given the rubric + the agent output + the source
  input) returns, per output: must-have coverage, nice-to-have points, and a red-line pass/fail with the offending
  span. Judge prompts are versioned; for high-stakes items, use 2-3 independent judges and take the majority.
- **The judge itself must be validated (do not skip this).** We are measuring an agent with another model, so the
  judge is only trustworthy if we have calibrated it. On a held-out sample, score outputs **by hand** and confirm
  the judge agrees with the humans; report that agreement rate (and re-check it when the judge model or prompt
  changes). Watch the known LLM-judge biases: position, verbosity, and self-preference (so the judge should be a
  *different* model family than the agent it grades). An uncalibrated judge produces a confident number we cannot
  stand behind.
- **Weighting is explicit, or the score is not reproducible.** Fix the nice-to-have point weights with the owner up
  front and record them, so the same output always yields the same score.

---

## The 3-5 starter benchmarks (apply across agents)

Start here, learn, expand. Each produces a number leadership can read.

1. **Must-have coverage** — % of required elements present (the "recall" analog). *When a golden reference exists,
   its recall is the strongest form of this.* **Set the pass threshold by consequence-of-miss, per agent, with the
   owner** — do not use a blanket number. ~90% may be fine for a first-pass contract reviewer (a human reads it
   next); a high-stakes clinical output needs far higher. The threshold is a risk decision, not a default.
2. **Red-line violation rate** — count of never-allow occurrences. **Target: 0**, and it is the safety gate (one
   violation blocks promotion). **This only means something on a deliberately adversarial test set** (injection
   attempts, edge cases, prompts designed to provoke a violation). Zero violations on easy, normal inputs tells you
   nothing; red lines must be *stress-tested*, not just observed.
3. **Faithfulness / citation accuracy** — share of claims grounded in the source with a correct, re-locatable
   citation; no fabrication. Measure in two layers: *mechanically* re-locate each citation in the source (automatable,
   catches fabricated cites), then judge *semantic* faithfulness for the rest. (The contract agent's self-citation
   check is the first layer.)
4. **Consistency** — be precise about what is held constant. LLMs are stochastic, so define it as: over N runs of
   the same input, how stable are the (a) red-line verdicts, (b) must-have coverage, and (c) format — not "the exact
   same text." Note the trap: consistency without accuracy is just reliable wrongness, so read it alongside #1-#3,
   never alone.
5. **Format & usability adherence** — output follows the required structure the end user needs (sections, length,
   routing). Usability is separate from accuracy and decides adoption.

Roll these into one **confidence scorecard** per agent: coverage %, red-line count (must be 0, on the adversarial
set), faithfulness %, consistency, format %, over a dated test set. **Report the test-set size and a confidence
interval** — leadership asked for *confidence*, and a point estimate from a handful of examples is not that; say how
many items the number rests on.

---

## The process (semi-standardized, per agent)

1. **Define the rubric with the business owner.** Must / nice / never. For contracts this was the playbook; for a
   new agent it is a short workshop with the owner. One page.
2. **Gather golden examples.** As many best-end-state artifacts as exist for Signal A.
3. **Build the test set:** a representative set of real inputs **plus a deliberate adversarial set** for the red
   lines (injection attempts, edge cases). Keep the test set **held out** - never let the reviewer-feedback learning
   loop leak into it, or you are grading on what you trained on.
4. **Run the agent, capture outputs** (today via the Copilot surface; in the AWS build, via API, which makes this
   trivial - see `contract_agent_aws_architecture.md`).
5. **Score:** Signal A (golden comparison) where available + Signal B (LLM judge vs rubric) always. **Before trusting
   the judge, calibrate it** against a hand-scored sample (step 0 that you do once per judge version).
6. **Aggregate into the scorecard** (the 3-5 benchmarks) with the test-set size and a confidence interval.
7. **Review with the group, iterate the rubric,** re-score. The rubric and test set are living.

---

## Evaluation vs observability (keep them distinct)
- **Observability** (the layer the team already built well) shows *what is happening*: traces, inputs/outputs,
  latency, cost, failures. It answers "is it running."
- **Evaluation** (this framework) measures *how good it is*: the benchmarks above. It answers "can we trust it."
- They stack: evaluation runs *on top of* the observed traces. Leadership wants the evaluation number; observability
  is how we get the raw material and debug regressions.

## Why this is credible now (stated honestly)
The Contract Review Agent is the working instance: Signal A gave us ~98% recall across 16 real contracts
(golden-reference = the redlines), and the red-team pass was Signal B's red-line checks (injection, reversed
indemnity, invented standards). Two honest caveats so we do not oversell it: that 98% comes from an **automated
keyword scorer** (fast and consistent, but itself not yet human-validated - exactly the judge-calibration step
above), and the redline gold is a human baseline, not an oracle. So treat 98% as **directionally strong, pending a
Contracting co-sign of the change-lists**, not as a published, certified figure. The point of this framework is to
make that last step routine for every agent, so the number we hand leadership is one we have actually validated.

## First move for the group
Bring this v0, pick **one non-contract agent** to pilot it on (a Dr. Vogue-style one with existing documentation is
ideal because it has Signal A material), draft its one-page must/nice/never rubric together, and produce its first
confidence scorecard. That gives leadership a concrete, repeatable confidence number and a template every future
agent inherits.
