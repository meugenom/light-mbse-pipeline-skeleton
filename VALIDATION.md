# Validation Protocol & Test Results

**Generated on:** 2026-04-23 14:18:38

## 1. HIL Test Summary (POSIX/STM32)

 ### Potentiometer Properties

| ID | Parameter | Value | Unit |
|----|-----------|-------|------|
| REQ-PHY-001 | V_REF | 5.0 | V |
| REQ-PHY-002 | ANGLE_MAX | 355 | deg |
| REQ-PHY-003 | ADC_RESOLUTION | 4096 | counts |
| REQ-ALG-001 | SENSOR_TAB_SIZE | 101 | N/A |


### Potentiometer Sensor Tests
- PASS boundaries: 0 ADC -> 0 deg, 4096 ADC -> 355.0 deg
- PASS clamping: Out-of-bounds ADC handled correctly
- PASS midpoint: 2048 ADC -> 177.50 deg
- PASS monotonicity: Angle strictly increases with ADC
- PASS voltage: 2048 ADC -> 2.50V (V_REF=5.0V)


## 2. Full Accuracy Data Trace

| Turn Percentage | Angle Error % | Voltage Error % |
|----------------|----------------|----------------|
| 0.00 | 0.00 | 0.00|
| 9.99 | -1.30 | 0.00|
| 20.00 | 0.84 | 0.00|
| 29.98 | -0.49 | -0.00|
| 39.99 | 0.50 | 0.00|
| 50.00 | 0.00 | 0.00|
| 59.99 | -0.30 | 0.00|
| 70.00 | 0.24 | 0.00|
| 79.98 | -0.24 | -0.00|
| 89.99 | 0.17 | 0.00|
| 100.00 | 0.00 | 0.00|


---
</br>

## 3. Accuracy Analysis (Calculation vs Real Data)

**Max Angle Error:** 0.84%

**Max Voltage Error:** 0.00%


![Discrepancy between real stand data and Theoretical Model](./octave/plots/plot_errors.png)


---
*Document Version: v.0.3.0 | Part of LIGHT-MBSE-PIPELINE-SKELETON*
