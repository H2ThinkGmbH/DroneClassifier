%% Training the classifier to distinguish between 'drone' and 'no drone'

if exist(sfn_classifier) == 0
    % Adapting the vggish network
    net = vggish;
    lgraph = layerGraph(net.Layers);
    lgraph = removeLayers(lgraph,"regressionoutput");
    lgraph = addLayers(lgraph,[ ...
        fullyConnectedLayer(numClasses,Name="FCFinal",WeightLearnRateFactor=2,BiasLearnRateFactor=2) ...
        softmaxLayer(Name="softmax") ...
        classificationLayer(Name="classOut")]);
    lgraph = connectLayers(lgraph,"EmbeddingBatch","FCFinal");
    % Training
    % Performing transferlearning and saving the result. 
    options = trainingOptions("sgdm", ...
        LearnRateSchedule="piecewise", ...
        InitialLearnRate=0.001, ...
        LearnRateDropFactor=0.1, ...
        LearnRateDropPeriod=3, ...
        MaxEpochs=12, ...
        MiniBatchSize=256, ... % 512 is the highest possible value, after that my GPU memory is no longer sufficient
        Plots="training-progress");

    [trainedNet, netInfo] = trainNetwork(trainFeatures,trainLabels,lgraph,options);
    
    info.input = 'Spectrograms of the drone images from the RAR';
    info.preprocessing = 'transformDroneDate.mlx';
    info.trainingoptions = options;
    save(sfn_classifier, 'trainedNet', 'netInfo', '-mat');
else
    load(sfn_classifier);
end