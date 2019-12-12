
function judge = GaTSP(CityNum, inn, gnMax, crossProb,muteProb,unit_cost) 
% CityNum = 50; % 城市数目，可以选 10, 30, 51, 75
[dislist, Clist] = tsp(CityNum,unit_cost); % dislist 为城市之间相互的距离，Clist 为各城市的坐标
 
% inn = 30; % 初始种群大小
% gnMax = 500;  % 最大代数
% crossProb = 0.8; % 交叉概率
% muteProb = 0.8; % 变异概率
 
% 随机产生初始种群
population = zeros(inn, CityNum); % population 为初始种群，包括多条染色体
for i = 1 : inn
    population(i,:) = randperm(CityNum);
end
[~, cumulativeProbs] = calPopulationValue(population, dislist); % 计算种群每条染色体（个体）的累计概率
% cumulativeProbs 就是种群个体概率累计值的行向量
generationNum = 1;
generationMeanValue = zeros(generationNum, 1); % 每一代的平均距离
generationMaxValue = zeros(generationNum, 1);  % 每一代的最短距离
bestRoute = zeros(inn, CityNum); % 最佳路径
newPopulation = zeros(inn, CityNum); % 新的种群
while generationNum < gnMax + 1
   for j = 1 : 2 : inn      % 每隔来两个单位一循环
      selectedChromos = select(cumulativeProbs);  % 选择操作，选出两条需要交叉编译的染色体，即父亲母亲
      % 返回一个数组，里面是两个累计概率 - 随机概率   > 0 的个体的下标号
      crossedChromos = cross(population, selectedChromos, crossProb);  % 交叉操作，返回交叉后的两个染色体
      newPopulation(j, :) = mut(crossedChromos(1, :),muteProb);  % 对交叉后的染色体进行变异操作
      newPopulation(j + 1, :) = mut(crossedChromos(2, :), muteProb); % 对交叉后的染色体进行变异操作
   end
   population = newPopulation;  %产生了新的种群
   [populationValue, cumulativeProbs] = calPopulationValue(population, dislist);  % 计算新种群的适应度
   % 记录当前代最好和平均的适应度
   [fmax, nmax] = max(populationValue); % 这里是存放最大距离   fmax是最大值， nmax是最大值对应的位置
   % 因为计算适应度时取距离的倒数，这里面取最大的倒数，即最短的距离
   generationMeanValue(generationNum) = 1 / mean(populationValue);  % 记录平均距离
   generationMaxValue(generationNum) = 1 / fmax;  % 记录最短距离  
   bestChromo = population(nmax, :);  % 前代最佳染色体，即对应的路径
   bestRoute(generationNum, :) = bestChromo; % 记录每一代的最佳染色体
   drawTSP(Clist, bestChromo, generationMaxValue(generationNum), generationNum, 0);
   generationNum = generationNum + 1;
end
[bestValue,index] = min(generationMaxValue);
drawTSP(Clist, bestRoute(index, :), bestValue, index,1);
 
figure(2);
plot(generationMaxValue, 'r');  
hold on;
plot(generationMeanValue, 'b'); 
grid;
title('搜索过程');
legend('最优解', '平均解');
fprintf('遗传算法得到的最低费用: %.2f\n', bestValue);
fprintf('遗传算法得到的最佳路线');
disp(bestRoute(index, :));
judge = 1;
end

 

 

 

 

 



