function [selected, resp_time] = prob(window, xCenter, yCenter, item1, item2)
temp1 = imread(['./images/' num2str(item1) '.png']);
temp1 = imresize(temp1,0.25);
tex_temp1 = Screen('MakeTexture', window, temp1);
tempLoc1 = [xCenter/2-size(temp1,2)/2 xCenter/2+size(temp1,2)/2; yCenter-size(temp1,1)/2 yCenter+size(temp1,1)/2]; 

temp2 = imread(['./images/' num2str(item2) '.png']);
temp2 = imresize(temp2,0.25);
tex_temp2 = Screen('MakeTexture', window, temp2);
tempLoc2 = [xCenter*3/2-size(temp2,2)/2 xCenter*3/2+size(temp2,2)/2; yCenter-size(temp2,1)/2 yCenter+size(temp2,1)/2]; 
t0 = GetSecs;
answer = 0;
Screen('TextSize', window, 40);
Screen('TextStyle', window, 0);
resp_time = 1.5;

selected = 0;
while ~answer

    secs = GetSecs;
    if secs-t0>=1.5
        secs = t0 + 1.5;
        break
    end
    
    [keyIsDown,~,keyCode] = KbCheck();
    if keyIsDown
        if isequal(KbName(keyCode), 'LeftShift')
            answer = 1;
            resp_time = secs - t0;
            selected = 1;
            break
        elseif isequal(KbName(keyCode), 'RightShift')
            answer = 1;
            resp_time = secs - t0;
            selected = 2;
            break
        elseif isequal(KbName(keyCode), 'q')
            Screen('CloseAll');
            error('Quit key pressed');
        end
    end
    Screen('DrawTexture', window, tex_temp1,[], tempLoc1);
    Screen('DrawTexture', window, tex_temp2,[], tempLoc2);
    DrawFormattedText(window, '+', 'center', 'center', 255);
    Screen('Flip',window);
end

Screen('DrawTexture', window, tex_temp1,[], tempLoc1);
Screen('DrawTexture', window, tex_temp2,[], tempLoc2);
DrawFormattedText(window, '+', 'center', 'center', 255);
radius = 100;
if selected == 1
    Screen('FrameRect', window, [255, 255, 255], [xCenter/2-radius-5 yCenter-radius-5 xCenter/2+radius+5 yCenter+radius+5] ,4);
elseif selected == 2
    Screen('FrameRect', window, [255, 255, 255], [xCenter*3/2-radius-5 yCenter-radius-5 xCenter*3/2+radius+5 yCenter+radius+5] ,4);
end
Screen('Flip',window);
WaitSecs(1.5 - (secs-t0));
end