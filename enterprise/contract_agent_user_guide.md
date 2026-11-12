# Contract Review Agent: User Quick-Start

**For:** anyone asked to pre-review a contract now that the contracting team is one person.
**What it does:** reads your contract package, compares it to the Keck Contract Negotiation Playbook, and returns a citation-based pre-review: top risks, key terms, deviations with priorities, recommended negotiation positions, and ready-to-paste contract-request-form language.
**What it is not:** approval, legal advice, or a substitute for Contracting/Legal on Critical items. Every review says so, twice.

## How to use it (5 minutes)

1. Open the **Microsoft 365 Copilot app** or **m365.cloud.microsoft** in a browser. Open a chat with **Contract Review Agent v1 POC** (search the agent store, or @-mention it in a new chat). Use the regular chat, not the agent builder's preview pane — the preview cannot accept file uploads.
2. **Attach your documents** with the + button: the MSA or service agreement, plus every order form, SOW, quote, exhibit, and addendum you have. Upload them together in one conversation — the agent treats them as one package and flags conflicts between them.
3. Optionally attach the **Keck Contract Negotiation Playbook** too. If you don't, the agent will find the tenant copy and tell you exactly which file it used — check that line in the output header.
4. Click **"Review this agreement against the playbook."**
5. Read the review top-down: the header confirms what was reviewed and whether anything was unreadable; TOP RISKS gives the five things that matter; section 6 is pre-drafted text for the contract request form; section 7 tells you what must be escalated and to whom.

## Rules of the road

- **One vendor per conversation.** Reviewing a second contract? Start a new chat. If you upload mixed documents, the agent will stop and ask rather than guess.
- **The output is a draft.** Read it against the actual contract before relying on it; every claim carries a file and section citation so you can check in seconds.
- **Critical findings are not negotiable by you alone.** They go to Contracting/Legal — that's the playbook's own rule, and the agent will name the right escalation owner per finding.
- **Protected or scanned files:** if the agent says a document was partially unreadable (rights-protected files do this), get a clean copy; don't accept a partial review.
- **Confidentiality:** use only this agent in the work tenant. Never paste contract text into public tools, personal accounts, or browser search bars.

## Licensing

Using a shared agent requires no premium Copilot license (use the Copilot app or m365.cloud.microsoft; it will not appear inside Word without premium). Building or editing agents is a separate question — ask the Data Science & AI team.

## Feedback

The agent improves by versioned instruction updates, not by chatting. Send misses, wrong priorities, or unclear output to the Data Science & AI team with the contract (or its name) and what you expected. "Not addressed by the playbook" items in section 7 are especially valuable — they become playbook updates.
