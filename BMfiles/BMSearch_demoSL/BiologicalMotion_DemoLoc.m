 function BiologicalMotion_DemoLoc
% BiologicalMotion_DemoLoc

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
DotSize=10;
amplifier=1;
markershow=[12:13];%head(1)-shoulders(2/3)-elbows(4/5)-hands(6/7)-waist(8/9)-knees(10/11)-feet(12/13)
types=11;
proangle=linspace(0,pi,types);%projection angle relative to x (y=0) plane
BM_Upr=zeros(length(markershow),2,frame,length(proangle));
BM_Inv=zeros(length(markershow),2,frame,length(proangle));
NormilizedY=BM3D(markershow,3,:);
for i=1:types
BM_Upr(:,2,:,i)=-(BM3D(markershow,3,:)-(max(NormilizedY(:))+min(NormilizedY(:)))/2)*amplifier;
BM_Inv(:,2,:,i)=(BM3D(markershow,3,:)-(max(NormilizedY(:))+min(NormilizedY(:)))/2)*amplifier;
BM_Upr(:,1,:,i)=(BM3D(markershow,1,:)*cos(proangle(i))+BM3D(markershow,2,:)*sin(proangle(i)))*amplifier;
BM_Inv(:,1,:,i)=(BM3D(markershow,1,:)*cos(proangle(i))+BM3D(markershow,2,:)*sin(proangle(i)))*amplifier;
end

black=BlackIndex(whichscreen);
white=WhiteIndex(whichscreen);

[windowPtr, rect]=Screen('OpenWindow',whichscreen,black);
Screen('BlendFunction', windowPtr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[x,y]=RectCenter(rect);
offset=200;

fps=Screen('NominalFrameRate',windowPtr);
ifi=Screen('GetFlipInterval',windowPtr);
waitframes=round(fps/Hz);

KbName('UnifyKeyNames');
Key1 = KbName('LeftArrow');
Key2 = KbName('RightArrow');
Key3 = KbName('UpArrow');
Key4 = KbName('DownArrow');
escapeKey = KbName('ESCAPE');
spaceKey = KbName('SPACE');
[touch, secs, keyCode] = KbCheck;

%% Show stimuli
% ListenChar(2);
HideCursor;
Screen(windowPtr,'FillRect',black);
Screen('Flip', windowPtr);
msg=['Press space key to start ...'];
errinfo=ShowInstruction_UMNVAL(windowPtr, rect, msg, spaceKey, black, white, -200);
    if errinfo==1
		Screen('CloseAll');
        return
    end
[oldFontName, oldFontNumber]=Screen('TextFont',windowPtr);
oldFontSize=Screen('TextSize',windowPtr);
oldFontStyle=Screen('TextStyle',windowPtr);
Screen('TextFont',windowPtr,'Verdana');
Screen('TextSize',windowPtr,10);
Screen('TextStyle',windowPtr,1);
Screen(windowPtr,'FillRect',black);
Screen(windowPtr,'DrawText','Left/Right to change viewpoint and Up/Down to change speed, SPACE to reset, ESC to quit ...',20,20,white);
oldPriority=Priority(MaxPriority(windowPtr));
vbl=Screen('Flip',windowPtr);
KbFlag=1;
KbWaitCount=0;
% k=ceil(types/2);
k=1;
while ~keyCode(escapeKey)
for i=1:frame
    Screen(windowPtr,'DrawText','Left/Right to change viewpoint and Up/Down to change speed, SPACE to reset, ESC to quit ...',20,20,white);
    Screen('DrawDots',windowPtr,squeeze(BM_Upr(:,:,i,mod(k-1,types)+1))',DotSize,white,[x-offset y],1);
    Screen('DrawDots',windowPtr,squeeze(BM_Inv(:,:,i,mod(k-1,types)+1))',DotSize,white,[x+offset y],1);
%     Screen('DrawDots',windowPtr,squeeze(BM_Upr(:,:,i,mod(k-1,types)+1))',DotSize,white,[x y],1);
    vbl = Screen('Flip', windowPtr, vbl + (waitframes-0.5)*ifi);
    if KbFlag==1
    [touch, secs, keyCode] = KbCheck;
    if keyCode(Key1)
        k=k-1; KbFlag=0;
    elseif keyCode(Key2)
        k=k+1; KbFlag=0;
    elseif keyCode(Key3)
        waitframes=round(waitframes/2);%max(waitframes-1,1);
        KbFlag=0;
    elseif keyCode(Key4)
        waitframes=waitframes*2;%waitframes+1;
        KbFlag=0;
    elseif keyCode(spaceKey)
        waitframes=round(fps/Hz);
%         k=ceil(types/2); KbFlag=0;
        k=1; KbFlag=0;
    elseif keyCode(escapeKey)
		break
    end
    elseif  KbFlag==0
        if KbWaitCount==1
        KbWaitCount=0;
        KbFlag=1;
        else
        KbWaitCount=KbWaitCount+1;
        end
    end
end
end
Screen('TextFont',windowPtr,oldFontNumber);
Screen('TextSize',windowPtr,oldFontSize);
Screen('TextStyle',windowPtr,oldFontStyle);
Priority(oldPriority);
ShowCursor;
% ListenChar(0);
Screen('CloseAll');
return