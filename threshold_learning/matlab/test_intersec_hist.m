filePattern = fullfile( '*.txt');
ibsrFiles   = dir(filePattern);
for k = 1:length(ibsrFiles)
  baseFileName = ibsrFiles(k).name;
%   fullFileName = fullfile(myFolder, baseFileName);
  fprintf('Now reading %s\n', baseFileName);
  filecontent = textread(baseFileName);
  obs=reshape(filecontent,128,256)';
  
  cc_right=compatible_center(histo_right,obs);
  cc_left=compatible_center(histo_left,obs);
  cc_front=compatible_center(histo_front,obs);
  cc_behind=compatible_center(histo_behind,obs);
  cc_up=compatible_center(histo_up,obs);
  cc_down=compatible_center(histo_down,obs);
  
  inter_right=intersection_hist(histo_right,obs);
  inter_left=intersection_hist(histo_left,obs);
  inter_front=intersection_hist(histo_front,obs);
  inter_behind=intersection_hist(histo_behind,obs);
  inter_up=intersection_hist(histo_up,obs);
  inter_down=intersection_hist(histo_down,obs);
  
    
    token = strtok(baseFileName, '.');
    str1 =  strcat('./output_cc/',token,'_cc.txt');
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
    
    token = strtok(baseFileName, '.');
    str1 =  strcat('./output_intersect/', token,'_inter.txt');
    % open a file for writing
    fid = fopen(str1, 'w');

    % print a title, followed by a blank line
    fprintf(fid, 'right %f \n',inter_right);
    fprintf(fid, 'left %f \n',inter_left);
    fprintf(fid, 'front %f \n',inter_front);
    fprintf(fid, 'behind %f \n',inter_behind);
    fprintf(fid, 'up %f \n',inter_up);
    fprintf(fid, 'down %f \n',inter_down);

 
    fclose(fid);
end

%%

all_intersect=dir('./output_intersect/*.txt');
fileNames = {all_intersect.name}; 
num=numel(fileNames);

str_right='./output_dirfiles/right.txt';
str_left='./output_dirfiles/left.txt';
str_front='./output_dirfiles/front.txt';
str_behind='./output_dirfiles/behind.txt';
str_down='./output_dirfiles/down.txt';
str_up='./output_dirfiles/up.txt';

fid_r=fopen(str_right, 'w');
fid_l=fopen(str_left, 'w');
fid_f=fopen(str_front, 'w');
fid_b=fopen(str_behind, 'w');
fid_d=fopen(str_down, 'w');
fid_u=fopen(str_up, 'w');


for i=1:num
    fullpath=strcat('./output_intersect/',fileNames{i});
    [direction, value]=textread(fullpath, '%s %f');
    if(value(1)>0.4)
        fprintf(fid_r, fileNames{i});
        fprintf(fid_r,'\n');
    end
    
    if(value(2)>0.4)
        fprintf(fid_l, fileNames{i});
        fprintf(fid_l,'\n');
    end
    
    if(value(3)>0.4)
        fprintf(fid_f, fileNames{i});
        fprintf(fid_f,'\n');
    end
    
    if(value(4)>0.4)
        fprintf(fid_b, fileNames{i});
        fprintf(fid_b,'\n');
    end
    
    if(value(5)>0.4)
        fprintf(fid_u, fileNames{i});
        fprintf(fid_u,'\n');
    end
    
    if(value(6)>0.4)
        fprintf(fid_d, fileNames{i});
        fprintf(fid_d,'\n');
    end
end

fclose(fid_r);
fclose(fid_l);
fclose(fid_f);
fclose(fid_b);
fclose(fid_u);
fclose(fid_d);

%%

right_intersect=dir('./right/*.txt');
nright_intersect=dir('./nright/*.txt');
rightNames = {right_intersect.name}; 
nrightNames = {nright_intersect.name};
num_r=numel(rightNames);
num_nr=numel(nrightNames);

bins=[0:0.01:1];
right_count=zeros(num_r,1);
nright_count=zeros(num_nr,1);
for i=1:num_r   
%     token = strtok(rightNames{i}, '.');
%    fullpath =  strcat('./right/', token,'_inter.txt');
    fullpath=strcat('./right/',rightNames{i});
    [direction, value]=textread(fullpath, '%s %f');
    right_count(i)=value(1);
end

for i=1:num_nr   
%     token = strtok(rightNames{i}, '.');
%    fullpath =  strcat('./right/', token,'_inter.txt');
    fullpath=strcat('./nright/',nrightNames{i});
    [direction, value]=textread(fullpath, '%s %f');
    nright_count(i)=value(1);
end

%figure(0)
figure,
hist(right_count,bins);
figure,
hist(nright_count,bins);


%%
left_intersect=dir('./nright/*.txt');
nleft_intersect=dir('./right/*.txt');
leftNames = {left_intersect.name}; 
nleftNames = {nleft_intersect.name};
num_l=numel(leftNames);
num_nl=numel(nleftNames);

bins=[0:0.01:1];
left_count=zeros(num_l,1);
nleft_count=zeros(num_nl,1);
for i=1:num_l   
%     token = strtok(rightNames{i}, '.');
%    fullpath =  strcat('./right/', token,'_inter.txt');
    fullpath=strcat('./nright/',leftNames{i});
    [direction, value]=textread(fullpath, '%s %f');
    left_count(i)=value(2);
