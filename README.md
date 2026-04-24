> **Why this Skeleton?**
> In traditional embedded development, is often  a **"Valley of Death"** between hardware design and software implementation. Hardware engineers provide datasheets and LTSpice models, but software engineers write C-code based on idealized assumptions. And by result the system fails due to jitter, noise or thermal drift.

>This **skeleton** is designed to bridge that gap and provides a structured workflow for modeling, simulation, and validation. Your can use it as a template. This is a version 0.1.0 and will be improved in the future.


# LIGHT-MBSE-PIPELINE-SKELETON 

> For example to pipeline the modeling and validation of a Potentiometer.

1. **Methodology & Approach:**
- LIGHT-MBSE-PIPELINE-SKELETON is designed to be a roadmap for modeling and valisating a some component, for example a temperature sensor.
2. **Setup:** 
- Datasheets Potentiometer `references/Potentiometer-Properties.csv` and `references/Potentiometer-Data.csv`.

## Iteration Roadmap and publishing plan

| Version | Status | Pipeline Engine | Focus |
| ------- | ------ | --------------- | ----- |
| Research | Closed | SKELETON v.0.1.0 | MBSE-PIPELINE-SKELETON |
| Base Version | Closed | SKELETON v.0.2.0 | MBSE-PIPELINE-SKELETON |
| Worked Example | Current | SKELETON v.0.3.0 | MBSE-PIPELINE-SKELETON |


## Table of Contents

