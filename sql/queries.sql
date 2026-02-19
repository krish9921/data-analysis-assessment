/*
================================================================================
Task 2 – SQL Analysis

Please write queries below to answer the following questions.
Assume standard SQL syntax (e.g., PostgreSQL or SQLite).
================================================================================
*/

-- 1. Number of users by region and platform
-- SELECT 
      region, 
      platform, 
      COUNT(DISTINCT user_id) as user_count
  FROM users 
  GROUP BY region, platform 
  ORDER BY user_count DESC;


-- 2. Number of devices per user
-- SELECT 
    u.user_id, 
    COUNT(d.device_id) as device_count
FROM users u
LEFT JOIN devices d ON u.user_id = d.user_id 
GROUP BY u.user_id 
ORDER BY device_count DESC, u.user_id;


-- 3. Event volume per device type per day
-- SELECT 
    DATE(e.ts) as event_date,
    d.device_type, 
    COUNT(*) as event_volume
FROM events e
JOIN devices d ON e.device_id = d.device_id
GROUP BY DATE(e.ts), d.device_type
ORDER BY event_date, event_volume DESC;


-- 4. Identify devices with unusually high event volume
-- (Explain your reasoning for "unusually high" in a comment)
-- WITH device_stats AS (
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
ORDER BY total_events DESC;

--For unusually high event volume, I defined it as top 5% using NTILE(20). This finds the busiest 5% of devices without needing complex stats like mean+3*stddev.

