// ==========================================
// AUTO-GENERATED LUT FOR SENSOR
// Generated on: 2026-04-23 14:18:34
// Sensor: Potentiometer
// ==========================================
#ifndef SENSOR_LUT_H
#define SENSOR_LUT_H

// REQ-ALG-001 SENSOR_TAB_SIZE 101 N/A 
static constexpr int SENSOR_TAB_SIZE = 101;

// REQ-PHY-001 V_REF 5 V 
static constexpr float V_REF = 5.00f;

// REQ-PHY-002 ANGLE_MAX 355 deg 
static constexpr float ANGLE_MAX = 355.00f;

// REQ-PHY-003 ADC_RESOLUTION 4096 counts 
static constexpr int ADC_RESOLUTION = 4096;

// REQ-PHY-005
static constexpr float SENSOR_TAB_ANGLE[] = {
    0.00f, 3.50f, 7.01f, 10.51f, 14.02f, 17.52f, 21.02f, 24.53f, 28.03f, 31.53f, 
    35.04f, 38.68f, 42.34f, 46.01f, 49.67f, 53.33f, 56.99f, 60.66f, 64.32f, 67.98f, 
    71.60f, 75.04f, 78.48f, 81.92f, 85.35f, 88.79f, 92.23f, 95.67f, 99.10f, 102.54f, 
    105.98f, 109.62f, 113.31f, 116.99f, 120.67f, 124.35f, 128.03f, 131.71f, 135.39f, 139.07f, 
    142.71f, 146.19f, 149.67f, 153.15f, 156.63f, 160.11f, 163.59f, 167.06f, 170.54f, 174.02f, 
    177.50f, 180.99f, 184.47f, 187.96f, 191.45f, 194.94f, 198.42f, 201.91f, 205.40f, 208.88f, 
    212.37f, 216.02f, 219.70f, 223.38f, 227.06f, 230.74f, 234.42f, 238.10f, 241.78f, 245.47f, 
    249.10f, 252.52f, 255.94f, 259.37f, 262.79f, 266.21f, 269.63f, 273.05f, 276.47f, 279.89f, 
    283.32f, 286.94f, 290.63f, 294.31f, 297.99f, 301.67f, 305.35f, 309.03f, 312.71f, 316.39f, 
    320.05f, 323.55f, 327.06f, 330.56f, 334.06f, 337.57f, 341.07f, 344.57f, 348.08f, 351.58f, 
    355.00f
};


#endif // SENSOR_LUT_H
