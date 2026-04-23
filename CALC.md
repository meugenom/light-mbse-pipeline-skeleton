# Model Calculation - Sensor Algorithm

> This document describes the mathematical pipeline used to generate the potentiometer sensor model.
> All offline computation is done in Octave/MATLAB. The C++ runtime uses only precomputed Lookup Tables (LUT) - ensuring O(1) performance without floating-point divisions at runtime.

## 1. Physical Parameters

Based on the hardware specification ([REQ-PHY-001 to 003]), the ideal sensor has the following constraints:
-  **$V_{ref}$:** 5.0 V
-  **Max Angle:** 355°
-  **ADC Resolution:** 4096 counts (12-bit)

## 2. Mathematical Model

The sensor is modeled as a strictly linear potentiometer. The conversion from raw ADC counts to physical units is defined as:

$$Angle = ADC \cdot \left( \frac{355.0}{4096.0} \right)$$

$$Voltage = ADC \cdot \left( \frac{5.0}{4096.0} \right)$$

## 3. LUT Generation (101-Point Grid)

Instead of calculating this at runtime, the Octave script generates a 101-point uniform grid representing 0% to 100% of the potentiometer's travel.

The step size is defined by `SENSOR_TAB_SIZE = 101`. For each index $i \in [0, 100]$:

$$ADC_i = i \cdot \left( \frac{4096.0}{100.0} \right)$$

The ideal Angle and Voltage are computed for each $ADC_i$ and exported as C++ arrays.

## 4. Export to C++ Header

_This file is auto-generated and must not be edited manually._

The script automatically generates `src/includes/sensor_lut.h` containing:
- `SENSOR_TAB_ADC[101]`
- `SENSOR_TAB_ANGLE[101]`
- `SENSOR_TAB_VOLTAGE[101]`

## 5. C++ Runtime (Interpolation)

At runtime, the C++ code performs the following O(1) operations:
1.  **Clamping:** Ensures the raw ADC value is within `[0, 4096]`.
2.  **Index search:** Quickly finds the bounding indices in `SENSOR_TAB_ADC`.
3.  **Linear Interpolation:** Calculates the precise Angle and Voltage between the two closest table points.

*Document Version: v.0.3.0 | Part of LIGHT-MBSE-PIPELINE-SKELETON*