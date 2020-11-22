%Screen('Preference', 'SkipSyncTests', 1);
tic;
clear;clc;close;

prompt={'Enter Screen Size:'};
name='Expemental information';
numlines=1;
defaultanswer={'14'};
answer=inputdlg(prompt,name,numlines,defaultanswer);
SCsize=str2num(answer{1});

ntrials=2;

BMfile='BMfiles\Walk.txt';
if ~exist('BMfile','var')
    [f, p] = uigetfile({'*.txt','Biological Motion file (*.txt)'},...
        'Select the Biological Motion file...','BMfiles\Walk.txt');
    BMfile = fullfile(p, f);
end
[BM3D, frame, marker, Hz]=LoadBMfile(BMfile);% frame=30

%% Prepare stimuli
AssertOpenGL;
whichscreen=max(Screen('Screens'));
DotSize=7;
amplifier=0.6*14/SCsize;
types=6;
proangle=[linspace(0,pi/3,types/2) linspace(pi*2/3,pi,types/2)];%projection angle relative to x (y=0) plane
ST.DotSize=DotSize;
ST.amplifier=amplifier;
ST.proangle=proangle;
markershow=[1:13];%head(1)-shoulders(2/3)-elbows(4/5)-hands(6/7)-waist(8/9)-knees(10/11)-feet(12/13)
BM_Upr=zeros(length(markershow),2,frame,length(proangle));
BM_Inv=zeros(length(markershow),2,frame,length(proangle));
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
ST.centerx=centerx;
ST.centery=centery;
ST.rect=rect;
defaultwin=Screen('MakeTexture', windowPtr, imread('Fixation.bmp'));
beginwin=Screen('MakeTexture', windowPtr, imread('begin.jpg'));
continuewin=Screen('MakeTexture', windowPtr, imread('continue.jpg'));


fps=Screen('NominalFrameRate',windowPtr);% 60
ifi=Screen('GetFlipInterval',windowPtr);
waitframes=round(fps/Hz);% 2=60/30=fps/frame
ST.waitframes=waitframes;
ST.fps=fps;
ST.ifi=ifi;

InitializePsychSound;
DefaultFreq=44100;
pahandle = PsychPortAudio('Open', [], [],[], DefaultFreq, 2);%打开音频设备
SamplingRate=44100;
fdbeep=MakeBeep(1000,0.2,SamplingRate);
fdbeep=repmat(fdbeep,[2,1]);

KbName('UnifyKeyNames');
Key1 = KbName('LeftArrow');
Key2 = KbName('RightArrow');
escapeKey = KbName('ESCAPE');
spaceKey = KbName('SPACE');
[touch, secs, keyCode] = KbCheck;

breakall=0;% 0=not break

StandDuration=1;
DurationType=[0.4 0.6 1.4 1.6];
frameStandard=StandDuration/((1/fps)*waitframes);
frameCompare=DurationType./((1/fps)*waitframes);

ST.StandDuration=StandDuration;
ST.DurationType=DurationType;
ST.frameStandard=frameStandard;
ST.frameCompare=frameCompare;


Duration=1:length(DurationType);
stimseq0=CombineFactors(Duration,1:ntrials);
stimseq=stimseq0(Shuffle(1:size(stimseq0,1)),:);
results=zeros(size(stimseq,1),30);
%% Show stimuli
HideCursor;
Screen(windowPtr,'FillRect',gray);
Screen('Flip', windowPtr);
Screen('DrawTexture',windowPtr,beginwin);
beginonset=Screen('Flip', windowPtr);
while 1
    [touch, secs, keyCode] = KbCheck;
    if keyCode(spaceKey)
        break
    end
end
beginoffset=Screen('Flip',windowPtr);


Priority(2);

