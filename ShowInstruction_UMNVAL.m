function errinfo=ShowInstruction_UMNVAL(windowPtr, rect, msg, confirmKey, BackColor, FontColor, VertP)
% This program shows instruction for PTB3

if ~ischar(msg)
    fprintf('msg must be a string!\n');
    errinfo=1;
    return
end
% [oldFontName, oldFontNumber]=Screen('TextFont',windowPtr);
oldFontSize=Screen('TextSize',windowPtr);
oldFontStyle=Screen('TextStyle',windowPtr);
[center_x,center_y]=RectCenter(rect);
% Screen('TextFont',windowPtr,'Verdana');
Screen('TextSize',windowPtr,18);
Screen('TextStyle',windowPtr,1);
normBoundsRect=Screen('TextBounds',windowPtr,msg);
textwidth=RectWidth(normBoundsRect);
Screen('FillRect',windowPtr,BackColor);
Screen('DrawText',windowPtr,msg,center_x-floor(textwidth/2),center_y+VertP,FontColor);
Screen('Flip', windowPtr);
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
[touch, secs, keyCode] = KbCheck;
touch = 0;
	while ~(touch && (keyCode(confirmKey) || keyCode(escapeKey)))
		[touch, secs, keyCode] = KbCheck;
	end
    if keyCode(escapeKey)
		Screen('CloseAll');
        errinfo=1;
        return
	end
Screen('FillRect',windowPtr,BackColor);
Screen('Flip', windowPtr);
% Screen('TextFont',windowPtr,oldFontNumber);
Screen('TextSize',windowPtr,oldFontSize);
Screen('TextStyle',windowPtr,oldFontStyle);
errinfo=0;
return