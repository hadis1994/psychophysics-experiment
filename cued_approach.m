function [gsd, answer, resp_time] = cued_approach(window, xCenter, yCenter, pahandle, go_inds, item, gsd)

inc_time = 0.017;
dec_time = 0.05;

should_ans = any(go_inds==item);

temp = imread(['./images/' num2str(item) '.png']);
temp=imresize(temp,0.5);
tex_temp=Screen('MakeTexture', window, temp);
tempLoc=[xCenter-size(temp,2)/2 xCenter+size(temp,2)/2; yCenter-size(temp,1)/2 yCenter+size(temp,1)/2];
t0 = GetSecs;
answer = 0;
first_time = 1;
resp_time = 1;
while ~answer
    secs = GetSecs;
    [keyIsDown,~,keyCode] = KbCheck();
    if keyIsDown
        if isequal(KbName(keyCode), 'Return') && should_ans && secs - t0 >= gsd
            answer = 1;
            resp_time = secs - t0;
            gsd = gsd + inc_time;
            break;
        elseif isequal(KbName(keyCode), 'q')
            Screen('CloseAll');
            error('Quit key pressed');
        end
    end
    Screen('DrawTexture', window, tex_temp,[], tempLoc);
    Screen('Flip', window);
    secs = GetSecs;
    
    if first_time && should_ans && secs-t0 >= gsd
        first_time = 0;
        PsychPortAudio('Start', pahandle, 1, 0);
    end
    
    if secs-t0 > 1
        break
    end
end

if ~answer && should_ans
    gsd = gsd - dec_time;
end
end