function [X,Y,H1] = VelCumDist(subjs,vd_drOut)
%VelCumDist Get cumulative distribution of movement linear velocity for all subjects
%   KJS init (as fxn): 2020-02-11

%%
% Preallocate space
X = cell(size(subjs));
Y = cell(size(subjs));

for si = 1:length(subjs)
    disp(subjs{si})
    load([vd_drOut subjs{si} filesep subjs{si} '_TotalDistanceTraveled.mat'],'h')
    for ri = 1:length(h) %#ok<*USENS>
        X{si,ri} = h{ri,:}(1,:);
        Y{si,ri} = h{ri,:}(2,:);
    end
    clear h ri
end


% Plot cumulative distribution
H1 = figure('units','normalized','outerposition',[0 0 1 1]);
disp('Plotting...please be patient...')

    % Plot first subject
    plot(X{1,1}(:),Y{1,1}(:),'color',[0.5 0.5 0.5])
    hold on
    for i = 2:size(X,2)
        plot(X{1,i}(:),Y{1,i}(:),'color',[0.5 0.5 0.5]);
        drawnow nocallbacks
    end
    
    % Plot everyone else
    for si = 2:length(subjs)
%         disp(si)
        for i = 1:size(X,2)
            plot(X{si,i}(:),Y{si,i}(:),'color',[0.5 0.5 0.5]);
            drawnow nocallbacks
        end
    end
    clear si i
    vline(5,'r')
    vline(15,'r')
    axis square
    xlabel('Linear velocity (cm/s)')
    ylabel('Cumulative distribution')
    title('Distribution: Linear Velocity, Familiar Arena')
    set(gca,'xlim',[0 60],'FontSize',14,'TitleFontSizeMultiplier',1.5)
end

