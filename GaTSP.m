
function judge = GaTSP(CityNum, inn, gnMax, crossProb,muteProb,unit_cost) 
% CityNum = 50; % ������Ŀ������ѡ 10, 30, 51, 75
[dislist, Clist] = tsp(CityNum,unit_cost); % dislist Ϊ����֮���໥�ľ��룬Clist Ϊ�����е�����
 
% inn = 30; % ��ʼ��Ⱥ��С
% gnMax = 500;  % ������
% crossProb = 0.8; % �������
% muteProb = 0.8; % �������
 
% ���������ʼ��Ⱥ
population = zeros(inn, CityNum); % population Ϊ��ʼ��Ⱥ����������Ⱦɫ��
for i = 1 : inn
    population(i,:) = randperm(CityNum);
end
[~, cumulativeProbs] = calPopulationValue(population, dislist); % ������Ⱥÿ��Ⱦɫ�壨���壩���ۼƸ���
% cumulativeProbs ������Ⱥ��������ۼ�ֵ��������
generationNum = 1;
generationMeanValue = zeros(generationNum, 1); % ÿһ����ƽ������
generationMaxValue = zeros(generationNum, 1);  % ÿһ������̾���
bestRoute = zeros(inn, CityNum); % ���·��
newPopulation = zeros(inn, CityNum); % �µ���Ⱥ
while generationNum < gnMax + 1
   for j = 1 : 2 : inn      % ÿ����������λһѭ��
      selectedChromos = select(cumulativeProbs);  % ѡ�������ѡ��������Ҫ��������Ⱦɫ�壬������ĸ��
      % ����һ�����飬�����������ۼƸ��� - �������   > 0 �ĸ�����±��
      crossedChromos = cross(population, selectedChromos, crossProb);  % ������������ؽ���������Ⱦɫ��
      newPopulation(j, :) = mut(crossedChromos(1, :),muteProb);  % �Խ�����Ⱦɫ����б������
      newPopulation(j + 1, :) = mut(crossedChromos(2, :), muteProb); % �Խ�����Ⱦɫ����б������
   end
   population = newPopulation;  %�������µ���Ⱥ
   [populationValue, cumulativeProbs] = calPopulationValue(population, dislist);  % ��������Ⱥ����Ӧ��
   % ��¼��ǰ����ú�ƽ������Ӧ��
   [fmax, nmax] = max(populationValue); % �����Ǵ��������   fmax�����ֵ�� nmax�����ֵ��Ӧ��λ��
   % ��Ϊ������Ӧ��ʱȡ����ĵ�����������ȡ���ĵ���������̵ľ���
   generationMeanValue(generationNum) = 1 / mean(populationValue);  % ��¼ƽ������
   generationMaxValue(generationNum) = 1 / fmax;  % ��¼��̾���  
   bestChromo = population(nmax, :);  % ǰ�����Ⱦɫ�壬����Ӧ��·��
   bestRoute(generationNum, :) = bestChromo; % ��¼ÿһ�������Ⱦɫ��
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
title('��������');
legend('���Ž�', 'ƽ����');
fprintf('�Ŵ��㷨�õ�����ͷ���: %.2f\n', bestValue);
fprintf('�Ŵ��㷨�õ������·��');
disp(bestRoute(index, :));
judge = 1;
end

 

 

 

 

 



