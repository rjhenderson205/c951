# Machine Learning Project Proposal – Predictive Maintenance for Municipal Bus Fleet

## A. Project Proposal

### A1. Organizational Need
The Regional Logistics Cooperative (RLC) operates a fleet of 650 municipal buses that support commuter transit across three counties. Unexpected vehicle breakdowns strand passengers, disrupt schedules, and incur premium repair costs. RLC needs a machine learning solution that predicts high-risk buses at least 48 hours before failure so maintenance teams can intervene proactively.

### A2. Context and Background
RLC currently relies on scheduled maintenance every 6,000 miles. This approach fails to account for heterogeneous wear across routes with steep grades, extreme weather, or stop frequency variations. Historical records show an average of 28 roadside failures per month, with each incident costing roughly $4,300 in towing, labor, and rider compensation. The cooperative already collects rich telemetry (engine temperature, vibration, battery voltage) through onboard sensors but only uses it for retrospective reporting.

### A3. Literature Review
1. **Li, Ding, and Sun (2020)** surveyed remaining useful life (RUL) estimation methods, concluding that feature fusion from sensor streams improves prognostics in fleet assets.
   - *Relation to project:* Informs our feature engineering strategy by emphasizing time-series degradation indicators rather than static thresholds.
2. **Wang, Chen, Qiao, and Snoussi (2019)** demonstrated a deep learning architecture combining convolutional and recurrent layers to forecast component failures in industrial systems.
   - *Relation to project:* Supports evaluating hybrid CNN-LSTM models for capturing local and temporal patterns within bus telemetry.
3. **New York City Open Data (2024)** provides the "Bus Breakdown and Delays" dataset, documenting incident causes and durations across transit fleets.
   - *Relation to project:* Offers an external benchmark for feature selection (e.g., weather overlays, route congestion) and a potential supplemental dataset for pre-training anomaly detectors.

### A4. Planned Solution Summary
We will build a predictive maintenance pipeline that ingests telemetry and maintenance logs, engineers time-windowed features, and trains supervised learning models (gradient boosted trees and sequence models) to classify buses into risk tiers (high, medium, low). Predictions feed a dispatch dashboard that lists recommended interventions and estimated failure probabilities.

### A5. Benefits of the Solution
- **Reduced downtime:** Anticipating high-risk buses lowers monthly roadside failures by an estimated 40%.
- **Cost savings:** Preventive maintenance scheduling cuts emergency repair spending, freeing budget for rider experience upgrades.
- **Improved safety and reliability:** Riders experience fewer service disruptions, enhancing public trust in the network.
- **Data-driven culture:** Maintenance staff transition from reactive to proactive workflows, improving morale and accountability.

## B. Project Plan

### B1. Scope Definition
- **In scope:** Data ingestion, cleaning, feature engineering, model training, evaluation, interpretability analysis, dashboard mockup, deployment playbook.
- **Out of scope:** Live integration with bus CAN systems, procurement of new sensors, organizational change management.

### B2. Goals, Objectives, Deliverables
- **Goal:** Deploy a pilot model that flags at-risk buses two days in advance with ≥85% precision on the high-risk class.
- **Objectives:**
  1. Consolidate two years of telemetry, maintenance logs, and weather data.
  2. Train and compare at least three ML algorithms (XGBoost, Random Forest, CNN-LSTM).
  3. Produce actionable maintenance recommendations and a prioritized work order list.
- **Deliverables:** Cleaned datasets, modeling notebooks, evaluation report, feature importance brief, deployment roadmap, stakeholder presentation deck.

### B3. Methodology (CRISP-DM)
- **Business Understanding:** Workshops with maintenance supervisors to refine risk thresholds and success metrics.
- **Data Understanding:** Exploratory analysis of telemetry streams, failure annotations, and external weather feeds.
- **Data Preparation:** Resample sensor data to 5-minute intervals, impute gaps, create rolling aggregates, label failure windows.
- **Modeling:** Train baseline tree-based models, then experiment with sequence models on rolling windows.
- **Evaluation:** Use time-based cross-validation and cost-sensitive metrics (precision, recall, maintenance cost savings).
- **Deployment:** Package winning model as a REST microservice, document inference schedule, and design monitoring dashboards.

### B4. Projected Timeline
| Phase | Tasks | Duration | Dates |
| --- | --- | --- | --- |
| Initiation | Stakeholder interviews, success metric alignment | 2 weeks | Oct 6–Oct 17, 2025 |
| Data Engineering | Data extraction, cleaning, labeling | 4 weeks | Oct 20–Nov 14, 2025 |
| Modeling | Baseline and advanced model development | 5 weeks | Nov 17–Dec 19, 2025 |
| Evaluation | Cost-benefit analysis, interpretability review | 2 weeks | Jan 5–Jan 16, 2026 |
| Deployment Prep | API design, monitoring plan, documentation | 3 weeks | Jan 19–Feb 6, 2026 |

