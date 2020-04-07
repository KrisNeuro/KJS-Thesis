%% DataViz: All individual channels from all usable subjects
%
%   CALLS ON:
%       - colorcet.m  (source: https://peterkovesi.com/projects/colourmaps/)
% 
% KJS init: 2019-12-16, completed 2019-12-17
% 
%% Setup
subjs = {'A201' 'A202' 'A301' 'A602' 'E105' 'E106' 'E107' 'E108' 'E201'}; % Subject ID listing. A*=male  E*=female
root_drIn = [uigetdir(pwd,'Select RawEEG\BL data directory') filesep]; %root data input directory
    %root_drIn = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\RawEEG\BL\'; 
figdrOut = [uigetdir(pwd,'Set figure output directory: PowSpec_AllChannels\BL') filesep]; 
    %figdrOut = 'K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\figs\PowSpec_AllChannels\BL\';

Fs = 2000; %sampling frequency (Hz)
window = Fs*0.4; 

%% Loop thru subjects
for si = 1:length(subjs)
    disp(subjs{si})
    
    % Get list of recordings (BLlist)
    list = dir([root_drIn subjs{si}]);
    BLlist = {files(contains({files(:).name},'BL')).name}';
    clear list
    % Remove any non-experimental trials
    if any(contains(BLlist,"_Rex1")) 
        BLlist = BLlist(~contains(BLlist,"_Rex1"));
    end
    
    % Preallocate output space
    IL = zeros(200,2,length(BLlist)); %frequencies, channels, recordings
    PL = zeros(200,2,length(BLlist));
    DH = zeros(200,6,length(BLlist));
    VH = zeros(200,6,length(BLlist));
    
    %% Loop thru recordings
    disp('Loading power data..')
    for ri = 1:length(BLlist)
        disp(ri)
        load([root_drIn subjs{si} filesep BLlist{ri}],'AllDat')
        [Pxx,f] = pwelch(AllDat,window,window*0.9,Fs*2,Fs);
        clear AllDat
        
        % Limit data from 0.5-100 Hz
        i = find(f>=0.5 & f<=100); %indices to keep
        f = f(i);
        Pxx = Pxx(i,:);
        
        % **This layout is dependent on headstage mapping!**
        IL(:,:,ri) = Pxx(:,1:2);
        DH(:,:,ri) = Pxx(:,3:8);
        VH(:,:,ri) = Pxx(:,9:14);
        PL(:,:,ri) = Pxx(:,15:16);
        clear Pxx i 
    end        
    clear ri
        
    %% Plot
    h1 = figure('units','normalized','outerposition',[0 0 1 1]);  %IL
        l1 = plot(f,10*log10(squeeze(IL(:,1,:))),'b');
        hold on
        l2 = plot(f,10*log10(squeeze(IL(:,2,:))),'r');
        axis square
        box off
        title('mPFC-IL')
        xlabel('Frequency (Hz)');
        ylabel('Power (dB)');
        legend([l1(1) l2(1)],{'Ch.1','Ch.2'})
        set(gca,'fontsize',16,'titlefontsizemultiplier',1.5)
        
    h2 = figure('units','normalized','outerposition',[0 0 1 1]); %PL
        l1 = plot(f,10*log10(squeeze(PL(:,1,:))),'b');
        hold on
        l2 = plot(f,10*log10(squeeze(PL(:,2,:))),'r');
        axis square
        box off
        title('mPFC-PL')
        xlabel('Frequency (Hz)');
        ylabel('Power (dB)');
        legend([l1(1) l2(1)],{'Ch.15','Ch.16'})
        set(gca,'fontsize',16,'titlefontsizemultiplier',1.5)
        clear l1 l2
        
    h3 = figure('units','normalized','outerposition',[0 0 1 1]); %dHPC
        l1 = plot(f,10*log10(squeeze(DH(:,1,:))),'k');
        hold on
        l2 = plot(f,10*log10(squeeze(DH(:,2,:))),'b');
        l3 = plot(f,10*log10(squeeze(DH(:,3,:))),'c');
        l4 = plot(f,10*log10(squeeze(DH(:,4,:))),'g');
        l5 = plot(f,10*log10(squeeze(DH(:,5,:))),'r');
        l6 = plot(f,10*log10(squeeze(DH(:,6,:))),'m');
        axis square
        box off
        title('dHPC')
        xlabel('Frequency (Hz)');
        ylabel('Power (dB)');
        legend([l1(1) l2(1) l3(1) l4(1) l5(1) l6(1)],{'Ch.3','Ch.4','Ch.5','Ch.6','Ch.7','Ch.8'})
        set(gca,'fontsize',16,'titlefontsizemultiplier',1.5)
        clear l*
        
    h4 = figure('units','normalized','outerposition',[0 0 1 1]); %vHPC
        l1 = plot(f,10*log10(squeeze(VH(:,1,:))),'k');
        hold on
        l2 = plot(f,10*log10(squeeze(VH(:,2,:))),'b');
        l3 = plot(f,10*log10(squeeze(VH(:,3,:))),'c');
        l4 = plot(f,10*log10(squeeze(VH(:,4,:))),'g');
        l5 = plot(f,10*log10(squeeze(VH(:,5,:))),'r');
        l6 = plot(f,10*log10(squeeze(VH(:,6,:))),'m');
        axis square
        box off
        title('vHPC')
        xlabel('Frequency (Hz)');
        ylabel('Power (dB)');
        legend([l1(1) l2(1) l3(1) l4(1) l5(1) l6(1)],{'Ch.9','Ch.10','Ch.11','Ch12','Ch.13','Ch.14'})
        set(gca,'fontsize',16,'titlefontsizemultiplier',1.5)
        clear l*

    %% Save figures
    saveas(h4,[figdrOut subjs{si} filesep subjs{si} '_AllChan-vHPC.png'])
    saveas(h4,[figdrOut subjs{si} filesep subjs{si} '_AllChan-vHPC.fig'])
    close(h4); clear h4
    
    saveas(h3,[figdrOut subjs{si} filesep subjs{si} '_AllChan-dHPC.png'])
    saveas(h3,[figdrOut subjs{si} filesep subjs{si} '_AllChan-dHPC.fig'])
    close(h3); clear h3
    
    saveas(h2,[figdrOut subjs{si} filesep subjs{si} '_AllChan-PL.png'])
    saveas(h2,[figdrOut subjs{si} filesep subjs{si} '_AllChan-PL.fig'])
    close(h2); clear h2
    
    saveas(h1,[figdrOut subjs{si} filesep subjs{si} '_AllChan-IL.png'])
    saveas(h1,[figdrOut subjs{si} filesep subjs{si} '_AllChan-IL.fig'])
    close(h1); clear h1
    
    %% Save data
    disp('Saving data..')
    fd = [figdrOut subjs{si} filesep];
        if ~exist(fd,'dir'); mkdir(fd); end
    fn = 'PowSpecPerChan.mat'; %file name
    save([figdrOut fn],'BLlist','DH','f','Fs','IL','PL','VH')
    disp('Data saved!')
    
    clear IL PL DH VH BLlist f fn fd
end %loop subjects
clear si window Fs




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pool all data per brain region (channel regardless)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subjs = {'A201' 'A202' 'A301' 'A602' 'E105' 'E106' 'E107' 'E108' 'E201'}; % Subject ID listing. A*=male  E*=female   (same as above)

%% Setup
% Init figures
    h1 = figure('units','normalized','outerposition',[0 0 1 1]); %mPFC-IL
    h2 = figure('units','normalized','outerposition',[0 0 1 1]); %mPFC-PL
    h3 = figure('units','normalized','outerposition',[0 0 1 1]); %dHPC
    h4 = figure('units','normalized','outerposition',[0 0 1 1]); %vHPC

% Colormap for subjects
map = zeros(3,length(subjs)); %preallocate space
cmap = colorcet('R2'); %Rainbow2
% Distribute color codes evenly across length(subjects)
for si = 1:length(subjs)
    map(:,si) = cmap(round(length(cmap)/length(subjs)*si),:);
end
clear si cmap

%% Load & plot first subject's data
load([figdrOut subjs{1} filesep 'PowSpecPerChan.mat'],'DH','f','IL','PL','VH')
%load(['K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\ReducedEEG\BL\' subjs{1} filesep 'PowSpecPerChan.mat'],'DH','f','IL','PL','VH')
    
figure(h1) %mPFC-IL
i1 = plot(f,10*log10(squeeze(IL(:,1,:))),'color',map(:,1));
hold on
plot(f,10*log10(squeeze(IL(:,2,:))),'color',map(:,1))
i1 = i1(1);
% legend(i1(1),subjs{1})
% leg1 = get(gca,'Legend');

figure(h2) %mPFC-PL
p1 = plot(f,10*log10(squeeze(PL(:,1,:))),'color',map(:,1));
hold on
plot(f,10*log10(squeeze(PL(:,2,:))),'color',map(:,1))
p1 = p1(1);
% legend(p1(1),subjs{1})
% leg2 = get(gca,'Legend');

figure(h3) %dHPC
d1 = plot(f,10*log10(squeeze(DH(:,1,:))),'color',map(:,1));
hold on
plot(f,10*log10(squeeze(DH(:,2,:))),'color',map(:,1))
plot(f,10*log10(squeeze(DH(:,3,:))),'color',map(:,1))
plot(f,10*log10(squeeze(DH(:,4,:))),'color',map(:,1))
plot(f,10*log10(squeeze(DH(:,5,:))),'color',map(:,1))
plot(f,10*log10(squeeze(DH(:,6,:))),'color',map(:,1))
d1 = d1(1);
% legend(d1(1),subjs{1})

figure(h4) %vHPC
v1 = plot(f,10*log10(squeeze(VH(:,1,:))),'color',map(:,1));
hold on
plot(f,10*log10(squeeze(VH(:,2,:))),'color',map(:,1))
plot(f,10*log10(squeeze(VH(:,3,:))),'color',map(:,1))
plot(f,10*log10(squeeze(VH(:,4,:))),'color',map(:,1))
plot(f,10*log10(squeeze(VH(:,5,:))),'color',map(:,1))
plot(f,10*log10(squeeze(VH(:,6,:))),'color',map(:,1))
v1 = v1(1);
% legend(v1(1),subjs{1})

clear DH IL PL VH

%% Loop thru subjects, append to figures
for si = 2:length(subjs)
    disp(subjs{si})
    
    % Load data
    load([figdrOut subjs{si} filesep 'PowSpecPerChan.mat'],'DH','IL','PL','VH')
    %load(['K:\Personal Folders\Kristin Schoepfer\Neuralynx\DATA\REVAMPED\dat\ReducedEEG\BL\' subjs{si} filesep 'PowSpecPerChan.mat'],'DH','f','IL','PL','VH')
    
    % Plot IL
    figure(h1)
    i2 = plot(f,10*log10(squeeze(IL(:,1,:))),'color',map(:,si));
    plot(f,10*log10(squeeze(IL(:,2,:))),'color',map(:,si))
    i1 = [i1 i2(1)]; %append first line for legend
    
    % Plot PL
    figure(h2)
    p2 = plot(f,10*log10(squeeze(PL(:,1,:))),'color',map(:,si));
    plot(f,10*log10(squeeze(PL(:,2,:))),'color',map(:,si))    
    p1 = [p1 p2(1)];
    
    % Plot dHPC
    figure(h3)
    d2 = plot(f,10*log10(squeeze(DH(:,1,:))),'color',map(:,si));
    plot(f,10*log10(squeeze(DH(:,2,:))),'color',map(:,si))
    plot(f,10*log10(squeeze(DH(:,3,:))),'color',map(:,si))
    plot(f,10*log10(squeeze(DH(:,4,:))),'color',map(:,si))
    plot(f,10*log10(squeeze(DH(:,5,:))),'color',map(:,si))
    plot(f,10*log10(squeeze(DH(:,6,:))),'color',map(:,si))
    d1 = [d1 d2(1)];
    
    % Plot vHPC
    figure(h4)
    v2 = plot(f,10*log10(squeeze(VH(:,1,:))),'color',map(:,si));
    plot(f,10*log10(squeeze(VH(:,2,:))),'color',map(:,si))
    plot(f,10*log10(squeeze(VH(:,3,:))),'color',map(:,si))
    plot(f,10*log10(squeeze(VH(:,4,:))),'color',map(:,si))
    plot(f,10*log10(squeeze(VH(:,5,:))),'color',map(:,si))
    plot(f,10*log10(squeeze(VH(:,6,:))),'color',map(:,si))
    v1 = [v1 v2(1)];
    
    % Reset workspace for next subject
    clear DH IL PL VH f
end
clear si
clear *2

%% Format figures
% mPFC-IL
figure(h1)
axis square
box off
title('mPFC-IL')
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
legend(i1,subjs,'location','northeast')
set(gca,'fontsize',16,'titlefontsizemultiplier',1.5)

% mPFC-PL
figure(h2)
axis square
box off
title('mPFC-PL')
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
legend(p1,subjs,'location','northeast')
set(gca,'fontsize',16,'titlefontsizemultiplier',1.5)

% dHPC
figure(h3)
axis square
box off
title('dHPC')
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
legend(d1,subjs,'location','northeast')
set(gca,'fontsize',16,'titlefontsizemultiplier',1.5)

% vHPC
figure(h4)
axis square
box off
title('vHPC')
xlabel('Frequency (Hz)')
ylabel('Power (dB)')
legend(v1,subjs,'location','northeast')
set(gca,'fontsize',16,'titlefontsizemultiplier',1.5)

%% Save figures

% IL
    saveas(h1,[figdrOut 'IL-AllChan.fig'])
    saveas(h1,[figdrOut 'IL-AllChan.png'])
    close(h1); clear h1 i1
    
% PL
    saveas(h2,[figdrOut 'PL-AllChan.fig'])
    saveas(h2,[figdrOut 'PL-AllChan.png'])
    close(h2); clear h2 p1
    
% dHPC
    saveas(h3,[figdrOut 'dHPC-AllChan.fig'])
    saveas(h3,[figdrOut 'dHPC-AllChan.png'])
    close(h3); clear h3 d1
    
% vHPC
    saveas(h4,[figdrOut 'vHPC-AllChan.fig'])
    saveas(h4,[figdrOut 'vHPC-AllChan.png'])
    close(h4); clear h4 v1

%%
% end script
