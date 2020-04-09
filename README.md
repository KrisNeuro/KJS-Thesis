Sequence of events:
---------------------------------------------------------------------
---------------------------------------------------------------------

# 0. AddScriptPaths.m
User selects local directories containing .m scripts to be added to MATLAB search path.

---------------------------------------------------------------------

# 1. Thesis1_ImportPreprocess
*Requires MATLAB Signal Processing Toolbox be installed*
Imports and preprocesses LFP and VT data from NLX to MAT format.

Steps:
 1. Import & Pre-process data (pre-cleaning), per trial
 2. Get total distance traveled (for this subject, per arena type)
 3. Get distribution of subj's movement velocities for all recordings per arena type
 4. Get cumulative distribution of movement linear velocity for all subjects

Calls functions:
 - HilbKJS.m
 - ImportCSC2.m
 - ImportVTBL.m, ImportVTEPM.m
 - PowSpec.m
 - TotalDistanceTraveled.m
 - VelCumDist.m
 - VelDist.m

---------------------------------------------------------------------

# 2. Thesis2_FindBadChannels
Calculates and plots Phase-Locking Value (PLV) between channels within a brain region to determine unusable/bad channels to be excluded from further analyis. PLV is calculated via Hilbert transform on pre-cleaned data band-passed from 0.5-100 Hz.
Uses only the LFPs from familiar arena ('BL') trials as input.

Steps:
 1. Mean power spectra per channel (16)
 2. Phase-Locking Value (PLV) Analysis (credit: YiQi Xu)
  2.1  Coherencyc analysis (Chronux toolbox)
  2.2  Hilbert Transform/PLV
  2.3  Calculate & plot mean PLV across channels

