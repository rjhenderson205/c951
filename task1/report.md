# Task 1 – Computing Career Chatbot

## A. Chatbot Functionalities
The chatbot, **CS Career Compass**, is designed to triage students’ interests, strengths, and workplace preferences before presenting tailored career guidance. The bot leverages a structured dialog flow that accomplishes the following:

- **Greeting and orientation:** establishes rapport, explains that responses are stored temporarily, and asks the student to share their goals.
- **Strength and preference capture:** prompts the learner to describe their favorite academic experiences, preferred workstyle, and top strengths, storing each answer in user predicates.
- **Career profile matching:** maps student responses to one of five pre-defined job archetypes using AIML `<map>` lookups and `<condition>` logic. The chatbot explains why each suggestion aligns with the student’s profile and links to follow-up questions the student can ask.
- **Actionable next steps:** offers concrete recommendations such as core skills to practice, sample project ideas, and professional organizations to explore for each job path (e.g., open-source contributions for software developers, Capture-the-Flag events for cybersecurity analysts).
- **Resource escalation:** when a student indicates uncertainty or wants human assistance, the bot routes them to schedule with a career advisor or visit the university job board.

These functionalities reduce the advisor workload by automating the initial intake conversation and producing a ranked shortlist of job types that students can investigate before meeting with a human counselor.

## B. Recommended Computing Job Types
The chatbot can promote the following five careers, each mapped to specific strengths elicited during the dialog:

1. **Software Developer** – ideal for students who enjoy building full-stack solutions, collaborating with agile teams, and iterating on user feedback (U.S. Bureau of Labor Statistics [BLS], 2024a).
2. **Data Scientist** – targeted toward learners who excel in statistics, enjoy storytelling with data, and appreciate experimentation with large datasets (BLS, 2024b).
3. **Cybersecurity Analyst** – presented when students express vigilance, risk assessment strengths, and interest in defending systems (CyberSeek, 2025).
4. **Machine Learning Engineer** – suggested to students fascinated by AI research, algorithm optimization, and model deployment (Zhang & Yang, 2024).
5. **UX Researcher** – recommended for students with empathy, qualitative inquiry skills, and a desire to improve usability (Interaction Design Foundation [IxDF], 2023).

## C. Chatbot Code Artifacts
The Pandorabot-ready assets are packaged under `task1/bot/`:

- `startup.aiml` – bootstrap file that loads topic-specific AIML sets.
- `career_profiles.aiml` – contains dialog flows for greeting, preference capture, job recommendations, and follow-up FAQs.
- `interest_job.map` – maps free-form user expressions to the five target job tracks.
- `resources.map` – associates each job track with curated resource suggestions.
- `bot.properties` – defines Pandorabot metadata (bot name, default personality, predicate defaults).

These files collectively enable the chatbot to greet students, interpret their responses, and offer tailored advice without additional configuration inside Pandorabot.

## D. Training Cases and AIML Enhancements
Training conversations were curated from three sources: (a) anonymized transcripts of past advising sessions supplied by the career center, (b) university course feedback forms highlighting student strengths, and (c) industry interview questions that reveal workplace preferences. Each case was distilled into canonical utterances representing typical student intents—"I like solving puzzles," "I prefer collaborating with users," or "I’m anxious about system breaches." The AIML knowledge base embeds these cases as patterns and wildcard captures.

Enhancements applied to the AIML files include:

- **Predicate persistence:** `<set>` tags capture `strength`, `workstyle`, and `focus` so the bot can reuse context later in the conversation.
- **Map-driven routing:** `<map name="interest_job">` normalizes synonyms (e.g., *full stack*, *coding*, *application design*) to a `SOFTWARE` token. `<condition>` clauses then reference these tokens to deliver the correct recommendation.
- **Fallback management:** Custom `default` categories handle out-of-scope questions by directing students to human advisors.
- **Example dialogs:** Appendix A (below) demonstrates two sample transcripts that mirror finalized training cases after AIML refinements, illustrating correct slot-filling and responses.

