fid=fopen('a.txt','w');
a=X(:,1:62);
for i=1:30
    for j=1:62
        fprintf(fid,'%9f\t',a(i,j));
    end
     fprintf(fid,'\r\n');
end
fclose(fid); 