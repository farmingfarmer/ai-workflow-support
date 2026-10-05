# Copilot Agent Plan — Coaching Session Summarizer

**Internal working doc (AI team).** Covers the three follow-ups from the Sept 22 demo: (1) the licensing answer for non-premium users, (2) the intern test protocol that settles it definitively for our tenant, (3) the agent build spec, ready to create as soon as Dr. Bagavathy returns her template markup.

---

## ✅ RESULT — license test passed (early October 2026)

Jason Tjia (intern, **no** M365 Copilot premium license) accessed the shared
`License Test - Session 1 Summarizer` agent, fed it the synthetic Session 1
transcript, and worked the agent end to end with no problems — access,
execution, and the transcript workload all succeeded for an unlicensed user.

**Conclusion (best-case row of the §2 matrix):** a Copilot agent built and
shared by a premium-licensed user (Dr. Bagavathy) is usable by non-premium
users (her APDs/coaches) in our tenant. Unlicensed users should use the
**M365 Copilot app or m365.cloud.microsoft** (Copilot Chat is not available
inside Word/Office apps for unlicensed users in large tenants as of April
2026 — point coaches there in the rollout guidance).

**Unblocked next steps:** §4 items 3–5 — await Kavitha's template markup,
then build `Session 1 Summarizer v1`, validate on her two sample
transcripts, and hand off under her account shared to the APDs.

---

## 1. Licensing: can non-premium users use an agent built by a premium user?

**Short answer: yes, most likely — but it's a tenant-admin decision, not a license question, so the intern test is still the definitive check.**

Current state of Microsoft's model (verified Sept 2026):

- Users do **not** need an M365 Copilot (premium) license to use shared agents. Agents are available in **Copilot Chat** (included with standard M365 subscriptions), with usage billed to the org via **Copilot Credits / pay-as-you-go metering** that a tenant admin enables in the M365 admin center. Since April 2026 this no longer even requires an Azure subscription.
- **Caveat 1 — tenant switch:** if USC's admins have not enabled pay-as-you-go/Copilot Credits, unlicensed users may see the agent but hit a wall using it (or not see it at all).
- **Caveat 2 — where it runs:** as of April 15, 2026, tenants over 2,000 seats (USC qualifies) lost Copilot Chat inside Word/Excel/PowerPoint for unlicensed users. Unlicensed coaches would use the agent in the **Microsoft 365 Copilot app or at m365.cloud.microsoft** — not embedded in Office apps.
- **Caveat 3 — knowledge sources:** agents grounded in *premium knowledge* (e.g., SharePoint document libraries) specifically require the pay-as-you-go plan for unlicensed users. **Design consequence: build the agent with the template embedded in its instructions and no knowledge sources** — the coach uploads the transcript per session. This keeps the agent in the cheapest, most-compatible tier and sidesteps the grounding requirement entirely.