- [Iteration Roadmap](#iteration-roadmap)
- [Table of Contents](#table-of-contents)
- [Motivation](#motivation)
- [Environment & Toolchain (Reproducibility)](#environment--toolchain-reproducibility)
- [Project Documentation](#project-documentation)
- [Project Directory Structure](#project-directory-structure)
- [LTSpice Workflow](#ltspice-workflow)
- [Octave Workflow](#octave-workflow)
- [Code Workflow](#code-workflow)
- [Renode Workflow](#renode-workflow)
- [Build & Test](#build--test)
- [Validation Workflow, Results](#validation-workflow-results)
- [Known Problems and Limitations](#known-problems-and-limitations)
- [References](#references)
- [License](#license)

## Motivation

I built a C++ motor model from stand test data. The model works — in the hover-cruise range (20–60% throttle) average error is 5.5% by thrust, 3.8% by current. But I had no way to reproduce the result from scratch in a reasonable time. If I lost intermediate files — no way to know where anything came from. If I changed the motor — everything needed to be redone manually.
The idea was simple: every artifact should be automatically generated from a single source of truth.
So I redesigned the structure and implemented it as a `LIGHT-MBSE-PIPELINE-SKELETON` - a lightweight, reproducible pipeline for embedded modeling. It's not a full toolchain, not a code, only text, but structured as workflow. The idea is to have some roadmap to automate the entire process from raw data to validated model, ensuring that every artifact is traceable and reproducible.


## Environment & Toolchain (Reproducibility)

**Used System:** macOS Tahoe 26.4.1 on Apple Silicon
Scripts and tests in this project can be reproduced with the following tools:

| Tool | Version | Purpose |
| ------ | --------- | --------- |
| **GNU Octave** | 11.1.0 | Mathematical modeling, generation LUT, Reports |
| **Clang** | 21.0.0 | Runtime model implementation (POSIX) |
| **arm-none-eabi-gcc**| 15.2.rel1 | Bare-metal target compilation (STM32) |
| **Renode** | 1.16.1.16858 | Instruction-accurate hardware emulation |
| **CMake** | 4.3.1 | Build system management |
| **Bash** | 5.3.9 | Pipeline scripting and orchestration |


## Project Documentation

| File | Description |
|------|-------------|
| [FULL SPECIFICATION](./SPEC.md) | Component specifications, raw stand test data |
| [CALCULATION DETAILS](./CALC.md) | Model derivation: math, pipeline, voltage scaling |
| [VALIDATION REPORT](./VALIDATION.md) | Validation results and performance metrics |
| [METRICS.md](./METRICS.md) | Units and measurement standards |
| [README.md](./README.md) | Project overview, workflow, and documentation structure |

## Pipeline Overview

```text
              new Iteration
        ┌──────────┴────────────┐
        ▼                       ▼
┌────────────────┐    ┌───────────────────┐
│    LTSpice.    │    │    Datasheets     │
│1. Shema        │    │1. Table Data      │
│2. Conditions   │    │2. Raw Data        │
│3. Restrictions │    │3. Specifications  │
└───────┬────────┘    └─────────┬─────────┘
        │                       │
        ▼                       ▼
┌─────────────────────────────────────────┐
│        Octave Mathematical Model.       │
│1. Approximation of Curves               │
│2. Algorithm Logic and model design      │
│3. Export LUT/Dump Generation            │
└───────────────────┬─────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│         C/C++ Model Design              │
│1. Import LUT/Dump                       │
│2. Implement Algorithm Logic             │
│3. Optimize for Bare-Metal               │    
│4. Prepare Test Cases                    │
└───────────────────┬─────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│         Renode Model Testing            │
│1. Set up Test Bench and add Dump        │
│2. Run Simulations                       │
│3. Export Logs/Dump                      │
└───────────────────┬─────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────┐
│         Results Analysis                │
│1. Compare with Datasheet and Stand Test │
│2. Analyze Deviations and Errors         │
│3. Prepare Validation Report             │
│4. Prepare Publications LATEX, Markdown  │
└───────────────────┬─────────────────────┘
                    │
                    ▼
            End of Iteration

```

## Project Directory Structure

```text
├── README.md 
├── CALC.md
├── SPEC.md
├── VALIDATION.md
├── METRICS.md
├── LICENSE
├── ltspice/ /* muffler */
├── octave/ /* Octave scripts for calculations */
├── references/ /* Reference materials, datasheets, papers */
├── src/ /* Source code */  
├── tests/ /* Test cases and validation scripts */
├── build(build_stm32)/ /* Build artifacts */
├── renode/ /* Renode simulation environment */
├── docs/ /* Documentation */
├── logs/ /* Logs */
├── assets/ /* Assets */
```


## LTSpice Workflow
> Now we have not LTSpice models, but in the future we will add them.
- Schema and simulation setup in LTSpices.
- Components, parameters.
- Roadmap for starting simulations and extracting data.

## Octave Workflow
> See all details in `CALC.md`
- Workflow in Octave/Mathcad. 
- Calculations to generate the LUT or building the mathematical model.
- Export the data as a LUT or Dump to be used in the C-code and Renode.

## Code Workflow

1. **Import LUT:** Include `src/includes/sensor_lut.h` in `src/core/sensor.cpp`
2. **Implement Algorithm:** in `src/core/sensor.cpp` both for POSIX and STM32 platforms

## Renode Workflow

1. **Set up Environment:** `renode/test_run.resc` — define the test bench, load the model firmware, set up peripherals
2. **Logs:** `./start.sh` — execute the renode command with logs parameters
3. **Logs Output:** `./logs`

## Building

1. **Build:** `./start.sh` — Fully pipeline automation: builds the model firmware, runs Renode tests, exports logs, and generates validation reports.
2. **Test:** `./start.sh` — Executes the Renode test bench, POSIX unit tests, and generates validation reports.
3. **Test's Reports:**  in `./logs` as `logs/sensor_test_posix.log` and `logs/sensor_test_stm32.log`

## Validation Workflow, preparing results, describing the results.

> See all details in `VALIDATION.md`

```text
[VERIFIED]| ### Potentiometer Sensor Tests
[VERIFIED]| - PASS boundaries: 0 ADC -> 0 deg, 4096 ADC -> 355.0 deg
[VERIFIED]| - PASS clamping: Out-of-bounds ADC handled correctly
[VERIFIED]| - PASS midpoint: 2048 ADC -> 177.50 deg
[VERIFIED]| - PASS monotonicity: Angle strictly increases with ADC
[VERIFIED]| - PASS voltage: 2048 ADC -> 2.50V (V_REF=5.0V)

--- TRACE DATA FOR OCTAVE ---
[TRACE]| RAW_ADC; ANGLE_DEG; VOLTAGE_V
[TRACE]| 0 ; 0.000000 ; 0.000000 
[TRACE]| 409 ; 34.988586 ; 0.499268 
[TRACE]| 819 ; 71.582321 ; 0.999756 
[TRACE]| 1228 ; 105.912819 ; 1.499023 
[TRACE]| 1638 ; 142.674454 ; 1.999512 
[TRACE]| 2048 ; 177.500000 ; 2.500000 
[TRACE]| 2457 ; 212.318878 ; 2.999268 
[TRACE]| 2867 ; 249.082275 ; 3.499756 
[TRACE]| 3276 ; 283.253021 ; 3.999023 
[TRACE]| 3686 ; 320.014252 ; 4.499512 
[TRACE]| 4096 ; 355.000000 ; 5.000000 

--- TEST BENCH: FINISHED ---
```

![Dscrepancy Plot](./octave/plots/plot_errors.png)

## References

- List of references, datasheets, papers in `references/` directory.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE)

---
*Document Version: v.0.3.0 | Part of LIGHT-MBSE-PIPELINE-SKELETON*