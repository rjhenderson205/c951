# C951 Portfolio Deliverables

This repository contains the complete artifacts for the three C951 assessments:

- **Task 1 – Computing Career Chatbot:** Documentation, AIML knowledge base, and installation guide for the CS Career Compass chatbot deployed on Pandorabot.
- **Task 2 – Disaster-Recovery Robot:** Scenario report and BubbleRob Lua controller that demonstrate autonomous goal-seeking behavior for tornado response.
- **Task 3 – Machine Learning Project Proposal:** Predictive maintenance proposal for a municipal bus fleet, including scope, methodology, and resource plan.

## Repository Structure

```
docs/
	implementation_plan.md        High-level roadmap for all deliverables
task1/
	report.md                     Written responses for rubric items A–I
	installation_guide.md         Deployment and recording instructions
	bot/                          AIML files, maps, and bot configuration
task2/
	report.md                     Disaster-recovery scenario documentation
	scripts/bubblerob_recovery.lua Lua control script for BubbleRob prototype
task3/
	proposal.md                   Machine learning project proposal
task1.txt, task2.txt, task3.txt Original task instructions for reference
```

## Getting Started
1. Review `docs/implementation_plan.md` for an overview of the solution approach.
2. For Task 1, upload the AIML package inside `task1/bot/` to Pandorabots and follow `task1/installation_guide.md`.
3. For Task 2, attach `task2/scripts/bubblerob_recovery.lua` to the BubbleRob object in CoppeliaSim and create the obstacles outlined in `task2/report.md`.
4. For Task 3, share `task3/proposal.md` as the formal project plan with stakeholders.

## Verification Notes
- AIML files were linted manually for tag balance and reference the correct map names.
- The BubbleRob Lua script follows CoppeliaSim’s `sysCall_*` interface and logs thermal anomalies to `mission_log.csv` when the simulation stops.
- Documentation across all tasks includes APA-style citations for referenced works.

