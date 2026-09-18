-- PHASE 4 — DRY-FRUIT MANUFACTURING OPERATIONS ANALYTICS
-- Dataset: Simulated_Dry_Fruit_Analytics_Project.xlsx
-- Purpose: Reproduce Phase 4 findings in SQL.
-- Assumption: Analysis_Calc has been loaded as a table named analysis_calc.
-- Important: This is synthetic portfolio data. Do not present outputs as real employer findings.

-- Q01. Machine downtime hotspot
SELECT Machine,
       COUNT(*) AS records,
       SUM(Downtime_Minutes) AS total_downtime_min,
       SUM(Downtime_Minutes) / NULLIF(SUM(Scheduled_Minutes), 0) * 100 AS downtime_rate_pct,
       SUM(Actual_Output_kg) / NULLIF(SUM(Target_Output_kg), 0) * 100 AS attainment_pct
FROM analysis_calc
GROUP BY Machine
ORDER BY total_downtime_min DESC;

-- Q02. Product reject-rate ranking
SELECT Product,
       COUNT(*) AS records,
       SUM(Rejects_kg) AS rejects_kg,
       SUM(Rejects_kg) / NULLIF(SUM(Actual_Output_kg), 0) * 100 AS reject_rate_pct,
       SUM(Actual_Output_kg) / NULLIF(SUM(Target_Output_kg), 0) * 100 AS attainment_pct
FROM analysis_calc
GROUP BY Product
ORDER BY reject_rate_pct DESC;

-- Q03. Shift attainment + HSE read-out
SELECT Shift,
       COUNT(*) AS records,
       SUM(Actual_Output_kg) / NULLIF(SUM(Target_Output_kg), 0) * 100 AS attainment_pct,
       SUM(Downtime_Minutes) / NULLIF(SUM(Scheduled_Minutes), 0) * 100 AS downtime_rate_pct,
       AVG(PPE_Compliance_pct) AS avg_ppe_pct,
       SUM(Safety_Observations) AS safety_observations,
       SUM(CASE WHEN Incident_Type <> 'No incident' THEN 1 ELSE 0 END) AS non_no_incident_records
FROM analysis_calc
GROUP BY Shift
ORDER BY attainment_pct ASC;

-- Q04. Shift × machine interaction analysis
SELECT Shift,
       Machine,
       COUNT(*) AS records,
       SUM(Actual_Output_kg) / NULLIF(SUM(Target_Output_kg), 0) * 100 AS attainment_pct,
       SUM(Downtime_Minutes) / NULLIF(SUM(Scheduled_Minutes), 0) * 100 AS downtime_rate_pct,
       SUM(Rejects_kg) / NULLIF(SUM(Actual_Output_kg), 0) * 100 AS reject_rate_pct,
       AVG(PPE_Compliance_pct) AS avg_ppe_pct,
       AVG(GMP_Score) AS avg_gmp_score,
       SUM(Safety_Observations) AS safety_observations,
       SUM(CASE WHEN Incident_Type <> 'No incident' THEN 1 ELSE 0 END) AS non_no_incident_records
FROM analysis_calc
GROUP BY Shift, Machine
ORDER BY attainment_pct ASC;

-- Q05. Downtime vs attainment association
-- DuckDB: CORR() is supported.
SELECT corr(Downtime_Rate_pct, Production_Attainment_pct) AS pearson_r
FROM analysis_calc;

-- Q06. GMP vs reject-rate association
SELECT corr(GMP_Score, Reject_Rate_pct) AS pearson_r
FROM analysis_calc;

-- Q07. PPE compliance vs safety observations
SELECT corr(PPE_Compliance_pct, Safety_Observations) AS pearson_r
FROM analysis_calc;

-- Q08. Maintenance duration vs downtime
SELECT corr(Maintenance_Duration_hr, Downtime_Minutes) AS pearson_r
FROM analysis_calc;

-- Q09. Maintenance-type downtime comparison
SELECT Maintenance_Type,
       COUNT(*) AS records,
       SUM(Downtime_Minutes) AS total_downtime_min,
       SUM(Downtime_Minutes) / NULLIF(SUM(Scheduled_Minutes), 0) * 100 AS downtime_rate_pct,
       AVG(Maintenance_Duration_hr) AS avg_maintenance_duration_hr
FROM analysis_calc
GROUP BY Maintenance_Type
ORDER BY downtime_rate_pct DESC;

-- Q10. Corrective-action status concentration by shift
SELECT Shift,
       SUM(CASE WHEN Corrective_Action_Status IN ('Open', 'In progress') THEN 1 ELSE 0 END) AS active_status_records,
       COUNT(*) AS records,
       SUM(CASE WHEN Corrective_Action_Status IN ('Open', 'In progress') THEN 1 ELSE 0 END)
           / CAST(COUNT(*) AS DOUBLE) * 100 AS active_status_pct
FROM analysis_calc
GROUP BY Shift
ORDER BY active_status_pct DESC;

-- Q11. Product × machine reject-rate matrix
SELECT Product,
       Machine,
       COUNT(*) AS records,
       SUM(Rejects_kg) AS rejects_kg,
       SUM(Rejects_kg) / NULLIF(SUM(Actual_Output_kg), 0) * 100 AS reject_rate_pct,
       SUM(Actual_Output_kg) / NULLIF(SUM(Target_Output_kg), 0) * 100 AS attainment_pct
FROM analysis_calc
GROUP BY Product, Machine
ORDER BY reject_rate_pct DESC;

-- Q12. Monthly operating trend
-- Assumes Date is imported as a DATE type in the SQL environment.
SELECT strftime('%Y-%m', CAST(Date AS DATE)) AS month,
       SUM(Target_Output_kg) AS target_kg,
       SUM(Actual_Output_kg) AS actual_kg,
       SUM(Actual_Output_kg) / NULLIF(SUM(Target_Output_kg), 0) * 100 AS attainment_pct,
       SUM(Downtime_Minutes) / NULLIF(SUM(Scheduled_Minutes), 0) * 100 AS downtime_rate_pct,
       SUM(Rejects_kg) / NULLIF(SUM(Actual_Output_kg), 0) * 100 AS reject_rate_pct
FROM analysis_calc
GROUP BY month
ORDER BY month;

-- Q13. Non-incident share by machine (HSE concentration)
SELECT Machine,
       COUNT(*) AS records,
       SUM(CASE WHEN Incident_Type <> 'No incident' THEN 1 ELSE 0 END) AS non_no_incident_records,
       SUM(CASE WHEN Incident_Type <> 'No incident' THEN 1 ELSE 0 END)
           / CAST(COUNT(*) AS DOUBLE) * 100 AS non_no_incident_pct,
       AVG(PPE_Compliance_pct) AS avg_ppe_pct,
       SUM(Safety_Observations) AS safety_observations
FROM analysis_calc
GROUP BY Machine
ORDER BY non_no_incident_pct DESC;

-- Portfolio interpretation guardrail:
-- Association is not causation. Use terms such as:
-- "appears associated with", "is concentrated in", "shows a pattern consistent with",
-- "may indicate", and "warrants further investigation".
