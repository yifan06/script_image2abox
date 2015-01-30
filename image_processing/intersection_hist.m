function [d]=intersection_hist(bin1,bin2)
%Function intersection_hist evaluates the satisfaction degree of a given direction
%(fuzzy relation) and an observed histogram of angles using intersection of
% two histograms.

minsum = 0;
if(size(bin1)==size(bin2))
%     for i=1 : size(bins1)
%         minsum =minsum+ min(bins1(i), bins2(i));
%         % ou tout simplement> minsum=sum(min(bins1, bins2))
%     end
    minsum=sum(sum(min(bin1, bin2)));
end
d = minsum / min(sum(sum(bin1)), sum(sum(bin2)));