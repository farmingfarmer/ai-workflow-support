# Deploy v1.8 (redline mode) to the live Contract Review Agent

The full v1.8 instruction text is on GitHub as a clean, paste-ready file (no markers, no
conversation starters, exactly the 7,993 characters that go in the Instructions box).

**File (open in Edge on the ThinkPad, signed in as farmingfarmer):**
https://github.com/farmingfarmer/ai-workflow-support/blob/main/enterprise/contract_agent_paste_block.txt

## Copy it (zero-corruption, no git, no base64)

1. Open the URL above in Edge.
2. In the file's toolbar (top-right of the file box), click the **copy icon** ("Copy raw file").
   - If you'd rather: click **Raw**, then `Ctrl+A`, `Ctrl+C`.
3. The exact instruction text is now on your clipboard.

## Paste it into the agent

4. Open the Contract Review Agent in the agent builder.
5. Click the **pencil edit-toggle** to unlock the Instructions box (it's read-only until you do).
6. Click inside the Instructions box, `Ctrl+A`, `Ctrl+V`.
7. **Verify** before saving: search the box for **"REDLINE / PROPOSED EDITS"** and
   **"EXACT-QUOTE ANCHOR"** — both must be present. That confirms v1.8 (redline + jump-ready anchors).
8. Click **Update** / **Save**.

## What v1.8 adds over the last confirmed live version (v1.6)

- **v1.7 jump-ready anchors:** every citation carries a 3-8 word verbatim quote anchor so a
  citation can be searched/jumped to the exact spot. (The speaker notes lean on this.)
- **v1.8 opt-in redline mode:** on request, a clause-by-clause "Suggested edits" table —
  original language + cite, the issue, a proposed insert/delete/replace from the playbook's
  preferred/fallback language, and the rule. Headed "draft, not final/binding language."

## Demo it

- Redline mode is opt-in. After a normal review, tell the agent:
  **"Now give me the redline / proposed edits for this contract."**
- Or on a fresh doc: **"Review this against the playbook, then propose redline edits."**
