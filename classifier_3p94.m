% % | Class | maxPitch | maxDelay | maxAmplitude | maxNoise | distLevel |
% % |-------|----------|----------|--------------|----------|-----------|
% % | 3p91  | 0.102    | 0.015    | 0.318        | 0.237    | 0.112     |
% % | 3p92  | 0.118    | 0.017    | 0.255        | 0.229    | 0.081     | 
% % | 3p93  | 0.103    | 0.018    | 0.332        | 0.216    | 0.092     |
% % | 3p94  | 0.085    | 0.021    | 0.301        | 0.221    | 0.111     |
% % | 3p95  | 0.120    | 0.021    | 0.297        | 0.221    | 0.092     |
% % | 3p96  | 0.104    | 0.026    | 0.857        | 0.213    | 0.097     |
% % | 3p97  | 0.104    | 0.030    | 0.905        | 0.181    | 0.097     |
% % | 3p98  | 0.104    | 0.027    | 0.841        | 0.240    | 0.108     |
% % | 3p99  | 0.096    | 0.025    | 0.854        | 0.188    | 0.117     |

loadDataStore_230903;

% Augmentierung
% Beispiel mehrere
% techniques = {'delay', 'noise'};  % Beispiel
% params = {struct('customPitch', wert1, 'maxAmplitude', wert2), struct('maxNoise', wert3)};   
augmentTechniques = {'customPitch', 'delay2', 'environmental', 'harmonicDistortion'};
augmentParams     = {struct('maxPitch', 0.085), ...
                     struct('maxDelay', 21e-3, 'maxAmplitude', 0.301), ...
                     struct('maxNoise', 0.221), ...
                     struct('distortionLevel', 0.111)};   
[trainFeatures, trainLabels] = prepareData(ads_train, trainCount, ...
                                           f_hp, f_lp, length_chunks, ...
                                           overlap, 'train', ...
                                           "trainData_3p94.mat", ...
                                           augmentTechniques, ...
                                           augmentParams);
[valFeatures, valLabels]     = prepareData(ads_validate, valCount, ...
                                           f_hp, f_lp, length_chunks, ...
                                           overlap, 'validate', ...
                                           "23-09-03 validationData.mat");

% Änderung der Labels und gleichzeitiges Entfernen von 'no drone'
[newTrainLabels, idx] = arrayfun(@(x) mapLabels(char(x)), trainLabels, 'UniformOutput', false);
idx = cell2mat(idx);  % Konvertieren von Cell-Array zu numerischem Array
trainFeatures = trainFeatures(:, :, :, idx ~= 0);
trainLabels = categorical(newTrainLabels(idx ~= 0));  % Direkte Umwandlung des Cell-Arrays

[newValLabels, idxVal] = arrayfun(@(x) mapLabels(char(x)), valLabels, 'UniformOutput', false);
idxVal = cell2mat(idxVal);
valFeatures = valFeatures(:, :, :, idxVal ~= 0);
valLabels = categorical(newValLabels(idxVal ~= 0));

sfn_classifier = 'DroneClassifier_V3p94.mat';
trainingClassifier_V3p4;

realWorldTest_classifier_3p94;

%% Evaluating the perfomance of the trained network
predClass   = predict(trainedNet,valFeatures);
[~, ind]    = max(predClass');

classes = getDroneClasses();
predictions = classes(ind);
confusionchart(categorical(valLabels'), categorical(predictions),"RowSummary","row-normalized");

% Helper-Funktion zur Änderung der Labels
function [newLabel, idx] = mapLabels(label)
    idx = 1;
    if strcmp(label, 'no drone')
        newLabel = '';
        idx = 0;
    else
        newLabel = label;  % Alle anderen Labels bleiben unverändert
    end
end