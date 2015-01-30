function [r]=test_fun_script(arg1,arg2)
   token = strcat(arg1, '_',arg2);
    str1 =  strcat('/data/yiyang/processing_chain/',token,'.txt');
    % open a file for writing
    fid = fopen(str1, 'w');
r=1;
    % print a title, followed by a blank line
    fprintf(fid, '%s\n',arg1);
    fprintf(fid, '%s\n',arg2);
    fclose(fid);
end