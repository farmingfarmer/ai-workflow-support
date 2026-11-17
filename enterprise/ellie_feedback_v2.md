# Ellie Hayes demo — feedback & v2 plan (Nov 17, 2026)

Demo of the Contract Review Agent to **Ellie Hayes** (contract reviewer), with Yesha facilitating.
Follow-up meeting set for **Thu/Fri this week**. Clint (contracting, 20 hrs/wk) also gets the agent shared.

> Process note (Alex's read): the session front-loaded too much — demo + rapid-fire questions at once —
> so Ellie couldn't react as fast as she was asked. She repeatedly said each section *was* useful even as
> the framing pushed "is this too much?" Yesha's stance is deliberate devil's-advocate (pre-empt complaints,
> protect the team's ROI/reputation, "peel back verbosity"). Takeaways below are the substance, not the framing.

## Alex's priorities (what to nail)
1. **Exact-location clickable citations** — a citation must jump to the *exact words* it cites inside the
   document, highlighted in place. Jumping to the top of the document "isn't much help at all." ← top priority.
2. **Visually distinct, scannable output** — more bold, more headlines, fewer dense text blocks.
3. **Plain language** — less dense legal/AI terminology; easier to understand; not "another legal-based document."

## Ellie's feedback — itemized

### Format / presentation (the main theme)
- **Risk titles must be prominent.** Right now every item reads "Critical… Critical…"; she wants the *issue itself*
  as the headline (e.g., the specific term), with severity secondary. "If the issue/title was more prominent it'd be easier."
- **Top ~10, ranked.** She'd limit the headline list to ~10 (not fixed at 10, but a tight ranked set). Wants to
  cross-check against an internal IS "top 10 / top 25 mandatory items" list she'll look for.
- **Snapshot first.** Lead with a summary/snapshot of the review; let detail live below as reference. Text-heavy
  at the *bottom* is fine if the top is a clean snapshot.
- **Too long overall.** The fear: "you might as well just read the SOW." If it's as long as the doc, people won't use it.
  Target = minimum necessary for an initial review, with depth available but collapsed.
- **Less focus on the injection/attack angle up front.** Start with the plain review + top pieces; the hidden-instruction
  catch confused her at first. Keep the capability, de-emphasize it in the lead.
- **Model the IS contract review sheet** (she will share it) — the one-page snapshot directors use to see what they're
  approving: a header per item (defers to MSA? renewal terms? termination? etc.). Format inspiration, not a citation source.

### Content — keep (she explicitly valued these)
- **Document inventory** — yes, keep. Contracts have many attachments/schedules and often no index.
- **Recommended positions** table — preferred outcome / fallback / concrete ask: helpful.
- **Draft submission language** — helpful (suggestion to bring terms in line).
- **Escalation / subject-matter + departmental reviews** — helpful, but make it a **checklist**, minimized.
- **Redline / "suggested edits are draft"** — she liked this ("Oh, I like that"); keep and label clearly as suggested/draft.

### Content — fix
- **Don't repeat "cannot determine / no information."** Collapse null/absent triggers. BUT: when something is
  *required* by playbook/SOP and absent (e.g., PHI is shared but there's no BAA/DSA), that is a real **GAP** worth
  stating plainly. Rule: suppress trivial "not present" noise; surface required-but-missing as a named gap.
- **"Finding" column was unclear.** Ellie didn't understand what the "finding" meant in the positions table. Rename /
  reframe so each row reads as: the issue → preferred outcome → fallback → concrete ask → owner.
- **Owner = department, not a person.** And map to the *right* group: e.g., data-use → Privacy + InfoSec + Contracting
  **+ a data owner**. Owner should reflect who actually closes that item (Contracting admin closes IP/indemnity/LoL,
  with business-owner sign-off on business-decision terms like limitation of liability).

### Genuine product forks (decide with Alex / the reviewers — not guessing)
- **Business terms vs legal terms:** Ellie wants a *distinction*. Business term = what the business is ordering
  (deliverables, term, scope); legal term = IP, indemnity, limitation of liability (contract admin/legal closes these).
  Open: split into two labeled sections, or tag each row business/legal, or keep holistic. **Recommend:** tag rows
  (business/legal) within one table rather than splitting — keeps it short, gives her the distinction.
- **Top-10 vs full detail:** replace detail with top-10, or snapshot-on-top + collapsed detail below?
  **Recommend:** snapshot + ranked top-10 on top, full sections collapsed/progressive below. (Built this way in v2 prototype.)
- **Playbook authority:** the current playbook came from Laura + Copilot and may not be authoritative. Ellie will
  review it against internal mandatory lists. Treat the playbook as swappable (agent already pins which copy it used).

## What's built so far (v2)
- **`review_v2_prototype.html`** — redesigned, scannable review view with **exact-location citations**: clicking a
  citation lands on and highlights the exact cited phrase (using the agent's v1.7 verbatim anchors), not the document
  top. Snapshot card on top; ranked top risks with the *issue* as the bold headline and severity as a secondary chip;
  one-line "why" + owner revealed on expand (progressive disclosure = less on-screen text). Works for both the
  contract and the playbook panes.

## Next (toward Thu/Fri)
- [ ] Get Ellie's IS contract review sheet + internal top-10/25 list; align the snapshot header to it.
- [ ] Fold the format changes into the **agent instructions** (v1.9): snapshot-first, issue-as-headline, top-10,
      suppress null triggers (keep required-but-missing gaps), owner=department, "suggested edits are draft" label.
- [ ] Decide the two forks above with Alex.
- [ ] Production path for exact-location citations on the real Copilot surface (the prototype proves the UX;
      productionizing = render agent output + uploaded doc into this view automatically).
- [ ] Share agent with Clint; confirm the "open in Copilot" flow works outside a live meeting (it misbehaved during the call).
