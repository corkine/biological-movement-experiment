function BMSearchScrUpr
% BMSearchScrUpr

[subject, setsize, ntrials] = inputsubinfo;
if ~exist('subject','var')
    subject='1111';
end
if ~exist('setsize','var')
    setsize=[4];
end
if ~exist('ntrials','var')
    ntrials=20;
end
BMfile=['BMfiles\Walk.txt'];
if ~exist('BMfile','var')
   [f, p] = uigetfile({'*.txt','Biological Motion file (*.txt)'},...
       'Select the Biological Motion file...','BMfiles\Walk.txt');
   BMfile = fullfile(p, f);
end
[BM3D, frame, marker, Hz]=LoadBMfile(BMfile);

%% Prepare stimuli
AssertOpenGL;
whichscreen=max(Screen('Screens'));
DotSize=5;
amplifier=0.3;
RadiusOffset=300;
types=6;
markershow=[1:13];
proangle=[linspace(0,pi/3,types/2) linspace(pi*2/3,pi,types/2)];%projection angle relative to x (y=0) plane
% proangle=[0 pi];
BM_Upr=zeros(length(markershow),2,frame,types);
BM_Inv=zeros(length(markershow),2,frame,types);
NormilizedX=BM3D(markershow,1,:);
NormilizedY=BM3D(markershow,3,:);
rangex=round((max(NormilizedX(:))-min(NormilizedX(:)))/2);
rangey=round((max(NormilizedY(:))-min(NormilizedY(:)))/2);
randshiftx=PsychRandSample([-rangex:rangex],[length(markershow),types]);
randshifty=PsychRandSample([-rangey:rangey],[length(markershow),types]);
for i=1:types
BM_Upr(:,2,:,i)=-(BM3D(markershow,3,:)-(max(NormilizedY(:))+min(NormilizedY(:)))/2)*amplifier;
BM_Inv(:,2,:,i)=(BM3D(markershow,3,:)-(max(NormilizedY(:))+min(NormilizedY(:)))/2)*amplifier;
BM_Upr(:,2,:,i)=-(BM3D(markershow,3,:)-(max(NormilizedY(:))+min(NormilizedY(:)))/2+...
    repmat(randshifty(:,i),[1,1,frame])+repmat(squeeze(BM_Upr(:,2,1,i)),[1,1,frame]))*amplifier;
BM_Inv(:,2,:,i)=(BM3D(markershow,3,:)-(max(NormilizedY(:))+min(NormilizedY(:)))/2+...
    repmat(randshifty(:,i),[1,1,frame])-repmat(squeeze(BM_Inv(:,2,1,i)),[1,1,frame]))*amplifier;
BM_Upr(:,1,:,i)=(BM3D(markershow,1,:)*cos(proangle(i))+BM3D(markershow,2,:)*sin(proangle(i)))*amplifier;
BM_Inv(:,1,:,i)=(BM3D(markershow,1,:)*cos(proangle(i))+BM3D(markershow,2,:)*sin(proangle(i)))*amplifier;
BM_Upr(:,1,:,i)=(BM3D(markershow,1,:)*cos(proangle(i))+BM3D(markershow,2,:)*sin(proangle(i))+...
    repmat(randshiftx(:,i),[1,1,frame])-repmat(squeeze(BM_Upr(:,1,1,i)),[1,1,frame]))*amplifier;
BM_Inv(:,1,:,i)=(BM3D(markershow,1,:)*cos(proangle(i))+BM3D(markershow,2,:)*sin(proangle(i))+...
    repmat(randshiftx(:,i),[1,1,frame])-repmat(squeeze(BM_Inv(:,1,1,i)),[1,1,frame]))*amplifier;
end

black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);
gray=round((black+white)/2);

% Screen('Resolution',whichscreen,[],[],60);
[windowPtr, rect]=Screen('OpenWindow',whichscreen,gray);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[centerx,centery]=RectCenter(rect);

defaultwin=Screen('MakeTexture', windowPtr, imread('Fixation.bmp'));
[x,y]=pol2cart(linspace(pi/2,pi*2+pi/2,max(setsize)+1),RadiusOffset);
x(end)=[]; y(end)=[];

SamplingRate=44100;
fdbeep=MakeBeep(1000,0.2,SamplingRate);

fps=Screen('NominalFrameRate',windowPtr);
ifi=Screen('GetFlipInterval',windowPtr);
waitframes=round(fps/Hz);
% showframe=min(Hz*0.5,frame);

KbName('UnifyKeyNames');
Key1 = KbName('LeftArrow');
Key2 = KbName('RightArrow');
escapeKey = KbName('ESCAPE');
spaceKey = KbName('SPACE');
[touch, secs, keyCode] = KbCheck;

