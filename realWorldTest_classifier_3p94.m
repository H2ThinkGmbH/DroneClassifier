% pfad    - filepath of the audio data for the real world test
% messung - filename of the audio data for the real world test

% pfad = 'D:\Dropbox\03 H2 Think\AuDroK mFund\Auswertungen\23-08 Drone Class Classifier\VALIDATION\C3\';
pfad = 'D:\Dropbox\03 H2 Think\AuDroK mFund\Auswertungen\23-08 Drone Class Classifier\VALIDATION\C2\';
% pfad = 'D:\Dropbox\03 H2 Think\AuDroK mFund\Auswertungen\23-08 Drone Class Classifier\VALIDATION\C1\';
% pfad = 'D:\Dropbox\03 H2 Think\AuDroK mFund\Auswertungen\23-08 Drone Class Classifier\VALIDATION\C0\';    
% messung = '06-36-S-15m-Arr3.wav'; % C3
% messung = '22-16-S-15m-Mic1.wav'; % C2
% messung = '26-16-var-Mic1.wav'; % C2
% messung = '21-35-var-Mic1.wav'; % C2
messung = '20-35-F-30m-Mic1.wav'; % C2
% messung = '18-35-F-15m-Mic1.wav'; % C2
% messung = 'DJI fpv drohne 11_32_A.wav'; % C1
% messung = 'DJI fpv drohne Digitec_A.wav'; % C1
% messung = 'DJI fpv drohne Digitec_A.wav'; % C1
% messung = 'REC038.wav'; % C1
% messung = 'REC082.wav'; % C1
% messung = 'DJI Mini 3 Billy Kyle_A_Rechts.wav'; % C0 
% messung = 'DJI Mini 3 Pro Matthias Dangl_A.wav'; % C0
% messung = 'DJI Mini 3 Pro Billy Kyle_B_Links.wav'; % C0

[audio, Fs] = audioread([pfad, messung]);

% Load classifier for drone vs. no drone classification
load('DroneClassifier_V5p09.mat');
droneVsNoDroneNet = trainedNet;
load('DroneClassifier_V3p94.mat');
droneClassNet = trainedNet;

numberChunks = floor(size(audio,1)/Fs);
predictions  = zeros(numberChunks, 5);
regressions  = zeros(numberChunks, 5);

for cnt = 1:numberChunks
    if size(audio,2) ~= 1
        audio = audio(:,1);
    end
    audioChunk = audio(((cnt-1)*Fs+1):(cnt*Fs));
    audioChunk = normalizeAudioInput(audioChunk, 0.9);
    feature = vggishPreprocess(audioChunk,Fs, "OverlapPercentage",50);
    pred = predict(droneVsNoDroneNet,feature(:,:,1));
    [~, ind]  = max(pred');
    if ind ~= 2
        regressions(cnt,5) = pred(2);
        pred = predict(droneClassNet,feature(:,:,1));
        [~, ind]  = max(pred');
        switch ind
            case 1
                predictions(cnt,:) = [1 0 0 0 0];
                regressions(cnt,1) = pred(1);
            case 2
                predictions(cnt,:) = [0 1 0 0 0];
                regressions(cnt,2) = pred(2);
            case 3
                predictions(cnt,:) = [0 0 1 0 0];
                regressions(cnt,3) = pred(3);
            case 4
                predictions(cnt,:) = [0 0 0 1 0];
                regressions(cnt,4) = pred(4);
        end
    else
        predictions(cnt,:) = [0 0 0 0 1];
        regressions(cnt,5) = pred(2);
    end
end

[~, ind]  = max(predictions');
classes   = getDroneClasses();
predClass = classes(ind);

%% Propability
probC0 = sum(regressions(:,1))/sum(regressions(:,1:4),"all");
disp(['C_0: ' num2str(100*probC0) ' %'])
probC1 = sum(regressions(:,2))/sum(regressions(:,1:4), "all");
disp(['C_1: ' num2str(100*probC1) ' %'])
probC2 = sum(regressions(:,3))/sum(regressions(:,1:4), "all");
disp(['C_2: ' num2str(100*probC2) ' %'])
probC3 = sum(regressions(:,4))/sum(regressions(:,1:4), "all");
disp(['C_3: ' num2str(100*probC3) ' %'])

%% Regressions Plot
figure(3)
subplot(511)
plot(time, regressions(:,5))
title('no drone')
subplot(512)
plot(time, regressions(:,1))
title('C0')
subplot(513)
plot(time, regressions(:,2))
title('C1')
subplot(514)
plot(time, regressions(:,3))
title('C2')
subplot(515)
plot(time, regressions(:,4))
title('C3')

%% Plotting

figure(2)

% Spektrogramm (2/3 der Höhe)
ax1 = subplot('Position',[0.1 0.46 0.835 0.48]);
spectrogram(audio, 512, 250, 512, Fs, 'yaxis');
ax = gca;
xTickLabelsInSeconds = ax.XTick * 60; % Umwandlung von Minuten in Sekunden
ax.XTickLabel = xTickLabelsInSeconds;
xlabel('time in seconds');
set(gca, 'YScale', 'log');
ylim([0.2 20]);
title(['Spectrogram of the audio signal ', messung]);
set(gca, 'FontSize', 16);

% Klassifizierung (1/3 der Höhe)
time = 1:numberChunks;
[uniqueClasses, ~, idx] = unique(predClass);
ax2 = subplot('Position',[0.1 0.1 0.8 0.2]);
plot(time, idx, 'o-');
xlim([0 numberChunks])
ylim([0 5]);
set(gca, 'YTick', 1:numel(uniqueClasses), 'YTickLabel', uniqueClasses);
xlabel('time in seconds');
ylabel('Predicted class');
title('Classification over time');
set(gca, 'FontSize', 16);
grid on