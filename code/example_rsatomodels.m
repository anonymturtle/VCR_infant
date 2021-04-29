%% Example : Relate category representations to computational models 
% This script demonstrates the analysis relating category representations 
% in infants or adults to computational models using RSA
% of the  study "Visual category representation in the infant brain"

%% Initialize

% Clean command window, workspace and figure windows
clc; clear; close all;
% Start timing
tic;

%% Download dataset (if necessary) and add VCR_infant to the MATLAB path
setup([5,6]);

%% Load example dataset
load('exampledata_time.mat', 'neuralRDMs');
load('exampledata_model.mat', 'modelRDMs');

%% Check RDMs

% Check Content
% Neural RDM
neuralRDMs.Content
% Model RDM
modelRDMs.Model

% Check dimensionality
% Neural RDM
neuralRDMs.Dimension
% Model RDM
modelRDMs.Dimension
%%

%% Define neural RDM in time points of interest
timescale = (-200:20:1000)';
timeofinterest = [144,176]'; % (i.e., 95% confidence interval of peak latency)
TOI = dsearchn(timescale,timeofinterest);
rdmNeural = squeeze(nanmean(neuralRDMs(2).RDM(:,:,TOI(1):TOI(2)),3)); % the adult's RDMs

%% Relate neural and model RDMs

% Pre-allocate result matrix
rsaResMat = nan(1,2); 

% We then compared the model RDMs to infant or adult neural RDMs
for modelI = 1:2 % Loop through models
    % Define the model RDM
    rdmModel = modelRDMs(modelI).RDM;
    
    % Vectorize RDMs
    vectModel = vectorizerdm(rdmModel);
    vectNeural = vectorizerdm(rdmNeural);
    
    % Correlation
    rsaResMat(modelI) = correlatevectors(vectModel,vectNeural);
end

% Display run time
disp("RSA done.")
runTime_minutes = toc/60
%%

%% Plot correlation result bars
figure(1);
bar(rsaResMat);
set(gca, 'xtick',1:2, 'xticklabel',{modelRDMs(1).Model,modelRDMs(2).Model});
xlabel("Model");
ylabel("Spearman's R");
title("Relating neural RDMs with model RDMs");
% Adjust figure position and size
rectFig = get(gcf,'position');
width=600; height=300;
set(gcf,'position',[rectFig(1),rectFig(2),width,height], 'color', 'white');
%%