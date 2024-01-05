function [features, labels] = prepareData(ads, dataCount, ...
                                          f_hp, f_lp, ...
                                          length_chunks, ...
                                          overlap, mode, ...
                                          filename, ...
                                          augmentTechniques, ...
                                          augmentParams)

% prepareData creates a query of features an labels, which can be used
% as an input for the training process
%
% ads			- Contains the audio data set
% dataCount		- Contains the amount of audio files in the data set
% f_hp, f_lp		- Cutt-off frequencies for the low and the high pass
% filename		- Filename for saving the prepared data (if data have
%			  already been processed and saved, the will be loaded)
% augmentTechniques	- Contains the augmentation techniques, which will be applied
% augmentParams		- Contains the input parameters for the augmentation functions

features = []; labels = [];
if exist(filename, 'file') == 0
    wb = waitbar(0); cnt = 0;
    
    while hasdata(ads)
        cnt = cnt + 1;
        [audioIn, fileInfo] = read(ads);
        if size(audioIn,2) == 2
            audioIn = [audioIn(:,1); audioIn(:,2)];
        end
    
        Fs = fileInfo.SampleRate;
        audioIn = highpass(audioIn,f_hp,Fs);
        if f_lp < Fs/2
            audioIn = lowpass(audioIn,f_lp,Fs);
        end

        audioIn = normalizeAudioInput(audioIn, 0.9);
    
        % Cut data that is most likely to be no drone noise 
	% (e.g. before take-off or after landing) out
        if ~isequal(fileInfo.Label, 'no drone')
            [audioIn, isDrone] = preClassification(audioIn, Fs, fileInfo.FileName);
        end

        if strcmp(mode, 'train') && ~isempty(augmentTechniques) && ~isequal(fileInfo.Label, 'no drone')
            audioIn = augmentAudio(audioIn, augmentTechniques, augmentParams, Fs);
        end
    
        if size(audioIn,1) >= length_chunks*Fs || size(audioIn,2) >= length_chunks*Fs
            if sum(isDrone) > 0 || isequal(fileInfo.Label, 'no drone')
                if size(audioIn,1) == 1
                    feature = vggishPreprocess(audioIn',Fs, "OverlapPercentage",100*overlap);
                else
                    feature = vggishPreprocess(audioIn,Fs, "OverlapPercentage",100*overlap);
                end
                numSpectrograms = size(feature,4);
                features = cat(4,features,feature);
                labels = cat(2,labels,repelem(fileInfo.Label,numSpectrograms));
            end
        end
        message = sprintf('"Cnt" = %d/%d\n%s', cnt, sum(dataCount.Count), fileInfo.FileName(79:end));
        waitbar(cnt/sum(dataCount.Count), wb, message);
    end
    save(filename, 'features', 'labels');
else
    load(filename, 'features', 'labels');
    if isempty(features) == 1
        load(filename, 'trainFeatures', 'trainLabels');
        features = trainFeatures;
        labels   = trainLabels;
    end
end
