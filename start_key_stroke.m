function [] = start_key_stroke(window)
KbEventFlush();
while 1
    [keyIsDown,~,keyCode] = KbCheck();
    if keyIsDown
        if isequal(KbName(keyCode), 'Return')
            break;
        elseif isequal(KbName(keyCode), 'q')
            Screen('CloseAll');
            error('Quit key pressed');
        end
    end
end
Screen('Flip',window);
WaitSecs(0.5);

end