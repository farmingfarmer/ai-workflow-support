# Draft requests to IT / SharePoint owner (Contract Review intake)

Two answers unblock the SharePoint intake Flow: an AI capability in Power Automate, and a SharePoint team site.
Below is a single bundled note (if both go to one person), plus the two as separate drafts (if routing them
separately). Swap in the recipient and send. No secrets or contract data are in these.

---

## Bundled note (one recipient)

**Subject:** Two quick asks for the Contract Review intake automation (AI Builder + SharePoint site)

Hi [name],

The DS and AI team is building a proof of concept that reviews a contract dropped into a SharePoint library and
writes a first-pass review back as a file, all inside our tenant. To wire it up I need two things, and I am happy
to hop on a short call if that is easier.

**1. AI capability in Power Automate**
- Is AI Builder enabled in our environment, with credits/capacity available? I want to use the "Create text with
  GPT" prompt action to generate the review inside a Flow.
- Can you confirm it processes in-tenant and does not send contract text to any external service? The contracts are
  internal and need to stay under our existing agreements.
- If AI Builder is not the right path, do we have an Azure OpenAI resource (or the HIPAA ChatGPT) that exposes an
  API endpoint and key with a GPT-4-class deployment I could call instead? If so, please share the endpoint URL, a
  key, and the deployment name.

**2. A SharePoint team site for the library**
- Which team site should host the document library (I would call it "Contract Review")? If we have a DS and AI or
  Contracting site that fits, please send the URL (for example, https://keckmedicine.sharepoint.com/sites/yoursite).
  If not, can you point me to the right place or help set one up?
- Can you confirm I have permission to create a document library, a few folders, and a few columns there? If not, I
  can share the exact structure for someone with access to set up.

Thanks very much,
Alex

---

## Separate draft A: AI capability (route to IT / Power Platform admin)

**Subject:** AI Builder (GPT prompt action) availability in Power Automate

Hi [name],

For the Contract Review intake automation the DS and AI team is building, I need to confirm what AI capability I can
call from Power Automate. A few quick questions:

1. Is AI Builder enabled in our Power Automate environment, and do we have AI Builder credits/capacity available?
   Specifically, I want to use the "Create text with GPT" prompt action to generate a first-pass contract review
   inside a Flow.
2. If it is available, I want to confirm the data handling. The contracts are internal and need to stay inside our
   Microsoft tenant under our existing agreements, so can you confirm the prompt action processes in-tenant and does
   not send contract text to any external service?
3. If AI Builder is not the right path, do we have an Azure OpenAI resource (or the HIPAA ChatGPT) that exposes an
   API endpoint and key with a GPT-4-class deployment that I can call from a Flow or a script instead? If so, could
   you share the endpoint URL, a key, and the deployment name.

Context: this is a proof of concept that reviews a contract dropped into a SharePoint library and writes the review
back as a file, all inside the tenant. Happy to hop on a short call if that is easier.

Thanks,
Alex

---

## Separate draft B: SharePoint team site (route to Yesha / SharePoint owner)

**Subject:** SharePoint team site for the Contract Review library

Hi [name],

For the Contract Review intake automation, I need a SharePoint team site to host a document library (I would call
it "Contract Review") where contracts get dropped in and the agent's reviews get written back.

Two things:

1. Which team site should I use? If we have a DS and AI or Contracting team site that fits, please send me the URL
   (for example, https://keckmedicine.sharepoint.com/sites/yoursite). If we do not have one yet, can you point me to
   the right place or help set one up.
2. Can you confirm I have permission to create a document library, a few folders, and a few columns on that site?
   If not, I can share the exact structure and have someone with access set it up in a couple of minutes.

Everything stays inside our tenant. Happy to walk through it on a short call.

Thanks,
Alex
