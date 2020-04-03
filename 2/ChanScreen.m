function [F] = ChanScreen(files,i)

% fprintf('Loading data: %s\n',Rxlist{i}(1:end-11))
    load(files{i},'AllDat');
    F = figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(411)
        plot(AllDat(1:10000,1));
        hold on;
        plot(AllDat(1:10000,2));
        title('IL')
        set(gca,'ylim',[-2e4 2e4])
        legend 1 2
    subplot(412)
        plot(AllDat(1:10000,15));
        hold on;
        plot(AllDat(1:10000,16));
        title('PL')
        set(gca,'ylim',[-2e4 2e4])
        legend 15 16
    subplot(413)
        plot(AllDat(1:10000,9));
        hold on;
        plot(AllDat(1:10000,10));
        plot(AllDat(1:10000,11));
        plot(AllDat(1:10000,12));
        plot(AllDat(1:10000,13));
        plot(AllDat(1:10000,14));
        title('ventral hippocampus')
        legend 9 10 11 12 13 14
    subplot(414)
        plot(AllDat(1:10000,3));
        hold on;
        plot(AllDat(1:10000,4));
        plot(AllDat(1:10000,5));
        plot(AllDat(1:10000,6));
        plot(AllDat(1:10000,7));
        plot(AllDat(1:10000,8));
        title('dorsal hippocampus')
        legend 3 4 5 6 7 8
%     pause(1);
end

