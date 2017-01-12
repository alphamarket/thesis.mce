clear;
clc;
close all;
%%
%Create Test 1
    subtestsize=2;beta=0.01;gamma=0.9;alpha=0.9;numberOfAgent=3;
    cooperativeLearningsize=200;IndividualLearningsize=5;
    temperature=0.4;SelectAction=0;
    test{1}.environment=@maze;
    
    test{1}.subtestsize=subtestsize;
    test{1}.group{1}.temperature=0.10;
    test{1}.group{1}.SelectAction=1;
    test{1}.group{1}.cooperativeLearningsize=cooperativeLearningsize;
    test{1}.group{1}.IndividualLearningsize=IndividualLearningsize;
    test{1}.group{1}.numberOfAgent=numberOfAgent;
    test{1}.group{1}.beta=beta;
    test{1}.group{1}.gamma=gamma;
    test{1}.group{1}.alpha=alpha;
    test{1}.group{1}.name='NewSA';
    test{1}.group{1}.type='NewSA';
    test{1}.group{1}.show='--R';
    test{1}.group{1}.micro=0.5;
    
    test{1}.group{2}.temperature=0.25;
    test{1}.group{2}.SelectAction=1;
    test{1}.group{2}.cooperativeLearningsize=cooperativeLearningsize;
    test{1}.group{2}.IndividualLearningsize=IndividualLearningsize;
    test{1}.group{2}.numberOfAgent=numberOfAgent;
    test{1}.group{2}.beta=beta;
    test{1}.group{2}.gamma=gamma;
    test{1}.group{2}.alpha=alpha;
    test{1}.group{2}.name='MCE';
    test{1}.group{2}.type='MCE';
    test{1}.group{2}.show='-b'
    test{1}.group{2}.micro=0.50;
    
%     test{1}.group{3}.temperature=0.50;
%     test{1}.group{3}.SelectAction=1;
%     test{1}.group{3}.cooperativeLearningsize=cooperativeLearningsize;
%     test{1}.group{3}.IndividualLearningsize=IndividualLearningsize;
%     test{1}.group{3}.numberOfAgent=numberOfAgent;
%     test{1}.group{3}.beta=beta;
%     test{1}.group{3}.gamma=gamma;
%     test{1}.group{3}.alpha=alpha;
%     test{1}.group{3}.name='NewSA1';
%     test{1}.group{3}.type='NewSA1';
%     test{1}.group{3}.show='--R';
%     test{1}.group{3}.micro=0.50;
%    
%     test{1}.group{4}.temperature=0.75;
%     test{1}.group{4}.SelectAction=1;
%     test{1}.group{4}.cooperativeLearningsize=cooperativeLearningsize;
%     test{1}.group{4}.IndividualLearningsize=IndividualLearningsize;
%     test{1}.group{4}.numberOfAgent=numberOfAgent;
%     test{1}.group{4}.beta=beta;
%     test{1}.group{4}.gamma=gamma;
%     test{1}.group{4}.alpha=alpha;
%     test{1}.group{4}.name='NewSA1';
%     test{1}.group{4}.type='NewSA1';
%     test{1}.group{4}.show='--R';
%     test{1}.group{4}.micro=0.50;
%    
%     test{1}.group{5}.temperature=1;
%     test{1}.group{5}.SelectAction=1;
%     test{1}.group{5}.cooperativeLearningsize=cooperativeLearningsize;
%     test{1}.group{5}.IndividualLearningsize=IndividualLearningsize;
%     test{1}.group{5}.numberOfAgent=numberOfAgent;
%     test{1}.group{5}.beta=beta;
%     test{1}.group{5}.gamma=gamma;
%     test{1}.group{5}.alpha=alpha;
%     test{1}.group{5}.name='NewSA1';
%     test{1}.group{5}.type='NewSA1';
%     test{1}.group{5}.show='--R';
%     test{1}.group{5}.micro=0.50;
    
    t=Run(test);
    
    