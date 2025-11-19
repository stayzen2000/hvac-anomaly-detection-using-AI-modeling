# AI HVAC Anomaly Detection – Data Cleaning & SQL Prep

This repository documents the first stage of my HVAC anomaly detection project:
**cleaning and preparing HVAC time-series data in PostgreSQL so it is ready for
machine learning and analysis.**

I'm building this as part of my journey into data science and as a practical
proof-of-concept for HVAC contractors I work with through my automation agency.

---

## 🔧 Project Goal

Build an **AI-powered early detection system** that can flag anomalies in HVAC
behavior **before** a system fails, so HVAC companies can:

- Get early alerts for unusual behavior
- Proactively contact customers (residential or commercial)
- Schedule diagnostics or repairs before major damage or failures

This repo covers **Step 1: data cleaning and preparation in PostgreSQL**.

---

## 📊 Dataset

- Source: Public HVAC dataset from Kaggle (time-series sensor data)
- Rough contents:
  - Temperature readings (return, supply, outdoor)
  - Relative humidity readings
  - Setpoint values
  - Power & energy consumption
  - System state (e.g., heating / cooling)
  - Anomaly flag (0 = normal, 1 = anomaly)

> ⚠️ Note: The dataset comes from earlier years and a different region, but it
> still serves as a strong starting point for prototyping an anomaly detection
> model.

---

## 🧱 Tech Stack

- **Database:** PostgreSQL
- **Interface:** pgAdmin
- **Languages:** SQL (for cleaning & transformations), Python (for later ML phase)
- **Next phase tools (planned):** pandas, scikit-learn (or similar), Jupyter/Colab

---

## 🗄️ Database Schema

Table: `hvac_clean`

Key columns (see `hvac_schema.sql` for full schema):

- `timestamp` – timestamp of the reading
- `t_return` – return air temperature
- `t_supply` – supply air temperature
- `t_outdoor` – outdoor air temperature
- `rh_return` – return air relative humidity
- `rh_supply` – supply air relative humidity
- `rh_outdoor` – outdoor air relative humidity
- `sp_return` – return air temperature setpoint
- `t_saturation` – saturation temperature
- `power_kw` – power consumption (kW)
- `energy_kwh` – energy consumption (kWh)
- `system_state` – operating mode (e.g., `heating`, `cooling`)
- `anomaly_flag` – `0` = normal, `1` = anomaly

Engineered features:

- `temp_error` – difference between actual return temp and setpoint  
  `temp_error = t_return - sp_return`
- `delta_supply_return` – difference between supply and return temps  
  `delta_supply_return = t_supply - t_return`

These additional features make it easier for machine learning models to detect
unusual behavior.

---

## 🧼 Data Cleaning & Feature Engineering

All SQL steps are in [`hvac_cleaning.sql`](./hvac_cleaning.sql), including:

- Creating the `hvac_clean` table from the raw data
- Adding engineered columns:
  - `temp_error`
  - `delta_supply_return`
- Normalizing text fields (e.g., lowercasing `system_state`)
- Basic sanity checks on ranges and missing values

Example snippet:

```sql
-- Preview cleaned data
SELECT *
FROM hvac_clean
LIMIT 10;