# Playbook addition: Effect of Termination (ready to paste into the Termination rules section)

Source: Essie Hayes comment on the Keck Contract Negotiation Playbook, "Termination rules" section,
Nov 18 2026 7:55 AM: *"Effect of Termination. Payment due up to effective date of termination vs payment
for full term. Ex.: If USC terminates Order without cause, USC only pays amount due up to effective date
of termination."* Reinforced verbally in the Nov 20 stakeholder meeting: vendors often grant termination for
convenience easily, then bury language requiring payment for the full remaining term, which makes the
convenience right illusory. This is the single most-requested playbook addition from that meeting.

## New row for the "Termination rules" table (same 5 columns as the existing table)

| Topic | Preferred position | Flag / exception | Review priority | Suggested action |
|---|---|---|---|---|
| **Effect of termination (payment on termination)** | On termination for convenience or without cause, USC pays only amounts accrued and due through the effective date of termination. No obligation to pay for the unused remainder of the term. | Vendor language that keeps USC on the hook for the **full remaining term**, a **make-whole / early-termination fee**, or "all fees for the remainder of the term become immediately due" despite a convenience-termination right. Revenue-recognition concerns often drive this. | **Critical** | Cap USC liability at amounts due through the effective date; strike full-term / make-whole payment language; confirm the convenience right has real economic effect, not just a nominal exit. |

## Negotiation-reality note (to add under the table, matching the existing note style)

A termination-for-convenience right is only valuable if the **effect-of-termination** clause limits USC's payment
to the effective date. Vendors frequently grant convenience termination freely while burying full-term or
make-whole payment language that negates it, so the easy "yes" on convenience is the tell to go read the payment
effect. **Always pair the two:** a convenience right plus a full-term payment obligation equals no real exit.

## Suggested full clause language (draft for Essie/Contracting to refine)

> **Effect of Termination.** Upon termination of this Agreement or any Order for convenience or without cause by
> USC, USC's sole payment obligation shall be for Services properly performed and fees accrued and due through the
> effective date of termination. USC shall have no obligation to pay fees for any unused or remaining portion of
> the term, and no early-termination fee, make-whole, acceleration of future fees, or minimum-commitment payment
> shall apply to a termination for convenience or for USC's termination for Vendor's uncured breach.

## How this reaches the agent

The agent cites the playbook via tenant search at review time, so once this row and note are in the
**Keck Contract Negotiation Playbook (Expanded)**, the agent will pick it up automatically and cite it. In
parallel, instruction block **v1.12** adds an explicit TERMINATION-PAIR CHECK so the agent reliably catches the
full-term-payment trap even before/independent of the playbook propagating (see
`contract_agent_paste_block.txt`).
