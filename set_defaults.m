function [keysOfInterest, screenNumber, white, black] = set_defaults()
PsychDefaultSetup(2);
Screen('Preference', 'VisualDebugLevel', 0);
KbName('UnifyKeyNames')
keysOfInterest=zeros(1,256);
keysOfInterest(KbName({'LeftShift', 'RightShift', 'q'}))=1;

Screen('CloseAll');
screens = Screen('Screens');
screenNumber = max(screens);
Screen('Preference', 'TextRenderer', 1);
Screen('Preference', 'TextAntiAliasing', 1);
Screen('Preference', 'TextAlphaBlending', 0);
Screen('Preference', 'DefaultTextYPositionIsBaseline', 1);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

end