#ifndef SENSOR_H
#define SENSOR_H

/**
 * Calculates the potentiometer angle in degrees.
 * Uses O(1) interpolation based on a generated LUT table.
 * * @param rawAdc - Raw ADC value (e.g., from 0 to 1023).
 * @return Angle in degrees (from 0.0 to ANGLE_MAX).
 */
float getPotentiometerAngle(int rawAdc);


/**
 * Calculates the output voltage of the potentiometer.
 * Useful for data validation or reference voltage debugging.
 * * @param rawAdc - Raw ADC value.
 * @return Voltage in Volts (V).
 */
float getPotentiometerVoltage(int rawAdc);

#endif // SENSOR_H