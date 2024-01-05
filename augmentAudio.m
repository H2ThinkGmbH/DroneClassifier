% Data Augmentation
function augAudio = augmentAudio(audioIn, techniques, params, Fs)
    augAudio = audioIn;

    if size(audioIn,1) ~= 0
        for i = 1:length(techniques)
            switch techniques{i}
                case 'pitch'
                    maxSemitone = params{i}.maxSemiTone;
                    augAudio = applyRandomPitching(audioIn, maxSemitone);
                case 'customPitch'  % Neue Pitch-Funktion
                    if params{i}.maxPitch == 0
                        augAudio = audioIn;
                    else
                        maxPitch = params{i}.maxPitch;
                        augAudio = applyCustomPitching(augAudio, maxPitch, Fs);
                    end
                case 'noise' % Hinzufügen von Rauschen
                    maxNoise = params{i}.maxNoise;
                    augAudio = applyRandomNoise(audioIn, maxNoise);
                case 'delay'
                    maxDelay = params{i}.maxDelay;
                    maxAmplitude = params{i}.maxAmplitude;
                    augAudio = applyRandomDelay(audioIn, maxDelay, maxAmplitude, Fs);
                case 'delay2'
                    maxDelay = params{i}.maxDelay;
                    maxAmplitude = params{i}.maxAmplitude;
                    augAudio = applyDelay(audioIn, maxDelay, maxAmplitude, Fs);
                case 'environmental'
                    maxNoiseAmp = params{i}.maxNoise;
                    augAudio = applyEnvironmentalNoise(audioIn, Fs, maxNoiseAmp);
                case 'doppler'
                    maxSpeed = params{i}.maxSpeed;
                    augAudio = applyDopplerEffect(audioIn, maxSpeed, Fs);
                case 'harmonicDistortion'
                    distortionLevel = params{i}.distortionLevel;
                    augAudio = applyHarmonicDistortion(augAudio, distortionLevel, Fs);
            end
        end
    end
end

function augAudio = applyRandomDelay(audioIn, maxDelay, maxAmp, sampleRate)
    % Check whether the delay is too long
    if maxDelay > length(audioIn)/sampleRate
        error('The maximum delay is greater than the length of the audio signal.');
    end

    % Generate random delay and amplitude
    randomDelay = rand() * maxDelay; % Random delay between 0 and maxDelay
    randomAmp = rand() * maxAmp; % Random amplitude between 0 and maxAmp

    % Convert delay to samples
    delaySamples = round(randomDelay * sampleRate);

    % Generate delay signal
    delaySignal = [zeros(delaySamples, 1); audioIn(1:end-delaySamples)];

    % Multiply delay signal with random amplitude
    delaySignal = delaySignal * randomAmp;

    % Create output signal by superimposing
    augAudio = audioIn + [zeros(delaySamples, 1); delaySignal(1:end-delaySamples)];

    % Clipping test
    if max(abs(augAudio)) > 1
        augAudio = 0.9 * augAudio / max(abs(augAudio));
    end
end

function augAudio = applyDelay(audioIn, maxDelay, maxAmp, sampleRate)
    % Überprüfen, ob das Delay zu groß ist
    if maxDelay > length(audioIn)/sampleRate
        error('The maximum delay is greater than the length of the audio signal.');
    end

    % Delay and amplitude are varied by +/- 10
    randomDelay = maxDelay*(1+0.2*(rand()-0.5)); 
    randomAmp   = maxAmp*(1+0.2*(rand()-0.5)); % Random amplitude between 0 and maxAmp

    % Convert delay to samples
    delaySamples = round(randomDelay * sampleRate);

    % Generate delay signal
    delaySignal = [zeros(delaySamples, 1); audioIn(1:end-delaySamples)];

    % Multiply delay signal with random amplitude
    delaySignal = delaySignal * randomAmp;

    % Create output signal by superimposing
    try
        augAudio = audioIn + [zeros(delaySamples, 1); delaySignal(1:end-delaySamples)];
    catch
        disp('Es ist ein Fehler aufgetreten');
    end

    % Clipping test
    if max(abs(augAudio)) > 1
        augAudio = 0.9 * augAudio / max(abs(augAudio));
    end
end

% Function only used in the development process
% Please look here for more details: https://github.com/LorisNanni/Audiogmenter
function pitchAudio = applyRandomPitching(audioIn, maxSemitone)
    % Applying an arbitrtary pithing of audioIn in the range +/-
    % mexSemiTones
    pitch = 2*maxSemitone*rand(1)-maxSemitone;
    augmenter = audioDataAugmenter( ...
                            "AugmentationMode","independent", ...
                            "AugmentationParameterSource","random", ...
                            "SpeedupFactor",[0.9,1.1,1.2], ...
                            "ApplyTimeStretch",false, ...
                            "ApplyPitchShift",true, ...
                            "SemitoneShift", pitch, ...
                            "SNR", 0, ...
                            "ApplyVolumeControl",false, ...
                            "ApplyTimeShift",false);
    pitchAudio = augment(augmenter,audioIn);
    pitchAudio = cell2mat(pitchAudio{1,1});
end

% Function only used in the development process
% Please look here for more details: https://github.com/LorisNanni/Audiogmenter
function augAudio = applyRandomNoise(audioIn, maxNoise)
    % Adding noise in the range [0 maxNoise] to audioIn 
    % maxNoise relates to the full scale (1 == Max)
    noise = maxNoise*rand(1);
    augmenter = audioDataAugmenter( ...
                            "AugmentationMode","independent", ...
                            "AugmentationParameterSource","random", ...
                            "SpeedupFactor",[0.9,1.1,1.2], ...
                            "ApplyTimeStretch",false, ...
                            "ApplyPitchShift",false, ...
                            "SemitoneShift", 0, ...
                            "SNR", noise, ...
                            "ApplyVolumeControl",false, ...
                            "ApplyTimeShift",false);
    augAudio = augment(augmenter,audioIn);
    augAudio = cell2mat(augAudio{1,1});
