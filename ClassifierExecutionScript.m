% This script contains a collection of (almost) all scripts that have been used 
% during the the development of the classifier. Some of them turned out to be
% dead ends and can be ignored. The relevant results are marked in the form of
% marked in the form of comments.

% First tests for development
classifier_3p01;
classifier_3p02;
classifier_3p03;
classifier_3p04;

% Without augmentation
classifier_3p05;

% Examination of the augmentation with Doppler (Dead End)
classifier_3p06;
classifier_3p07;
classifier_3p08;
classifier_3p09;
classifier_3p10;

% Classifiers 3.11 - 3.40 examine simultaneous augmentation with a combination 
% of different the combination of different techniques and different parameters. 
% These investigations turned out to be less target-oriented.

% Augmentation parameters of classifiers E3p11 to 3p20
% | Classifier | maxSemiTone | maxDelay | maxAmplitude | maxNoise |
% |------------|-------------|----------|--------------|----------|
% | 3p11       | 0.72        | 0.029    | 0.69         | 0.34     |
% | 3p12       | 0.39        | 0.013    | 0.52         | 0.63     |
% | 3p13       | 0.27        | 0.026    | 0.43         | 0.72     |
% | 3p14       | 0.55        | 0.016    | 0.61         | 0.49     |
% | 3p15       | 0.68        | 0.024    | 0.74         | 0.28     |
% | 3p16       | 0.33        | 0.031    | 0.26         | 0.75     |
% | 3p17       | 0.47        | 0.019    | 0.38         | 0.51     |
% | 3p18       | 0.61        | 0.027    | 0.72         | 0.67     |
% | 3p19       | 0.75        | 0.030    | 0.56         | 0.42     |
% | 3p20       | 0.29        | 0.017    | 0.48         | 0.37     |

classifier_3p11;
classifier_3p12;
classifier_3p13;
classifier_3p14;
classifier_3p15;
classifier_3p16;
classifier_3p17;
classifier_3p18;
classifier_3p19;
classifier_3p20;

% Augmentation parameters of classifiers E3p21 to 3p30
% | Classifier | maxSemiTone | maxDelay | maxAmplitude | maxNoise |
% |------------|-------------|----------|--------------|----------|
% | 3p21       | 0.63        | 0.022    | 0.71         | 0.24     |
% | 3p22       | 0.42        | 0.015    | 0.59         | 0.32     |
% | 3p23       | 0.28        | 0.027    | 0.47         | 0.21     |
% | 3p24       | 0.52        | 0.029    | 0.38         | 0.37     |
% | 3p25       | 0.71        | 0.031    | 0.65         | 0.28     |
% | 3p26       | 0.35        | 0.019    | 0.54         | 0.36     |
% | 3p27       | 0.46        | 0.024    | 0.72         | 0.23     |
% | 3p28       | 0.59        | 0.017    | 0.61         | 0.31     |
% | 3p29       | 0.76        | 0.021    | 0.45         | 0.27     |
% | 3p30       | 0.30        | 0.030    | 0.51         | 0.34     |

classifier_3p21;
classifier_3p22;
classifier_3p23;
classifier_3p24;
classifier_3p25;
classifier_3p26;
classifier_3p27;
classifier_3p28;
classifier_3p29;
classifier_3p30;

% Augmentation parameters of classifiers E3p31 to 3p40
% | Classifier | maxSemiTone | maxDelay | maxAmplitude | maxNoise |
% |------------|-------------|----------|--------------|----------|
% | 3p31       | 0.33        | 0.015    | 0.33         | 0.25     |
% | 3p32       | 0.65        | 0.028    | 0.60         | 0.25     |
% | 3p33       | 0.54        | 0.026    | 0.75         | 0.25     |
% | 3p34       | 0.70        | 0.018    | 0.40         | 0.25     |
% | 3p35       | 0.38        | 0.021    | 0.51         | 0.25     |
% | 3p36       | 0.46        | 0.030    | 0.28         | 0.25     |
% | 3p37       | 0.60        | 0.019    | 0.70         | 0.25     |
% | 3p38       | 0.75        | 0.033    | 0.45         | 0.25     |
% | 3p39       | 0.25        | 0.014    | 0.67         | 0.25     |
% | 3p40       | 0.50        | 0.025    | 0.35         | 0.25     |

