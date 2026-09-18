-- PHASE 5 — DRY-FRUIT MANUFACTURING ANALYTICS SQL PACK
-- Synthetic portfolio dataset. Association does not establish causation.

-- 01. Robustness: machine-level downtime and attainment
SELECT Machine,
       COUNT(*) AS records,
       SUM(Downtime_Minutes) / NULLIF(SUM(Scheduled_Minutes),0) * 100 AS downtime_rate_pct,
       SUM(Actual_Output_kg) / NULLIF(SUM(Target_Output_kg),0) * 100 AS attainment_pct
FROM data
GROUP BY Machine
ORDER BY downtime_rate_pct DESC;

-- 02. Robustness: shift-level downtime and attainment
SELECT Shift,
       COUNT(*) AS records,
       SUM(Downtime_Minutes) / NULLIF(SUM(Scheduled_Minutes),0) * 100 AS downtime_rate_pct,
       SUM(Actual_Output_kg) / NULLIF(SUM(Target_Output_kg),0) * 100 AS attainment_pct
FROM data
GROUP BY Shift
ORDER BY attainment_pct ASC;

-- 03. Product × machine quality hotspot
SELECT Product,
       Machine,
       COUNT(*) AS records,
       SUM(Rejects_kg) / NULLIF(SUM(Actual_Output_kg),0) * 100 AS reject_rate_pct,
       SUM(Actual_Output_kg) / NULLIF(SUM(Target_Output_kg),0) * 100 AS attainment_pct
FROM data
GROUP BY Product, Machine
ORDER BY reject_rate_pct DESC;

-- 04. Shift × product interaction
SELECT Shift,
       Product,
       COUNT(*) AS records,
       SUM(Actual_Output_kg) / NULLIF(SUM(Target_Output_kg),0) * 100 AS attainment_pct,
       SUM(Downtime_Minutes) / NULLIF(SUM(Scheduled_Minutes),0) * 100 AS downtime_rate_pct,
       SUM(Rejects_kg) / NULLIF(SUM(Actual_Output_kg),0) * 100 AS reject_rate_pct
FROM data
GROUP BY Shift, Product
ORDER BY attainment_pct ASC;

-- 05. Active corrective-action concentration
SELECT Shift,
       COUNT(*) AS records,
       SUM(CASE WHEN Corrective_Action_Status IN ('Open','In progress') THEN 1 ELSE 0 END) AS active_records,
       SUM(CASE WHEN Corrective_Action_Status IN ('Open','In progress') THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS active_rate_pct
FROM data
GROUP BY Shift
ORDER BY active_rate_pct DESC;

-- 06. Monthly stability check
SELECT strftime('%Y-%m', Date) AS month,
       COUNT(*) AS records,
       SUM(Actual_Output_kg) / NULLIF(SUM(Target_Output_kg),0) * 100 AS attainment_pct,
       SUM(Downtime_Minutes) / NULLIF(SUM(Scheduled_Minutes),0) * 100 AS downtime_rate_pct,
       SUM(Rejects_kg) / NULLIF(SUM(Actual_Output_kg),0) * 100 AS reject_rate_pct
FROM data
GROUP BY month
ORDER BY month;

-- 07. Maintenance type diagnostic
SELECT Maintenance_Type,
       COUNT(*) AS records,
       AVG(Maintenance_Duration_hr) AS avg_maintenance_duration_hr,
       SUM(Downtime_Minutes) / NULLIF(SUM(Scheduled_Minutes),0) * 100 AS downtime_rate_pct
FROM data
GROUP BY Maintenance_Type
ORDER BY downtime_rate_pct DESC;

-- 08. HSE signal concentration
SELECT Shift,
       Machine,
       COUNT(*) AS records,
       SUM(CASE WHEN Incident_Type <> 'No incident' THEN 1 ELSE 0 END) AS non_incident_records,
       SUM(CASE WHEN Incident_Type <> 'No incident' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS non_incident_rate_pct
FROM data
GROUP BY Shift, Machine
ORDER BY non_incident_rate_pct DESC;

-- 09. Dryer 3 diagnostic cohort
SELECT Shift,
       Product,
       COUNT(*) AS records,
       SUM(Downtime_Minutes) / NULLIF(SUM(Scheduled_Minutes),0) * 100 AS downtime_rate_pct,
       SUM(Actual_Output_kg) / NULLIF(SUM(Target_Output_kg),0) * 100 AS attainment_pct,
       SUM(Rejects_kg) / NULLIF(SUM(Actual_Output_kg),0) * 100 AS reject_rate_pct
FROM data
WHERE Machine = 'Dryer 3'
GROUP BY Shift, Product
ORDER BY attainment_pct ASC;

-- 10. Data needed for causal validation
-- Add event-level downtime reason, failure mode, staffing/work content,
-- process parameters, defect reason, exposure hours, action ageing/owner,
-- and planned/unplanned maintenance status before causal claims.
