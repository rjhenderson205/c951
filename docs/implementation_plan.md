# Implementation Plan

## Overview
This plan outlines the deliverables required to complete the three assessment tasks bundled in this repository. The final submission will contain structured documentation, runnable artifacts, and supporting assets that align with each task’s grading rubric.

## Task 1 – Computing Career Chatbot
- **Deliverables**
  - Narrative report covering requirements (sections A–I), including functionality description, job mappings, training rationale, maintenance, environment assessment, and monitoring strategy.
  - AIML knowledge base and supporting configuration branded for the Pandorabot platform (five job recommendations minimum, strengths/preferences dialogue, fallback logic).
  - Installation and access guide referencing the hosted Pandorabot instance plus Panopto recording link placeholder and script.
  - References section with APA-style citations.
- **Assumptions**
  - Pandorabot deployment URL will be represented as a placeholder pending actual publishing by the submitter.
  - Panopto recording cannot be produced programmatically; include script/outline and submission instructions.
- **Implementation Notes**
  - Store AIML templates and bot metadata inside `task1/bot/`.
  - Document chatbot narrative in `task1/report.md` with embedded tables and citation markers.
  - Provide installation manual at `task1/installation_guide.md`.

## Task 2 – Disaster-Recovery Robot Prototype
- **Deliverables**
  - Scenario description, obstacle details, and recovery improvements.
  - Justification of robot modifications including sensors and control logic.
  - Explanation of reasoning, knowledge representation, uncertainty handling, and intelligence mechanisms.
  - Discussion of future work with reinforcement learning and advanced search.
  - Lua control script for BubbleRob illustrating goal-seeking behavior with sensor integration.
  - References section with APA-style citations.
- **Assumptions**
  - Prototype code will target CoppeliaSim BubbleRob sample; final validation performed by student outside repo.
- **Implementation Notes**
  - Place documentation in `task2/report.md` and code in `task2/scripts/bubblerob_recovery.lua`.
  - Provide configuration tips or scene setup notes within documentation.

## Task 3 – Machine Learning Project Proposal
- **Deliverables**
  - Comprehensive proposal covering sections A–E with problem context, literature review, solution overview, project plan, methodology, timeline, resource estimates, evaluation criteria, algorithm selection, data strategy, and governance practices.
  - References in APA style for all external works.
- **Assumptions**
  - Proposal will focus on a realistic but hypothetical organizational need aligned with accessible public datasets.
- **Implementation Notes**
  - Author proposal in `task3/proposal.md` using clear headings matching rubric items.
  - Include tables or timelines as markdown where applicable.

## Cross-Cutting Activities
- Maintain master `README.md` with navigation guidance and summary of deliverables.
- Track sources centrally and ensure consistent citation style across documents.
- Run spell-check and markdown linting manually; no automated tooling bundled.
- Provide verification summary once artifacts are complete (including manual review status of AIML and Lua files).
