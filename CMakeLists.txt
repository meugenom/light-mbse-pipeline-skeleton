cmake_minimum_required(VERSION 3.16)
project(light-mbse-pipeline-skeleton VERSION 1.3.0 LANGUAGES C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Platform selection
set(PLATFORM "posix" CACHE STRING "Target platform: posix | stm32")

# Libraries
add_library(sensor_model STATIC
    src/core/sensor.cpp
)

# Include directories
target_include_directories(sensor_model PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/src/includes
)

if(PLATFORM STREQUAL "posix")
    # Compiler warnings
    add_compile_options(-Wall -Wextra -Wpedantic)
    # UNIT TEST POSIX
    add_executable(test_sensor tests/posix/test_sensor.cpp)
    target_link_libraries(test_sensor PRIVATE sensor_model)
    enable_testing()
    add_test(NAME sensor_tests COMMAND test_sensor)
endIf()

if(PLATFORM STREQUAL "stm32")    
    add_executable(test_sensor_stm32
        tests/stm32/test_sensor_stm32.cpp 
        tests/stm32/startup.c)
    target_include_directories(test_sensor_stm32 PRIVATE tests/stm32)

    target_link_libraries(test_sensor_stm32 PRIVATE sensor_model)

    # Say Linker to use our memory map
    target_link_options(test_sensor_stm32 PRIVATE
        "-T${CMAKE_CURRENT_SOURCE_DIR}/tests/stm32/stm32f4.ld"
        "-Wl,-Map=${CMAKE_CURRENT_BINARY_DIR}/sensor_stm32.map"
    )

endif()

# === AUSGABE ===
message(STATUS "light-mbse-pipeline-skeleton - Build konfiguriert")
message(STATUS "Compiler: ${CMAKE_CXX_COMPILER_ID}")