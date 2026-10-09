# Build Your Session 1 Summarizer Agent — Step-by-Step Guide

**For:** Dr. Bagavathy (IM Residency)
**What you're building:** a Copilot agent that takes a Session 1 coaching transcript and returns two documents in one pass — the full coach summary (with checklist and notes) and the concise learner summary. Build it once under your account, share it with your APDs, and nobody retypes or re-pastes templates again.

**Good news first:** we tested this with a team member who has **no premium Copilot license** — he could open your shared agent, upload a transcript, and generate both documents with no issues. So your APDs and coaches do **not** need premium licenses to use it. (One note: non-premium users access it through the **Microsoft 365 Copilot app** or **m365.cloud.microsoft** in a browser — the agent won't appear for them inside Word.)

You'll need two companion files we've provided: **`agent_instructions_v1.txt`** (the agent's brain — you'll paste this) and **`synthetic_session1_sample.txt`** (a completely fictional test transcript — safe to experiment with).

---

## Part 1 — Build it (about 10 minutes)

1. Go to **m365.cloud.microsoft** in your browser (or open the Microsoft 365 Copilot app) and sign in with your USC account.
2. Open **Copilot Chat**. In the right-hand pane, find **Agents → Create agent** (sometimes under "All agents" → "+ Create").
3. The agent builder opens with two tabs: **Describe** and **Configure**. Skip the conversational Describe tab and click **Configure** — we're pasting exact instructions, not describing them.
4. Fill in:
   - **Name:** `Session 1 Summarizer v1`
   - **Description:** `Turns an uploaded Session 1 coaching transcript into a coach summary and a learner summary.`
   - **Instructions:** open `agent_instructions_v1.txt`, copy **everything below the line that says "paste everything below"**, and paste it into the Instructions box.
   - **Knowledge sources: leave EMPTY.** This is deliberate — adding SharePoint files here would require extra licensing for your non-premium coaches. The template lives inside the instructions instead.
   - **Capabilities** (code interpreter, image generator): leave off.
   - **Conversation starters:** add two — `Summarize this Session 1 transcript` and `What do you need from me?`
5. Click **Create**. The agent now appears in your Agents list.

## Part 2 — Test it (about 5 minutes)

1. Open your new agent and **upload `synthetic_session1_sample.txt`** (paperclip/+ button), then click the starter **"Summarize this Session 1 transcript."**
2. Check the output against these four marks — the test file was designed with deliberate traps:
   - You get **two documents**: a detailed coach summary and a short learner summary.
   - In the coach summary's checklist, **"Session 2 scheduled" is marked *Not covered*** (the fictional coach never scheduled it). If the agent claims it was covered, it's inventing — tell us.
   - The personal details (the learner's partner moving, looking for a gym) appear **only in the coach summary's Notes** — not in the learner version.
   - The **goal wording is identical** in both documents, word for word.
3. If all four check out, try it on one of your **real** session transcripts and judge the quality yourself. (Real transcripts: download from the meeting recap, upload to the agent directly — they stay inside the USC tenant.)

## Part 3 — Share it with your APDs (2 minutes)

1. Open the agent → **Share** (or the "…" menu → Share).
2. Choose **specific people** and add your four APDs by name — avoid "anyone in the organization."
3. Send them the link, plus one instruction: **use it at m365.cloud.microsoft or in the Microsoft 365 Copilot app** (it won't show up inside Word without a premium license), upload the session transcript, click the starter, review the coach summary for accuracy, then share the learner summary with the learner for confirmation.

## Part 4 — Making it better (the version loop)

The agent does **not** learn from corrections made mid-conversation — those vanish when the chat ends. Improvements happen by updating its written instructions:

1. Keep a running note (or Teams thread) where you and the APDs drop feedback: wrong section, missing nuance, wording you'd change, things that should/shouldn't be learner-visible.
2. Send that to us. We fold it into an updated instructions file (`v2`), you paste it over the old instructions (edit agent → Configure → Instructions) and rename the agent `…v2`.
3. Repeat until the output is steady-state. Then we clone the pattern for Sessions 2–4 — same build steps, different template — for four agents total.

## If your builder looks different (new Microsoft layout)

Microsoft is rolling out a refreshed agent builder in waves, so your screen may not show the "Describe / Configure" tabs — you might instead see **"Build your own specialist agent"** with a chat box that says *"Message Agent Builder,"* Templates and My agents tabs, and (after skipping) a **"New Agent"** editor. It's the same builder with a new layout, and the steps map one-to-one:

| In this guide | In the new layout |
|---|---|
| Skip the "Describe" tab | Click **Skip** (top right) past the "Message Agent Builder" chat — don't describe, we paste |
| Configure tab → Instructions box | The big **Instructions** box on the New Agent screen — paste `agent_instructions_v1.txt` there |
| Knowledge sources: leave empty | **Knowledge: leave empty**, and turn **OFF** any "Work content" toggles (Cloud files, Outlook, etc.) — those are knowledge sources by another name |
| Capabilities: leave off | **Skills: leave empty** |
| Name / description / starters | Same fields, same screen (starters may sit lower on the page) |

Everything else — the test with the practice transcript, sharing, the version loop — is unchanged.

## If something doesn't work

- **Can't find "Create agent":** tell us — a tenant setting may hide the builder; we'll chase it with IT.
- **An APD can't see or use the shared agent:** confirm they're in the M365 Copilot app or m365.cloud.microsoft (not Word), then tell us the exact error text — we've mapped what each message means.
- **Output quality dips or it starts inventing content:** stop using that output, note what happened, and send us the example. The instructions forbid inference, and a violation is exactly the feedback the next version needs.
