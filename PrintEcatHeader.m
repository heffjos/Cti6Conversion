function PrintEcatHeader(FileName)
% function PrintNiftiHeader(FileName)
%
% INPUT
%  FileName - full path to nifti file name(s); leave empty for manual selection
%

    if exist('FileName', 'var') ~= 1 || isempty(FileName)
        EcatFiles = spm_select(Inf, 'img$', 'Select img files...');
        for i = 1:size(EcatFiles, 1)
            FileName{i} = Ecatfiles(i, :);
        end
        clear i
    else ischar(FileName)
        FileName = {FileName};
    end

    PrintHdrs{1} = '----------------------';
    PrintHdrs{2} = '------';
    PrintHdrs{3} = '-----';
    PrintHdrs{4} = '------';
    for i = 1:numel(PrintHdrs)
        N(i) = length(PrintHdrs{i});
    end
    clear i

    for i = 1:size(FileName, 1)    
        Fid = fopen(FileName{i}, 'rb', 'ieee-le');
        fseek(Fid, 28);

        original_file_name = freadVAXD(Fid, 20, 'char'); % 28 20
        sw_version = freadVAXD(Fid, 1, 'int16'); % 48 2
        data_type = freadVAXD(Fid, 1, 'int16'); % 50 2
        system_type = freadVAXD(Fid, 1, 'int16'); % 52 2
        file_type = freadVAXD(Fid, 1, 'int16'); % 54 2
        node_id = freadVAXD(Fid, 10, 'char'); % 56 10
        scan_start_day = freadVAXD(Fid, 1, 'int16'); % 66 2
        scan_start_month = freadVAXD(Fid, 1, 'int16'); % 68 2
        scan_start_year = freadVAXD(Fid, 1, 'int16'); % 70 2
        scan_start_hour = freadVAXD(Fid, 1, 'int16'); % 72 2
        scan_start_minute = freadVAXD(Fid, 1, 'int16'); % 74 2
        scan_start_second = freadVAXD(Fid, 1, 'int16'); % 76 2
        isotope_code = freadVAXD(Fid, 8, 'char'); % 78 8
        isotope_halflife = freadVAXD(Fid, 1, 'float32'); % 86 4
        radiopharmaceutical = freadVAXD(Fid, 32, 'char'); % 90 32
        gantry_tilt = freadVAXD(Fid, 1, 'float32'); % 122 4
        gantry_rotation = freadVAXD(Fid, 1, 'float32'); % 126 4
        bed_elevation = freadVAXD(Fid, 1, 'float32'); % 130 4
        rot_source_speed = freadVAXD(Fid, 1, 'int16'); % 134 2
        wobble_speed = freadVAXD(Fid, 1, 'int16'); % 136 2
        transm_source_type = freadVAXD(Fid, 1, 'int16'); % 138 2
        axial_fov = freadVAXD(Fid, 1, 'float32'); % 140 4
        transaxial_fov = freadVAXD(Fid, 1, 'float32'); % 144 4
        transaxial_samp_mode = freadVAXD(Fid, 1, 'int16'); % 148 2
        coin_samp_mode = freadVAXD(Fid, 1, 'int16'); % 150 2
        axial_samp_mode = freadVAXD(Fid, 1, 'int16'); % 152 2
        calibration_factor = freadVAXD(Fid, 1, 'float32'); % 154 4
        calibration_units = freadVAXD(Fid, 1, 'int16'); % 158 2
        compression_code = freadVAXD(Fid, 1, 'int16'); % 160 2
        study_name = freadVAXD(Fid, 12, 'char'); % 162 12
        patient_id = freadVAXD(Fid, 16, 'char'); % 174 16
        patient_name = freadVAXD(Fid, 32, 'char'); % 190 32
        patient_sex = freadVAXD(Fid, 1, 'char'); % 222 1
        patient_age = freadVAXD(Fid, 10, 'char'); % 223 10
        patient_height = freadVAXD(Fid, 10, 'char'); % 233 10
        patient_weight = freadVAXD(Fid, 10, 'char'); % 243 10
        patient_dexterity = freadVAXD(Fid, 1, 'char'); % 253 1
        physician_name = freadVAXD(Fid, 32, 'char'); % 254 32
        operator_name = freadVAXD(Fid, 32, 'char'); % 286 32
        study_description = freadVAXD(Fid, 32, 'char'); % 318 32
        acquisition_type = freadVAXD(Fid, 1, 'int16'); % 350 2
        bed_type = freadVAXD(Fid, 1, 'int16'); % 352 2
        septa_type = freadVAXD(Fid, 1, 'int16'); % 354 2
        facility_name = freadVAXD(Fid, 20, 'char'); % 356 20
        num_planes = freadVAXD(Fid, 1, 'int16'); % 376 2
        num_frames = freadVAXD(Fid, 1, 'int16'); % 378 2
        num_gates = freadVAXD(Fid, 1, 'int16'); % 380 2
        num_bed_pos = freadVAXD(Fid, 1, 'int16'); % 382 2
        init_bed_position = freadVAXD(Fid, 1, 'float32'); % 384 4
        bed_offset = freadVAXD(Fid, 15, 'float32'); % 388 60
        plane_separation = freadVAXD(Fid, 1, 'float32'); % 448 4
        lwr_sctr_thres = freadVAXD(Fid, 1, 'int16'); % 452 2
        lwr_true_thres = freadVAXD(Fid, 1, 'int16'); % 454 2
        upr_true_thres = freadVAXD(Fid, 1, 'int16'); % 456 2
        collimator = freadVAXD(Fid, 1, 'float32'); % 458 4
        user_process_code = freadVAXD(Fid, 10, 'char'); % 462 10
        acquisition_mode = freadVAXD(Fid, 1, 'int16'); % 472 2

        Offset = 28; 
        fprintf(1, '%-*s %-*s %-*s %-*s\n', ...
            N(1), 'name', ...
            N(2), 'offset', ...
            N(3), 'nvals', ...
            N(4), 'values'); 
        fprintf(1, '%-*s %-*s %-*s %-*s\n', ...
            N(1), PrintHdrs{1}, ...
            N(2), PrintHdrs{2}, ...
            N(3), PrintHdrs{3}, ...
            N(4), PrintHdrs{4});

        Offset = PrintInfo(N, 'original_file_name', Offset, original_file_name, 'char');
        Offset = PrintInfo(N, 'sw_version', Offset, sw_version, 'int16');
        Offset = PrintInfo(N, 'data_type', Offset, data_type, 'int16');
        Offset = PrintInfo(N, 'system_type', Offset, system_type, 'int16');
        Offset = PrintInfo(N, 'file_type', Offset, file_type, 'int16');
        Offset = PrintInfo(N, 'node_id', Offset, node_id, 'char');
        Offset = PrintInfo(N, 'scan_start_day', Offset, scan_start_day, 'int16');
        Offset = PrintInfo(N, 'scan_start_month', Offset, scan_start_month, 'int16');
        Offset = PrintInfo(N, 'scan_start_year', Offset, scan_start_year, 'int16');
        Offset = PrintInfo(N, 'scan_start_hour', Offset, scan_start_hour, 'int16');
        Offset = PrintInfo(N, 'scan_start_minute', Offset, scan_start_minute, 'int16');
        Offset = PrintInfo(N, 'scan_start_second', Offset, scan_start_second, 'int16');
        Offset = PrintInfo(N, 'isotope_code', Offset, isotope_code, 'char');
        Offset = PrintInfo(N, 'isotope_halflife', Offset, isotope_halflife, 'float32');
        Offset = PrintInfo(N, 'radiopharmaceutical', Offset, radiopharmaceutical, 'char');
        Offset = PrintInfo(N, 'gantry_tilt', Offset, gantry_tilt, 'float32');
        Offset = PrintInfo(N, 'gantry_rotation', Offset, gantry_rotation, 'float32');
        Offset = PrintInfo(N, 'bed_elevation', Offset, bed_elevation, 'float32');
        Offset = PrintInfo(N, 'rot_source_speed', Offset, rot_source_speed, 'int16');
        Offset = PrintInfo(N, 'wobble_speed', Offset, wobble_speed, 'int16');
        Offset = PrintInfo(N, 'transm_source_type', Offset, transm_source_type, 'int16');
        Offset = PrintInfo(N, 'axial_fov', Offset, axial_fov, 'float32');
        Offset = PrintInfo(N, 'transaxial_fov', Offset, transaxial_fov, 'float32');
        Offset = PrintInfo(N, 'transaxial_samp_mode', Offset, transaxial_samp_mode, 'int16');
        Offset = PrintInfo(N, 'coin_samp_mode', Offset, coin_samp_mode, 'int16');
        Offset = PrintInfo(N, 'axial_samp_mode', Offset, axial_samp_mode, 'int16');
        Offset = PrintInfo(N, 'calibration_factor', Offset, calibration_factor, 'float32');
        Offset = PrintInfo(N, 'calibration_units', Offset, calibration_units, 'int16');
        Offset = PrintInfo(N, 'compression_code', Offset, compression_code, 'int16');
        Offset = PrintInfo(N, 'study_name', Offset, study_name, 'char');
        Offset = PrintInfo(N, 'patient_id', Offset, patient_id, 'char');
        Offset = PrintInfo(N, 'patient_name', Offset, patient_name, 'char');
        Offset = PrintInfo(N, 'patient_sex', Offset, patient_sex, 'char');
        Offset = PrintInfo(N, 'patient_age', Offset, patient_age, 'char');
        Offset = PrintInfo(N, 'patient_height', Offset, patient_height, 'char');
        Offset = PrintInfo(N, 'patient_weight', Offset, patient_weight, 'char');
        Offset = PrintInfo(N, 'patient_dexterity', Offset, patient_dexterity, 'char');
        Offset = PrintInfo(N, 'physician_name', Offset, physician_name, 'char');
        Offset = PrintInfo(N, 'operator_name', Offset, operator_name, 'char');
        Offset = PrintInfo(N, 'study_description', Offset, study_description, 'char');
        Offset = PrintInfo(N, 'acquisition_type', Offset, acquisition_type, 'int16');
        Offset = PrintInfo(N, 'bed_type', Offset, bed_type, 'int16');
        Offset = PrintInfo(N, 'septa_type', Offset, septa_type, 'int16');
        Offset = PrintInfo(N, 'facility_name', Offset, facility_name, 'char');
        Offset = PrintInfo(N, 'num_planes', Offset, num_planes, 'int16');
        Offset = PrintInfo(N, 'num_frames', Offset, num_frames, 'int16');
        Offset = PrintInfo(N, 'num_gates', Offset, num_gates, 'int16');
        Offset = PrintInfo(N, 'num_bed_pos', Offset, num_bed_pos, 'int16');
        Offset = PrintInfo(N, 'init_bed_position', Offset, init_bed_position, 'float32');
        Offset = PrintInfo(N, 'bed_offset', Offset, bed_offset, 'float32');
        Offset = PrintInfo(N, 'plane_separation', Offset, plane_separation, 'float32');
        Offset = PrintInfo(N, 'lwr_sctr_thres', Offset, lwr_sctr_thres, 'int16');
        Offset = PrintInfo(N, 'lwr_true_thres', Offset, lwr_true_thres, 'int16');
        Offset = PrintInfo(N, 'upr_true_thres', Offset, upr_true_thres, 'int16');
        Offset = PrintInfo(N, 'collimator', Offset, collimator, 'float32');
        Offset = PrintInfo(N, 'user_prcoess_code', Offset, user_process_code, 'char');
        Offset = PrintInfo(N, 'acquisition_mode', Offset, acquisition_mode, 'int16');
        
        fprintf('--- %s ---\n\n', FileName{i})
        fclose(Fid);
    end
