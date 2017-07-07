function EcatCsvConversion(FileList)
% function DeidentifyEcat(FileList)
%
% INPUT
%   FileList - csv file listing files to deidentify 1 per line
%       FIELD1 - full path to .img file
%       FIELD2 - participant name (typically this is the name given by North campus scanner)
%       FIELD3 - time (5-40, 45-90, 5-90, etc.)
%       FIELD4 - the study name, currently suppored:
%           endopoid0

    VALIDSTUDIES = {'endopoid0'};
    if exist(FileList, 'file') ~= 2
        error('File list %s does not exist.', FileList);
    end

    FileLines = {};
    LinesIdx = 1;
    Fid = fopen(FileList, 'r');
    Line = fgetl(Fid);
    while ischar(Line)
        if ~strcmp(Line(1), '#')
            FileLines{LinesIdx} = Line;
            LinesIdx = LinesIdx + 1;
        end
        Line = fgetl(Fid);
    end
    fclose(Fid);

    if isempty(FileLines)
        error('Empty file: %s', FileList);
    end

    for i = 1:numel(FileLines)
        Tmp = textscan(FileLines{i}, '%s%s%s%s', 'Delimiter', ',');
        FileNames{i} = Tmp{1}{1};
        Participants{i} = Tmp{2}{1};
        Time{i} = Tmp{3}{1};
        Studies{i} = Tmp{4}{1};
    end

    % check valid studies
    for i = 1:numel(Studies)
        Studies{i} = lower(Studies{i});
        if ~any(strcmp(Studies{i}, VALIDSTUDIES))
            error('Csv file: %s, Line number %d, Invalid study %s.', ...
                FileLIst, i, Studies{i});
        end
    end

    % check if input ECAT files exist and correct frame numbers
    for i = 1:numel(FileNames)
        if exist(FileNames{i}, 'file') ~= 2
            error('Csv file: %s, Line number %d, ECAT file %s does not exist.', ...
                FileList, i, FileNames{i});
        end

        Cti6Hdr = ReadCti6Hdr(FileNames{i});
        if strcmp(Studies{i}, 'endopoid0') && Cti6Hdr.FrameNum < 2
            error('ECAT file %s, Line number %d, Expected frames > 2, but found %d', ...
                FileNames{i}, i, Cti6Hdr.FrameNum);
        end
    end

    % checks are good now we do work
    for i = 1:numel(FileNames)
        mkdir(fullfile(pwd, Participants{i}, 'CTI6'));
        mkdir(fullfile(pwd, Participants{i}, 'run_01'));

        % generate output file names based on study
        if strcmp(Studies{i}, 'endopoid0')
            OutFile{1} = sprintf('%s_R0SMLGN_%s_k1_CFN.nii', Participants{i}, Time{i});
            OutFile{2} = sprintf('%s_R0SMLGN_%s_dv_CFN.nii', Participants{i}, Time{i});
        end

        % convert ECAT to nifti
        Cti6Hdr = ReadCti6Hdr(FileNames{i});
        for iFrame = [1 2]
            % read data and flip for correct orientation
            Data = ReadCti6Data(Cti6Hdr, iFrame, FileNames{i});
            Data = Data(end:-1:1,end:-1:1,end:-1:1);

            % create nifti header here
            dat = file_array;
            dat.fname = fullfile(pwd, Participants{i}, 'run_01', OutFile{iFrame});
            dat.dim = [Cti6Hdr.dim1 Cti6Hdr.dim2 Cti6Hdr.dim3];
            dat.dtype = 'FLOAT32-LE';
            dat.scl_slope = 1;
            dat.scl_inter = 0;
            dat.offset = 352;
            
            N = nifti();
            N.dat = dat;
            N.mat = [Cti6Hdr.PixelSize 0  0 (Cti6Hdr.PixelSize * Cti6Hdr.dim1)/2;
                0 Cti6Hdr.PixelSize 0 (Cti6Hdr.PixelSize * Cti6Hdr.dim2)/2;
                0 0 Cti6Hdr.SliceWidth (Cti6Hdr.SliceWidth * Cti6Hdr.dim3)/2
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

        EcatFid = fopen(FileNames{i}, 'r+');

        fseek(EcatFid, 190, -1);
        fwrite(EcatFid, Fill1, 'uchar');
        fseek(EcatFid, 190, -1);
        NewField1 = fread(EcatFid, 32, 'uchar=>char')';

        fseek(EcatFid, 174, -1);
        fwrite(EcatFid, Fill1, 'uchar');
        fseek(EcatFid, 174, -1);
        NewField2 = fread(EcatFid, 16, 'uchar=>char')';

        fprintf(1, 'File name: %s\n', FileNames{i});
        fprintf(1, 'Field1   : %s\n', NewField1);
        fprintf(1, 'Field2   : %s\n\n', NewField2);
        
        % move/rename files according to study
        [p f e] = fileparts(FileNames{i});
        NewEcatName = regexprep(f, '^\d+_\d+', Participants{i});
        movefile(FileNames{i}, fullfile(pwd, Participants{i}, 'CTI6', [NewEcatName e]));
    end
end
        