classifier_3p31;
classifier_3p32;
classifier_3p33;
classifier_3p34;
classifier_3p35;
classifier_3p36;
classifier_3p37;
classifier_3p38;
classifier_3p39;
classifier_3p40;

% The results of the simultaneous variation of several parameters showed no 
% convergence. For this reason, it was decided to first examine all augmentation 
% techniques individually in order to in order to obtain a baseline from them
% To sharpen the focus on the classification into drone classes, an additional 
% classification step was introduced an additional classification step in which 
% a distinction is first made between 'drone' and 'no drone'. Subsequently, only 
% the drone the drone data was considered.

% Augmentation by adding harmonic distortions

classifier_3p41;
classifier_3p42;
classifier_3p43;
classifier_3p44;
classifier_3p45;
classifier_3p46;
classifier_3p47;
classifier_3p48;
classifier_3p49;
classifier_3p50;

% Investigation of the influence of noise on accuracy

classifier_3p51; % (97.2 +/- 0.8) %
classifier_3p52; % (95.5 +/- 2.2) %
classifier_3p53; % (96.0 +/- 3.0) %
classifier_3p54; % (95.8 +/- 2.7) %
classifier_3p55; % (86.5 +/- 5.4) %
classifier_3p56; % (89.7 +/- 6.7) %
classifier_3p57; % (93.8 +/- 2.9) %
classifier_3p58; % (89.3 +/- 6.4) %
classifier_3p59; % (78.4 +/- 25.3) %
classifier_3p60; % (36.9 +/- 44.7) %

% Investigation of the influence of pitching on accuracy

classifier_3p61;
classifier_3p62;
classifier_3p63;
classifier_3p64;
classifier_3p65;
classifier_3p66;
classifier_3p67;
classifier_3p68;
classifier_3p69;
classifier_3p70;

% Investigation of the influence of echoes

classifier_3p71; % 15 ms / 30 %
classifier_3p72; % 15 ms / 50 %
classifier_3p73; % 15 ms / 70 %
classifier_3p74; % 15 ms / 90 %
classifier_3p75; % 18 ms / 30 %
classifier_3p76; % 18 ms / 50 %
classifier_3p77; % 18 ms / 70 %
classifier_3p78; % 18 ms / 90 %
classifier_3p79; % 21 ms / 30 %
classifier_3p80; % 21 ms / 50 %
classifier_3p81; % 21 ms / 70 %
classifier_3p82; % 21 ms / 90 %
classifier_3p83; % 24 ms / 30 %
classifier_3p84; % 24 ms / 50 %
classifier_3p85; % 24 ms / 70 %
classifier_3p86; % 24 ms / 90 %
classifier_3p87; % 27 ms / 30 %
classifier_3p88; % 27 ms / 50 %
classifier_3p89; % 27 ms / 70 %
classifier_3p90; % 27 ms / 90 %

% With the sweet spots determined from the previous investigations, from here onwards 
% again searched for the best combination of the various augmentation parameters for 
% simultaneous application. The individual parameters were randomized slightly around 
% the previously slightly around the previously determined sweet spot.

