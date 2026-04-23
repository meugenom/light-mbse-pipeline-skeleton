function [] = generate_spec_markdown(filename, V_REF, ANGLE_MAX, ADC_RESOLUTION, SENSOR_TAB_SIZE, ...
                                        POINT_ID, ROW_ADC_VALUE, DESCRIPTION)

    % Putting SPEC to the file ./SPEC.md
    fid = fopen('../SPEC.md', 'w');
        if fid == -1
            error('Datei konnte nicht geöffnet werden: ../SPEC.md');
    end

    gen_time = datestr(now, 'yyyy-mm-dd HH:MM:SS');

    % Write the specifications to the file
    fprintf(fid, '# Specifications for Potentiometer:\n');
    fprintf(fid, '> AUTO-GENERATED from `/octave/main.m` on %s\n\n', gen_time);

    fprintf(fid, '## Components:\n');
    fprintf(fid, '1. **Potentiometer:**\n');
    

    fprintf(fid, '## 1. Potentiometer Specifications\n\n');
    fprintf(fid, 'These values represent the physical and electrical properties of the potentiometer.\n\n');
    
    fprintf(fid, '| Constraint Name | Parameter Name | Parameter Value | Parameter Unit |\n');
    fprintf(fid, '|---|---|---|---|\n');
    fprintf(fid, '|%s|%s|%.4f|%s|\n', V_REF.constraint_name, V_REF.parameter_name, V_REF.parameter_value, V_REF.parameter_unit);    
    fprintf(fid, '|%s|%s|%.4f|%s|\n', ANGLE_MAX.constraint_name, ANGLE_MAX.parameter_name, ANGLE_MAX.parameter_value, ANGLE_MAX.parameter_unit);
    fprintf(fid, '|%s|%s|%.4f|%s|\n', ADC_RESOLUTION.constraint_name, ADC_RESOLUTION.parameter_name, ADC_RESOLUTION.parameter_value, ADC_RESOLUTION.parameter_unit);
    fprintf(fid, '|%s|%s|%.4f|%s|\n', SENSOR_TAB_SIZE.constraint_name, SENSOR_TAB_SIZE.parameter_name, SENSOR_TAB_SIZE.parameter_value, SENSOR_TAB_SIZE.parameter_unit);


    fprintf(fid, '## 4. Test Report from Data\n\n');
    fprintf(fid, '| POINT_ID | RAW_ADC_VALUE | DESCRIPTION |\n');
    fprintf(fid, '|---|---|---|\n');
    for i = 1:length(POINT_ID)
        fprintf(fid, '|%g|%g|%s|\n', POINT_ID(i), ROW_ADC_VALUE(i), DESCRIPTION{i});
    end    

    fclose(fid);
end
