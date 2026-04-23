/**
 * Tests for potentiometer model: 270 degrees, 10-bit ADC
 */

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include "sensor.h"
#include "sensor_lut.h"

bool approxEqual(float actual, float expected, float tol) {
    return fabsf(actual - expected) < tol;
}

static void check(bool ok, const char* expr, const char* file, int line) {
    if (!ok) {
        printf("[VERIFIED]| - FAIL: %s\n  -> %s:%d\n", expr, file, line);
        exit(1);
    }
}

#define CHECK(expr) check((expr), #expr, __FILE__, __LINE__)

// === Tests ===

void test_boundaries() {
    // Checking Limit Points
    float angle_min = getPotentiometerAngle(0);
    float angle_max = getPotentiometerAngle(ADC_RESOLUTION);

    CHECK(approxEqual(angle_min, 0.0f, 0.01f));
    CHECK(approxEqual(angle_max, ANGLE_MAX, 0.01f));
    
    printf("[VERIFIED]| - PASS boundaries: 0 ADC -> 0 deg, %d ADC -> %.1f deg\n", 
           ADC_RESOLUTION, ANGLE_MAX);
}

void test_clamping() {
    // Checking out-of-bounds (protection in code)
    float angle_low = getPotentiometerAngle(-100);
    float angle_high = getPotentiometerAngle(5000);

    CHECK(angle_low == 0.0f);
    CHECK(angle_high == ANGLE_MAX);
    
    printf("[VERIFIED]| - PASS clamping: Out-of-bounds ADC handled correctly\n");
}

void test_midpoint() {
    // Checking midpoint (50%)
    int mid_adc = ADC_RESOLUTION / 2;
    float expected_angle = ANGLE_MAX / 2.0f;
    float actual_angle = getPotentiometerAngle(mid_adc);

    CHECK(approxEqual(actual_angle, expected_angle, 0.5f));
    printf("[VERIFIED]| - PASS midpoint: %d ADC -> %.2f deg\n", mid_adc, actual_angle);
}

void test_monotonicity() {
    // Checking monotonicity: angle should only increase
    float prev_angle = -1.0f;
    for (int adc = 0; adc <= ADC_RESOLUTION; adc += 100) {
        float current_angle = getPotentiometerAngle(adc);
        CHECK(current_angle >= prev_angle);
        prev_angle = current_angle;
    }
    printf("[VERIFIED]| - PASS monotonicity: Angle strictly increases with ADC\n");
}

void test_voltage_logic() {
    // Checking voltage conversion
    float vol_half = getPotentiometerVoltage(ADC_RESOLUTION / 2);
    CHECK(approxEqual(vol_half, V_REF / 2.0f, 0.05f));
    printf("[VERIFIED]| - PASS voltage: %d ADC -> %.2fV (V_REF=%.1fV)\n", 
           ADC_RESOLUTION/2, vol_half, V_REF);
}

void test_trace_data() {
    printf("\n--- TRACE DATA FOR OCTAVE ---\n");
    printf("[TRACE]| RAW_ADC; ANGLE_DEG; VOLTAGE_V\n");
    
    // Going through 11 points (from 0% to 100% in 10% steps)
    for (int i = 0; i <= 10; i++) {
        // Fraction of rotation from 0.0 to 1.0
        float percent = i / 10.0f; 
        
        // Calculate the corresponding ADC value
        int rawAdc = static_cast<int>(percent * ADC_RESOLUTION);
        
        // Get the angle and voltage from your code
        float angle = getPotentiometerAngle(rawAdc);
        float voltage = getPotentiometerVoltage(rawAdc);
        
        // Output the data
        printf("[TRACE]| %d ; %f ; %f \n", rawAdc, angle, voltage);
    }
}

int main() {    
    printf("[VERIFIED]| ### Potentiometer Sensor Tests\n");

    test_boundaries();
    test_clamping();
    test_midpoint();
    test_monotonicity();
    test_voltage_logic();

    test_trace_data();

    printf("\n--- TEST BENCH: FINISHED ---\n");

    return 0;
}