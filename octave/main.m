% main.m
addpath("plots", "utils", "core", "validation");

% Define the filename for the motor properties CSV file
filename_potentiometer_properties = '../references/Potentiometer-Properties.csv';
% Define the filename for the motor model CSV file
filename_potentiometer_data = '../references/Potentiometer-Data.csv';
% Define the filename for the output SPEC.md file
filename_spec_md = './SPEC.md';
% Define the filename for the output LUT header file
filename_lut = '../src/includes/sensor_lut.h';
% Define the directory for saving plots
plot_dir = '../octave/plots';



% 1. Run parsing from datasheet
[V_REF, ANGLE_MAX, ADC_RESOLUTION, SENSOR_TAB_SIZE] = parse_potentiometer_properties(filename_potentiometer_properties);

% 2. Run parsing from motor model CSV file
[POINT_ID, RAW_ADC_VALUE, DESCRIPTION] = parse_potentiometer_data(filename_potentiometer_data);

printf("Ok! Data parsed from CSV files.\n");

% 3. Generate SPEC.md file
generate_spec_markdown(filename_spec_md, ...
    V_REF, ANGLE_MAX, ADC_RESOLUTION, SENSOR_TAB_SIZE, ...
    POINT_ID, RAW_ADC_VALUE, DESCRIPTION);

printf("Ok! SPEC.md generated in %s\n", filename_spec_md);

% 4 Calculate LUT values
valid_idx = (RAW_ADC_VALUE >= 0) & (RAW_ADC_VALUE <= ADC_RESOLUTION.parameter_value);

% 5. Calculate factual angle values for each point from the data file
% This is a linear mapping from ADC values to angles, based on the potentiometer's characteristics.
ADC_POINTS = RAW_ADC_VALUE(valid_idx);
ANGLE_POINTS = (POINT_ID(valid_idx) / 10) * ANGLE_MAX.parameter_value;

% 6. Generating LUT in 100 steps
lut_adc = linspace(0, ADC_RESOLUTION.parameter_value, SENSOR_TAB_SIZE.parameter_value);

% Linear interpolation: find the angle for each step of the ADC grid
% 'linear' — because the potentiometer is usually linear
% 'extrap' — in case the data slightly goes out of bounds
lut_angle = interp1(ADC_POINTS, ANGLE_POINTS, lut_adc, 'linear', 'extrap');

% Calculate the equivalent voltage for the LUT (for debugging)
lut_voltage = (lut_adc / ADC_RESOLUTION.parameter_value) * V_REF.parameter_value;

% Safety Clamping
lut_angle(lut_angle < 0) = 0.0;
lut_angle(lut_angle > ANGLE_MAX.parameter_value) = ANGLE_MAX.parameter_value;

% 7. Save LUT to header file (sensor_lut.h)
% Using the same call structure as for the motor
generate_sensor_lut(filename_lut, ...
                    SENSOR_TAB_SIZE, ...
                    V_REF, ...
                    ANGLE_MAX, ...
                    ADC_RESOLUTION, ...
                    lut_adc, ...
                    lut_angle, ...
                    lut_voltage ...
                    )

printf("Ok! Sensor LUT saved in %s\n", filename_lut);