Sources: [Microsoft: no Copilot license needed to deploy agents to the M365 channel](https://microsoft.github.io/mcscatblog/posts/no-copilot-license-m365-channel/) · [Copilot pay-as-you-go meters](https://learn.microsoft.com/en-us/microsoft-365/copilot/pay-as-you-go/meters) · [Copilot extensibility cost considerations](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/cost-considerations) · [Copilot Studio licensing](https://learn.microsoft.com/en-us/microsoft-copilot-studio/billing-licensing) · [April 2026 Copilot Chat changes for unlicensed users](https://chrismenardtraining.com/post/microsoft-365-copilot-chat-changes-on-april-15-2026-what-unlicensed-users-need-to-know/) · [Who can use what (May 2026)](https://www.thomasjuhlolesen.dk/2026/05/copilot-agents-in-microsoft-365-who-can-use-what.html)

## 2. Intern test protocol (definitive, ~30 minutes)

1. **Build:** A premium-licensed team member creates the Session 1 agent (spec in §3) via the agent builder in Copilot Chat — instructions only, **no knowledge sources**.
2. **Share:** Share the agent with an intern who has **no** M365 Copilot license (share link / "Share with specific people").
3. **Test, in this order:**
   a. Intern opens the **M365 Copilot app** (or m365.cloud.microsoft) → can they *see* the shared agent?
   b. Can they *open* it and send a message?
   c. Can they **upload a file** (use a synthetic/test transcript — never a real one) and get the two summary documents back?
   d. Note any "premium required" / credits / metering errors verbatim, with screenshots.
4. **Also test in Word/Teams** to confirm the expected unlicensed limitation, so we can tell coaches exactly where to go.
5. **If blocked at (a) or (c):** the tenant likely lacks pay-as-you-go/Copilot Credits — that becomes an IT ask ("enable Copilot pay-as-you-go billing so shared agents are usable by Copilot Chat users"), or the fallback below.

**Fallback if unlicensed access is a dead end:** coaches without premium licenses use plain Copilot Chat with the Part B prompt + template pasted manually (works today, zero licensing risk) — the agent then only serves premium users until licenses/credits arrive. Kavitha already has this workflow in hand.

## 3. Agent build spec — "IM Coaching — Session 1 Summarizer"

- **Platform:** Agent builder in Copilot Chat (declarative agent) under Dr. Bagavathy's account once validated; our test copy first.
- **Knowledge:** none (see §1 caveat 3). Template lives in the instructions; transcript is uploaded per conversation.
- **One agent per session** (4 total, matching her mental model and keeping each agent's instructions short). Name + version in the agent name: `Session 1 Summarizer v1`.
- **Versioning loop (her ask):** agents don't self-learn from feedback; we curate. Coaches drop feedback in a running doc/Teams thread → we fold it into the instructions → publish `v2` → retire `v1`. Repeat until steady state. Make this explicit to the coaches so feedback lands with us, not in mid-conversation corrections that vanish.
- **Output:** ONE run produces TWO documents — the coach summary (full template, checklist, notes) and the learner summary (concise, organic, verbatim-shared goals). Uniform language between them is enforced by generating both in the same pass.

### Instructions block (paste into agent builder — v1 draft, pending Kavitha's markup)

> You are a summarizer for Internal Medicine residency coaching sessions. The user will upload a transcript of a Session 1 ("Strengths & Vision") coaching conversation between a faculty coach and a resident (the learner). You produce exactly two documents in one response.
>
> RULES (apply to both documents):
> 1. Use ONLY what was actually said in the transcript. Never infer, embellish, or add content. If unsure whether something was said, leave it out.
> 2. Capture the learner's answers in their own words where possible; light cleanup of filler only, never change meaning.
> 3. If a question was not asked or answered, write "Not discussed" — never fill it in from context.
> 4. Attribute clearly: the learner's words vs. the coach's suggestions. Never present the coach's words as the learner's goals.
> 5. Neutral, descriptive tone. This is a record of a conversation, not an evaluation of the learner.
>
> DOCUMENT 1 — COACH SUMMARY (full detail, coach-facing only):
> [Insert Part A of session1_summary_template — header table, sections 1–10 with [mm:ss] timestamp citations on every captured point, the Session 1 checklist marked Covered/Not covered with evidence (never assume covered), and the Notes section for anything substantive outside the framework. Leave Learner Review & Approval blank.]
>
> DOCUMENT 2 — LEARNER SUMMARY (concise, learner-facing):
> [Insert session1_learner_summary_template — What we talked about / Your strengths / Your vision for the year / Your goal before we meet again / What we each agreed to do / Next session / confirmation block.]
> For Document 2: no checklist, no timestamps, no coach notes, no mention of the session structure or rubric. Copy the goal wording, success measure, next steps, and session date VERBATIM from Document 1 — do not re-paraphrase them.
>
> After both documents, add one line: "Coach: review Document 1 for accuracy, then share Document 2 with the learner for confirmation."

- **Conversation starters:** "Summarize this Session 1 transcript" · "What do you need from me?" (answer: just the transcript file).

## 4. Sequence

1. ~~Licensing research~~ (done — §1).
2. Run the intern test (§2) → report result to Kavitha ("we'll let you know immediately").
3. Receive Kavitha's markup of the coach template + learner-visibility annotations → finalize both templates.
4. Build `Session 1 Summarizer v1` on our side, validate against the two sample transcripts, then hand off/rebuild under Kavitha's account and share with the APDs.
5. Sessions 2–4 agents once her Session 2–4 templates land (she's mirroring the Session 1 pattern herself; second meeting round is in progress now).
6. Separately: chase the Facilitator channel-lock question with IT (see facilitator_troubleshooting.md) — Yesha flagged we should have standing guidance.
