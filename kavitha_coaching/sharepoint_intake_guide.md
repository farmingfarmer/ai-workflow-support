# SharePoint Data Folders: Setup and File Naming Guide

**For:** Nancy, Monique, and the KSOM IM residency team
**Purpose:** one consistent way to organize and name the files that feed the CCC dashboard, so the AI agent can reliably find every learner in every document. Five minutes to read; saves hours of rework later.

## Folder structure (as agreed Nov 4)

One folder per review period, with a subfolder per data source. All learners' files go together inside each source folder; no per-learner folders.

```
KSOM CCC Data/
  2026-12 Review (Jul-Dec 2026)/
    01 Faculty Evals (New Innovations)/
    02 360 Evals (MS Forms)/
    03 ITE Score Reports/
    04 MKSAP Completion/
    05 Didactics Attendance/
    06 Procedure Logs/
    07 Scholarship Logs/
    08 Praise or Concern Cards/
    09 Coaching Documents/
    10 Other/
  2027-06 Review (Jan-Jun 2027)/
    (same subfolders)
```

Numbered prefixes keep the folders in a predictable order. "10 Other" catches anything that doesn't fit; if it fills up with one kind of thing, we'll promote that to its own folder.

## File naming: two patterns only

1. **A file about ONE learner** starts with their name:
   `Lastname_Firstname_<description>_<MM.DD.YYYY>.pdf`
   Examples: `Smith_John_ITE_report_10.15.2026.pdf` · `Smith_John_praise_card_09.02.2026.pdf`
2. **A file covering MANY learners** (batch reports, rosters) starts with ALL:
   `ALL_<description>_<MM.DD.YYYY>.xlsx`
   Examples: `ALL_faculty_evals_export_11.08.2026.xlsx` · `ALL_didactics_attendance_fall_11.01.2026.xlsx`

The date is when the report was run or the document was received, in MM.DD.YYYY (same convention as the coaching summaries). Use underscores rather than spaces inside the name parts.

## Three rules that matter more than the rest

1. **Don't edit the files themselves.** Export or save them exactly as the source system produced them and just name the file correctly. The agent reads the content; the filename only needs to say who and when.
2. **Batch exports are fine.** You do not need to split a New Innovations report into 20 learner files; name it `ALL_...` and the agent separates the learners from the content.
3. **When unsure, drop it in "10 Other" with the best name you can.** A misfiled document with a good filename is recoverable; a perfectly filed document named `scan0042.pdf` is not.

## What happens from here

Once the folder and the Teams group access are granted, the agent reads directly from these folders. Nothing you load is moved or changed; the dashboard and per-resident snapshots are generated from what's here, every six months ahead of the CCC. If a source arrives in a new format (a different export, a new QR form), just load it with the naming pattern; no need to ask first.

Questions or weird cases: send one example our way and we'll tell you where it should live.
