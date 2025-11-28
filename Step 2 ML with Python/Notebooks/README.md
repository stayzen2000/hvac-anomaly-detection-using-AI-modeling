# HVAC Anomaly Detection Using Machine Learning

A complete AI-powered anomaly detection system for HVAC performance monitoring using historical sensor data.

## Features

- **Full data cleaning** — SQL + Python pipelines
- **Time-series train/validation/test split** — Prevents data leakage
- **Random Forest ML model** — Fast, interpretable, and highly accurate
- **Comprehensive metrics** — Confusion matrix + classification reports
- **Feature importance analysis** — Understand what drives anomalies
- **Interactive anomaly tester** — User-friendly tool for any skill level (HVAC techs, recruiters, data scientists)
- **Human-friendly interface** — Real feature names + normal operating ranges

This project demonstrates real-world data science skills: feature engineering, modeling, evaluation, interpretability, and practical application design.

---

## Project Overview

HVAC systems generate continuous telemetry (temperatures, humidity, power usage, energy consumption). Manually identifying abnormal behavior is difficult and often leads to:

- Inefficient operation
- Increased costs
- Poor indoor comfort
- Equipment stress or failure

This project uses machine learning to automatically identify anomalous HVAC performance from historical data. A major highlight is an **interactive anomaly checker** that allows anyone—even with zero HVAC knowledge—to input values and receive a prediction (NORMAL vs ANOMALY) with anomaly probability.

---

## Dataset & Features

### Raw Features

| Feature | Description |
|---------|-------------|
| `t_supply` | Supply air temperature (°C) |
| `t_return` | Return air temperature (°C) |
| `t_outdoor` | Outdoor temperature (°C) |
| `rh_supply` | Supply air humidity (%) |
| `rh_return` | Return air humidity (%) |
| `rh_outdoor` | Outdoor humidity (%) |
| `power_kw` | Power usage (kW) |
| `energy_kwh` | Daily accumulated energy (kWh) |

### Engineered Features

Created using SQL + Python:

- `delta_supply_return` — Supply temp − return temp (HVAC effectiveness)
- `temp_error` — Return − supply temperature difference
- `sp_return` — Return air setpoint

### Target Variable

- `anomaly_flag`
  - `0` = Normal
  - `1` = Anomaly

---

## Data Preparation

The dataset was cleaned and labeled using SQL:

- Fixed timestamps
- Created engineered features
- Labeled anomalies using domain rules
- Exported cleaned dataset to CSV

Data was then loaded into Python for modeling.

---

## Time-Based Train/Val/Test Split

To avoid data leakage, a chronological split is used:

```python
df['timestamp'] = pd.to_datetime(df['timestamp'])
df = df.sort_values('timestamp')

n = len(df)
train_end = int(0.70 * n)
val_end = int(0.85 * n)

train_df = df[:train_end]      # 70% training
val_df   = df[train_end:val_end]       # 15% validation
test_df  = df[val_end:]        # 15% test (final evaluation)
```

---

## Model: Random Forest Classifier

Random Forest was chosen because it:

- Handles nonlinear patterns
- Works extremely well on tabular data
- Provides feature importance scores
- Is robust and stable

### Training

```python
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report

rf = RandomForestClassifier(
    n_estimators=200,
    max_depth=None,
    random_state=42,
    n_jobs=-1
)

rf.fit(X_train, y_train)
```

---

## Model Performance

### Validation Results

High precision and recall for both classes.

### Test Results (Final Evaluation)

The model achieved near-perfect metrics on unseen data:

| Metric | Score |
|--------|-------|
| Precision | 1.00 |
| Recall | 1.00 |
| F1-score | 1.00 |

These results indicate that engineered features perfectly separate normal vs anomalous HVAC states, demonstrating excellent generalization.

---

## Confusion Matrix & Feature Importance

### Confusion Matrix

Shows almost no misclassification on test data.

### Top Important Features

According to the Random Forest model:

1. `power_kw`
2. `delta_supply_return`
3. `t_return`
4. `energy_kwh`
5. `t_supply`

These align closely with HVAC physics—abnormal power draw and temperature deltas are strong indicators of anomalies.

---

## Interactive Anomaly Tester

This project includes a full interactive tester where users manually enter HVAC readings and receive instant predictions.

### Features

- Human-friendly names for all parameters
- Typical "normal ranges" based on dataset statistics
- Instant prediction (NORMAL vs ANOMALY)
- Anomaly probability score

### Example Usage

```
Power Usage (kW) (normal: 0.35 to 7.90): [user input]
Return Air Temperature (°C) (normal: 15.1 to 24.9): [user input]
...

--- Prediction Result ---
Prediction: ANOMALY
Anomaly probability: 0.98
```

