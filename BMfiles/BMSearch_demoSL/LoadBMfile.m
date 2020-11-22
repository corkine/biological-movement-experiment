function [BM3D, frame, marker, Hz]=LoadBMfile(BMfile)
%[BM3D, frame, marker, Hz]=LoadBMfile(BMfile)

fid=fopen(BMfile,'rt');
fscanf(fid,'%s',2);
frame=fscanf(fid,'%f',1);
fscanf(fid,'%s',2);
marker=fscanf(fid,'%f',1);
fscanf(fid,'%s',2);
Hz=fscanf(fid,'%f',1);
BM3D=zeros(marker,3,frame);
for i=1:frame
    BM3D(:,:,i)=fscanf(fid,'%f %f %f',[3,marker])';
end
fclose(fid);

return