function [droneSignal, isDrone] = preClassification(audioIn, Fs, Filename, L, OP)
% This function performs a pre-classification of the individual audio chunks 
% to exclude those parts of the audio signal in which no drone noises can be 
% heard (mainly before take-off or after landing)


    if nargin < 6
        L = 1; % Default value for chunk length is 1 second
    end
    if nargin < 7
        OP = 0.5; % Default value for overlap is 0.5
    end

    if isempty(micNumber)
        warning('None of our free-field measurements')
        droneSignal = audioIn;
        isDrone = 1;
        return
    end

    chunkSamples = round(L * Fs);
    overlapSamples = round(OP * chunkSamples);
    stepSize = chunkSamples - overlapSamples;

    droneSignal = []; % Initialize output signal
    isDrone = false(size(audioIn));

    % Glide over the input signal
    lastAddedIdx = 0;
    for idx = 1:stepSize:(length(audioIn) - chunkSamples + 1)
        chunk = audioIn(idx:idx+chunkSamples-1);

         if isDroneChunk(chunk, Fs) % If chunk contains a drone
            isDrone(idx:idx+chunkSamples-1) = true;

            % Check whether the current chunk overlaps with the last chunk added
            if idx <= lastAddedIdx
		% Skip the current chunk if it overlaps with the last chunk added
                continue; 
            end
            
            droneSignal = [droneSignal; chunk];
            lastAddedIdx = idx + chunkSamples - 1;
        end
    end
    % Check the remaining part of the signal if it does not reach the chunk length
    remainingIdx = lastAddedIdx + 1;
    while remainingIdx <= length(audioIn)
        remainingEnd = min(remainingIdx + chunkSamples - 1, length(audioIn));
        remainingChunk = audioIn(remainingIdx:remainingEnd);

        if isDroneChunk(remainingChunk, Fs)
            droneSignal = [droneSignal; remainingChunk];
            isDrone(remainingIdx:remainingEnd) = true;
        end

        remainingIdx = remainingEnd + 1;
    end
end

% This function detects the presence of drones based on the harmonic to noise ratio
function detected = isDroneChunk(chunk, Fs)
    try
        % The threshold of 0.5 was determined empirically. The motto was that it 
	% was better to define a drone noise as "no drone" than the other way around
        if mean(harmonicRatio(chunk, Fs)) > 0.50
            detected = 1;
        else
            detected = 0;
        end
    catch
        disp('error')
        detected = 0;
    end
end