Calls functions:
- barPLV.m
- coherencyc.m (from Chronux toolbox: http://chronux.org/)
- ChanScreen.m
- MeanPowSpecFig.m

---------------------------------------------------------------------

 **PAUSE**
 For each subject, researcher will now manually inspect data visualization outputs to determine any channels to be removed. Channel exclusion criteria include one or more of the following:  Muscle artifact contamination, Poor signal grounding, significanly decreased total amplitude vs other channels in its electrode bundle, mean power spectra that fails to resemble 1/f 'pink noise'-like shape, or poor PLV relative to other channels in its electrode bundle.

Figures to inspect are output by:
 - ChanScreen.m
 - MeanPowSpecFig.m
 - barPLV.m
 
---------------------------------------------------------------------

# 3. Thesis3_RemoveBadChannels
User designates channels to remove. Of the remaining usable channels, an average signal is created by finding the mean voltage of usable channels at each timestamp (at 2kHz). This 'good channel index' is applied to all trials in all arenas for this subject, and data are saved as new files.
This script *should* run standalone. No functions called.

---------------------------------------------------------------------

# 4. Thesis4_AnalyzeAllVelDat
*Requires MATLAB Signal Processing Toolbox be installed*
Analyze LFP data from familiar arena ('BL') including all movement velocity ranges:
- Theta phase lag analysis: Filtered by mean dHPC power threshold
- Band power cross-correlations (theta, gamma, delta): To be Z-scored

Steps:
 1. Filter for theta band (ThetaFiltfilt)
 2. Theta Phase Lag analysis
 3. Format data for bootstrapping: Theta phase lag, width @ half-max
 4. Band power cross-correlations (theta, gamma, delta) 
 5. Format data for bootstrapping: Band power cross-corr, R^2_orig
 6. Z-score R^2 data (theta, gamma, delta)

Calls functions:
 - ThetaPhaseLagdH2.m
 - Format4Bootstrap_thetaphaselagdH.m
 - BandPowerCrossCorr.m
 - regoutliers.m   (https://www.mathworks.com/matlabcentral/fileexchange/37212-regression-outliers)
 - mtcsg.m (from A.Adhikari)
 - Format4Bootstrap_Rsq.m
 - ZscoreRsq_boot.m
 
 ---------------------------------------------------------------------

# 5. Thesis5_FilterByVelocity
Filter BL arena LFP data based on linear velocity ranges:
- 0-5 cm/s ("slow")
- 5-15 cm/s ("medium")
- 15+ cm/s ("fast")

Fetches data:
- IL,PL,DHIP,VHIP, Rxlist (AllDat, reduced channels, all BL recordings. Output by Thesis3_RemoveBadChannels.m)
- Vrex (Output by VelDist.m, called by Thesis1_*.m)

Steps:
 1. Fetch input data: Vrex, IL, PL, DHIP, VHIP (all BL recordings)
 2. Find time indices of velocity ranges
 3. Plot & save subject's BL velocity distribution
 4. Align LFP data to time indices (per trial)
 5. Save velocity-filtered data (per trial)
 6. Save velocity-filtered data (all BL arena trials, per subj): 'subjID_ReducedDataPerSpeed.mat'
 7. Calculate time spent in each velocity range

Calls function:
- GetDataDuration.m

---------------------------------------------------------------------

# 6. Thesis6_Format4Bootstrap_5to15
Format LFP data taken from epochs of movement 5-15 cm/s in the familiar ('BL') arena for bootstrapping procedures relating to power spectra, band power, and coherence between regions.

Steps:
 1. Format for bootstrap: LFP data
 2. Calculate Power Spectra (pwelch)
  2.1 Calculate Power Spectra: One curve per subject
  2.2 Calculate female Power Spectra: Separate each subj by estrous stage
  2.3 Plot Power Spectra & Functional statistical tests: Sex Differences
  2.4 Plot Power Spectra & Functional statistical tests: Females only/Estrous stages
  2.5 Plot Power Spectra & Functional statistical tests: Male vs Estrous stages
 3. Calculate band power in theta, gamma, and delta bands
 4. Format for bootstrap: coherencyc & Plot    
 5. Calculate magnitude-squared coherence (mscohere)
  5.1 Calculate mscohere: One curve per subject
  5.2 Calculate female mscohere: Separate each subj by estrous stage
  5.3 Plot mscohere & Functional statistical tests: Sex Differences
  5.4 Plot mscohere & Functional statistical tests: Females only/Estrous stages
  5.5 Plot mscohere & Functional statistical tests: Male vs Estrous stages

Fetches data generated by:
 Thesis5_FilterByVelocity.m  'subjID_ReducedDataPerSpeed.mat'
      
Calls functions:
 - coherencyc.m  (from Chronux toolbox: http://chronux.org/)
 - colorcet.m  (https://peterkovesi.com/projects/colourmaps/)
 - Format4Bootstrap_LFP.m
 - Format4Bootstrap_BandPower2.m
 - Format4Bootstrap_coherency.m
 - get_bootstrapped_sample.m
 - get_direct_prob.m
 - shadedErrorBar.m  (https://www.mathworks.com/matlabcentral/fileexchange/26311-raacampbell-shadederrorbar)
 - twosampF.m 
 - PlotBoot_mscohere.m
 - PlotBoot_mscohereBands.m
 - PlotBoot_mscohereHormones.m
 - PlotBoot_mscohereHormonesBands.m 
 - PlotBoot_mscohereMvHorms.m
 - PlotBoot_mscohereMvHormsBands.m
 - PlotBoot_PowSpec.m
 - PlotBoot_PowSpecBands.m
 - PlotBoot_PowSpecHormones.m
 - PlotBoot_PowSpecHormonesBands.m
 - PlotBoot_PowSpecMvHorms.m
 - PlotBoot_PowSpecMvHormsBands.m
 - PowSpec5to15.m
 - PowSpec5to15_Hormones.m
 - PowSpec5to15Trials.m

---------------------------------------------------------------------

# 7. Thesis7_Analyze5to15BLDat_V3
Analyzing familiar arena data via hierarchical bootstrapping: 5-15 cm/s movement epochs
*Requires MATLAB Communication Toolbox be installed*

Steps:
 1.0 Hierarchical bootstrap: Band power (BL,5-15cm/s)
  1.1 MvF: Band Power 
  1.2 Plot theta band joint-probability matrices: M vs F 
  1.3 Plot gamma band joint-probability matrices: M vs F 
  1.4 Plot delta band joint-probability matrices: M vs F 
  1.5 Females/Hormones: Band Power
  1.6 Plot theta band joint-probability matrices: Females/Hormones
  1.7 Plot gamma band joint-probability matrices: Females/Hormones
  1.8 Plot delta band joint-probability matrices: Females/Hormones
 2.0 Hierarchical bootstrap: Theta phase lags (BL,mean dHPC power threshold)
  2.1 MvF: Theta phase lags 
  2.2 Plot mean theta phase lag joint-probability matrices: M vs F 
  2.3 Females/Hormones: Theta phase lags
  2.4 Plot mean theta phase lag joint-probability matrices: Females/Hormones
 3.0 Hierarchical bootstrap: Theta, Gamma, Delta R^2
  3.1 MvF: R^2
  3.2 Plot mean R^2 joint-probability matrices: M vs F 
  3.3 Females/Hormones: R^2
  3.4 Plot mean R^2 joint-probability matrices: Females/Hormones

Calls functions:
 - get_bootstrapped_sample.m
 - get_direct_prob.m
 - BootStat_MvF.m
 - BootStat_FHorms.m

---------------------------------------------------------------------
---------------------------------------------------------------------
