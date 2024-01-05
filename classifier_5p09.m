loadDataStore_231205;

% Augmentierung
% Beispiel mehrere
% techniques = {'delay', 'noise'};  % Beispiel
% params = {struct('maxDelay', wert1, 'maxAmplitude', wert2), struct('maxNoise', wert3)};   
augmentTechniques = {'customPitch', 'delay2', 'harmonicDistortion'};
augmentParams     = {struct('maxPitch', 0.085), ...
                     struct('maxDelay', 21e-3, 'maxAmplitude', 0.301), ...
                     struct('distortionLevel', 0.111)};    
[trainFeatures, trainLabels] = prepareData(ads_train, trainCount, ...
                                           f_hp, f_lp, length_chunks, ...
                                           overlap, 'train', ...
                                           "trainData_5p09.mat", ...
                                           augmentTechniques, ...
                                           augmentParams);
[valFeatures, valLabels]     = prepareData(ads_validate, valCount, ...
                                           f_hp, f_lp, length_chunks, ...
                                           overlap, 'validate', ...
                                           "valData_5p09.mat");

% Änderung der Labels 'C0' bis 'C3' zu 'drone' 
trainLabels = arrayfun(@(x) iff(isempty(strfind(char(x), 'no drone')), 'drone', char(x)), trainLabels, 'UniformOutput', false);
trainLabels = categorical(trainLabels);
valLabels = arrayfun(@(x) iff(isempty(strfind(char(x), 'no drone')), 'drone', char(x)), valLabels, 'UniformOutput', false);
valLabels = categorical(valLabels);

sfn_classifier = 'DroneClassifier_V5p09.mat';
numClasses = 2;
trainingClassifier_V5;


%% Evaluating the perfomance of the trained network
predClass   = predict(trainedNet,valFeatures);
[~, ind]    = max(predClass');

classes = ["drone" "no drone"];
predictions = classes(ind);
confusionchart(categorical(valLabels'), categorical(predictions),"RowSummary","row-normalized");