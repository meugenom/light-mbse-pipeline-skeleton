function [] = generate_validation_sum(filename_validation_sum, ...
                                      filename_text_sum, ...
                                      filename_sensor_properties, ...
                                      TURN_PCT, err_angle_pct, err_voltage_pct)

    % open finale protocol file for writing
    fid = fopen(filename_validation_sum, 'w');
    if fid == -1
        error('Datei konnte nicht geöffnet werden: %s', filename_validation_sum);
    end

    % open the test summary text file for reading
    test_text_fid = fopen(filename_text_sum, 'r');
    if test_text_fid == -1
        warning('Test summary file not found: %s', filename_text_sum);
        test_content_available = false;
    else
        test_content_available = true;
    end

    % generate the current date and time for the protocol
    gen_time = datestr(now, 'yyyy-mm-dd HH:MM:SS');
    
    fprintf(fid, '# Validation Protocol & Test Results\n\n');
    fprintf(fid, '**Generated on:** %s\n', gen_time);
    fprintf(fid, '\n## 1. HIL Test Summary (POSIX/STM32)\n\n'); 
    fprintf(fid, ' ### Potentiometer Properties\n\n');   

    % add csv table from sensor_properties to fid    
    % 'Delimiter', ';'
    raw_text = fileread(filename_sensor_properties);
    clean_text = strrep(raw_text, '"', '');
    lines = strsplit(clean_text, '\n');

    fprintf(fid, '| ID | Parameter | Value | Unit |\n');
    fprintf(fid, '|----|-----------|-------|------|\n');

        for i = 2:length(lines) % skip header line 
            line = strtrim(lines{i});
            if isempty(line), continue; end
    
            parts = strsplit(line, ';');
            if length(parts) >= 4
                fprintf(fid, '| %s | %s | %s | %s |\n', ...
                strtrim(parts{1}), strtrim(parts{2}), strtrim(parts{3}), strtrim(parts{4}));
            end
        end

    fprintf(fid, '\n\n');
    
    % add text from test_text to fid
    while ~feof(test_text_fid)
        line = fgetl(test_text_fid);
        if ischar(line) % Check if line is valid
            fprintf(fid, '%s\n', line);
        end
    end
    fclose(test_text_fid);    
    fprintf(fid, '\n\n');

    fprintf(fid, '## 2. Full Accuracy Data Trace\n\n');
    fprintf(fid, '| Turn Percentage | Angle Error %% | Voltage Error %% |\n');
    fprintf(fid, '|----------------|----------------|----------------|\n');
    for i = 1:length(TURN_PCT)
        fprintf(fid, '| %.2f | %.2f | %.2f|\n', TURN_PCT(i), err_angle_pct(i), err_voltage_pct(i));
    end
    fprintf(fid, '\n');
    fprintf(fid, '\n---\n');
    fprintf(fid, '</br>\n');
    fprintf(fid, '\n## 3. Accuracy Analysis (Calculation vs Real Data)\n\n');
    fprintf(fid, '**Max Angle Error:** %.2f%%\n\n', max(err_angle_pct));
    fprintf(fid, '**Max Voltage Error:** %.2f%%\n\n', max(err_voltage_pct));
    fprintf(fid, '\n');
    fprintf(fid, '![Discrepancy between real stand data and Theoretical Model](%s)\n', './octave/plots/plot_errors.png');
    fprintf(fid, '\n');
    fprintf(fid, '\n---\n');
    fprintf('Report saved to: %s\n', filename_validation_sum);
    fprintf(fid, '*Document Version: v.0.3.0 | Part of LIGHT-MBSE-PIPELINE-SKELETON*\n');  
    
    
    fclose(fid);

end