cuecond=[1:2]; %cue condition: upright tar vs. nontar, inverted tar vs. nontar
stimseq=zeros(ntrials*length(cuecond)*length(setsize),2);% cue condition x set size
stimseq(:,1)=repmat([cuecond]',[ntrials*length(setsize),1]);
stimseq(:,2)=repmat(reshape(ones(length(cuecond),1)*[setsize],[length(cuecond)*length(setsize),1]),[ntrials,1]);
stimseq=stimseq(Shuffle(1:size(stimseq,1)),:);
results=zeros(size(stimseq,1),4);
tarpos=zeros(size(stimseq,1),max(setsize));

%% Show stimuli
HideCursor;
% ListenChar(2);
Screen(windowPtr,'FillRect',gray);
Screen('Flip', windowPtr);
msg=['Press space key to start ...'];
errinfo=ShowInstruction_UMNVAL(windowPtr, rect, msg, spaceKey, gray, white, -200);
    if errinfo==1
		Screen('CloseAll');
        return
    end

oldPriority=Priority(MaxPriority(windowPtr));
vbl=Screen('Flip',windowPtr);

for trial=1:size(stimseq,1)
WaitSecs(1);
results(trial,1:2)=stimseq(trial,1:2);
tarpos(trial,:)=randperm(max(setsize));
initframe=PsychRandSample(1:frame,[stimseq(trial,2),1]);
BM_Show=zeros(length(markershow),2,frame,stimseq(trial,2));
switch stimseq(trial,1)
    case {1} % Upright target with inverted distractors
        BM_Show(:,:,:,1)=BM_Upr(:,:,:,PsychRandSample(1:types));
        BM_Show(:,:,:,2:end)=BM_Inv(:,:,:,PsychRandSample(1:types,[stimseq(trial,2)-1,1]));
    case {2} % Inverted distractors only
        BM_Show(:,:,:,:)=BM_Inv(:,:,:,PsychRandSample(1:types,[stimseq(trial,2),1]));
    case {3} % Inverted target with upright distractors
        BM_Show(:,:,:,1)=BM_Inv(:,:,:,PsychRandSample(1:types));
        BM_Show(:,:,:,2:end)=BM_Upr(:,:,:,PsychRandSample(1:types,[stimseq(trial,2)-1,1]));
    case {4} % Upright distractors only
        BM_Show(:,:,:,:)=BM_Upr(:,:,:,PsychRandSample(1:types,[stimseq(trial,2),1]));
end
trialtime=GetSecs;
while ~(touch==1 && (keyCode(Key1) || keyCode(Key2) || keyCode(escapeKey)))
    Screen('DrawTexture',windowPtr,defaultwin);
for i=1:stimseq(trial,2)
    Screen('DrawDots',windowPtr,squeeze(BM_Show(:,:,initframe(i),i))',DotSize,white,[centerx+x(tarpos(trial,i)) centery+y(tarpos(trial,i))],1);
end
%     Screen('DrawingFinished',windowPtr);
    vbl = Screen('Flip', windowPtr, vbl + (waitframes-0.5)*ifi);
    initframe=mod(initframe,frame)+1;
    [touch, secs, keyCode] = KbCheck;
end
    Screen('DrawTexture',windowPtr,defaultwin);
    vbl = Screen('Flip', windowPtr);
    if (keyCode(Key1) && (stimseq(trial,1)==1 || stimseq(trial,1)==3)) || (keyCode(Key2) && (stimseq(trial,1)==2 || stimseq(trial,1)==4))
        results(trial,3)=1;
        results(trial,4)=secs-trialtime;
    elseif keyCode(escapeKey)
        fprintf('quitting program by user!\n');
		break
    else
        results(trial,4)=secs-trialtime;
        Snd('Play',fdbeep,SamplingRate);
        Snd('Wait');
        Snd('Close');
    end
    touch=0;
if mod(trial,40)==0 && trial~=size(stimseq,1)
    msg=['Take a break and press space key to continue ...'];
    errinfo=ShowInstruction_UMNVAL(windowPtr, rect, msg, spaceKey, gray, white, -200);
    if errinfo==1
        ShowCursor;
%         ListenChar;
		Screen('CloseAll');
        return
    end
end
end

Priority(oldPriority);
ShowCursor;
% ListenChar;
Screen('CloseAll');
datafile=sprintf('Data\\%s_%s_%s',subject,mfilename,datestr(now,30));
save(datafile,'results','stimseq','ntrials','proangle','cuecond','setsize','tarpos');
BMSearch_Analysis(datafile);
return