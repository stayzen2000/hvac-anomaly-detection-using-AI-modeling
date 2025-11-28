# HVAC Anomaly Detection — Machine Learning Project

This project applies machine learning to detect **anomalous HVAC system behavior** using real historical sensor data from a commercial building. It transforms raw operational data into a working prediction system capable of identifying abnormal temperature patterns, power usage spikes, and potential system faults.

---

## 📌 Why This Project Matters

Commercial HVAC systems are responsible for **30–50% of total building energy consumption**.  
Even small inefficiencies can cause:

- Higher utility bills  
- Uncomfortable indoor environments  
- Equipment strain and early failure  
- Increased maintenance costs  

Most buildings lack automated anomaly detection, making faults hard to catch early.

This project solves that by turning HVAC data into automated, intelligent system monitoring.

---

## 📊 About the Dataset

The dataset comes from an HVAC system serving a **non-residential building in Turin, Italy**.  
It contains environmental and operational measurements from **winter seasons 2019–2020 and 2020–2021**.

### **Variables Included (11 total):**
- **timestamp**  
- **Temperatures (°C):**
  - Return air temperature  
  - Supply air temperature  
  - Outdoor air temperature  
- **Relative Humidity (%):**
  - Return air humidity  
  - Supply air humidity  
  - Outdoor air humidity  
- **Return air temperature setpoint (°C)**  
- **Saturation temperature in the humidifier (°C)**  
- **Fan power (kW)**  
- **Fan energy consumption (kWh)**  

### **Dataset Source**
Borda, Davide (2022).  
*“Development of Anomaly Detectors for HVAC Systems using Machine Learning.”*  
Mendeley Data, V1.  
DOI: **10.17632/mjhr46dkj6.1**

---

## 🔍 What This Project Does

- Cleans and processes real HVAC sensor data (SQL + Python)  
- Engineers features that capture HVAC physics (temperature deltas, power usage patterns)  
- Uses a Random Forest classifier for anomaly detection  
- Achieves **near-perfect accuracy** on unseen test data  
- Includes an **interactive anomaly tester** where anyone can enter HVAC values and get predictions  
- Uses human-friendly labels + normal operating ranges for accessibility  

---

## 💼 Business Impact

A system like this enables businesses to:

- Detect inefficiencies before occupants feel discomfort  
- Catch abnormal behavior before high energy costs accumulate  
- Identify early signs of equipment failure  
- Reduce downtime, repair costs, and emergency service calls  
- Improve operational reliability and comfort  

This directly translates into **lower operating costs and smarter HVAC maintenance**.

---

## 🎯 What Reviewers Will Learn

By reviewing this project, you will see:

- Real-world dataset cleaning and transformation  
- Time-series modeling best practices (chronological splits)  
- Feature engineering grounded in real HVAC behavior  
- Machine learning model training and evaluation  
- Clear interpretability through feature importance  
- An interactive, user-friendly tool that demonstrates practical application  

This project showcases the ability to turn a real operational problem into a **clear, explainable, and functional machine learning solution.**

---