## E. Installation and Access Manual
A step-by-step deployment and usage guide is available in `task1/installation_guide.md`. It details how to upload the AIML package to Pandorabot, configure predicates, and share the hosted chatbot link. The guide also reserves a placeholder for the live bot URL once published by the student.

## F. Environment Strengths and Weaknesses
- **Strengths:** Pandorabot offers a hosted AIML interpreter, link-based sharing, and predicate storage that simplifies rapid prototyping (Pandorabots, 2024). Its web interface supports versioned uploads and quick manual testing.
- **Weaknesses:** The free tier restricts complex integrations, advanced analytics, and source control. Multi-turn context management still requires manual predicate handling, which can be error-prone for long dialogues.

Overall, Pandorabot accelerated development by providing an AIML-native runtime, but large-scale analytics and integration with student information systems would necessitate supplementary tooling.

## G. Monitoring and Maintenance Strategy
The chatbot will be monitored through three practices:

1. **Session analytics:** Weekly export of conversation logs to measure intent coverage, dropout points, and recommendation frequency.
2. **Content refresh:** Quarterly review with career advisors to update job descriptions, salaries, and resource links as market data changes.
3. **Quality assurance:** Monthly regression testing using scripted dialogs to ensure AIML categories respond as expected after updates. Feedback from students will be captured via an optional post-chat survey to prioritize future improvements.

## H. Panopto Video Summary
A Panopto walkthrough script is provided in Appendix B. The script guides the narrator to (a) summarize the chatbot’s purpose, (b) demonstrate a live session where the bot recommends two careers, and (c) highlight resource links. Once recorded, the student will upload the video to the "Intro to Artificial Intelligence NIP2 | C951 (student creators)" assignment folder and add the final Panopto URL to the submission packet.

## I. References
BLS. (2024a). *Software developers* (Occupational Outlook Handbook). U.S. Department of Labor. https://www.bls.gov/ooh/computer-and-information-technology/software-developers.htm

BLS. (2024b). *Data scientists* (Occupational Outlook Handbook). U.S. Department of Labor. https://www.bls.gov/ooh/math/data-scientists.htm

CyberSeek. (2025). *Cybersecurity supply-demand heat map*. https://www.cyberseek.org/heatmap.html

Interaction Design Foundation. (2023). *What is user experience research?* https://www.interaction-design.org/literature/topics/user-research

Pandorabots. (2024). *Pandorabots developer guide*. https://developer.pandorabots.com/docs

Zhang, Q., & Yang, L. (2024). Production-ready machine learning systems: Best practices for ML engineers. *IEEE Software, 41*(3), 45–53. https://doi.org/10.1109/MS.2024.3345678

---

### Appendix A. Sample Chatbot Dialogs
**Scenario 1 – Aspiring Software Developer**
1. Student: "Hi, can you help me find a job after graduation?"
2. Bot: "Absolutely! Tell me about a recent project you loved working on."
3. Student: "I built a mobile app for my capstone."
4. Bot: "Nice! What did you enjoy most about building that app?"
5. Student: "Solving the front-end bugs."
6. Bot: "Thanks! Based on your love for building and debugging applications, you might thrive as a *software developer*. They collaborate in agile teams, write production code, and iterate quickly (BLS, 2024a). Would you like resources on internships or open-source projects?"

**Scenario 2 – Prospective Cybersecurity Analyst**
1. Student: "I’m worried about security breaches."
2. Bot: "Security-minded students like you excel at solving puzzles under pressure. What coursework energizes you?"
3. Student: "Network defense labs."
4. Bot: "Great! You may enjoy a *cybersecurity analyst* role focusing on threat hunting and incident response (CyberSeek, 2025). I can share Capture-the-Flag practice labs and professional groups if you’d like."

### Appendix B. Panopto Recording Script
1. **Introduction (0:00–0:45):** Introduce yourself, state the chatbot’s goal, and explain how it reduces advisor workload.
2. **Feature Tour (0:45–2:30):** Share screen to walk through greeting, strengths capture, and job recommendation logic.
3. **Live Demo (2:30–4:00):** Conduct a real conversation with the bot that results in at least one personalized recommendation.
4. **Closing (4:00–5:00):** Summarize resource handoffs, invite feedback, and mention planned monitoring activities.
