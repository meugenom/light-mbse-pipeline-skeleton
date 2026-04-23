function [POINT_ID, ROW_ADC_VALUE, DESCRIPTION] = parse_potentiometer_data(filename, GRAMS_TO_NEWTONS)
    
    printf('Parsing potentiometer data from file: %s\n', filename);

    % read file
    raw_text = fileread(filename);
    clean_text = strrep(raw_text, '"', '');
    C = textscan(clean_text, '%f %f %s', ...
                'Delimiter', ',', 'HeaderLines', 1, 'CollectOutput', 1);
    data = C{1};
    printf("Strings loaded: %d\n", size(data, 1));

    % 2. Extracting columns
    % The CSV has columns: POINT_ID, ROW_ADC_VALUE, DESCRIPTION.
    POINT_ID = data(:, 1);
    ROW_ADC_VALUE = data(:, 2);
    DESCRIPTION = C{2};

end