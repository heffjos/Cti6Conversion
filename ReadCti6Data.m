function Data = ReadCti6Data(Cti6Hdr, Frame, FileName)
% function Data = ReadCti6Data(Cti6Hdr, Frame, FilName)
%
% INPUT
%   Cti6Hdr  - cti6 header structure
%   Frame    - indicates what "frame" in cti6 header to read
%   FileName - string, full path to .img file

    Data = zeros(Cti6Hdr.dim1, Cti6Hdr.dim2, Cti6Hdr.dim3);
    DIM = size(Data);
    Scale = zeros(Cti6Hdr.dim3, 1);
    fid = fopen(deblank(FileName), 'rb', 'ieee-le');
    zzz = 0;

    SkipBuf = freadVAXD(fid, 512, 'uint8');
    while feof(fid) ~= 1
        SkipBuf = freadVAXD(fid, 12, 'uint8');
        numEntries = freadVAXD(fid, 1, 'int32');
        matrixIDs = freadVAXD(fid, 512-16, 'uint8');

        for jjj=1:numEntries,
            IDframe = matrixIDs((jjj-1)*16+1);
            if IDframe == Frame,
                zzz = zzz+1;
                SkipBuf = freadVAXD(fid, 168, 'uint8');
                ReconScale = freadVAXD(fid, 1, 'float32');
                Scale(zzz) = freadVAXD(fid,1,'float32');
                ImageMin = freadVAXD(fid, 1, 'int16');
                ImageMax = freadVAXD(fid, 1, 'int16');
                Unused = freadVAXD(fid, 2, 'int16');
                PixelSize = freadVAXD(fid, 1, 'float32');
                SliceWidth = freadVAXD(fid, 1, 'float32');
                SkipBuf = freadVAXD(fid, 512-192, 'uint8');
                blockData = double(freadVAXD(fid,64*256,'int16'));
                for yyy=1:DIM(2),
                    Data(:,yyy,zzz) =  blockData(((yyy-1)*DIM(1)+1):(yyy*DIM(1)))'*Scale(zzz);
                end
            else
                fseek (fid,512*65, 'cof');
            end
        end
    end
   
   fclose(fid);
   QQ = find(Data < 0);
   Data(QQ) = 0;
end