end

        
        
        
        
        
function Offset = PrintInfo(N, Descrip, Offset, Value, Type)
% function PrintInfo(N, Descrip, Offset, NVals
%
% INPUT
%  N - vector, contains minimum lengths for values printed
%  Descrip - string, field description
%  Offset - integer, current place in nifti header
%  Value - int, float, or str to be printed
%  Type - specifies the type for Value
%

    NVal = numel(Value);
    fprintf(1, '%-*s %-*d %-*d ', N(1), Descrip, N(2), Offset, N(3), NVal);

    if strcmp(lower(Type), 'char')
        fprintf(1, '%s\n', Value);
        Offset = Offset + 1 * NVal;
    elseif any(strcmp(lower(Type), {'int16', 'int32'}))
        if NVal > 1
            for i = 1:(NVal-1)
                fprintf(1, '%d ', Value(i));
            end
        end
        fprintf(1, '%d\n', Value(end));

        if strcmp(lower(Type), 'int16')
            Offset = Offset + 2 * NVal;
        else
            Offset = Offset + 4 * NVal;
        end
    elseif strcmp(lower(Type), 'float32')
        if NVal > 1
            for i = 1:(NVal-1)
                fprintf(1, '%0.1f ', Value(i));
            end
        end
        fprintf(1, '%0.1f\n', Value(end));
        Offset = Offset + 4 * NVal;
    else
        error('Invalid type: %s', Type);
    end
end
