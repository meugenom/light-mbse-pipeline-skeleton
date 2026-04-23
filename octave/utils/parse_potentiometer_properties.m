function [V_REF, ANGLE_MAX, ADC_RESOLUTION, SENSOR_TAB_SIZE] = parse_potentiometer_properties(filename)

    printf('Parsing potentiometer properties from file: %s\n', filename);

    % read file
    raw_text = fileread(filename);
    clean_text = strrep(raw_text, '"', '');
    lines = strsplit(clean_text, '\n');

    % Initialize variables
    V_REF = {};
    ANGLE_MAX = {};
    ADC_RESOLUTION = {};
    SENSOR_TAB_SIZE = {};

    % Parse lines
    for i = 1:length(lines)

        line = strtrim(lines{i});

        if isempty(line)
            continue; % skip empty lines
        end

        parts = strsplit(line, ';');

        if length(parts) ~= 4
            continue; % skip malformed lines
        end

        constraint_name = strtrim(parts{1});
        parameter_name = strtrim(parts{2});
        parameter_value = strtrim(parts{3});
        parameter_unit = strtrim(parts{4}); % not used in this function

        % Assign values based on parameter name
        switch parameter_name
            case 'V_REF'
                V_REF.constraint_name = constraint_name;
                V_REF.parameter_name = parameter_name;
                V_REF.parameter_value = str2double(parameter_value);
                V_REF.parameter_unit = parameter_unit;
            case 'ANGLE_MAX'
                ANGLE_MAX.constraint_name = constraint_name;
                ANGLE_MAX.parameter_name = parameter_name;
                ANGLE_MAX.parameter_value = str2double(parameter_value);
                ANGLE_MAX.parameter_unit = parameter_unit;
            case 'ADC_RESOLUTION'
                ADC_RESOLUTION.constraint_name = constraint_name;
                ADC_RESOLUTION.parameter_name = parameter_name;
                ADC_RESOLUTION.parameter_value = str2double(parameter_value);
                ADC_RESOLUTION.parameter_unit = parameter_unit;
            case 'SENSOR_TAB_SIZE'
                SENSOR_TAB_SIZE.constraint_name = constraint_name;
                SENSOR_TAB_SIZE.parameter_name = parameter_name;
                SENSOR_TAB_SIZE.parameter_value = str2double(parameter_value);
                SENSOR_TAB_SIZE.parameter_unit = parameter_unit;
        end
    end
end
