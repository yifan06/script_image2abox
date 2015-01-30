histo_right=zeros(256,128);
histo_left=zeros(256,128);
histo_front=zeros(256,128);
histo_behind=zeros(256,128);
histo_up=zeros(256,128);
histo_down=zeros(256,128);
pi=3.1415926;
alpha1=0;
alpha2=0;
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

x=[1:256];
y=[1:128];
figure, mesh(histo_right);
%%
obs=textread('PUl_PUr.txt');
obsreal=reshape(obs,128,256)';
figure, mesh(obsreal);
obs2=textread('THl_PUl.txt');
obsreal2=reshape(obs2,128,256)';
figure, mesh(obsreal2);
 %%
cc_right=intersection_hist(histo_right,obsreal);
cc_left=intersection_hist(histo_left,obsreal);
cc_front=intersection_hist(histo_front,obsreal);
cc_behind=intersection_hist(histo_behind,obsreal);
cc_up=intersection_hist(histo_up,obsreal);
cc_down=intersection_hist(histo_down,obsreal);
