-- Trust & Safety Hyderabad Content Ops: Model Discrepancy & SLA Compliance Engine
WITH ModelEvaluations AS (
    SELECT 
        Case_ID,
        Language,
        Enforcement_Action,
        Violation_Policy,
        SLA_Minutes,
        Escalation_Tier,
        CASE 
            WHEN Auto_Model_Prediction LIKE 'Policy Violation%' THEN 'Model_Flagged'
            ELSE 'Model_Cleared'
        END AS Model_Classification,
        CASE 
            WHEN Enforcement_Action IN ('Immediate Removal + Strike', 'Content Removal', 'Age-Restricted', 'Terminate Stream + Strike') 
            THEN 'Human_Enforced'
            ELSE 'Human_Cleared'
        END AS Final_Adjudication,
        CASE 
            WHEN Escalation_Tier = 'P0' AND SLA_Minutes > 15 THEN 1
            WHEN Escalation_Tier = 'P1' AND SLA_Minutes > 60 THEN 1
            WHEN Escalation_Tier = 'P2' AND SLA_Minutes > 120 THEN 1
            ELSE 0
        END AS SLA_Breach_Flag
    FROM `incident_log_master`
),

PerformanceAggregation AS (
    SELECT 
        Language,
        COUNT(Case_ID) AS Total_Cases,
        -- False Positive: Model flagged violation, but human cleared (e.g. EDSA applies)
        SUM(CASE WHEN Model_Classification = 'Model_Flagged' AND Final_Adjudication = 'Human_Cleared' THEN 1 ELSE 0 END) AS False_Positives,
        -- False Negative: Model missed content, but human had to take enforcement action
        SUM(CASE WHEN Model_Classification = 'Model_Cleared' AND Final_Adjudication = 'Human_Enforced' THEN 1 ELSE 0 END) AS False_Negatives,
        -- Correct alignments
        SUM(CASE WHEN Model_Classification = 'Model_Flagged' AND Final_Adjudication = 'Human_Enforced' THEN 1 ELSE 0 END) AS True_Positives,
        SUM(CASE WHEN Model_Classification = 'Model_Cleared' AND Final_Adjudication = 'Human_Cleared' THEN 1 ELSE 0 END) AS True_Negatives,
        SUM(SLA_Breach_Flag) AS Total_SLA_Breaches,
        ROUND(AVG(SLA_Minutes), 1) AS Mean_Handle_Time_Mins
    FROM ModelEvaluations
    GROUP BY Language
)

SELECT 
    Language,
    Total_Cases,
    False_Positives,
    False_Negatives,
    ROUND((False_Negatives::FLOAT / NULLIF(Total_Cases, 0)) * 100, 2) AS Model_Leakage_Rate_Pct,
    ROUND(((True_Positives + True_Negatives)::FLOAT / NULLIF(Total_Cases, 0)) * 100, 2) AS Reviewer_Model_Alignment_Pct,
    Total_SLA_Breaches,
    Mean_Handle_Time_Mins
FROM PerformanceAggregation
ORDER BY Total_Cases DESC;
