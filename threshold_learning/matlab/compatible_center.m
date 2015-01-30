function [ out ] = compatible_center( dir, obs )
%Function compatible_center evaluates the satisfaction degree of a given direction
%(fuzzy relation) and an observed histogram of angles using the gravity of
% center of compatibility.

%   Detailed explanation goes here
if (size(dir)~= size(obs))
    out=0;
else
    %
    % get all the same value index
    %dir=round(diro.*1000000)/.1000000;
    u = unique(dir);
    hx=zeros(length(u));
    hy=zeros(length(u));
    
    for i=1:length(u)
        index=find(dir==u(i));
        hx(i)=u(i);
        hy(i)=max(obs(index));
    end
    out=sum(hx.*hy)/sum(hy);  
end


end

