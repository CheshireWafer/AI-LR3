%%классификация изображений с помощью CNN
%загрузка данных как ImageDatastore объект
digitDatasetPath = fullfile(matlabroot, 'toolbox', 'nnet', 'nndemos', 'nndatasets', 'DigitDataset');
imds = imageDatastore(digitDatasetPath, 'IncludeSubfolders',true, 'LabelSource','foldernames');
%отображение нескольких (20) изображений из datastore
figure
numImages = 10000;
perm = randperm(numImages, 20);
for i = 1:20
    subplot(4,5,i);
    imshow(imds.Files{perm(i)});
end
%разделение datastore на обучающую и тестовую выборки 
numTrainingFiles = 750;
[imdsTrain,imdsTest] = splitEachLabel(imds,numTrainingFiles,'randomize');
%определение архитектуры свёрточной нейронной сети
layers = [imageInputLayer([28 28 1])
    convolution2dLayer(5,20)
    reluLayer
    maxPooling2dLayer(2,'Stride',2)
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];
%установка параметров обучения
options = trainingOptions('sgdm','MaxEpochs',20,'InitialLearnRate',1e-4,'Verbose',false,'Plots','training-progress');
%обучение сети
net = trainNetwork(imdsTrain,layers,options);
%тестирование сети
YPred = classify(net,imdsTest);
YTest = imdsTest.Labels;
%определение точности классификации
accuracy = sum(YPred == YTest)/numel(YTest)

net = trainNetwork(imds,layers,options)
%net = trainNetwork(ds,layers,options)
net = trainNetwork(X,Y,layers,options)
net = trainNetwork(sequences,Y,layers,options)
net = trainNetwork(tbl, layers,options)
net = trainNetwork(tbl,responseName,layers,options)

[net,info] = trainNetwork( )