# CS Career Compass – Installation & Access Guide

## 1. Prerequisites
- A Pandorabots developer account (https://developer.pandorabots.com/)
- AIML 2.0 enabled bot instance
- Optional: Spreadsheet or analytics tool for reviewing chat logs

## 2. Uploading the Chatbot Package
1. Zip the contents of the `task1/bot/` folder, preserving file names (`startup.aiml`, `career_profiles.aiml`, `interest_job.map`, `resources.map`, `bot.properties`).
2. Sign in to Pandorabots and create a new bot named **CSCareerCompass**.
3. Navigate to **File Manager → Upload**, choose the zipped package, and confirm the upload.
4. In the Pandorabots console, run the command `:load aiml b` to load the startup file. You should see confirmation that `career_profiles.aiml` has been learned.

## 3. Configuring Predicates and Maps
- Under **Settings → Maps**, verify that `interest_job` and `resources` are listed. Edit any entries to match institutional resources as needed.
- In **Settings → Properties**, confirm the `bot.properties` values (job labels, bot name) and adjust branding if required.

## 4. Testing the Chatbot
1. Open the **Chat** tab and greet the bot with "hello" followed by "start advising".
2. Walk through at least two conversation paths (e.g., software-focused, cybersecurity-focused) to confirm that job recommendations and resource prompts appear.
3. Use the `:trace` command while testing to inspect predicate assignments (`strength`, `workstyle`, `focus`, `path`).

## 5. Publishing the Bot
1. From the bot dashboard, select **Publish → Embed** and choose **Link**.
2. Copy the generated URL and share it with students. Document the URL in the final submission (placeholder provided below).

> **Live Bot URL (replace placeholder after publishing):** https://pandorabots.com/bot/CSCareerCompass

## 6. Panopto Demonstration Recording
1. Launch Panopto (WGU login) and start a new recording.
2. Present the slides or script from `task1/report.md` Appendix B.
3. Demonstrate a live conversation with the published chatbot.
4. Upload the recording to the "Intro to Artificial Intelligence NIP2 | C951 (student creators)" folder.
5. Copy the Panopto share link and include it with your submission package.

## 7. Maintenance Checklist
- Review chat logs weekly for unanswered intents.
- Update resource links every academic term.
- Perform regression tests after editing AIML files to ensure existing conversations still succeed.