ACC=0;
while ACC<0.75
    wrong=0;
    UprOrder=randsample(2,1); % the 1st is upr
    UprType=randsample(2,1);% 1=the 1st is standard duration
    for trial=1:size(stimseq,1)
        results(trial,1)= UprOrder;
        results(trial,2)=UprType;
        results(trial,3)=stimseq(trial,1);
        initframe=PsychRandSample(1:frame,[2,1]);% a initframe for each PLW(2 PLWs in the exp)
        BM_Show=zeros(marker,2,frame,2);
        results(trial,21)=initframe(1);
        results(trial,22)=initframe(2);
        if results(trial,1)==1 % Upright is the first PLW
            BM_Show(:,:,:,1)=BM_Upr(:,:,:,PsychRandSample(1:types));
            BM_Show(:,:,:,2)=BM_Inv(:,:,:,PsychRandSample(1:types));
        elseif results(trial,1)==2 % Upr is the second PLW
            BM_Show(:,:,:,1)=BM_Inv(:,:,:,PsychRandSample(1:types));
            BM_Show(:,:,:,2)=BM_Upr(:,:,:,PsychRandSample(1:types));
        end
        
        if results(trial,2)==1 % first PLW is stand
            frame1=frameStandard;
            frame2=frameCompare(results(trial,3));
            Duration1=StandDuration;
            Duration2=DurationType(results(trial,3));
        elseif results(trial,2)==2
            frame2=frameStandard;
            frame1=frameCompare(results(trial,3));
            Duration1=DurationType(results(trial,3));
            Duration2=StandDuration;
        end
        
        % present fixation
        trialinterval=randsample(10:15,1)*0.1;
        Screen('DrawTexture',windowPtr,defaultwin);
        fixonset=Screen('Flip', windowPtr);% onset
        vbl=Screen('Flip', windowPtr,fixonset+trialinterval);% the time of offset
        oldPriority=Priority(MaxPriority(windowPtr));
        % present the first PLW
        
        trialtime1=GetSecs;
        for i=1:frame1
            Screen('DrawDots',windowPtr,squeeze(BM_Show(:,:,  mod(i+initframe(1),frame)+1,1))',DotSize,white,[centerx centery],1);
            vbl= Screen('Flip', windowPtr, vbl+(waitframes-0.5)*ifi);
        end
        trialtime11=GetSecs;
        results(trial,8)=trialtime11-trialtime1;% check the duration of the 1st PLW
        Screen('Flip', windowPtr);
        
        % blank between two PLWs
        blankinterval=randsample(4:6,1)*0.1;
        Screen(windowPtr,'FillRect',gray);
        blankonset=Screen('Flip', windowPtr);
        vbl = Screen('Flip', windowPtr,blankonset+blankinterval);
        
        % present the second PLW
        trialtime2=GetSecs;
        for j=1:frame2
            Screen('DrawDots',windowPtr,squeeze(BM_Show(:,:,  mod(j+initframe(2),frame)+1,2))',DotSize,white,[centerx centery],1);
            vbl = Screen('Flip', windowPtr, vbl + (waitframes-0.5)*ifi);
        end
        results(trial,9)=GetSecs-trialtime2;
        Screen('Flip', windowPtr);
        
        results(trial,4)=-999;
        
        Screen(windowPtr,'FillRect',gray);
        Screen('Flip', windowPtr);
        trialtime=GetSecs;
        
        % give a response
        while  results(trial,4)==-999 % make sure that the response is valid only after the display of 2nd PLW is done
            RestrictKeysForKbCheck([Key1 Key2 escapeKey spaceKey]);
            [touch, secs, keyCode] = KbCheck;
            if keyCode(Key1) % the 1s plw is longer---left key
                results(trial,4)=1;
                results(trial,5)=secs-trialtime;
                if frame1<frame2
                    PsychPortAudio('FillBuffer',pahandle,fdbeep);
                    PsychPortAudio('Start',pahandle);
                    WaitSecs(0.1);
                    PsychPortAudio('Stop', pahandle);
                    wrong=wrong+1;
                end
            elseif keyCode(escapeKey)
                breakall=1;
                fprintf('quitting program by user!\n');
                break
            elseif keyCode(Key2) % the 2nd PLW is longer----right key
                results(trial,4)=2;
                results(trial,5)=secs-trialtime;
                if frame1>frame2
                    PsychPortAudio('FillBuffer',pahandle,fdbeep);
                    PsychPortAudio('Start',pahandle);
                    WaitSecs(0.1);
                    PsychPortAudio('Stop', pahandle);
                    wrong=wrong+1;
                end
            end
        end
        Screen('Flip', windowPtr);
        
        if breakall==1
            break
        end
        
        
        if trial==size(stimseq,1)
            ACC=1-wrong/size(stimseq,1);
            if ACC<0.75
                DrawFormattedText(windowPtr,double('ACC<75%，keep practicing'),200,200,white);
                Screen('Flip', windowPtr);
                WaitSecs(2.5);
                Screen('Flip', windowPtr);
                
                msg='press space key to continue';
                errinfo=ShowInstruction_UMNVAL(windowPtr, rect, msg, spaceKey, gray, white, -200);
                if errinfo==1
                    Screen('CloseAll');
                    return
                end
                Screen('Flip',windowPtr);
            end
        end
    end
    ACC=1-wrong/size(stimseq,1);
    if breakall==1
        break
    end
end
Priority(oldPriority);
ShowCursor;
PsychPortAudio('Close', pahandle);
% ListenChar;
DrawFormattedText(windowPtr,double('End!'),200,200,white);
Screen('Flip', windowPtr);
WaitSecs(2);
Screen('CloseAll');
% datafile=sprintf('E1_DataInt\\%s_%s_%s_%s',subject,mfilename,subname,datestr(now,30));
% save(datafile,'results','stimseq','ntrials','proangle','ST','age','gender');
% BMTime_Analysis(datafile);
