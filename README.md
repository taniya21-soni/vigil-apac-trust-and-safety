# Vigil-APAC: Multimodal Civic & Synthetic Media Policy Triage Framework

An end-to-end Trust & Safety audit, policy escalation, and quantitative operations framework built to triage high-risk synthetic media, medical misinformation, and graphic content in the APAC region.

---

## 📌 Project Overview
- **Objective:** Simulate a Tier-2/Tier-3 Trust & Safety Specialist workflow at scale—adjudicating ambiguous edge cases, resolving automated classification leakage, and drafting executive escalation briefs.
- **Focus Areas:** Indian General Elections / Civic Integrity, AI Deepfakes (Voice Clones), Medical Harm, and Graphic/Controversial Content.
- **Key Methodologies:** EDSA (Educational, Documentary, Scientific, Artistic) exemption analysis, SQL-based QA metrics, and SLA breach tracking.

---

## 📁 Repository Structure
```text
├── data/
│   └── incident_log_master.csv          # 15 granular edge cases across Indic languages
├── policies/
│   └── SOP_01_Civic_Integrity.md        # Standard Operating Procedure for synthetic media
├── escalations/
│   └── ESC-2024-001_Deepfake_Speech.md  # Executive Escalation Memo (P0 Election Incident)
├── analytics/
│   └── ops_metrics_dashboard.sql        # Production SQL computing error rates and SLA
└── README.md