### Normal Operating Ranges

Computed using 5th–95th percentile values from normal rows:

```python
normal_df = df[df["anomaly_flag"] == 0]
range_info = normal_df[features].quantile([0.05, 0.95]).T
range_info.columns = ["p05", "p95"]
range_info = range_info.round(2)
```

### Human-Friendly Labels

```python
friendly_names = {
    "power_kw": "Power Usage (kW)",
    "delta_supply_return": "Temperature Difference: Supply Air - Return Air (°C)",
    "t_return": "Return Air Temperature (°C)",
    "energy_kwh": "Total Energy Used Today (kWh)",
    "t_supply": "Supply Air Temperature (°C)",
    "rh_outdoor": "Outdoor Humidity (%)",
    "temp_error": "Temperature Error (Return - Supply) (°C)",
    "rh_return": "Indoor Humidity (%)",
    "sp_return": "Return Air Setpoint (°C)",
    "rh_supply": "Supply Air Humidity (%)",
    "t_outdoor": "Outdoor Temperature (°C)",
    "t_saturation": "Saturation Temperature (°C)",
}
```

### Prediction Wrapper

The `predict_hvac_status()` function builds a DataFrame in the correct feature order, runs the model, and prints the result (NORMAL/ANOMALY) with probability.

### Running the Interactive Tool

```python
interactive_hvac_prediction()
```

## How to Try the Model (Interactive Anomaly Tester)

This project includes an **interactive console tool** that allows anyone — even without HVAC knowledge — to manually enter HVAC readings and see whether the model predicts:

- **NORMAL operation**, or
- **ANOMALY detected**

The tool also shows the **probability of anomaly**, giving deeper insight into borderline cases.

### Step-by-Step Instructions

#### 1. Launch Jupyter Notebook

In your terminal:

```bash
jupyter notebook
```

Open the main notebook (e.g., `hvac_model.ipynb`).

#### 2. Run All Cells

In the Jupyter menu:

```
Kernel → Restart & Run All
```

This loads the data, trains the model, computes normal ranges, and initializes the interactive tool.

#### 3. Scroll to the "Interactive Tester" Section

You will see this function defined:

```python
interactive_hvac_prediction()
```

#### 4. Run the Cell Containing the Interactive Function

You will then see input prompts like:

```
Power Usage (kW)  (normal: 0.35 to 7.90):
Return Air Temperature (°C)  (normal: 15.1 to 24.9):
...
```

Each input line shows:
- A human-friendly feature name
- A normal HVAC operating range (based on the dataset)

This helps non-HVAC users pick reasonable values.

#### 5. Enter Values to Test the System

You can perform three types of experiments:

**✅ A. Try normal operating values**

Stay within the suggested ranges:

```
Power Usage (kW): 5
Return Air Temp (°C): 21
Supply Air Temp (°C): 14
...
```

Expected output:

```
Prediction: NORMAL
Anomaly probability: 0.04
```

**⚠️ B. Try values outside normal ranges**

Example:

```
Power Usage (kW): 20
Temperature Difference (°C): -1
Return Air Temp (°C): 5
...
```

Expected output:

```
Prediction: ANOMALY
Anomaly probability: 0.98
```

**🎯 C. Try extreme values to stress-test the model**

The model will confidently classify very abnormal combinations as anomalies.

#### 6. View the Model's Decision

After entering all fields, you will see:

```
--- Prediction Result ---
Prediction: NORMAL or ANOMALY
Anomaly probability: 0.xxx
```

### Tips for Non-HVAC Users

- **Inside the normal range** → likely NORMAL
- **Outside the normal range** → likely ANOMALY
- The ranges are computed from real HVAC data, so they reflect realistic operating behavior
- You do not need HVAC expertise — just pick values and test the model's response

### Why This Matters

The interactive tester transforms this ML model into a hands-on demo tool that:

- Data scientists can experiment with
- HVAC technicians can validate with real values
- Hiring managers or recruiters can quickly understand the project

It demonstrates not just machine learning, but also usability and accessibility—key strengths of this project.

---

## Future Enhancements

- Build a Streamlit / Gradio web app for broader accessibility
- Add real-time monitoring via IoT/BMS integration
- Use SHAP for enhanced model explainability
- Add fault category prediction (e.g., compressor failure, airflow blockage)
- Expand dataset to multi-building profiles
- Deploy as a microservice

---

## Tech Stack

- **Python** — Core programming language
- **Pandas** — Data manipulation and cleaning
- **NumPy** — Numerical computing
- **scikit-learn** — Machine learning models and metrics
- **Matplotlib** — Data visualization
- **PostgreSQL** — Data storage and SQL operations
- **Jupyter Notebook** — Interactive development environment

---