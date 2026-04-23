function [] = generate_sensor_lut(filename, ...
                        SENSOR_TAB_SIZE, ...
                        V_REF, ...
                        ANGLE_MAX, ...
                        ADC_RESOLUTION, ...
                        lut_adc, ...
                        lut_angle, ...
                        lut_voltage ...
                        )

    fid = fopen(filename, 'w');
    if fid == -1
        error('Datei konnte nicht geöffnet werden: %s', filename);
    end

    gen_time = datestr(now, 'yyyy-mm-dd HH:MM:SS');

    fprintf(fid, '// ==========================================\n');
    fprintf(fid, '// AUTO-GENERATED LUT FOR SENSOR\n');
    fprintf(fid, '// Generated on: %s\n', gen_time);
    fprintf(fid, '// Sensor: Potentiometer\n');
    fprintf(fid, '// ==========================================\n');

    fprintf(fid, '#ifndef SENSOR_LUT_H\n');
    fprintf(fid, '#define SENSOR_LUT_H\n\n');

    fprintf(fid, '// %s %s %g %s \n', SENSOR_TAB_SIZE.constraint_name, SENSOR_TAB_SIZE.parameter_name, SENSOR_TAB_SIZE.parameter_value, SENSOR_TAB_SIZE.parameter_unit);
    fprintf(fid, 'static constexpr int SENSOR_TAB_SIZE = %d;\n\n', SENSOR_TAB_SIZE.parameter_value);

    fprintf(fid, '// %s %s %g %s \n', V_REF.constraint_name, V_REF.parameter_name, V_REF.parameter_value, V_REF.parameter_unit);
    fprintf(fid, 'static constexpr float V_REF = %.2ff;\n\n', V_REF.parameter_value);

    fprintf(fid, '// %s %s %g %s \n', ANGLE_MAX.constraint_name, ANGLE_MAX.parameter_name, ANGLE_MAX.parameter_value, ANGLE_MAX.parameter_unit);
    fprintf(fid, 'static constexpr float ANGLE_MAX = %.2ff;\n\n', ANGLE_MAX.parameter_value);

    fprintf(fid, '// %s %s %g %s \n', ADC_RESOLUTION.constraint_name, ADC_RESOLUTION.parameter_name, ADC_RESOLUTION.parameter_value, ADC_RESOLUTION.parameter_unit);
    fprintf(fid, 'static constexpr int ADC_RESOLUTION = %d;\n\n', ADC_RESOLUTION.parameter_value);


    % --- Generation Tabelle SENSOR_TAB_ANGLE ---
    fprintf(fid, '// REQ-PHY-005\n');
    fprintf(fid, 'static constexpr float SENSOR_TAB_ANGLE[] = {\n    ');
    for i = 1:length(lut_angle)
        fprintf(fid, '%.2ff', lut_angle(i));
        if i < length(lut_angle), fprintf(fid, ', '); end
        if mod(i, 10) == 0 && i < length(lut_angle), fprintf(fid, '\n    '); end
    end
    fprintf(fid, '\n};\n\n');

    fprintf(fid, '\n#endif // SENSOR_LUT_H\n');
    fclose(fid);

end