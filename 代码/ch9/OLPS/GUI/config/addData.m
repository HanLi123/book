%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This file is part of OLPS: http://OLPS.stevenhoi.org/
% Original authors: Doyen Sahoo
% Contributors: Bin LI, Steven C.H. Hoi
% Change log: 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ ] = addData( dataFileName, dataDescriptionName, newDataFrequency, configFile )

    load(configFile);
    index = length(dataFrequency);
    index = index+1;
    dataList{index} = dataDescriptionName;
    dataName{index} = dataFileName;
    dataFrequency(index) = newDataFrequency;
    disp('Added new Dataset.');
    save(configFile, 'algorithmList', 'algorithmName', 'algorithmParameters', 'dataFrequency', 'dataList', 'dataName', 'defaultParameters', 'windowRisk');
end