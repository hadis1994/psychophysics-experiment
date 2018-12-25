%% initialization
clc
clear
rng('Shuffle')

[keysOfInterest, screenNumber, white, black] = set_defaults();
[window, windowRect] = Screen('OpenWindow', screenNumber, black);
HideCursor;

[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);


[wavedata, freq] = audioread('beep.wav');
InitializePsychSound(1);
pahandle = PsychPortAudio('Open', [], [], 2, freq/2, 1, 0);
PsychPortAudio('FillBuffer', pahandle, wavedata');
Screen('TextSize', window, 28);
Screen('TextStyle', window, 0);

n_items = 60;

auction1_data = 'data_1.mat';
training_data = 'data_2.mat';
prob_data = 'data_3.mat';
auction2_data = 'data_4.mat';
%% auction 1
text1 = 'In this phase, pictures of some snack food are shown\n';
text2 = 'and you are asked to place a bet on each item. The\n';
text3 = 'items are independent of each other. At the end of this\n';
text4 = 'session, you are given $3 to bet and you are given an\n';
text5 = 'opportunity to actuallt buy one of these snacks.';
texts = [text1, text2, text3, text4, text5];
DrawFormattedText(window, texts, 'center', 'center', 255);
text = 'Press ENTER to continue';
DrawFormattedText(window, text, 'center', yCenter*3/2, 255);
Screen('Flip',window);
start_key_stroke(window);

wtp = zeros(n_items, 1);
resp_time_auction = zeros(n_items, 1);
for i=1:n_items
    [tmp1, tmp2] = slider(window, windowRect, xCenter, yCenter, i);
    wtp(i) = tmp1;
    resp_time_auction(i) = tmp2;
    Screen('Flip', window);
    WaitSecs(0.2);
end


info_file = matfile(auction1_data, 'Writable', true);
info_file.wtp = wtp;
info_file.resp_time_auction = resp_time_auction;

%% cue-approach training
% load(auction1_data);

text1 = 'On the appearance of each item, press ENTER key\n';
text2 = 'as fast as possible when you hear a tone.\n\n';
text3 = 'Remeber to press ENTER key AFTER you hear the tone.';
texts = [text1, text2, text3];
DrawFormattedText(window, texts, 'center', 'center', 255);
text = 'Press ENTER to continue';
DrawFormattedText(window, text, 'center', yCenter*3/2, 255);
Screen('Flip',window);
start_key_stroke(window);

[sorted, permutation]= sort(wtp,'descend');

high_go_inds = [permutation(8) permutation(11) permutation(12) permutation(15)];
high_nogo_inds = [permutation(9) permutation(10) permutation(13) permutation(14)];
low_go_inds = [permutation(46) permutation(49) permutation(50) permutation(53)];
low_nogo_inds = [permutation(47) permutation(48) permutation(51) permutation(52)];

high_valued_inds = permutation(8:15);
low_valued_inds = permutation(46:53);
go_inds = [high_go_inds low_go_inds];
nogo_inds = [high_nogo_inds, low_nogo_inds];

gsd = 0.65;

n_iterations = 12;
answers = zeros(n_iterations, n_items);
response_time = zeros(n_iterations, n_items);
for i=1:n_iterations
    permuted = randperm(n_items);
    for item=permuted
       [gsd, answer, resp_time] = cued_approach(window, xCenter, yCenter, pahandle, go_inds, item, gsd);
       answers(i, item) = answer;
       response_time(i, item) = resp_time;
       Screen('Flip', window);
       wait_time = randn()+3;
       if wait_time < 0
           wait_time = 1;
       end
       WaitSecs(wait_time);
    end
    if mod(i, 2) == 0
        text = 'Press ENTER to continue';
        DrawFormattedText(window, text, 'center', 'center', 255);
        Screen('Flip',window);
        start_key_stroke(window);
    end
end


info_file = matfile(training_data, 'Writable', true);
info_file.high_go_inds = high_go_inds;
info_file.high_nogo_inds = high_nogo_inds;
info_file.low_go_inds = low_go_inds;
info_file.low_nogo_inds = low_nogo_inds;

info_file.high_valued_inds = high_valued_inds;
info_file.low_valued_inds = low_valued_inds;
info_file.go_inds = go_inds;
info_file.nogo_inds = nogo_inds;
info_file.answers = answers;
info_file.response_time = response_time;

%% prob
% load(training_data);

text1 = 'Choose between two items (click RIGHT SHIFT to select\n';
text2 = 'the item at the right or LEFT SHIFT to select the item\n';
text3 = 'at the left).';
texts = [text1, text2, text3];
DrawFormattedText(window, texts, 'center', 'center', 255);
text = 'Press ENTER to continue';
DrawFormattedText(window, text, 'center', yCenter*3/2, 255);
Screen('Flip',window);
start_key_stroke(window);

high_permutation = randperm(16);
low_permuations = randperm(16);
high_items = zeros(16,2);
low_items = zeros(16,2);
count = 1;
for x=high_permutation
    for i=1:4
        for j=1:4
            if x==(i-1)*4+j
                tmp_itm = [high_go_inds(i) high_nogo_inds(j)];
                high_items(count,:) = tmp_itm(randperm(2));
                count = count + 1;
            end
        end
    end
end
count = 1;
for x=low_permuations
    for i=1:4
        for j=1:4
            if x==(i-1)*4+j
                tmp_itm = [low_go_inds(i) low_nogo_inds(j)];
                low_items(count,:) =  tmp_itm(randperm(2));
                count = count + 1;
            end
        end
    end
end
items = zeros(66,2);
items(1,:) = [datasample(high_go_inds,1) datasample(low_go_inds,1)];
items(2,:) = [datasample(high_nogo_inds,1) datasample(low_nogo_inds,1)];
items(3:18,:) = high_items;
items(19:34,:) = low_items;
items(35:50,:) = high_items;
items(51:66,:) = low_items;
item_perm = randperm(66);
items = items(item_perm,:);
selected_items=zeros(66,1);
response_times=zeros(66,1);
for i=1:66
    [selected, resp_time] = prob(window, xCenter, yCenter, items(i,1), items(i,2));
    response_times(i) = resp_time;
    if selected > 0
        selected_items(i) = items(i,selected);
    end
    wait_time = randn()+3;
	if wait_time < 0
        wait_time = 1;
    end
    DrawFormattedText(window, '+', 'center', 'center', 255);
    Screen('Flip',window);
	WaitSecs(wait_time);
end

info_file = matfile(prob_data, 'Writable', true);
info_file.selected_items = selected_items;
info_file.items = items;

%% auction 2
text1 = 'Like first session, place your bet on each item.';
DrawFormattedText(window, text1, 'center', 'center', 255);
text = 'Press ENTER to continue';
DrawFormattedText(window, text, 'center', yCenter*3/2, 255);
Screen('Flip',window);
start_key_stroke(window);
wtp = zeros(n_items, 1);
resp_time_auction = zeros(n_items, 1);
for i=1:n_items
    [tmp1, tmp2] = slider(window, windowRect, xCenter, yCenter, i);
    wtp(i) = tmp1;
    resp_time_auction(i) = tmp2;
    Screen('Flip', window);
    WaitSecs(0.2);
end

info_file = matfile(auction2_data, 'Writable', true);
info_file.wtp = wtp;
info_file.resp_time_auction = resp_time_auction;

%% close
PsychPortAudio('Close', pahandle);
Screen('CloseAll');