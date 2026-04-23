#include "sensor.h"
#include <algorithm>
#include "sensor_lut.h"

namespace {
    /**
     * O(1) Interpolation by lookup table for potentiometer angle
     * @param rawAdc - raw ADC value (0...ADC_RESOLUTION)
     */
    float interpolateAngle(int rawAdc) {
        // 1. Limiting Input Data (Safety Clamping)
        float adc_f = static_cast<float>(std::max(0, std::min(static_cast<int>(ADC_RESOLUTION), rawAdc)));

        // 2. Calculating the position in the table
        // Normalize ADC to table size (0 to 10)
        float idx_f = adc_f * (static_cast<float>(SENSOR_TAB_SIZE - 1) / ADC_RESOLUTION);
        
        int lo = static_cast<int>(idx_f);

        // Edge cases
        if (lo >= SENSOR_TAB_SIZE - 1) return SENSOR_TAB_ANGLE[SENSOR_TAB_SIZE - 1];
        if (lo < 0) return SENSOR_TAB_ANGLE[0];

        // 3. Linear interpolation
        float alpha = idx_f - static_cast<float>(lo);
        
        float angle0 = SENSOR_TAB_ANGLE[lo];
        float angle1 = SENSOR_TAB_ANGLE[lo + 1];

        return angle0 + alpha * (angle1 - angle0);
    }
}

/**
 * Public function to get the angle in degrees
 */
float getPotentiometerAngle(int rawAdc) {
    // In the simplest case — just return the interpolated value
    return interpolateAngle(rawAdc);
}

/**
 * Additional function: convert angle to voltage (if needed for logic)
 */
float getPotentiometerVoltage(int rawAdc) {
    float adc_f = static_cast<float>(std::max(0, std::min(static_cast<int>(ADC_RESOLUTION), rawAdc)));
    return (adc_f / ADC_RESOLUTION) * V_REF;
}