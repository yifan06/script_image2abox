function [r]=eval_direction(folder)
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
disp('first step');
disp(folder);
%% Read histogram of angles %% Output computed value
% filetype=strcat(folder,'*.txt');
% dd = dir(filetype);
% 
% fileNames = {dd.name}; 
% num=numel(fileNames);
% 
%     for i=1:num
%         filename='./temp_relations/THl_THr.txt';
%         obs=textread(fileNames{i});
%         obsreal=reshape(obs,128,256)';
% 
%         inter_right=intersection_hist(histo_right,obsreal);
%         inter_left=intersection_hist(histo_left,obsreal);
%         inter_front=intersection_hist(histo_front,obsreal);
%         inter_behind=intersection_hist(histo_behind,obsreal);
%         inter_up=intersection_hist(histo_up,obsreal);
%         inter_down=intersection_hist(histo_down,obsreal);
% 
% 
% 
%         % parsing file name
%         [pathstr,name,ext] = fileparts(filename);
%         str1 =  strcat('/data/yiyang/processing_chain/image_processing/inter_results/',name,'.txt');
%         % open a file for writing
%         fid = fopen(str1, 'w');
% 
%         % print a title, followed by a blank line
%         fprintf(fid, 'right %f \n',inter_right);
%         fprintf(fid, 'left %f \n',inter_left);
%         fprintf(fid, 'front %f \n',inter_front);
%         fprintf(fid, 'behind %f \n',inter_behind);
%         fprintf(fid, 'up %f \n',inter_up);
%         fprintf(fid, 'down %f \n',inter_down);
%         r=fclose(fid);
%     end
end