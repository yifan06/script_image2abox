%% Generation of fuzzy relations of six directions representing relative positions
histo_right=zeros(256,128);
histo_left=zeros(256,128);
histo_front=zeros(256,128);
histo_behind=zeros(256,128);
histo_up=zeros(256,128);
histo_down=zeros(256,128);
pi=3.1415926;
alpha1=0;
alpha2=0;
digits(6);
for i = 1:256
    for j= 1:128
        alpha1= i/256*2*pi-pi;
        alpha2= j/128*pi-pi/2;
%        right
       if -pi/2<=alpha1 & alpha1<=pi/2  
           if -pi/2<=alpha2 & alpha2<=pi/2  
               histo_right(i,j)=cos(alpha1)^2*cos(alpha2)^2;
           end
       end
       
%       left
       if pi/2<=alpha1 | alpha1<=-pi/2  
           if -pi/2<=alpha2 & alpha2<=pi/2  
               histo_left(i,j)=cos(alpha1)^2*cos(alpha2)^2;
           end
       end

%        front(below)
       if 0<=alpha1 & alpha1<=pi  
           if -pi/2<=alpha2 & alpha2<=pi/2  
               histo_front(i,j)=sin(alpha1)^2*cos(alpha2)^2;
           end
       end
       
%       behind(above)
       if (-pi<=alpha1 & alpha1<=0)
           if -pi/2<=alpha2 & alpha2<=pi/2  
               histo_behind(i,j)=sin(alpha1)^2*cos(alpha2)^2;
           end
       end
       
       
%        up
           if 0<=alpha2  
               histo_up(i,j)=sin(alpha2)^2*sin(alpha2)^2;
           end
       
%       down
           if alpha2<=0  
               histo_down(i,j)=sin(alpha2)^2*sin(alpha2)^2;
           end
       
    end
end

%%
dd = dir('*.txt');

fileNames = {dd.name}; 
num=numel(fileNames);
fileright=zeros(num,0);

% data = cell(numel(fileNames),2);
% data(:,1) = regexprep(fileNames, '.csv','');

for ii = 1:numel(fileNames)    
    fprintf(fileNames{ii});
    
    filecontent = textread(fileNames{ii});
    obs=reshape(filecontent,128,256)';
    
    cc_right=compatible_center(histo_right,obs);
    cc_left=compatible_center(histo_left,obs);
    cc_front=compatible_center(histo_front,obs);
    cc_behind=compatible_center(histo_behind,obs);
    cc_up=compatible_center(histo_up,obs);
    cc_down=compatible_center(histo_down,obs);
    
    token = strtok(fileNames{ii}, '.');
    str1 =  strcat(token,'_dirout.txt');
    % open a file for writing
    fid = fopen(str1, 'w');

    % print a title, followed by a blank line
    fprintf(fid, 'right %f \n',cc_right);
    fprintf(fid, 'left %f \n',cc_left);
    fprintf(fid, 'front %f \n',cc_front);
    fprintf(fid, 'behind %f \n',cc_behind);
    fprintf(fid, 'up %f \n',cc_up);
    fprintf(fid, 'down %f \n',cc_down);
 
    fclose(fid);
    
    fileright(ii)=cc_right;
end

fid1=fopen('right.txt',w);
fprintf(fid, '%f', fileright);
fclose(fid1);