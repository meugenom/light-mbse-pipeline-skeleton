function [RAW_ADC_TEST, ANGLE_DEG_TEST, VOLTAGE_V_TEST] = parse_test_table(filename)

    printf('Parsing motor properties from file: %s\n', filename);

    RAW_ADC_TEST = [];
    ANGLE_DEG_TEST = [];
    VOLTAGE_V_TEST = [];

    raw_data = dlmread(filename, ';', 1, 0); % Skip the header row (1) and start from the first column (0)

    printf('Parsed %d rows of test data.\n', size(raw_data, 1));

    if size(raw_data, 2) < 3
        error('Expected at least 3 columns in the test data CSV file.');
    end

    RAW_ADC_TEST = raw_data(:, 1);
    ANGLE_DEG_TEST = raw_data(:, 2);
    VOLTAGE_V_TEST = raw_data(:, 3);

end
