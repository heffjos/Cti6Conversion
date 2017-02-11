function PrintNiftiHeader(FileName)
% function PrintNiftiHeader(FileName)
%
% INPUT
%  FileName - full path to nifti file name(s); leave empty for manual selection
%

    if exist('FileName', 'var') ~= 1 || isempty(FileName)
        NiiFiles = spm_select(Inf, 'nii$', 'Select nii files...');
        for i = 1:size(NiiFiles, 1)
            FileName{i} = NiiFiles(i, :);
        end
        clear i
    else ischar(FileName)
        FileName = {FileName};
    end

    PrintHdrs{1} = '-------------------';
    PrintHdrs{2} = '------';
    PrintHdrs{3} = '-----';
    PrintHdrs{4} = '------';
    for i = 1:numel(PrintHdrs)
        N(i) = length(PrintHdrs{i});
    end
    clear i

    for i = 1:size(FileName, 1)
        Fid = fopen(FileName{i}, 'rb');

        sizeof_hdr = fread(Fid, 1, 'int32'); % 0 4  
        data_type = fread(Fid, 10, 'char');  % 4 10
        db_name = fread(Fid, 18, 'char');    % 14 18 
        extents = fread(Fid, 1, 'int32');    % 32 4
        session_error = fread(Fid, 1, 'int16'); % 36 2
        regular = fread(Fid, 1, 'char'); % 38 1
        dim_info = fread(Fid, 1, 'char'); % 39 1
        dim = fread(Fid, 8, 'int16'); % 40 16
        intent_p1 = fread(Fid, 1, 'float32'); % 56 4
        intent_p2 = fread(Fid, 1, 'float32'); % 60 4
        intent_p3 = fread(Fid, 1, 'float32'); % 64 4
        intent_code = fread(Fid, 1, 'int16'); % 68 2
        datatype = fread(Fid, 1, 'int16'); % 70 2
        bitpix = fread(Fid, 1, 'int16'); % 72 2
        slice_start = fread(Fid, 1, 'int16'); % 74 2
        pixdim = fread(Fid, 8, 'float32'); % 76 32
        vox_offset = fread(Fid, 1, 'float32'); % 108 4
        scl_slope = fread(Fid, 1, 'float32'); % 112 4
        scl_inter = fread(Fid, 1, 'float32'); % 116 4
        slice_end = fread(Fid, 1, 'int16'); % 120 2
        slice_code = fread(Fid, 1, 'char'); % 122 1
        xyzt_units = fread(Fid, 1, 'char'); % 123 1
        cal_max = fread(Fid, 1, 'float32'); % 124 4
        cal_min = fread(Fid, 1, 'float32'); % 128 4
        slice_duration = fread(Fid, 1, 'float32'); % 132 4
        toffset = fread(Fid, 1, 'float32'); % 136 4
        glmax = fread(Fid, 1, 'int32'); % 140 4
        glmin = fread(Fid, 1, 'int32'); % 144 4
        descrip = fread(Fid, 80, 'char'); % 148 80
        aux_file = fread(Fid, 24, 'char'); % 228 24
        qform_code = fread(Fid, 1, 'int16'); % 252 2
        sform_code = fread(Fid, 1, 'int16'); % 254 2
        quatern_b = fread(Fid, 1, 'float32'); % 256 4
        quatern_c = fread(Fid, 1, 'float32'); % 260 4
        quatern_d = fread(Fid, 1, 'float32'); % 264 4
        qoffset_x = fread(Fid, 1, 'float32'); % 268 4
        qoffset_y = fread(Fid, 1, 'float32'); % 272 4
        qoffset_z = fread(Fid, 1, 'float32'); % 276 4
        srow_x = fread(Fid, 4, 'float32'); % 280 16
        srow_y = fread(Fid, 4, 'float32'); % 296 16
        srow_z = fread(Fid, 4, 'float32'); % 312 16
        intent_name = fread(Fid, 16, 'char'); % 328 16
        magic = fread(Fid, 4, 'char'); % 344 4
      
        Offset = 0; 
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

        Offset = PrintInfo(N, 'sizeof_hdr', Offset, sizeof_hdr, 'int32');
        Offset = PrintInfo(N, 'data_type', Offset, data_type, 'char');
        Offset = PrintInfo(N, 'db_name', Offset, db_name, 'char');
        Offset = PrintInfo(N, 'extents', Offset, extents, 'int32');
        Offset = PrintInfo(N, 'session_error', Offset, session_error, 'int16');
        Offset = PrintInfo(N, 'regular', Offset, regular, 'char');
        Offset = PrintInfo(N, 'dim_info', Offset, dim_info, 'char');
        Offset = PrintInfo(N, 'dim', Offset, dim, 'int16');
        Offset = PrintInfo(N, 'intent_p1', Offset, intent_p1, 'float32');
        Offset = PrintInfo(N, 'intent_p2', Offset, intent_p2, 'float32');
        Offset = PrintInfo(N, 'intent_p3', Offset, intent_p3, 'float32');
        Offset = PrintInfo(N, 'intent_code', Offset, intent_code, 'int16');
        Offset = PrintInfo(N, 'datatype', Offset, datatype, 'int16');
        Offset = PrintInfo(N, 'bitpix', Offset, bitpix, 'int16');
        Offset = PrintInfo(N, 'slice_start', Offset, slice_start, 'int16');
        Offset = PrintInfo(N, 'pixdim', Offset, pixdim, 'float32');
        Offset = PrintInfo(N, 'vox_offset', Offset, vox_offset, 'float32');
        Offset = PrintInfo(N, 'scl_slope', Offset, scl_slope, 'float32');
        Offset = PrintInfo(N, 'scl_inter', Offset, scl_inter, 'float32');
        Offset = PrintInfo(N, 'slice_end', Offset, slice_end, 'int16');
        Offset = PrintInfo(N, 'slice_code', Offset, slice_code, 'char');
        Offset = PrintInfo(N, 'xyzt_units', Offset, xyzt_units, 'char');
        Offset = PrintInfo(N, 'cal_max', Offset, cal_max, 'float32');
        Offset = PrintInfo(N, 'cal_min', Offset, cal_min, 'float32');
        Offset = PrintInfo(N, 'slice_duration', Offset, slice_duration, 'float32');
        Offset = PrintInfo(N, 'toffset', Offset, toffset, 'float32');
        Offset = PrintInfo(N, 'glmax', Offset, glmax, 'int32');
        Offset = PrintInfo(N, 'glmin', Offset, glmin, 'int32');
        Offset = PrintInfo(N, 'descrip', Offset, descrip, 'char');
        Offset = PrintInfo(N, 'aux_file', Offset, aux_file, 'char');
        Offset = PrintInfo(N, 'qform_code', Offset, qform_code, 'int16');
        Offset = PrintInfo(N, 'sform_code', Offset, sform_code, 'int16');
        Offset = PrintInfo(N, 'quatern_b', Offset, quatern_b, 'float32');
        Offset = PrintInfo(N, 'quatern_c', Offset, quatern_c, 'float32');
        Offset = PrintInfo(N, 'quatern_d', Offset, quatern_d, 'float32');
        Offset = PrintInfo(N, 'qoffset_x', Offset, qoffset_x, 'float32');
        Offset = PrintInfo(N, 'qoffset_y', Offset, qoffset_y, 'float32');
        Offset = PrintInfo(N, 'qoffset_z', Offset, qoffset_z, 'float32');
        Offset = PrintInfo(N, 'srow_x', Offset, srow_x, 'float32');
        Offset = PrintInfo(N, 'srow_y', Offset, srow_y, 'float32');
        Offset = PrintInfo(N, 'srow_z', Offset, srow_z, 'float32');
        Offset = PrintInfo(N, 'intent_name', Offset, intent_name, 'char');
        Offset = PrintInfo(N, 'magic', Offset, magic, 'char');

        fprintf('--- %s ---\n\n', FileName{i})
        fclose(Fid);
    end
    clear i
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

