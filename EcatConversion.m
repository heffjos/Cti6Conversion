clear all;
Cti6Files = spm_select(Inf, 'img$', 'Select CTI6 files...');

for i = 1:size(Cti6Files, 1)
    FileName = strtrim(Cti6Files(i, :));
    [p f e] = fileparts(FileName);

    Cti6Hdr = ReadCti6Hdr(FileName);

    % write out each frame, typically this is the k1 and dv in that order
    % never have I seen a CTI6 file from the PET lab with > 2 frames, but
    % the code can handle it
    for iFrame = 1:Cti6Hdr.FrameNum
        % read data and flip for correct orientation
        Data = ReadCti6Data(Cti6Hdr, iFrame, FileName);
        Data = Data(end:-1:1,end:-1:1,end:-1:1);

        % create nifti header here
        dat = file_array;
        if iFrame == 1
            dat.fname = fullfile(p, [f '_k1.nii']);
        elseif iFrame == 2
            dat.fname = fullfile(p, [f '_dv.nii']);
        else
            dat.fname = fullfile(p, [f '_f' num2str(iFrame) '.nii']);
        end

        dat.dim = [Cti6Hdr.dim1 Cti6Hdr.dim2 Cti6Hdr.dim3];
        dat.dtype = 'FLOAT32-LE';
        dat.scl_slope = 1;
        dat.scl_inter = 0;
        dat.offset = 352;
        
        N = nifti();
        N.dat = dat;
        N.mat = [Cti6Hdr.PixelSize 0  0 -(Cti6Hdr.PixelSize * Cti6Hdr.dim1)/2;
            0 Cti6Hdr.PixelSize 0 -(Cti6Hdr.PixelSize * Cti6Hdr.dim2)/2;
            0 0 Cti6Hdr.SliceWidth -(Cti6Hdr.SliceWidth * Cti6Hdr.dim3)/2
            0 0 0 1];
        N.mat_intent = 'Scanner';
        N.mat0 = N.mat;
        N.mat0_intent = 'Scanner';
        N.descrip = 'Converted from CTI6 :)';
        
        create(N);
        dat(:, :, :, :) = Data;
    end

    % deidentify ECAT
    Fill1 = repmat('-', 1, 32);
    Fill2 = repmat('-', 1, 16);

    EcatFid = fopen(FileName, 'r+');

    fseek(EcatFid, 190, -1);
    fwrite(EcatFid, Fill1, 'uchar');
    fseek(EcatFid, 190, -1);
    NewField1 = fread(EcatFid, 32, 'uchar=>char')';

    fseek(EcatFid, 174, -1);
    fwrite(EcatFid, Fill1, 'uchar');
    fseek(EcatFid, 174, -1);
    NewField2 = fread(EcatFid, 16, 'uchar=>char')';

    fprintf(1, 'File name: %s\n', FileName);
    fprintf(1, 'Frames   : %d', Cti6Hdr.FrameNum);
    if Cti6Hdr.FrameNum ~= 2
        fprintf(1, ' (EXPECTED 2; WEIRD CTI6 FILE)');
    end
    fprintf(1, '\n');
    fprintf(1, 'Field1   : %s\n', Fill1);
    fprintf(1, 'Field2   : %s\n\n', Fill2);
        
end
