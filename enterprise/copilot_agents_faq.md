# Copilot Agents — Frequently Asked Questions

**Audience:** anyone in the organization curious about building or using a Copilot agent.
**Maintained by:** Data Science & AI Team. These answers reflect testing in *our* tenant, not just Microsoft documentation.

---

### What is a Copilot agent?

A reusable Copilot "specialist" someone builds once — with written instructions, a defined output format, and optional knowledge — that others can then use without any prompt-writing. You open the agent, give it your input (a file or text), and it produces output in the agreed format every time. Think of it as a prompt that's been productized.

### If I build an agent, who can use it?

**Anyone you share it with — they do not need a premium Copilot license.** We validated this in our tenant: a user with no Microsoft 365 Copilot license opened a shared agent, uploaded a file, and received full output with no errors. Build it under your account, share it with specific people, and they use it from their own accounts.

### Where do people without a premium license use my agent?

In the **Microsoft 365 Copilot app** or at **m365.cloud.microsoft** in a browser. As of April 2026, users without premium licenses in large tenants like ours no longer see Copilot inside Word, Excel, or PowerPoint — so don't tell your colleagues "it's in Word." Premium-licensed users can also reach agents from Teams and Office surfaces.

### Does it cost anything when unlicensed colleagues use my agent?

Usage by unlicensed users is covered by the organization's Copilot billing arrangement (Copilot Credits / pay-as-you-go metering), not by anything you or they pay individually. You don't need to do anything — but see the next question, because one design choice keeps agents in the cheapest, most-compatible tier.

### What are "knowledge sources," and should I add them?

Knowledge sources attach SharePoint sites or files to your agent as reference material. **Default to not using them.** Agents grounded in premium knowledge sources have extra licensing requirements for unlicensed users, and most agents don't need them: if your agent works from a template or a set of rules, paste those directly into the agent's *instructions*; if it works on a per-task document (a transcript, a report), have the user *upload it* in the conversation. Both approaches avoid the knowledge-source licensing question entirely.

### Does my agent learn from feedback over time?

**No.** Corrections made mid-conversation vanish when the chat ends. Agents improve when someone edits their written instructions. The working pattern: collect feedback from users in one place (a Teams thread or running doc), fold it into a revised instruction set, update the agent, and bump the version in its name ("…v2"). Repeat until the output is steady. Put the version in the agent's name so users know what they're on.

### How should I test an agent before I trust it?

With **synthetic test data containing deliberate traps** — never with real data first. Write a fake input that (a) omits something your output format expects, and check the agent reports it as missing rather than inventing it; (b) contains content that belongs in one output section and not another, and check it lands correctly; (c) has wording that must be carried through verbatim, and check it isn't paraphrased. An agent that passes planted traps has earned a trial on real material; an agent that fills in gaps confidently is worse than no agent.

### What data am I allowed to give an agent?

Work data stays inside the organization's M365 tenant, which is where Copilot agents run — so ordinary business documents are generally fine. **Patient data, student/learner records, and other regulated data follow the same rules they always do**: only in approved environments, only with the access you already legitimately have. An agent never expands what data you're allowed to touch. When in doubt, ask us, and always use synthetic data for testing and demos.

### Should my agent's output go straight to its audience?

Almost never. The pattern that works: the agent produces a **draft**, a human reviews it for accuracy, and only then does it go to its audience or into a system of record. Write that into your process (and consider writing it into the agent's output — ours end with a one-line reminder of who reviews what).

### How do I actually build one?

The agent builder lives in Copilot Chat → Agents → Create agent. Use the **Configure** tab (paste exact instructions; skip the conversational "Describe" tab), leave knowledge sources and capabilities off unless you have a reason, and add one or two conversation starters. The whole thing takes about 15 minutes with instructions in hand — see the companion **Agent Playbook** for the process, or use our **Agent Architect** agent, which interviews you about your process and writes the instruction block for you.

### I want one. Where do I start?

1. If you can write down your process and what good output looks like: use the **Agent Architect** agent or follow the **Agent Playbook**.
2. If you're not sure the problem fits an agent: contact the Data Science & AI Team — a 30-minute conversation usually settles it, and simpler tools (Facilitator for meetings, a saved prompt) sometimes beat an agent.
