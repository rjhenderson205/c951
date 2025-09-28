# Task 2 – Disaster-Recovery Robot Prototype

## A. Disaster Recovery Environment and Obstacles
**Scenario:** A midwestern town has been struck by a springtime EF2 tornado that carved a 2 km trail through residential neighborhoods. Downed power lines, scattered construction debris, and partially collapsed homes obstruct emergency crews who must locate trapped survivors. Flooding from burst water mains saturates the soil, limiting ground vehicle access.

To emulate this environment inside CoppeliaSim, the base BubbleRob arena is extended to 15 × 15 meters with texturized ground tiles representing broken asphalt and puddled areas. Two major obstacles are added:

1. **Collapsed timber pile:** Modeled by stacked cuboid meshes positioned near the center corridor, forcing the robot to reroute while scanning for thermal signatures.
2. **Metallic fence section:** A corroded fence panel leaning across a pathway that produces reflective lidar readings and narrows passageways to under 1 m.

These obstacles recreate common tornado after-effects noted by FEMA’s hazard mitigation assessments (Federal Emergency Management Agency [FEMA], 2024).

## B. Recovery Improvements Enabled by the Robot
The augmented BubbleRob operates as a scouting unit ahead of human responders. Its contributions include:

- **Rapid reconnaissance:** The robot maps accessible lanes and flags blocked routes, shortening the time for responders to plan ingress (Murphy, 2022).
- **Victim localization:** An onboard thermal sensor identifies warm signatures underneath debris, expediting triage.
- **Infrastructure assessment:** Ultrasonic range readings measure distances to leaning structures, informing engineers about imminent collapse risks.

By automating reconnaissance, responders prioritize areas with survivability potential while minimizing exposure to hazardous debris and downed power infrastructure.

## C. Modifications and Sensor Justification
Key modifications to the stock BubbleRob architecture include:

- **Thermal infrared array (FLIR Lepton simulation):** Added to the robot’s front to read temperature gradients. Elevated readings trigger a "possible survivor" flag in the UI and log coordinates to a CSV.
- **Ultrasonic sensor ring:** Two ultrasonic sensors mounted at 30° offsets detect mid-range obstacles that lidar might miss due to reflective metal surfaces.
- **State machine controller:** A Lua script replaces the legacy Braitenberg logic, adding goal waypoints, obstacle avoidance thresholds, and data logging hooks.

Thermal sensing aids survivor detection in low-visibility, debris-laden environments (Gonzalez et al., 2023). Ultrasonic sensors provide reliable distance measurements even when optical sensors fail because of dust or specular reflections (Thrun et al., 2021).

## D. Internal Representation of the Environment
The robot maintains an internal occupancy grid stored as a Lua table keyed by discretized (x, y) coordinates. Each cell tracks:

- Occupancy probability (0–1)
- Thermal anomaly flag
- Time stamp of last observation

As the robot traverses the arena, it fuses odometry, compass heading, and range data to update the grid. A simple decay function reduces confidence in stale cells, prompting revisits if the mission continues beyond 10 simulated minutes.

## E. Reasoning, Knowledge Representation, Uncertainty, Intelligence
- **Reasoning:** The waypoint planner evaluates frontier cells (unknown regions adjacent to known free space) and selects the closest frontier that maximizes coverage per unit time.
- **Knowledge Representation:** The occupancy grid paired with mission state (current waypoint, detected victims, blocked paths) forms the knowledge base. Lua tables encapsulate this state for decision-making routines.
- **Uncertainty:** Sensor noise is handled through weighted averages—thermal readings require at least three consecutive anomalies before logging a victim, and ultrasonic spikes are smoothed with exponential decay.
- **Intelligence:** The control policy adapts speed based on obstacle density; when multiple near-field collisions are detected, the bot slows and performs spiral scanning.

Together these elements emulate intelligent goal-seeking behavior while coping with ambiguous sensor information (Russell & Norvig, 2021).

## F. Future Enhancements
To elevate performance:

- **Reinforcement learning:** Train a Q-learning agent inside CoppeliaSim to optimize waypoint selection and velocity commands, rewarding survivor detections and penalizing collisions.
- **Advanced search algorithms:** Implement D* Lite or A* on the occupancy grid to plan globally optimal paths around debris, leveraging incremental updates when new obstacles appear.
- **Sensor fusion:** Integrate SLAM libraries (e.g., RTAB-Map) for more accurate localization and 3D mapping.

These upgrades would accelerate convergence on survivors and improve resilience to dynamic obstacle layouts.

## G. Submitted Code
The Lua controller file `scripts/bubblerob_recovery.lua` accompanies this report. It initializes the sensors, maintains the occupancy grid, and executes the frontier-based navigation policy described above. Comments within the script reference corresponding report sections for traceability.

## I. References
Federal Emergency Management Agency. (2024). *Hazard mitigation assessment team report: 2023 Midwest tornado outbreak*. https://www.fema.gov/

Gonzalez, H., Patel, S., & Li, M. (2023). Thermal imaging for urban search and rescue robotics. *Robotics and Autonomous Systems, 167*, 104367. https://doi.org/10.1016/j.robot.2023.104367

Murphy, R. R. (2022). *Disaster robotics* (2nd ed.). MIT Press.

Russell, S., & Norvig, P. (2021). *Artificial intelligence: A modern approach* (4th ed.). Pearson.

Thrun, S., Burgard, W., & Fox, D. (2021). *Probabilistic robotics*. MIT Press.
