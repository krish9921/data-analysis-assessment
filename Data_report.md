# Student Screening: Real World Project Opportunity
# Krishna Shah
> **Lead / Reference:** Thiago Castilho
> **Duration:** 48 Hours

## Overview

Welcome! This repository represents a technical screening exercise designed to evaluate your readiness for a real-world enterprise project within the Centennial College ARIES department.

This is not just a test; it is an opportunity to demonstrate how you think, how you code, and how you communicate technical findings.

## Tasks

### Task 1 – Data Understanding (Documentation)

**Data Quality:**

- Users: 121 rows, 0 missing values
- Devices: 450 rows
- Events: 15000 rows

**Analysis Highlights:**
- Time period: 2024-01-01 00:11:37+00:00 to 2024-02-07 23:54:05+00:00
- Busiest device: 1517 events
- Avg events/device: 33.3

**Main Entities:**
- users.csv: Contains user profiles with user_id, region, platform
- devices.csv: IoT devices linked to users by user_id, includes device_type  
- events.csv: Device telemetry with device_id, ts timestamp, type, and JSON payload

**Data Quality Issues:**
- No duplicate rows found across tables
- Minimal missing values observed
- Events payload contains parseable JSON with device metrics

**Payload Handling:**
Parsed JSON payload field using pd.json_normalize(). Key fields extracted for analysis.

**Assumptions Made:**
- user_id uniquely identifies users across tables
- ts column in events contains UTC timestamps  
- device_id uniquely identifies devices
- Missing regions treated as "Unknown" in analysis
---

### Task 2 – SQL Analysis

In `sql/queries.sql`, write valid SQL queries to answer the following questions. You can assume standard SQL syntax (e.g., PostgreSQL or SQLite).

1.  **SELECT 
      region, 
      platform, 
      COUNT(DISTINCT user_id) as user_count
  FROM users 
  GROUP BY region, platform 
  ORDER BY user_count DESC;**
2.  **SELECT 
    u.user_id, 
    COUNT(d.device_id) as device_count
FROM users u
LEFT JOIN devices d ON u.user_id = d.user_id 
GROUP BY u.user_id 
ORDER BY device_count DESC, u.user_id;**
3.  **SELECT 
    DATE(e.ts) as event_date,
    d.device_type, 
    COUNT(*) as event_volume
FROM events e
JOIN devices d ON e.device_id = d.device_id
GROUP BY DATE(e.ts), d.device_type
ORDER BY event_date, event_volume DESC;**
4.  **WITH device_stats AS (
    SELECT 
        device_id, 
        COUNT(*) as total_events,
        NTILE(20) OVER (ORDER BY COUNT(*) DESC) as percentile_rank
    FROM events 
    GROUP BY device_id
)
SELECT 
    device_id, 
    total_events
FROM device_stats 
WHERE percentile_rank <= 5
ORDER BY total_events DESC;** (For unusually high event volume, I defined it as top 5% using NTILE(20). This finds the busiest 5% of devices without needing complex stats like mean+3*stddev.).

*Please explain your assumptions using SQL comments.*

---

### Task 3 – Exploratory Analysis (Python)

** Data Cleaning: You implemented a safe_json_load function to handle the JSON payloads and used pd.json_normalize to extract metadata and status codes.

Visualizations: You generated several charts, including:

Device Type Activity Levels: A boxplot comparing event counts across different device types (e.g., fans, smart plugs, heaters).

Network Comparison: Code specifically designed to test activity differences between Ayla and Tuya devices. **

---

### Task 4 – Hypotheses & Questions

Hypothesis 1: Users with more devices generate more frequent events.
Methodology: aggregated the data by user_id to count unique devices and total events, then calculated the Pearson correlation coefficient.

Result:  correlation result was 0.254.

Verdict: Partially Supports. * Explanation: While there is a positive relationship (as one goes up, the other tends to follow), a correlation of 0.254 is considered weak. This suggests that while more devices contribute to more data, individual device behavior or specific "noisy" users might be more influential than just the raw device count.

Hypothesis 2: There are significant regional differences in event volume.
Methodology:  grouped the events_full dataframe by region and calculated the total event count and unique device count per region, visualizing it with a bar chart.

Result: United States is the primary driver of all traffic; requires cleaning to see clearly

Verdict: Supports. The data confirms that geographical location is a major factor in telemetry volume.

Explanation: The data shows which regions are driving the most telemetry. 

Hypothesis 3: Specific device types (like Fans) are more active than others.
Methodology: You calculated the mean events per device type and used a boxplot to see the distribution of activity.

Result: output shows fans have an average of 54.62 events, while all other categories (door sensors, heaters, etc.) hover around 29–31.

Verdict: Supports.

Explanation: There is a clear statistical outlier in behavior. Fans generate nearly double the average events of any other device type. This could indicate that fans report status more frequently or that they are the most interacted-with device in the dataset.

---

### Task 5 – Reflection

Answer briefly (in README or Notebook):
*   What **additional data** would improve this analysis?
# User Engagement Logs: We have device events, but we don't know if an event was a "manual" user press in the app or an "automatic" scheduled heartbeat. Knowing this would explain the high volume in certain devices.

# Standardized Geography: A master lookup table for regions would prevent the "US/USA/United States" naming mess you encountered.

# Error Codes: Including a status_code or error_type column would help determine if "noisy" devices (high event counts) are actually malfunctioning. 
*   What **limitations** prevent deeper insights?
# Data Fragmentation: The need to merge three separate tables just to see activity by region makes real-time analysis difficult.

# Temporal Limits: A 5-week window is too short to see long-term trends or seasonal behavior (e.g., do Fans drop off in winter?).

# Missing Metadata: A large portion of the devices table (over 100 rows) is missing location (Office, Bedroom, etc.), which prevents us from knowing where in the home the activity is happening
**
*   What would you explore next if this were Phase 0 of a larger project?

# I would specifically deep-dive into the fan device type. Since it averages 54.6 events (double the others), I’d check if this is a firmware bug or just high user frequency.

# Clustering Users: I’d group users into "Power Users" (multiple devices, high frequency) vs. "Passive Users" to help the marketing team understand which segment is most active.

# Predictive Maintenance: Use the event frequency to predict when a device might fail. If a smart_bulb suddenly jumps from 30 events a day to 300, it might be about to burn out.
---

## Submission Instructions

1.  **Fork** this repository.
2.  **Commit often & clearly:** We want to see your progress.
    *   Avoid one single massive commit.
    *   Use meaningful commit messages (explain *why*, not just *what*).
3.  **Submit the GitHub link** before the interview.

### Deliverables
*   **Git repository link.**
*   **Completed Notebook** (`notebooks/analysis.ipynb`).
*   **SQL Queries** (`sql/queries.sql`).
*   **Documentation** (updated `README.md` or `DATA_REPORT.md`).

---


