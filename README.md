> **Why this Skeleton?**
> In traditional embedded development, there is often a **"Valley of Death"** between hardware design and software implementation. While hardware engineers provide datasheets and LTSpice models, software engineers write C/C++ code based on idealized assumptions. Consequently, the system often fails due to jitter, noise, or thermal drift.
>
> This **skeleton** is designed to bridge the gap by providing a structured workflow for modeling, simulation, and validation. You can use it as a template. This is version 0.3.0, which will be continuously improved.

# LIGHT-MBSE-PIPELINE-SKELETON

> Example use case: Automating the modeling and validation of a potentiometer from raw stand data to verified C++ code.

1. **Methodology & Approach:**
- LIGHT-MBSE-PIPELINE-SKELETON provides a strict roadmap for modeling and validating hardware components using a text-based, reproducible pipeline.
2. **Setup:**
- Potentiometer datasheets are available in `references/Potentiometer-Properties.csv` and `references/Potentiometer-Data.csv`.

## Quick Start & Building

The pipeline is fully automated. You can build the firmware, run Renode simulations, export logs, and generate validation reports with a single command.

```bash
git clone [https://github.com/meugenom/light-mbse-pipeline-skeleton.git](https://github.com/meugenom/light-mbse-pipeline-skeleton.git)
cd light-mbse-pipeline-skeleton
./start.sh
```

*Note: Test reports will be generated in `./logs/sensor_test_posix.log` and `./logs/sensor_test_stm32.log`.*

### 🛡 Robust Orchestration
The pipeline is driven by a fail-safe bash orchestrator (`start.sh` with strict `set -euo pipefail`). It automatically handles:
- Toolchain dependency checks.
- Generation and verification of intermediate artifacts (LUT headers).
- Cross-platform builds (POSIX vs STM32) using CMake.
- Asynchronous execution and UART log extraction via Renode.
- On-the-fly parsing of validation traces into CSV formats.

## Table of Contents
- [Quick Start & Building](#quick-start--building)
- [Table of Contents](#table-of-contents)
- [Iteration Roadmap](#iteration-roadmap)
- [Motivation](#motivation)
- [Environment & Toolchain](#environment--toolchain)
- [Project Documentation](#project-documentation)
- [Project Directory Structure](#project-directory-structure)
- [Workflows](#workflows)
- [Validation Results](#validation-results)
- [References](#references)
- [License](#license)

## Iteration Roadmap and publishing plan

| Version | Status | Pipeline Engine | Focus |
| ------- | ------ | --------------- | ----- |
| Research | Closed | SKELETON v.0.1.0 | Description of initial finding |
| Base Version | Closed | SKELETON v.0.2.0 | Initial version formatting |
| Worked Example | Current | SKELETON v.0.3.0 | Addition of Feature |

## Motivation

I created a C++ motor model using stand test data. The model works perfectly — in the hover-cruise range (20–60% throttle), the average error is 5.5% for thrust and 3.8% for current. However, I had no way to reproduce the result from scratch in a reasonable amount of time. If I lost intermediate files, there was no way to know where anything came from. If the motor changed, everything had to be redone manually.

The core idea was simple: **every artifact should be automatically generated from a single source of truth.**

I redesigned the structure and implemented it as a `LIGHT-MBSE-PIPELINE-SKELETON` — a lightweight, reproducible pipeline for embedded modeling. It is not a heavy toolchain, but a text-based, structured workflow. The goal is to automate the entire process from raw data to a validated model, ensuring that every artifact is traceable and reproducible.


## Environment & Toolchain

**Host System:** macOS Tahoe 26.4.1 (Apple Silicon)  
The following tools are required to reproduce the tests and scripts:

| Tool | Version | Purpose |
| ------ | --------- | --------- |
| **GNU Octave** | 11.1.0 | Mathematical modeling, LUT generation, reporting |
| **Clang** | 21.0.0 | Runtime model implementation (POSIX) |
| **arm-none-eabi-gcc**| 15.2.rel1 | Bare-metal target compilation (STM32) |
| **Renode** | 1.16.1.16858 | Instruction-accurate hardware emulation |
| **CMake** | 4.3.1 | Build system management |
| **Bash** | 5.3.9 | Pipeline scripting and orchestration |

## Project Documentation

| File | Description |
|------|-------------|
| [SPEC.md](./SPEC.md) | Component specifications, raw stand test data |
| [CALC.md](./CALC.md) | Model derivation: math, pipeline, voltage scaling |
| [VALIDATION.md](./VALIDATION.md) | Validation results and performance metrics |
| [METRICS.md](./METRICS.md) | Units and measurement standards |
| [README.md](./README.md) | Project overview, workflow, and documentation structure |

## Pipeline Overview

```text
              new Iteration
        ┌──────────┴────────────┐
        ▼                       ▼
┌────────────────┐    ┌───────────────────┐
│    LTSpice.    │    │    Datasheets     │
│1. Schema       │    │1. Table Data      │
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
├── ltspice/ /* LTSpice simulation files and models */
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


## Workflows

### 1. LTSpice Workflow
> *Note: LTSpice models will be added in future iterations.*
- Schema and simulation setup.
- Component definition and parameters extraction.

### 2. Octave Workflow
> *See details in `CALC.md`*
- Pure GNU Octave workflow for mathematical modeling.
- Automatic generation of C++ Lookup Tables (LUT) from raw CSV data.

### 3. Code Workflow
- **Import LUT:** Automatically included via `src/includes/sensor_lut.h`.
- **Implementation:** Core logic implemented in `src/core/sensor.cpp`, ensuring cross-compatibility for both POSIX and STM32 targets.

### 4. Renode Workflow
- **Environment:** `renode/test_run.resc` defines the STM32 test bench, loads the firmware, and configures peripherals.
- **Execution:** Automated entirely via the `./start.sh` orchestrator.

## Validation Results


> *See full details in `VALIDATION.md`*

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

![Discrepancy Plot](./octave/plots/plot_errors.png)

## References
Available in the `references/` directory.

## License
This project is licensed under the MIT License. See [LICENSE](LICENSE).

---
*Document Version: 0.3.0 | Part of LIGHT-MBSE-PIPELINE-SKELETON*