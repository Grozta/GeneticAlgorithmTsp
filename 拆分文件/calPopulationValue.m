%------------------------------------------------
% 计算所有染色体的适应度
function [chromoValues, cumulativeProbs] = calPopulationValue(s, dislist)
inn = size(s, 1);  % 读取种群大小
chromoValues = zeros(inn, 1);
for i = 1 : inn
    chromoValues(i) = CalDist(dislist, s(i, :));  % 计算每条染色体的适应度【tsp长度】， chromoValues是一个个体适应度集合
end
chromoValues = 1./chromoValues'; % 因为让距离越小，选取的概率越高，所以取距离倒数 [带逗号时让行向量变成列向量]
% chromoValues存的是种群中个体累加概率
% 根据个体的适应度计算其被选择的概率

fsum = 0;
for i = 1 : inn
    % 乘以15次方的原因是让好的个体被选取的概率更大（因为适应度取距离的倒数，若不乘次方，则个体相互之间的适应度差别不大），换成一个较大的数也行
    fsum = fsum + chromoValues(i)^15;   
end
% 计算单个概率
probs = zeros(inn, 1);
for i = 1: inn
    probs(i) = chromoValues(i)^15 / fsum;
end
% 计算累积概率
cumulativeProbs = zeros(inn,1);
cumulativeProbs(1) = probs(1);
for i = 2 : inn
    cumulativeProbs(i) = cumulativeProbs(i - 1) + probs(i);
end
cumulativeProbs = cumulativeProbs'; % 列向量转成行向量
end