### B5. Resources and Costs
- **Personnel:**
  - 1 ML engineer (0.6 FTE, 20 weeks) – $48,000
  - 1 Data engineer (0.4 FTE, 12 weeks) – $24,000
  - 0.2 FTE domain expert (maintenance supervisor) – $6,000
- **Infrastructure:**
  - Cloud compute (GPU instances for training) – $4,500
  - Storage and data transfer – $1,200
- **Software:**
  - Managed ML platform subscription (Azure ML or AWS Sagemaker) – $3,000
- **Contingency (10%)** – $8,250
- **Total Estimated Cost:** $86,750

### B6. Success Criteria
- Model precision ≥85% and recall ≥60% for high-risk predictions on the holdout set.
- Demonstrated reduction of simulated roadside failures by ≥30% in backtesting.
- Maintenance team adoption: at least 70% of high-risk work orders executed within 24 hours during pilot.

## C. Machine Learning Solution Design

### C1. Hypothesis
If we combine time-windowed telemetry, maintenance history, and contextual variables, we can accurately predict which buses will experience a critical failure within 48 hours, enabling proactive interventions.

### C2. Algorithm Selection
- **Primary:** Gradient Boosted Decision Trees (XGBoost) for tabular feature sets.
- **Secondary:** CNN-LSTM sequence model applied to normalized sensor windows.
- **Justification:**
  - **Advantage:** Gradient boosting handles heterogeneous features and missing values efficiently, delivering strong performance on structured maintenance data (Li et al., 2020).
  - **Limitation:** Tree ensembles struggle with very long temporal dependencies, motivating the inclusion of a sequence model for comparison.

### C3. Tools and Environments
- **Development:** Python 3.11, JupyterLab, scikit-learn, XGBoost, TensorFlow/Keras.
- **Data Pipeline:** Apache Airflow for scheduled ingestion, Azure Data Lake storage.
- **Version Control:** GitHub Enterprise repository with MLflow for experiment tracking.
- **Third-party APIs:** OpenWeatherMap for historical weather augmentation; NYC Open Data API as ancillary dataset for feature ideation.

### C4. Performance Measurement
- **Evaluation Metrics:** Precision, recall, F1 for the high-risk class; ROC-AUC; cost savings relative to reactive maintenance baseline.
- **Validation Strategy:** Time-series cross-validation with expanding window (train on past, validate on future segments) to prevent leakage.
- **Monitoring:** Post-deployment, track prediction drift, false positives/negatives, and maintenance compliance via weekly dashboards.

## D. Data Description

### D1. Data Sources
1. **RLC Telemetry Warehouse:** 5-minute sensor readings per bus (engine temperature, vibration RMS, battery state-of-charge, hydraulic pressure).
2. **Maintenance Work Orders:** SQL database capturing repair codes, parts replaced, labor hours, costs.
3. **Weather Context:** NOAA Integrated Surface Database for precipitation, ambient temperature, wind gusts along bus routes.

### D2. Data Collection Method
- Telemetry collected via onboard IoT gateway transmitting over LTE to the warehouse.
- Maintenance records entered by technicians through the CMMS (Computerized Maintenance Management System).
- Weather data pulled nightly via NOAA API filtered by depot coordinates.

#### D2a. Advantage and Limitation
- **Advantage:** Continuous telemetry offers high temporal resolution for detecting subtle degradation trends.
- **Limitation:** Cellular outages create missing intervals that require imputation, introducing potential bias if outages correlate with extreme conditions.

### D3. Data Preparation Steps
- Align telemetry and maintenance data by bus ID and time, generating labeled windows (48-hour horizon prior to failure events).
- Resample missing telemetry using median interpolation; flag imputed segments as binary features.
- Remove outliers via Hampel filters on each sensor channel.
- Normalize features per bus to account for unit-specific baselines.
- Encode categorical repair codes using target encoding with cross-validation to prevent leakage.

### D4. Handling Sensitive Data
- Telemetry lacks personally identifiable information, but maintenance logs include employee IDs. Restrict access through role-based controls, anonymize technicians in analytical datasets, and follow corporate policy for secure storage.
- Communicate insights without attributing blame to specific staff; focus on process improvements.

## E. References
Li, X., Ding, Q., & Sun, J. Q. (2020). Remaining useful life estimation in manufacturing systems: A review. *Journal of Manufacturing Systems, 57*, 168–186. https://doi.org/10.1016/j.jmsy.2020.08.004

New York City Open Data. (2024). *Bus breakdown and delays* [Dataset]. https://data.cityofnewyork.us/Transportation/Bus-Breakdown-and-Delays/ez4e-fazm

Wang, T., Chen, Y., Qiao, M., & Snoussi, H. (2019). Data-driven predictive maintenance approach based on deep learning techniques. *Reliability Engineering & System Safety, 170*, 120–132. https://doi.org/10.1016/j.ress.2017.10.019
