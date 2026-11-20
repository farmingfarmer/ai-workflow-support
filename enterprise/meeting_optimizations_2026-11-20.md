# Contract Agent optimizations from the Nov 20 2026 stakeholder meeting (Essie Hayes)

The POC validated well live: Essie ran real documents (incl. a brand-new PatientIQ renewal order she was
actively negotiating), traced the agent's reasoning, and confirmed it caught real issues against her own redlines.
The actionable optimizations, in priority order.

## 1. Effect-of-Termination playbook rule  [PRIMARY - drafted, ready to paste]
Essie's playbook comment (Nov 18) + verbal emphasis: vendors grant termination for convenience freely, then bury
full-term / make-whole payment language that negates it. On no-cause termination USC should pay only amounts due
through the effective date. Critical priority; pairs with the existing "Convenience termination" row.
- **Deliverable:** `playbook_entry_effect_of_termination.md` - the ready-to-paste table row, negotiation-reality
  note, and a draft full clause for Essie/Contracting to refine.
- **Action:** Alex/Essie paste it into the Keck Contract Negotiation Playbook (Expanded). The agent cites the
  playbook via tenant search, so it picks the rule up automatically once it's in.

## 2. Instruction block v1.12  [DONE in `contract_agent_paste_block.txt` - needs re-deploy]
Two additions (block now 7990 chars, within the 8000 paste limit):
- **TERMINATION-PAIR CHECK (all types):** when a contract grants termination for convenience/without cause,
  locate the effect-of-termination / payment clause and flag Critical if USC still owes the full term, a
  make-whole, or a large early-termination fee; GAP if that clause is absent where a convenience right exists.
  This makes the agent catch the trap reliably even before the playbook propagates.
- **Numeric-consistency in REDLINE mode:** if a line item is relabeled to one unit, set quantity to 1 and
  recompute the extended total; flag quantity x unit-price used to inflate a single subscription/bundle. This
  came straight from Essie's live PatientIQ test: the agent relabeled a bundled subscription "single" but left
  quantity at 2, so it caught the concept but not the number.
- **Re-deploy:** fetch the updated paste block onto the ThinkPad and paste it into the agent builder (pencil/edit
  toggle). Not yet deployed - awaiting Alex's go.

## 3. Human-vs-agent comparison workflow  [process - starting now]
Essie will drop her own redlines + the agent's redlines into a shared PatientIQ folder (named e.g.
`PatientIQ_2182_AgentRedline` / `PatientIQ_2182_HumanRedline`). As pairs land, build a side-by-side comparison
(what each changed, where they match/diverge) and fold results into the running precision/recall number. This is
the real validation engine going forward - her actual work, not synthetic tests.

## 4. SharePoint automation Flow 1 (intake -> Reviews library)  [solves the history/audit concern]
Essie couldn't find her chat history (fragmented because we clicked "New chat" per doc during P/R testing; also a
Microsoft surfacing limitation) and worried about losing un-exported work. The fix is document-level, not
person-level: drop a contract in a shared library, the agent reviews it, the review is written as its own file
with vendor/type/status tracked. Gives a real audit trail without employee surveillance. Scoped; ready to build.

## 5. Already validated / no change needed
- **Defer-to-MSA on thin quotes:** Essie wants to test quotes that just reference the MSA with basics
  (price/payment/term/description). The agent already has the defer-to-MSA SOW logic; it should recognize the
  deferral and not false-flag it as incomplete. Confirm on her quote test.
- **Multi-document reasoning:** the agent correctly cross-referenced the new order against the executed
  subscription agreement (both provided in-chat) to catch the inflated price - working as designed, in-tenant.

## Process items
- **Contracting co-sign:** Clint/Ellie confirm the change-lists before any number is published externally.
- **Pilot:** first real reviewer (Essie, and Clint async given reduced hours) using it on live work.
- **Cadence:** weekly sync aligned to the two-week sprint; async pings when something's ready.
