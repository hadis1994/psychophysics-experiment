function [wtp, resp_time] = slider(window, windowRect, xCenter, yCenter, image_number)

White = [255 255 255];
Black = [0 0 0];
Blue = [0 0 255];
responseKey = 1; % using mouse
width = 7;
x_scalaPosition = 0.8;
y_scalaPosition = 0.8;
x_range = [round((1-x_scalaPosition)*windowRect(3)) round(x_scalaPosition*windowRect(3))];
x_distance = x_range(2) - x_range(1);
y_constant = round(windowRect(4)*y_scalaPosition);
y_variance = 10;

number_of_points = 4;
x_starts = zeros(number_of_points,1);
rating_positions = zeros(number_of_points,2);

x = x_range(1);
for i=1:number_of_points
    x_starts(i) = x;
    rating_positions(i, :) = [round(x-6) round(y_constant+5)];
    x = x+round(x_distance/(number_of_points-1));
end

t0 = GetSecs;
answer = 0;

Screen('TextSize', window, 40);
Screen('TextStyle', window, 0);

SetMouse(round(mean(x_range)), round(windowRect(4)*y_scalaPosition), window, 1);

temp = imread(['./images/' num2str(image_number) '.png']);
temp=imresize(temp,0.5);
tex_temp=Screen('MakeTexture', window, temp);
tempLoc=[xCenter-size(temp,2)/2 xCenter+size(temp,2)/2; yCenter-size(temp,1)/2 yCenter+size(temp,1)/2];

while ~answer 
    [x,~,buttons,~,~,~] = GetMouse(window, 1);
    if x > x_range(2)
        x = x_range(2);
    elseif x < x_range(1)
        x = x_range(1);
    end
    
    Screen('DrawLine', window, White, x_range(1), y_constant, x_range(2), y_constant, width);
    for i = 1:number_of_points
        Screen('DrawText', window, ['$' num2str(i-1)], x_starts(i)-10, y_constant+y_variance+30, White);
    end
    Screen('DrawTexture', window, tex_temp,[], tempLoc);
	Screen('DrawLine', window, Blue, x, windowRect(4)*y_scalaPosition - y_variance, x, windowRect(4)*y_scalaPosition  + y_variance, width);
    Screen('Flip', window);
    
    if buttons(responseKey) == 1 
        answer = 1;
        wtp = (x-x_range(1))/(x_range(2)-x_range(1))*3;
    end
    
    [keyIsDown,~,keyCode] = KbCheck();
    if keyIsDown && isequal(KbName(keyCode), 'q')
        Screen('CloseAll');
        error('Quit key pressed');
    end
end
resp_time = GetSecs - t0;
WaitSecs(0.2);
end