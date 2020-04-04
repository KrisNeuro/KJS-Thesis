%% WesAndCmap.m
%
% Selected color maps from:
%   - R package 'wesanderson' (source: https://github.com/karthik/wesanderson/)
%   - colorcet (source: https://peterkovesi.com/projects/colourmaps/)
%
% KJS init: 2020-04-04
% *****************************************************************************

%% Wes Anderson color palettes
  % Converted from hex color code to RGB (to be read by MATLAB). Selected color palettes look discernable in grayscale.

GrandBudapest2 = 	[230 160 196;  198 205 247;  216 164 153;  114 148 212];
Moonrise3 =    		[133 212 227;  244 181 189;  156 150 74;  205 192 140];
Darjeeling2 = 		[236 203 0174;  4 108 154;  214 156 78; 171 221 222;  0 0 0];
Rushmore1 = 	   	[225 189 109;  234 190 148;  11 119 94;  53 39 74;  242 48 15];
Royal1 = 		   	[137 157 164;  201 51 18;  250 239 209;  220 134 59];
Moonrise1 =  	   	[243 223 108;  206 171 7;  213 213 211; 36 40 26];

% *****************************************************************************

%% colorcet color palettes
  % used in draft figures
fempurp = colorcet('L8'); %linear blue magenta yellow
    propurp = fempurp(65,:); %purple - PROESTRUS FEMALES
    estyel = fempurp(192,:); %yellow - ESTROUS FEMALES
    metred = fempurp(128,:); %magenta? - METESTRUS FEMALES
digreen = colorcet('L9'); %linear blue green yellow white
    digreen = digreen(128,:); %deep green - DIESTRUS FEMALES
clear fempurp
maleblue = colorcet('L6'); %linear blue 192
maleblue = maleblue(192,:); % MALES

% *****************************************************************************

% eof
