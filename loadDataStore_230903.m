% The training data are used to train the classifier
% The validation data are intended as a benchmark for the classifier
% The test data are used to examine the real-world performance of the classifier

% String of the filepath of the Trainingdata
filepath_train = 'D:\Dropbox\03 H2 Think\AuDroK mFund\Auswertungen\23-08 Drone Class Classifier\TRAINING'; 

ads_train = audioDatastore(filepath,...
"IncludeSubfolders",true,...
"LabelSource","foldernames");
labelTable = countEachLabel(ads_train);
numClasses = height(labelTable);

% Filename of the datastore, to ensure, that all developments are done with the same set of training and validation data
fn = '23-09-03 train and validateADS.mat'
if exist(fn,'file') == 1
    load(fn);
else
    [ads_train, ads_validate] = splitEachLabel(ads_train,0.5,"randomized");
    save(fn, 'ads_train', "ads_validate");
end

filepath_test = 'D:\Dropbox\03 H2 Think\AuDroK mFund\Auswertungen\23-08 Drone Class Classifier\VALIDATION';
ads_test = audioDatastore(filepath_test,...
"IncludeSubfolders",true,...
"LabelSource","foldernames");
% labelTable = countEachLabel(ads_test);
% numClasses = height(labelTable);

trainCount = countEachLabel(ads_train);
valCount   = countEachLabel(ads_validate);

% Cut-off frequency for the highpass in Hz
f_hp = 200;
f_lp = 20e3;

% Length of the investigated audio clips in seconds
length_chunks = 1;

% Overlap range of the audio clips in percent
overlap = 0.75;