end

function audioOut = applyEnvironmentalNoise(audioIn, Fs_sig, maxAmp)
    folderPath = 'D:\Dropbox\03 H2 Think\AuDroK mFund\Auswertungen\Environmental Noise';
    % Get a list of all files in the folder
    files = dir(fullfile(folderPath, '*.wav')); % change '*.mp3' to the format of your files

    % If no file is found display a message and return
    if isempty(files)
        disp('No files found');
        audioOut = audioIn;
        return;
    end

    if maxAmp < 0 || maxAmp > 1
        disp('maxAmp muss zwischen 0 und 1 liegen');
        audioOut = audioIn;
        return;
    end

    % Generate a random index into the files array
    randIndex = randi(length(files));

    % Select a random file
    randFile = files(randIndex).name;

    % Construct full file path
    fullFilePath = fullfile(folderPath, randFile);

    % Load the envirnonmental audio file
    [audioEnv, Fs_env] = audioread(fullFilePath);
    if Fs_env ~= Fs_sig
        audioEnv = resample(audioIn, Fs_sig, Fs_env);  % Signal neu abtasten
    end

    % Take an arbitrary section with the same length of the input file
    sInput = length(audioIn);
    sEnvir = length(audioEnv);

    if (sEnvir(1) - sInput(1)) > 0
        ind = randi(sEnvir(1) - sInput(1));
        audioEnv = audioEnv(ind:(ind+sInput-1));
        
        % Calculation of the rms of the input signal
        rms_sig = rms(audioIn);

        % Adjustment of the amplitude of the ambient noise
        rms_env = rms(audioEnv);
        scaled_audioEnv = (rms_sig / rms_env) * maxAmp * audioEnv;

        % Create mixed signal
        if sum(size(audioIn) == size(scaled_audioEnv)) == 0
            audioOut = audioIn + scaled_audioEnv';
        else
            audioOut = audioIn + scaled_audioEnv;
        end

        % Scaling if the signal is clipped
        if max(audioOut) > 0.9
            audioOut = 0.9* audioOut/max(audioOut);
        end
    else
        audioOut = audioIn;
    end
end

% This function did not lead to satisfactory results. It may simply be faulty.
function augAudio = applyDopplerEffect(audioIn, maxSpeed, sampleRate)
    % Generate a random speed between -maxSpeed and maxSpeed
    randomSpeed = (2 * rand() - 1) * maxSpeed;
    
    % Length of the signal
    L = length(audioIn);
    
    % Time vector
    t = (0:L-1) / sampleRate;
    
    % Doppler coefficient
    c = 343; % Schallgeschwindigkeit in m/s
    dopplerCoeff = (c + randomSpeed) / c;
    
    % Interpolated time axis
    t_doppler = t / dopplerCoeff;
    
    % Interpolation
    augAudio = interp1(t_doppler, audioIn, t, 'linear', 'extrap');
    
    % Clipping-Prüfung
    if max(abs(augAudio)) > 1
        augAudio = 0.9 * augAudio / max(abs(augAudio));
    end
end

function augAudio = applyHarmonicDistortion(audioIn, distortionLevel, sampleRate)
    % Check whether the degree of distortion is valid
    if distortionLevel < 0 || distortionLevel > 1
        error('Distortion level must be between 0 and 1.');
    end

    % Add harmonic distortion through non-linear function
    augAudio = audioIn - distortionLevel * sin(2 * pi * (500/sampleRate) * (1:length(audioIn))') .* audioIn;

    % Clipping check and correction if necessary
    if max(abs(augAudio)) > 1
        augAudio = augAudio / max(abs(augAudio));
    end
end

function augAudio = applyCustomPitching(audioIn, semiTone, Fs)
    % Generate a random pitch change within the [-semiTone, semiTone] range
    pitchShift = (rand()*2 -1)*semiTone;
    
    % Conversion of pitch shift to frequency ratio
    freqRatio = 2^(pitchShift / 12);

    % Check whether a reduction in the sampling rate is necessary
    originalFs = Fs;
    if Fs > 48000
        % Temporary reduction of the sampling rate for processing
        Fs = 48000;
        audioIn = resample(audioIn, Fs, originalFs);
    end

    % Applying the pitch shift
    augAudio = pitchShiftWithSameSpeed(audioIn, freqRatio, Fs);

    % Return to the original sampling rate if necessary
    if originalFs > 48000
        augAudio = resample(augAudio, originalFs, Fs);
    end
end

% is required for applyCustomPitching
function shiftedAudio = pitchShiftWithSameSpeed(audioIn, freqRatio, Fs)
    % Adjusting the sampling rates to integers for the resample function
    segmentLength = 1e5; % Length of each segment
    numSegments = ceil(length(audioIn) / segmentLength);
    shiftedAudio = [];

    newFs = round(Fs * freqRatio);

    for i = 1:numSegments
        segmentStart = (i - 1) * segmentLength + 1;
        segmentEnd = min(i * segmentLength, length(audioIn));
        segment = audioIn(segmentStart:segmentEnd);

        % Applying the pitch shift to the current segment
        try
            shiftedSegment = resample(segment, newFs, Fs);
        catch
            shiftedSegment = segment;
            disp('Error with resampling')
        end

        % Adding the edited segment to the output signal
        shiftedAudio = [shiftedAudio; shiftedSegment];
    end
end