end

for i=1:num_nl   
%     token = strtok(rightNames{i}, '.');
%    fullpath =  strcat('./right/', token,'_inter.txt');
    fullpath=strcat('./right/',nleftNames{i});
    [direction, value]=textread(fullpath, '%s %f');
    nleft_count(i)=value(2);
end

figure(2)
hist(left_count,bins);
figure(3)
hist(nleft_count,bins);

%%
up_intersect=dir('./up/*.txt');
nup_intersect=dir('./nup/*.txt');
upNames = {up_intersect.name}; 
nupNames = {nup_intersect.name};
num_u=numel(upNames);
num_nu=numel(nupNames);

bins=[0:0.01:1];
up_count=zeros(num_u,1);
nup_count=zeros(num_nu,1);
for i=1:num_u   
%     token = strtok(rightNames{i}, '.');
%    fullpath =  strcat('./right/', token,'_inter.txt');
    fullpath=strcat('./up/',upNames{i});
    [direction, value]=textread(fullpath, '%s %f');
    up_count(i)=value(5);
end

for i=1:num_nu  
%     token = strtok(rightNames{i}, '.');
%    fullpath =  strcat('./right/', token,'_inter.txt');
    fullpath=strcat('./nup/',nupNames{i});
    [direction, value]=textread(fullpath, '%s %f');
    nup_count(i)=value(5);
end

figure(4)
hist(up_count,bins);
figure(5)
hist(nup_count,bins);

%%
front_intersect=dir('./front/*.txt');
nfront_intersect=dir('./nfront/*.txt');
frontNames = {front_intersect.name}; 
nfrontNames = {nfront_intersect.name};
num_f=numel(frontNames);
num_nf=numel(nfrontNames);

bins=[0:0.01:1];
front_count=zeros(num_f,1);
nfront_count=zeros(num_nf,1);
for i=1:num_f   
%     token = strtok(rightNames{i}, '.');
%    fullpath =  strcat('./right/', token,'_inter.txt');
    fullpath=strcat('./front/',frontNames{i});
    [direction, value]=textread(fullpath, '%s %f');
    front_count(i)=value(3);
end

for i=1:num_nf  
%     token = strtok(rightNames{i}, '.');
%    fullpath =  strcat('./right/', token,'_inter.txt');
    fullpath=strcat('./nfront/',nfrontNames{i});
    [direction, value]=textread(fullpath, '%s %f');
    nfront_count(i)=value(3);
end

figure(6)
hist(front_count,bins);
figure(7)
hist(nfront_count,bins);

%%

right_intersect=dir('./right_sain/*.txt');
nright_intersect=dir('./nright_sain/*.txt');
rightNames = {right_intersect.name}; 
nrightNames = {nright_intersect.name};
num_r=numel(rightNames);
num_nr=numel(nrightNames);

bins=[0:0.01:1];
right_count=zeros(num_r,1);
nright_count=zeros(num_nr,1);
for i=1:num_r   
%     token = strtok(rightNames{i}, '.');
%    fullpath =  strcat('./right/', token,'_inter.txt');
    fullpath=strcat('./right_sain/',rightNames{i});
    [direction, value]=textread(fullpath, '%s %f');
    right_count(i)=value(1);
end

for i=1:num_nr   
%     token = strtok(rightNames{i}, '.');
%    fullpath =  strcat('./right/', token,'_inter.txt');
    fullpath=strcat('./nright_sain/',nrightNames{i});
    [direction, value]=textread(fullpath, '%s %f');
    nright_count(i)=value(1);
end

%figure(0)
figure,
hist(right_count,bins);
figure,
hist(nright_count,bins);

%%
% error model e=p0(x>th)+p1(x<th)

opt_rth=0;
opt_lth=0;
opt_uth=0;
opt_fth=0;

for th=0:0.01:1
    ind0=find(nright_count>th);
    ind1=find(right_count<th);
    
%     ind2=find(nleft_count>th);
%     ind3=find(left_count<th);
%     
%     ind4=find(nup_count>th);
%     ind5=find(up_count<th);
%     
%     ind6=find(nfront_count>th);
%     ind7=find(front_count<th);
    
    n0=length(ind0);
    n1=length(ind1);
    
%     n2=length(ind2);
%     n3=length(ind3);
%     
%     n4=length(ind4);
%     n5=length(ind5);
%     
%     n6=length(ind6);
%     n7=length(ind7);
%     
    e_r=n0/num_nr+n1/num_r;
%     e_l=n2/num_nl+n3/num_l;
%     e_u=n4/num_nu+n5/num_u;
%     e_f=n6/num_nf+n7/num_f;
    
    if th==0
        min_er=e_r;
%         min_el=e_l;
%         min_eu=e_u;
%         min_ef=e_f;
    else
        if e_r<=min_er
            min_er=e_r;
            opt_rth=th;
        end
%         if e_l<=min_el
%             min_el=e_l;
%             opt_lth=th;
%         end
%         if e_u<=min_eu
%             min_eu=e_u;
%             opt_uth=th;
%         end
%         if e_f<=min_ef
%             min_ef=e_f;
%             opt_fth=th;
%         end
    end
end

    

