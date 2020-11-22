function [subject, setsize, ntrials] = inputsubinfo
prompt={'Enter subject number:','Enter Set Size:','Enter trial number:'};
name='Experimental Information';
numlines=1;
defaultanswer={'s1001','3 6 9','20'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
subject=answer{1};
setsize=str2num(answer{2});
ntrials=str2double(answer{3});
return