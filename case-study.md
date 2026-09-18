# Dry-Fruit Manufacturing Operations Performance & HSE Analytics

## Executive summary

This portfolio project is a **simulated manufacturing analytics case study** built around a dry-fruit production environment. The working dataset contains 540 synthetic manufacturing records covering production, downtime, quality, maintenance and HSE-related signals.

The project followed an end-to-end analytics workflow: business-question framing, data understanding, data-quality checking, KPI calculation, spreadsheet analysis, SQL reproduction, deeper relationship testing, management dashboarding, and recommendation development.

The analysis identified several recurring patterns in the simulated data. Downtime showed the strongest relationship with production attainment; Dryer 3 had the highest simulated downtime burden; Shift C was the weakest simulated shift on attainment; the Shift C × Dryer 3 combination was the strongest diagnostic hotspot; and Dried Mango × Dryer 3 had the highest product-machine reject rate.

These are **illustrative findings from synthetic data**. They do not represent actual employer performance and should not be used as evidence that any real machine, shift, product or employee group is responsible for operational losses.

## 1. Business problem

The core business question was:

> What operational factors appear to be driving production underperformance, quality losses and HSE exposure?

The analysis was deliberately designed around business questions rather than starting with charts.

## 2. Dataset and scope

- 540 synthetic production records.
- Products: Dried Mango, Dried Pineapple, Desiccated Coconut.
- Machines: Dryer 1, Dryer 2, Dryer 3, Dryer 4.
- Shifts: Shift A, Shift B, Shift C.
- Measures include target and actual output, downtime, rejects, rework, PPE compliance, housekeeping, GMP, safety observations, incident type, corrective-action status, maintenance duration and fuel use.

## 3. KPI framework

Production attainment = Actual Output / Target Output × 100

Reject rate = Rejects / Actual Output × 100

Downtime rate = Downtime Minutes / Scheduled Minutes × 100

Net good output = Actual Output − Rejects

The workbook also contains an **OEE-like** metric. It is intentionally not described as formal OEE because a full OEE methodology and all required components have not been established.

## 4. Analytical approach

1. Understand the data and row structure.
2. Check data types, missing values, duplicates and plausible ranges.
3. Calculate and validate core operational KPIs.
4. Analyse machine, product, shift and month performance.
5. Reproduce core analyses in SQL.
6. Test deeper relationships and interactions.
7. Stress-test key relationships across machine and shift subgroups.
8. Build a management-oriented dashboard.
9. Translate findings into investigation priorities rather than unsupported root-cause claims.

## 5. Key findings from the simulated dataset

### Finding 1 — Downtime is the strongest operational loss signal

Overall record-level downtime versus production-attainment correlation is approximately **-0.663**. The negative relationship remains present at machine and shift level, which makes the pattern more defensible than an aggregate relationship that disappears after segmentation.

**Interpretation:** Higher downtime observations tend to coincide with lower attainment in this simulation.

**Do not claim:** Downtime was proven to cause the production losses.

### Finding 2 — Dryer 3 carries the highest simulated downtime burden

Dryer 3 records approximately **8,668 downtime minutes** and a **13.41% downtime rate**, the highest among the four simulated machines.

**Management implication:** Dryer 3 is a sensible first candidate for diagnostic review in the simulated case.

### Finding 3 — Shift C is the weakest simulated shift on attainment

Shift C records approximately **84.51% production attainment** and the highest downtime rate at shift level.

**Management implication:** The simulated evidence supports reviewing shift operating context, including handover, workload, escalation and corrective-action backlog.

### Finding 4 — Shift C × Dryer 3 is the strongest diagnostic hotspot

The Shift C × Dryer 3 combination has approximately:

- **80.47% attainment**
- **15.38% downtime rate**
- **4.51% reject rate**

This is a multi-dimensional hotspot and a better diagnostic target than treating either Shift C or Dryer 3 in isolation.

### Finding 5 — Dried Mango × Dryer 3 is the highest product-machine reject cohort

The Dried Mango × Dryer 3 cohort has a reject rate of approximately **4.82%**, the highest observed product-machine combination in the simulation.

**Management implication:** Quality investigation should move beyond product-level averages and examine the product-machine interaction.

### Finding 6 — Some HSE relationships are weak

The simulated relationships between GMP and reject rate, and between PPE compliance and safety observations, are weak.

**Management implication:** These measures should remain contextual indicators rather than being presented as explanatory drivers. Better HSE fields would allow stronger analysis.

## 6. Prioritised recommendations

### Priority 1 — Diagnose Dryer 3 / Shift C

Review event-level downtime reasons, repeat stoppages, operating context and action backlog for the combination showing the weakest simulated performance.

### Priority 2 — Improve downtime taxonomy

Capture structured stop reasons, start/end times, loss categories, recurrence flags and validated maintenance context. This would make future root-cause analysis substantially stronger.

### Priority 3 — Drill into Dried Mango × Dryer 3 quality losses

Add process-condition variables such as moisture, temperature, recipe/setting information, defect category and quality checkpoint results.

### Priority 4 — Review Shift C operating context

Validate handover quality, staffing/loading, escalation routes, operating conditions and corrective-action closure status.

### Priority 5 — Improve HSE analytical granularity

Add severity, exposure hours, corrective-action age, owner, due date and repeat-occurrence fields.

## 7. Limitations and disclosure

- The entire working dataset is synthetic.
- Some patterns were deliberately embedded for educational demonstration.
- Findings are illustrative and do not represent actual employer performance.
- Association does not establish causation.
- Real-world operational decisions require validated production, maintenance, quality and HSE records.
- The dataset does not contain enough contextual variables to establish actual root causes.
- July contains only nine records and should be treated cautiously in trend interpretation.

## 8. What this project demonstrates

This case study demonstrates the ability to:

- Translate an operational problem into analytical questions.
- Work with structured manufacturing data.
- Perform data-quality checks.
- Calculate operational KPIs.
- Aggregate and compare performance across business dimensions.
- Reproduce analyses in SQL.
- Test relationships without overstating causality.
- Build a management-oriented dashboard.
- Translate analysis into prioritised recommendations.
- Communicate analytical limitations clearly.

## 9. Recommended next technical extension

The strongest next technical extension is to reproduce the analysis in **Python/pandas** using a notebook that:

- loads the dataset;
- runs automated data-quality checks;
- calculates the core KPIs;
- reproduces the main SQL analyses;
- generates the deeper statistical tests;
- exports clean tables for dashboarding;
- documents the analytical decisions reproducibly.

This would turn the project from a strong spreadsheet/SQL portfolio case into a more reproducible analytics workflow.
