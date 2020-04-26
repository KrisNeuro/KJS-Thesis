%% WesAndCmap.m
%
% Selected color maps from:
%   - R package 'wesanderson' (source: https://github.com/karthik/wesanderson/)
%   - colorcet (source: https://peterkovesi.com/projects/colourmaps/)
%
% KJS init: 2020-04-04
% *****************************************************************************

%% Wes Anderson color palettes
  % Converted from hex color code to RGB/255 (to be read by MATLAB). Selected color palettes look discernable in grayscale.

Rushmore1 = 	   	[225 189 109;  234 190 148;  11 119 94;  53 39 74;  242 48 15]/255;
  maleblue = Rushmore1(3,:); %dark teal green
  propurp = Rushmore1(4,:); %deep purple

GrandBudapest2 = 	[230 160 196;  198 205 247;  216 164 153;  114 148 212]/255;
  %propurp = GrandBudapest2(3,:);
  %maleblue = GrandBudapest2(4,:);
  %maleblue = [2 64 27]/255; % Cavalcanti1(2)
  digreen = GrandBudapest2(4,:);
  propurp = GrandBudapest2(1,:);
  estyel = GrandBudapest2(2,:);
  metred = GrandBudapest2(3,:);

Moonrise3 =    		[133 212 227;  244 181 189;  156 150 74;  205 192 140; 250 215 123]/255; % don’t use 1&4 together
  maleblue = Moonrise3(1,:);
  propurp = Moonrise3(3,:); 
  %propurp = Moonrise3(2,:); %baby pink :\
  %digreen = Moonrise3(3,:);
  %estyel = Moonrise3(5,:);
  %metred = Moonrise3(4,:);

Darjeeling2 = 		[236 203 0174;  4 108 154;  214 156 78; 171 221 222;  0 0 0]/255; % don’t use 1&4 together
  maleblue = Darjeeling2(5,:); %black
  digreen = Darjeeling2(1,:);
  propurp = Darjeeling2(2,:);
  estyel = Darjeeling2(3,:);
  %metred = Darjeeling2(4,:);

Royal1 =          [137 157 164;  201 51 18;  250 239 209;  220 134 59]/255;
  digreen = Royal1(1,:);
  propurp = Royal1(2,:);
  estyel = Royal1(4,:);
  metred = Royal1(3,:);

Moonrise1 =  	   	[243 223 108;  206 171 7;  213 213 211; 36 40 26]/255;
  digreen = Moonrise1(2,:);
  propurp = Moonrise1(4,:);
  estyel = Moonrise1(1,:);
  metred = Moonrise1(3,:);

% *****************************************************************************

%% L.Schoepfer color palettes

% Color codes
  % RGB
    % Mcol = [0 76 76]/255; %male
    % Dcol = [178 131 0]/255; %diestrus female
    % Pcol = [89 10 0]/255; %proestrus female
    % Ecol = [255 226 54]/255; %estrus female
 % MATLAB
Mcol = [0         0.2980    0.2980];
Dcol = [0.6980    0.5137         0];
Pcol = [0.3490    0.0392         0];
Ecol = [1.0000    0.8863    0.2118];

% Transparency ('FaceAlpha') of histogram bars, specified as a scalar value between 0 and 1 inclusive
Mfa = 0.72; %male
Dfa = 0.38; %diestrus
Pfa = 1; %proestrus
Efa = 0.58; %estrus

% *****************************************************************************

%% colorcet color palettes
  % used in draft figures
%fempurp = colorcet('L8'); %linear blue magenta yellow
%    propurp = fempurp(65,:); %purple - PROESTRUS FEMALES / POOLED FEMALES
%    estyel = fempurp(192,:); %yellow - ESTROUS FEMALES
%    metred = fempurp(128,:); %magenta? - METESTRUS FEMALES
%digreen = colorcet('L9'); %linear blue green yellow white
%    digreen = digreen(128,:); %deep green - DIESTRUS FEMALES
%clear fempurp
%maleblue = colorcet('L6'); %linear blue 192
%maleblue = maleblue(192,:); % MALES

maleblue = [0.171931	0.744122	0.988253];
propurp = [0.490079	0.06569	0.568432];
digreen = [0.295855	0.606869	0.258899];
estyellow = [0.982021	0.630867	0.240179];
metred = [0.906173	0.1939	0.445214];

% *****************************************************************************

% eof
