/**
 * STM32/Renode Test Bench for Potentiometer Sensor
 */

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstdarg>
#include <cstdint>

#include "sensor.h"
#include "sensor_lut.h"

// --- UART PRINTF IMPLEMENTATION FOR STM32 (without HAL) ---
extern "C" {
    int _write(int file, char *ptr, int len) {
        volatile uint32_t *usart2_sr = (volatile uint32_t *)0x40004400; // Status Register
        volatile uint32_t *usart2_dr = (volatile uint32_t *)0x40004404; // Data Register
        for (int i = 0; i < len; i++) {
            while (!(*usart2_sr & (1 << 7))); // Wait for TXE
            *usart2_dr = ptr[i] & 0xFF;
        }
        return len;
    }
    // Not print stubs in console
    void _close(void) {}
    void _lseek(void) {}
    void _read(void) {}
    void _fstat(void) {}
    int _isatty(int file) { return 1; }
    int _getpid(void) { return 1; }
    void _kill(int pid, int sig) {}
}

// Security wrapper for printf, max 256 chars
void safe_printf(const char *fmt, ...) {
    char buffer[256]; 
    va_list args;
    va_start(args, fmt);
    int len = vsnprintf(buffer, sizeof(buffer), fmt, args);
    va_end(args);
    if (len > 0) {
        _write(1, buffer, len);
    }
}

// Change all printf calls to safe_printf
#define printf safe_printf


// Checks if two floats are approximately equal within a relative tolerance
bool approxEqual(float actual, float expected, float tol) {
    return fabsf(actual - expected) < tol;
}

static void check(bool ok, const char* expr, const char* file, int line) {
    if (!ok) {
        printf("[VERIFIED]| - FAIL: %s at %s:%d\n", expr, file, line);
        while(1); // На STM32 просто останавливаемся
    }
}
#define CHECK(expr) check((expr), #expr, __FILE__, __LINE__)
// ================= TEST CASES =================

void test_boundaries() {
    float angle_min = getPotentiometerAngle(0);
    float angle_max = getPotentiometerAngle(ADC_RESOLUTION);
    CHECK(approxEqual(angle_min, 0.0f, 0.01f));
    CHECK(approxEqual(angle_max, ANGLE_MAX, 0.01f));
    printf("[VERIFIED]| - PASS boundaries\n");
}

void test_clamping() {
    float angle_low = getPotentiometerAngle(-100);
    float angle_high = getPotentiometerAngle(ADC_RESOLUTION + 500);
    CHECK(angle_low == 0.0f);
    CHECK(angle_high == ANGLE_MAX);
    printf("[VERIFIED]| - PASS clamping\n");
}

void test_midpoint() {
    int mid_adc = ADC_RESOLUTION / 2;
    float expected_angle = ANGLE_MAX / 2.0f;
    float actual_angle = getPotentiometerAngle(mid_adc);
    CHECK(approxEqual(actual_angle, expected_angle, 0.5f));
    printf("[VERIFIED]| - PASS midpoint\n");
}

void test_monotonicity() {
    float prev_angle = -1.0f;
    for (int adc = 0; adc <= ADC_RESOLUTION; adc += 100) {
        float current_angle = getPotentiometerAngle(adc);
        CHECK(current_angle >= prev_angle);
        prev_angle = current_angle;
    }
    printf("[VERIFIED]| - PASS monotonicity\n");
}

void test_voltage_logic() {
    float vol_half = getPotentiometerVoltage(ADC_RESOLUTION / 2);
    CHECK(approxEqual(vol_half, V_REF / 2.0f, 0.05f));
    printf("[VERIFIED]| - PASS voltage logic\n");
}

void test_trace_data() {
    safe_printf("\r\n--- TRACE DATA FOR OCTAVE ---\r\n");
    safe_printf("[TRACE]| RAW_ADC; ANGLE_DEG; VOLTAGE_V\r\n");
    
    // Going through 11 points (from 0% to 100% with a step of 10%)
    for (int i = 0; i <= 10; i++) {
        float percent = i / 10.0f; 
        
        int rawAdc = static_cast<int>(percent * ADC_RESOLUTION);
        
        float angle = getPotentiometerAngle(rawAdc);
        float voltage = getPotentiometerVoltage(rawAdc);
        
        // Using safe_printf and \r\n for correct UART output
        safe_printf("[TRACE]| %d ; %f ; %f \r\n", rawAdc, angle, voltage);
    }
}

// ================= main =================

int main() {
    // 1. Initialize UART for printf
    volatile uint32_t *rcc_apb1enr = (volatile uint32_t *)0x40023840;
    volatile uint32_t *rcc_ahb1enr = (volatile uint32_t *)0x40023830;
    volatile uint32_t *gpioa_moder = (volatile uint32_t *)0x40020000;
    volatile uint32_t *gpioa_afrl  = (volatile uint32_t *)0x40020020;
    volatile uint32_t *usart2_cr1  = (volatile uint32_t *)0x4000440C;
    volatile uint32_t *usart2_brr  = (volatile uint32_t *)0x40004408;

    *rcc_apb1enr |= (1 << 17);
    *rcc_ahb1enr |= (1 << 0);
    *gpioa_moder &= ~((3 << (2 * 2)) | (3 << (3 * 2)));
    *gpioa_moder |=  ((2 << (2 * 2)) | (2 << (3 * 2)));
    *gpioa_afrl  &= ~((0xF << (2 * 4)) | (0xF << (3 * 4)));
    *gpioa_afrl  |=  ((7 << (2 * 4)) | (7 << (3 * 4)));
    *usart2_brr   = 0x0683; // 9600
    *usart2_cr1   = (1 << 13) | (1 << 3) | (1 << 2);

    // 2. RUN TESTS    
    printf("\n[VERIFIED]| ### POTENTIOMETER STM32 TEST BENCH\n");
    
    test_boundaries();
    test_clamping();
    test_midpoint();
    test_monotonicity();
    test_voltage_logic();

    test_trace_data();

    printf("\n[RESULT]| Sensor tests finished.\n");

    // MICROCONTROLLER SHOULD NOT EXIT MAIN!
    while (1) {
        // Waiting for emulator to stop
    }

    return 0;
}