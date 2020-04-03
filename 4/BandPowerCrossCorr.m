function [] = BandPowerCrossCorr(subjs,root_drIn,arenas,plotOp)
%% BandPowerCrossCorr.m
% Batch processing band-power cross-correlations: All movement velocities
% 
%  KJS init (as fxn): 2020-02-14  Adapted from BandPowerCrossCorr_AllVelocityBL.m
 
%%
% % List of hormone state abbreviations for sub-struct outputs
% horms = {'D' 'P' 'E' 'M'};

% mtcsg parameters   (x,nFFT,Fs,WinLength,nOverlap,NW,Detrend,nTapers);
Fs = 2000; %sampling frequency (Hz)
nFFT = 2048;
WinLength = Fs*2.5; %time window
nOverlap = 0; %time overlap
NW = 2.5; 

%% 
for si= 1:length(subjs) %loop thru subjects
    fprintf('Analyzing bandpower cross-corrrelations for %s\n',subjs{si})
    for ai = 1:length(arenas)
        rt = arenas{ai};
        fprintf('Analyzing %s data.\n',rt)
        % Load data: All trials, all velocities
        drIn = [root_drIn rt filesep subjs{si} filesep]; 
        load([drIn subjs{si} '_ReducedData.mat'],'DHIP','IL','PL','VHIP')

        %% Loop thru recordings
        for ri = 1:size(IL,2) %#ok<*NODEF>
            fprintf('Trial %i of %i\n',ri,size(IL,2))

            %% Bandpower correlations
             % IL
            [yo,fo,~] = mtcsg(IL(:,ri),nFFT,Fs,WinLength,nOverlap,NW);
            %theta
            f=find(fo>4 & fo<12); %frequency index
            a=f(1); %index(1)
            b=f(end); %index(end)
            %gamma
            f=find(fo>30 & fo<80);
            c=f(1);
            d=f(end);
            %delta
            f=find(fo>1 & fo<4);
            e=f(1);
            g=f(end);

            theta=yo(a:b,:);
                il_theta_overtime=sum(theta,1);
            gamma=yo(c:d,:);
                il_gamma_overtime=sum(gamma,1);
            delta=yo(e:g,:);
                il_delta_overtime=sum(delta,1);
            clear yo fo

            % PL
            [yo,fo,~] = mtcsg(PL(:,ri),nFFT,Fs,WinLength,nOverlap,NW);
            %theta
            f=find(fo>4 & fo<12);
            a=f(1);
            b=f(end);
            %gamma
            f=find(fo>30 & fo<80);
            c=f(1);
            d=f(end);
            %delta
            f=find(fo>1 & fo<4);
            e=f(1);
            g=f(end);

            theta=yo(a:b,:);
                pl_theta_overtime=sum(theta,1);
            gamma=yo(c:d,:);
                pl_gamma_overtime=sum(gamma,1);
            delta=yo(e:g,:);
                pl_delta_overtime=sum(delta,1);
            clear yo fo

            % DHIP
            [yo,fo,~] = mtcsg(DHIP(:,ri),nFFT,Fs,WinLength,nOverlap,NW);
            %theta
            f=find(fo>4 & fo<12);
            a=f(1);
            b=f(end);
            %gamma
            f=find(fo>30 & fo<80);
            c=f(1);
            d=f(end);
            %delta
            f=find(fo>1 & fo<4);
            e=f(1);
            g=f(end);

            theta=yo(a:b,:);
                dhip_theta_overtime=sum(theta,1);
            gamma=yo(c:d,:);
                dhip_gamma_overtime=sum(gamma,1);
            delta=yo(e:g,:);
                dhip_delta_overtime=sum(delta,1);

            % VHIP 
            [yo,fo,~] = mtcsg(VHIP(:,ri),nFFT,Fs,WinLength,nOverlap,NW);
            %theta
            f=find(fo>4 & fo<12);
            a=f(1);
            b=f(end);
            %gamma
            f=find(fo>30 & fo<80);
            c=f(1);
            d=f(end);
            %delta
            f=find(fo>1 & fo<4);
            e=f(1);
            g=f(end);

            theta=yo(a:b,:);
                vhip_theta_overtime=sum(theta,1);
            gamma=yo(c:d,:);
                vhip_gamma_overtime=sum(gamma,1);
            delta=yo(e:g,:);
                vhip_delta_overtime=sum(delta,1);

            clear a b c d e f g theta gamma delta yo to fo 
            
          %% Check for & remove outliers
            % Theta
                noutliers = round(length(il_theta_overtime)/10); %remove no more than 1/10 of points
            [il_theta_overtime_1,dhip_theta_overtime_1,rSquaresildhip_theta] = regoutliers(il_theta_overtime,dhip_theta_overtime,noutliers,plotOp); %#ok<*ASGLU> %IL-DHIP
            [il_theta_overtime_2,vhip_theta_overtime_1,rSquaresilvhip_theta] = regoutliers(il_theta_overtime,vhip_theta_overtime,noutliers,plotOp); %IL-VHIP
            [pl_theta_overtime_1,dhip_theta_overtime_2,rSquarespldhip_theta] = regoutliers(pl_theta_overtime,dhip_theta_overtime,noutliers,plotOp); %PL-DHIP
            [pl_theta_overtime_2,vhip_theta_overtime_2,rSquaresplvhip_theta] = regoutliers(pl_theta_overtime,vhip_theta_overtime,noutliers,plotOp); %PL-VHIP
            [dhip_theta_overtime_3,vhip_theta_overtime_3,rSquaresdv_theta] = regoutliers(dhip_theta_overtime,vhip_theta_overtime,noutliers,plotOp); %DHIP-VHIP
            [il_theta_overtime_3,pl_theta_overtime_3,rSquaresip_theta] = regoutliers(il_theta_overtime,pl_theta_overtime,noutliers,plotOp); %IL-PL

            % Gamma
                noutliers = round(length(il_gamma_overtime)/10);
            [il_gamma_overtime_1,dhip_gamma_overtime_1,rSquaresildhip_gamma] = regoutliers(il_gamma_overtime,dhip_gamma_overtime,noutliers,plotOp); %IL-DHIP
            [il_gamma_overtime_2,vhip_gamma_overtime_1,rSquaresilvhip_gamma] = regoutliers(il_gamma_overtime,vhip_gamma_overtime,noutliers,plotOp); %IL-VHIP
            [pl_gamma_overtime_1,dhip_gamma_overtime_2,rSquarespldhip_gamma] = regoutliers(pl_gamma_overtime,dhip_gamma_overtime,noutliers,plotOp); %PL-DHIP
            [pl_gamma_overtime_2,vhip_gamma_overtime_2,rSquaresplvhip_gamma] = regoutliers(pl_gamma_overtime,vhip_gamma_overtime,noutliers,plotOp); %PL-VHIP
            [dhip_gamma_overtime_3,vhip_gamma_overtime_3,rSquaresdv_gamma] = regoutliers(dhip_gamma_overtime,vhip_gamma_overtime,noutliers,plotOp); %DHIP-VHIP
            [il_gamma_overtime_3,pl_gamma_overtime_3,rSquaresip_gamma] = regoutliers(il_gamma_overtime,pl_gamma_overtime,noutliers,plotOp); %IL-PL

            % Delta
                noutliers = round(length(il_delta_overtime)/10);
            [il_delta_overtime_1,dhip_delta_overtime_1,rSquaresildhip_delta] = regoutliers(il_delta_overtime,dhip_delta_overtime,noutliers,plotOp); %IL-DHIP
            [il_delta_overtime_2,vhip_delta_overtime_1,rSquaresilvhip_delta] = regoutliers(il_delta_overtime,vhip_delta_overtime,noutliers,plotOp); %IL-VHIP
            [pl_delta_overtime_1,dhip_delta_overtime_2,rSquarespldhip_delta] = regoutliers(pl_delta_overtime,dhip_delta_overtime,noutliers,plotOp); %PL-DHIP
            [pl_delta_overtime_2,vhip_delta_overtime_2,rSquaresplvhip_delta] = regoutliers(pl_delta_overtime,vhip_delta_overtime,noutliers,plotOp); %PL-VHIP
            [dhip_delta_overtime_3,vhip_delta_overtime_3,rSquaresdv_delta] = regoutliers(dhip_delta_overtime,vhip_delta_overtime,noutliers,plotOp); %DHIP-VHIP
            [il_delta_overtime_3,pl_delta_overtime_3,rSquaresip_delta] = regoutliers(il_delta_overtime,pl_delta_overtime,noutliers,plotOp); %IL-PL
            clear noutliers

            %% Store R^2 values in matrices
            % Rsquared values: Theta
                % Outliers removed
            [Rsquare.Theta.il_dhip(ri)] = rSquaresildhip_theta(end); %IL-DHIP
            [Rsquare.Theta.il_vhip(ri)] = rSquaresilvhip_theta(end); %IL-VHIP
            [Rsquare.Theta.pl_dhip(ri)] = rSquarespldhip_theta(end); %PL-DHIP
            [Rsquare.Theta.pl_vhip(ri)] = rSquaresplvhip_theta(end); %PL-VHIP
            [Rsquare.Theta.dhip_vhip(ri)] = rSquaresdv_theta(end); %DHIP-VHIP
            [Rsquare.Theta.il_pl(ri)] = rSquaresip_theta(end); %IL-PL
                % Original Rsquared, including outliers
            [Rsquare_orig.Theta.il_dhip(ri)] = rSquaresildhip_theta(1); %IL-DHIP
            [Rsquare_orig.Theta.il_vhip(ri)] = rSquaresilvhip_theta(1); %IL-VHIP
            [Rsquare_orig.Theta.pl_dhip(ri)] = rSquarespldhip_theta(1); %PL-DHIP
            [Rsquare_orig.Theta.pl_vhip(ri)] = rSquaresplvhip_theta(1); %PL-VHIP
            [Rsquare_orig.Theta.dhip_vhip(ri)] = rSquaresdv_theta(1); %DHIP-VHIP
            [Rsquare_orig.Theta.il_pl(ri)] = rSquaresip_theta(1); %IL-PL

            % Rsquared values: Gamma
                % Outliers removed
            [Rsquare.Gamma.il_dhip(ri)] = rSquaresildhip_gamma(end); %IL-DHIP
            [Rsquare.Gamma.il_vhip(ri)] = rSquaresilvhip_gamma(end); %IL-VHIP
            [Rsquare.Gamma.pl_dhip(ri)] = rSquarespldhip_gamma(end); %PL-DHIP
            [Rsquare.Gamma.pl_vhip(ri)] = rSquaresplvhip_gamma(end); %PL-VHIP
            [Rsquare.Gamma.dhip_vhip(ri)] = rSquaresdv_gamma(end); %DHIP-VHIP
            [Rsquare.Gamma.il_pl(ri)] = rSquaresip_gamma(end); %IL-PL
                % Original Rsquared, including outliers
            [Rsquare_orig.Gamma.il_dhip(ri)] = rSquaresildhip_gamma(1); %IL-DHIP
            [Rsquare_orig.Gamma.il_vhip(ri)] = rSquaresilvhip_gamma(1); %IL-VHIP
            [Rsquare_orig.Gamma.pl_dhip(ri)] = rSquarespldhip_gamma(1); %PL-DHIP
            [Rsquare_orig.Gamma.pl_vhip(ri)] = rSquaresplvhip_gamma(1); %PL-VHIP
            [Rsquare_orig.Gamma.dhip_vhip(ri)] = rSquaresdv_gamma(1); %DHIP-VHIP
            [Rsquare_orig.Gamma.il_pl(ri)] = rSquaresip_gamma(1); %IL-PL

            % Rsquared values: Delta
                % Outliers removed
            [Rsquare.Delta.il_dhip(ri)] = rSquaresildhip_delta(end); %IL-DHIP
            [Rsquare.Delta.il_vhip(ri)] = rSquaresilvhip_delta(end); %IL-VHIP
            [Rsquare.Delta.pl_dhip(ri)] = rSquarespldhip_delta(end); %PL-DHIP
            [Rsquare.Delta.pl_vhip(ri)] = rSquaresplvhip_delta(end); %PL-VHIP
            [Rsquare.Delta.dhip_vhip(ri)] = rSquaresdv_delta(end); %DHIP-VHIP
            [Rsquare.Delta.il_pl(ri)] = rSquaresip_delta(end); %IL-PL
                % Original Rsquared, including outliers
            [Rsquare_orig.Delta.il_dhip(ri)] = rSquaresildhip_delta(1); %IL-DHIP
            [Rsquare_orig.Delta.il_vhip(ri)] = rSquaresilvhip_delta(1); %IL-VHIP
            [Rsquare_orig.Delta.pl_dhip(ri)] = rSquarespldhip_delta(1); %PL-DHIP
            [Rsquare_orig.Delta.pl_vhip(ri)] = rSquaresplvhip_delta(1); %PL-VHIP
            [Rsquare_orig.Delta.dhip_vhip(ri)] = rSquaresdv_delta(1); %DHIP-VHIP
            [Rsquare_orig.Delta.il_pl(ri)] = rSquaresip_delta(1); %IL-PL
            
            clear dhi* il* pl_* vhi* rSquares* 
        end %trials
        clear ri

        %% Save data (per animal, per recording arena)
        fn = [subjs{si} '_' rt '_BandPowerCrossCorr.mat']; %file name
            save([drIn fn],'drIn','Fs','Rsquare','Rsquare_orig')
        fprintf('Bandpower cross-corr data saved for %s %s.\n',subjs{si},rt)

        % Reset workspace
        clear fn Rsqua* IL PL DHIP VHIP rt drIn
    end %arenas
    clear ai
end %subjects
clear si
end %function
