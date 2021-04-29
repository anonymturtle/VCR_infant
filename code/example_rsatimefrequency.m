%% Example : Relate oscillation-based category representations in infants and adults
% This script demonstrates the RSA analysis relating category
% representations of infants and adults in time and frequency 
% for the study "Visual category representation in the infant brain"

%% Initialize

% Clean command window, workspace and figure windows
clc; clear; close all;
% Start timing
tic;

%% Download dataset (if necessary) and add VCR_infant to the MATLAB path
setup(7);

%% Load example RDMs
load('exampledata_timefrex.mat', 'neuralRDMs');

%% Check RDMs

% Check content
neuralRDMs.Content
% Check dimensionality
neuralRDMs.Dimension
%%

%% Define infants' and the adult's RDMs 

% Infants' RDM is a single aggregated infant oscillatory RDM 
% by averaging decoding accuracy matrices based on 
% the extent of the cluster found in time-frequency decoding analysis 
RDMInfant = neuralRDMs(1).RDM;

% The adult's RDMs are time- and frequency- resolved RDMs 
% for a single participant
RDMAdult = neuralRDMs(2).RDM;
%%

%% Define time points of interest and frequencies of interest
TOI = -200:20:1000;
timeT = length(TOI);

FOI = logspace(log10(2),log10(30),30);
frequencyF = length(FOI);
%%

%% Relate the RDMs in time and frequency

% Pre-allocate result matrix
rsaResMat = nan(frequencyF,timeT);

% Vectorize RDMs
vectInfant = vectorizerdm(RDMInfant);

for frexAdult = 1:frequencyF % Loop through frequencies
    for timeAdult = 1:timeT % Loop through time points
        % Vectorize RDMs
        vectAdult = vectorizerdm(squeeze(RDMAdult(:,:,timeAdult,frexAdult)));
        
        % Correlation
        rsaResMat(frexAdult,timeAdult) = correlatevectors(vectInfant,vectAdult);
    end
end

% Display run time
disp("RSA done.")
runTime_minutes = toc/60
%%

%% Plot time-frequency Spearman's R matrix
figure(1);
imagesc(-200:20:1000, 1:30, squeeze(rsaResMat));
set(gca,'YTick',[1,6,11,16,21,26,30], ...
    'YTickLabel', round(FOI([1,6,11,16,21,26,30]),2));
axis xy; axis tight;
xlim([-200,1000]);
xlabel('Time (ms)'); ylabel('Frequency (Hz)');
CH = colorbar('eastoutside');
CH.Label.String = "Spearman's R";
title("Time and frequency Spearman's R matrix");
% Adjust figure position and size
rectFig = get(gcf,'position');
width=600; height=300;
set(gcf,'position',[rectFig(1),rectFig(2),width,height], 'color', 'white');
%%