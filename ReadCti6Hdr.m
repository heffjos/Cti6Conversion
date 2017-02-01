function Cti6Hdr = ReadCti6Hdr(FileName)
%function Cti6Hdr = ReadCti6Hdr(FileName)
%
% INPUT
%   FileName - string, full path to .img file

    Cti6Hdr = struct('OrigX',[],'OrigY',[],'OrigZ',[],...
                     'PixelSize',[],...
                     'SliceWidth',[],...
                     'dim1',[],'dim2',[],'dim3',[],...
                     'PixelType',[],...
                     'FrameNum',[]);
                     
    fid = fopen(deblank(FileName), 'rb', 'ieee-le');
    SkipBuf = freadVAXD(fid, 376, 'uint8');
    Cti6Hdr.dim3 = freadVAXD(fid, 1, 'int16');
    Cti6Hdr.FrameNum = freadVAXD(fid, 1, 'int16');
    GateNum = freadVAXD(fid, 1, 'int16');
    BedNum = freadVAXD(fid, 1, 'int16');
    InitBedPos = freadVAXD(fid, 1, 'single');
    SkipBuf = freadVAXD(fid, 512-388, 'uint8');
    SkipBuf = freadVAXD(fid, 512, 'uint8');
    SkipBuf = freadVAXD(fid, 132, 'uint8');
    Cti6Hdr.dim1 = freadVAXD(fid, 1, 'int16');
    Cti6Hdr.dim2 = freadVAXD(fid, 1, 'int16');
    SkipBuf = freadVAXD(fid, 24, 'uint8');
    Cti6Hdr.OrigX = freadVAXD(fid, 1, 'single');
    Cti6Hdr.OrigY = freadVAXD(fid, 1, 'single');
    SkipBuf = freadVAXD(fid, 16, 'uint8');
    Cti6Hdr.PixelSize = freadVAXD(fid, 1, 'single') * 10;
    Cti6Hdr.SliceWidth = freadVAXD(fid, 1, 'single') * 10;
    SkipBuf = freadVAXD(fid, 8, 'uint8');
    Cti6Hdr.OrigZ = freadVAXD(fid, 1, 'int16');
    Cti6Hdr.PixelType = 'short';
    fclose(fid);
end