% | Class | maxPitch | maxDelay | maxAmplitude | maxNoise | distLevel |
% |-------|----------|----------|--------------|----------|-----------|
% | 3p91  | 0.102    | 0.015    | 0.318        | 0.237    | 0.112     |
% | 3p92  | 0.118    | 0.017    | 0.255        | 0.229    | 0.081     | 
% | 3p93  | 0.103    | 0.018    | 0.332        | 0.216    | 0.092     |
% | 3p94  | 0.085    | 0.021    | 0.301        | 0.221    | 0.111     |
% | 3p95  | 0.120    | 0.021    | 0.297        | 0.221    | 0.092     |
% | 3p96  | 0.104    | 0.026    | 0.857        | 0.213    | 0.097     |
% | 3p97  | 0.104    | 0.030    | 0.905        | 0.181    | 0.097     |
% | 3p98  | 0.104    | 0.027    | 0.841        | 0.240    | 0.108     |
% | 3p99  | 0.096    | 0.025    | 0.854        | 0.188    | 0.117     |

classifier_3p91;
classifier_3p92;
classifier_3p93;
classifier_3p94;
classifier_3p95;
classifier_3p96;
classifier_3p97;
classifier_3p98;
classifier_3p99;

% In the 4th generation swe classifiers, some attempts were made in the variation of 
% the architecture of the network were undertaken, which proved to be a failure and 
% were terminated prematurely. The idea was to achieve a parallelization of the 
% classification into low, medium and high frequencies.

designParallelNetwork;
classifier_4p00;

% After the failure of attempts to change the network directly, the idea arose to 
% simply split the input layer into low, medium and high frequencies. Subsequently
% the regression values should then be added together. However, this approach
% approach did not prove promising either.

classifier_4p11;
classifier_4p12;

% In the fifth generation of classifiers, it should be investigated whether a subdivision
% into binary classifiers ('drone' vs. 'no drone'; 'C0/C1' vs. 'C2/C3'; 'C0' vs. 'C1' etc.)
% can lead to a performance gain.

% Distinction between 'drone'and 'no drone' using different augmentations from the investigations
% of generation three
classifier_5p01; % 3p23
classifier_5p02; % 3p30
classifier_5p03; % 3p37
classifier_5p04; % 3p34
classifier_5p05; % 3p13
classifier_5p06; % 3p17
classifier_5p07; % 3p27
classifier_5p08; % 3p94
classifier_5p09; % 3p94

% Distinction between 'C0/C1' vs 'C2/C3' using different augmentations from the investigations
% of generation three
classifier_5p11; % 3p21
classifier_5p12; % 3p22
classifier_5p13; % 3p23
classifier_5p14; % 3p24
classifier_5p15; % 3p25
classifier_5p16; % 3p28
classifier_5p17; % 3p33
classifier_5p18; % 3p35
classifier_5p19; % 3p39

% Distinction between 'C0' vs 'C1' using different augmentations from the investigations
% of generation three
classifier_5p21; % 3p23
classifier_5p22; % 3p39
classifier_5p23; % 3p33
classifier_5p24; % 3p15
classifier_5p25; % 3p24
classifier_5p26; % 3p25
classifier_5p27; % 3p32
classifier_5p28; % 3p34
classifier_5p29; % 3p35
classifier_5p30; % 3p39

% Distinction between 'C2' vs 'C3' using different augmentations from the investigations
% of generation three
classifier_5p31; % 3p21
classifier_5p32; % 3p22
classifier_5p33; % 3p23
classifier_5p34; % 3p24
classifier_5p35; % 3p25
classifier_5p36; % 3p28
classifier_5p37; % 3p29
classifier_5p38; % 3p31
classifier_5p39; % 3p39
classifier_5p40; % 3p40

% Investigation of the performance of the cascaded classifier
confusionChartClassifierCascade;
realWorldPerormance_ClassifierCascade;

% --> The Confusion Matrix looks quite acceptable in and of itself, but the real-world 
% performance is rather poor. Although the % result does not toggle as much as with the 
% original classifiers, but the result is wrong most of the time, with a strong
% tendency to classify in C3
%
% Work carried out later on the 3rd generation revealed an error in the source code,
% through which the no drone classification was generally excluded. For this reason
% It would be interesting to continue the investigations on the fifth generation