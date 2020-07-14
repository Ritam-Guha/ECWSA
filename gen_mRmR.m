function []=gen_mRmR()
% datasets = {'BreastCancer','Glass','Hill-valley_noise','Hill-valley_noiseless', 'Horse','Monk1','Monk2','Monk3','Sonar','Vowel','Wine','Zoo'};
%  datasets = {'Arrhythmia','Ionosphere','Soybean-small'};
% datasets={'BreastCancer','BreastEW','CongressEW','Exactly','Exactly2','HeartEW','Ionosphere','KrVsKpEW','Lymphography','M-of-n','PenglungEW','Sonar','SpectEW','Tic-tac-toe','Vote'}
datasets={'WaveformEW','Wine','Zoo'};
for i=1:size(datasets,2)
    fprintf('%s\n',datasets{i});
    x = importdata(strcat('Data/',datasets{i},'/',datasets{i},'_train','.mat'));
    x = x.input;
    t = importdata(strcat('Data/',datasets{i},'/',datasets{i},'_train_label','.mat'));
    t = t.input1;
      maxRelMinRed(x,t,datasets{i});
%     disp(x)
    fprintf('%s\n',datasets{i});
end
end