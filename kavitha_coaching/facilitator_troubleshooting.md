# Teams Facilitator — Troubleshooting Guide

**For:** Dr. Bagavathy and coaching faculty (IM Residency)
**Why this exists:** In our Sept 22 session, Facilitator worked in one of Dr. Bagavathy's meetings and was completely unavailable in another. This guide explains the difference and gives rules of thumb so coaching meetings always get Facilitator.

## What we observed

| Meeting | How it was created | Facilitator |
|---|---|---|
| Working meeting (worked) | Created from a **chat group / calendar invite**; Teams offered Facilitator at creation and it was turned on | Ran automatically, paced the agenda, posted over-time reminders, produced an end-of-meeting summary |
| Recurring admin meeting (didn't work) | Scheduled inside a **Teams channel** | No Facilitator toggle anywhere; Meeting options showed Copilot **"locked by admin"**; Copilot reported the Microsoft 365 administrator has disabled Copilot for these meetings |

## Why this happens

1. **Channel meetings play by different rules.** Meetings scheduled inside a Teams channel inherit the team/channel's policies and support fewer Copilot features than private (calendar/chat) meetings. Facilitator is built for private scheduled meetings; channel meetings are where we saw it locked.
2. **Admin policy can disable Copilot per meeting type.** The "locked by admin" message means a tenant policy (or a sensitivity label / meeting template applied to that team) has Copilot turned off for that context. Being the owner of the team does not override tenant policy.
3. **Old recurring meetings keep old settings.** A series created before your Copilot entitlement (or before Facilitator existed) may never offer the toggle. Editing **the series** (not a single occurrence) sometimes surfaces it; recreating the meeting always does.
4. **The chat fail-safe is not a backdoor.** Typing "Facilitator, please track this agenda…" in the meeting chat only works when Facilitator is *available* for that meeting. If it's admin-locked, "facilitator" is just a word in the chat — there's nothing listening.

## Rules of thumb for coaching meetings

1. **Schedule coaching sessions as private calendar meetings** (from Outlook or Teams calendar, or from a chat) — **never inside a Teams channel.**
2. **Turn on Facilitator at creation** when Teams offers it (the prompt above the invite body), and paste the session agenda into the invite body at the same time.
3. **For recurring series, always edit the series**, not a single occurrence — per-occurrence changes don't stick and can hide options.
4. **Turn on transcription at the start** of every session (transcript, not recording — per learner consent).
5. If an existing meeting won't show the toggle, **don't fight it — reschedule it fresh** from the calendar or chat with Facilitator on. One-time cost, permanent fix.

## If it's still locked

Copy this to your IT/Copilot admin contact:

> Facilitator and Copilot meeting options are unavailable ("locked by admin") for meetings scheduled in our residency Teams channel, while the same account can use Facilitator in private calendar meetings. Can you confirm which Teams meeting policy or sensitivity label applies to team **[team name]**, and whether Copilot/Facilitator can be enabled for its meetings — or confirm that private calendar meetings are the supported path?

You can also ask Copilot directly in Teams chat ("Why is Facilitator unavailable in [meeting]? What Copilot permissions do I have?") — it can sometimes see your policy state, though the definitive answer comes from IT.

## Decision tree

```
Scheduling a coaching session?
├─ Schedule as a PRIVATE calendar meeting (never in a channel)
├─ Facilitator prompt offered at creation? → turn it ON, paste agenda in body
├─ No prompt? → after creating, open the meeting → Meeting options → Facilitator ON
├─ Option missing/greyed "locked by admin"?
│    ├─ Recurring? → Edit the SERIES and retry Meeting options
│    ├─ Still locked? → recreate the meeting fresh from calendar/chat
│    └─ Locked even on fresh private meetings? → contact IT (text above)
└─ Day of meeting: confirm Facilitator active + transcription ON
```
