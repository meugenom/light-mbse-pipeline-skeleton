% Validation Test Results
addpath("plots", "utils", "core", "validation");

% Define the directory for saving plots
plot_dir = '../octave/plots';

% 1. Define filenames and get tested result data
filename_tested_table = '../logs/test_posix_parsed.csv';
[RAW_ADC_TEST, ANGLE_DEG_TEST, VOLTAGE_V_TEST] = parse_test_table(filename_tested_table);

% 2. Define the filename for the motor pure row data
filename_potentiometer_properties = '../references/Potentiometer-Properties.csv';
[V_REF, ANGLE_MAX, ADC_RESOLUTION, SENSOR_TAB_SIZE] = parse_potentiometer_properties(filename_potentiometer_properties);

% 3. Calculate IDEAL (theoretical) values for each RAW_ADC_TEST
v_ref_val = V_REF.parameter_value;
angle_max_val = ANGLE_MAX.parameter_value;
adc_res_val = ADC_RESOLUTION.parameter_value;

% Convert ADC to turn percentage for the X axis (0% - 100%)
TURN_PCT = (RAW_ADC_TEST / adc_res_val) * 100;

% Ideal straight line
ANGLE_THEORY = (RAW_ADC_TEST / adc_res_val) * angle_max_val;
VOLTAGE_THEORY = (RAW_ADC_TEST / adc_res_val) * v_ref_val;

% 4. Calculate relative error in percentage (C++ vs Theory)
% Use max(..., 0.001) to avoid division by zero at the very beginning (at 0%)
err_angle_pct = (ANGLE_DEG_TEST - ANGLE_THEORY) ./ max(ANGLE_THEORY, 0.001) * 100;
err_voltage_pct = (VOLTAGE_V_TEST - VOLTAGE_THEORY) ./ max(VOLTAGE_THEORY, 0.001) * 100;

% 5. Plot the error graph
figure_1 = figure('Name', 'Analysis Errors (Potentiometer)', 'Position', [100, 100, 800, 500]);
hold on; grid on;

% Angle error line (blue)
plot(TURN_PCT, err_angle_pct, '-ob', 'LineWidth', 2, 'DisplayName', 'Angle Error (%)');

% Voltage error line (red)
plot(TURN_PCT, err_voltage_pct, '-sr', 'LineWidth', 2, 'DisplayName', 'Voltage Error (%)');

title('Discrepancy between C++ Interpolation and Theoretical Model');
xlabel('Potentiometer Turn (%)');
ylabel('Relative Error (%)');
legend('Location', 'northeast');

% --- TOLERANCE LINES ---
% Standard check at 5% (as was in the motor)
yline(5, '--k', 'Tolerance +5%', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'left');
yline(-5, '--k', 'Tolerance -5%', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'left');

% Strict check according to the datasheet (Independent linearity 0.3%)
yline(0.3, ':g', 'Datasheet Linearity +0.3%', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'right');
yline(-0.3, ':g', 'Datasheet Linearity -0.3%', 'LineWidth', 1.5, 'LabelHorizontalAlignment', 'right');

hold off;

% Save the figure for SPEC.md
saveas(figure_1, fullfile(plot_dir, 'plot_errors.png'));

printf("Validation plot generated and saved to %s\n", plot_dir);

% Generate a Summary in the Validation.md
filename_validation_sum = '../VALIDATION.md';
filename_text_sum = '../logs/test_summary.txt';
filename_sensor_properties = '../references/Potentiometer-Properties.csv';
generate_validation_sum(filename_validation_sum, ...
                        filename_text_sum, ...
                        filename_sensor_properties, ...
                        TURN_PCT, err_angle_pct, err_voltage_pct);

printf("Validation analysis completed.\n");