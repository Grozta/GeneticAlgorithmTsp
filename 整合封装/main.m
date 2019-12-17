function result_out = main(vehicle_info,center_position_info, all_info_data_info)
% if vehicle_info||center_position_info||all_info_data_info
%     return;
% end
global vehicle; 
global center_position;
global all_info_data;
global cur_info;
% vehicle = [105 ,140]';
% center_position = [108.969337,34.276048]';
vehicle = vehicle_info';

center_position = center_position_info';


inn = 50; % 初始种群大小
gnMax = 200;  % 最大代数
crossProb = 0.8; % 交叉概率
muteProb = 0.25; % 变异概率
unit_cost = 2.1;% 单位费率 



all_info_data = all_info_data_info;

cur_info = [];
% 车辆分配
[demend_vehicle,] = vehicle_distribution(all_info_data);
count = 1;
while demend_vehicle
% 线路规划-------
[cur_info, all_info_data] = route_devided(all_info_data); % TODO 1、对于对车量情况的分析
% 这里的all_info_data是将已确认要规划的需求信息剔除掉，剩下的信息

% 这个函数将线路根据车容量限制，划分成多条路线，将返回一条路线的信息
center_info_one_row = [center_position' 0 0];
cur_info = [center_info_one_row;cur_info];
length = size(cur_info,1);
% 路径优化-------
cur_best_route = GaTSP(length, inn, gnMax, crossProb, muteProb, unit_cost);
% 这函数将tsp路线进行优化


% result_out.vehicle = vehicle;% [223,435]
% result_out.remind_all_info = all_info_data;
result_out.tsp(count).best_route = cur_best_route;
result_out.tsp(count).route_info = cur_info;

demend_vehicle = demend_vehicle - 1;
count = count + 1;
end
res_vehicle = vehicle;
remind_all_info = all_info_data;

end
%-------------------------------------------------------------------------------------------------%
function [ vehicle_count ] = vehicle_distribution( all_info_data )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
global vehicle;
vehicle_count = 0;
if isempty(all_info_data)
    return ;
end
demand_count = size(all_info_data,1);
total_demend = 0;

for loop =1 : demand_count
total_demend = all_info_data(loop,3) + total_demend;
end
loop = 1;
while true
    if total_demend - vehicle(loop) >= 0
        vehicle_count = vehicle_count + 1;
        total_demend = total_demend - vehicle(loop);
        loop = loop + 1;
        if loop > size(vehicle,1)
            return ;
        end
    else
        break;
    end
end
if total_demend ~= 0
    vehicle_count = vehicle_count + 1;
end

end

%-------------------------------------------------------------------------------------------------%
function [ cur_info,remain_info] = route_devided( all_info_data )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明

global vehicle;
global center_position;
%  ---- 不安全------
if isempty(vehicle)||isempty(center_position)||isempty(all_info_data)
    return;
end
%  ---- 不安全------
demand_count = size(all_info_data,1);
add_head_col= (1:demand_count)';
add_end_col = linspace(0,0,demand_count)';
new_all_info_data = [add_head_col, all_info_data, add_end_col add_end_col];

vehicle_capatity = vehicle(1);
vehicle(1,:) = [];
% 这里采用重力垂降法，选出凹坑区域，从凹坑区域顺时针开始选择需求点
for i = 1:demand_count
    if new_all_info_data(i,2)-center_position(1)>=0 && new_all_info_data(i,3)-center_position(2)>=0
        new_all_info_data(i,6) = 1;
        new_all_info_data(i,7) = sin_Angle(new_all_info_data(i,2)-center_position(1), new_all_info_data(i,3)-center_position(2));% sin = y/a
    end
    if new_all_info_data(i,2)-center_position(1)<=0 && new_all_info_data(i,3)-center_position(2)>=0
        new_all_info_data(i,6) = 2;
        new_all_info_data(i,7) = 2-sin_Angle(new_all_info_data(i,2)-center_position(1), new_all_info_data(i,3)-center_position(2));% sin = y/a
    end
    if new_all_info_data(i,2)-center_position(1)<=0 && new_all_info_data(i,3)-center_position(2)<=0
        new_all_info_data(i,6) = 3;
        new_all_info_data(i,7) = 3 + cos_Angle(new_all_info_data(i,2)-center_position(1), new_all_info_data(i,3)-center_position(2));% cos = x/a
    end
    if new_all_info_data(i,2)-center_position(1)>=0 && new_all_info_data(i,3)-center_position(2)<=0
        new_all_info_data(i,6) = 4;
        new_all_info_data(i,7) = 4 + cos_Angle(new_all_info_data(i,2)-center_position(1), new_all_info_data(i,3)-center_position(2));% cos = x/a 
    end
end
[new_all_info_data,]=sortrows(new_all_info_data,7);
% 上面的，此时new_all_info_data矩阵就是排序逆时针遍布的城市排布
[~,I] = sortrows(new_all_info_data,-4); % 按需求量逆序
 head_num  = I(1);% 返回一个new_all_info_data中需求最大的信息行序号
 if head_num~=1
    new_all_info_data = [new_all_info_data(head_num:size(new_all_info_data,1),:); new_all_info_data(1:head_num - 1,:)];
    % 表头
    % 序号， 经度， 纬度 ， 需求量， 满意度， 区域（直角坐标系的分区） ， 值（1，2区域是sin值，3，4区域是cos值）
 end
 flag = 1;
 while true
     if flag <= size(new_all_info_data, 1) && vehicle_capatity - new_all_info_data(flag, 4)>= 0   
         vehicle_capatity = vehicle_capatity - new_all_info_data(flag, 4);
         flag  = flag +1;
         if flag > size(new_all_info_data, 1)
             break;
         end
     else
         break;
     end
 end
 
cur_info = new_all_info_data(1:flag -1,2:5);
remain_info = new_all_info_data(flag:size(new_all_info_data,1),2:5);


% 选择需求重心
% 测试代码
% x = new_all_info_data(:,2) -center_position(1);
% y = new_all_info_data(:,3)-center_position(2);
% figuer(7);
% scatter(x,  y ,'r.');
% disp(new_all_info_data);

end


function  cos_angle = cos_Angle(x, y)       
        cos_angle = x/(sqrt(x^2 + y^2)); 
end
function  sin_angle = sin_Angle(x, y)       
        sin_angle = y/(sqrt(x^2 + y^2)); 
end
%-------------------------------------------------------------------------------------------------%

function best_route = GaTSP(CityNum, inn, gnMax, crossProb,muteProb,unit_cost) 
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
best_route =  bestRoute(index, :);
end
%-------------------------------------------------------------------------------------------------%
 
%------------------------------------------------
%城市位置坐标
function [DLn, cityn] = tsp(n,unit_cost)
global cur_info;
DLn = zeros(n, n);

if n == 99999
    city75 = [48 21;52 26;55 50;50 50;41 46;51 42;55 45;38 33;33 34;45 35;40 37;50 30;
        55 34;54 38;26 13;15 5;21 48;29 39;33 44;15 19;16 19;12 17;50 40;22 53;21 36;
        20 30;26 29;40 20;36 26;62 48;67 41;62 35;65 27;62 24;55 20;35 51;30 50;
        45 42;21 45;36 6;6 25;11 28;26 59;30 60;22 22;27 24;30 20;35 16;54 10;50 15;
        44 13;35 60;40 60;40 66;31 76;47 66;50 70;57 72;55 65;2 38;7 43;9 56;15 56;
        10 70;17 64;55 57;62 57;70 64;64 4;59 5;50 4;60 15;66 14;66 8;43 26]; % 75 cities d'=549.18 by D B Fogel
    for i = 1 : 75
        for j = 1 : 75
            DLn(i,j) = ((city75(i,1)-city75(j,1))^2 + (city75(i,2)-city75(j,2))^2)^0.5;
        end
    end
    cityn = city75;
else
    % city_pos = load('tsp_data');
     
    
   
    cityn = cur_info;
    for i = 1 : n
        for j = 1 : n
            %DLn(i,j) = abs(city_pos.data(i,1)-city_pos.data(j,1))*141490 + abs(city_pos.data(i,2)-city_pos.data(j,2))*110000;
            % DLn(i,j) = real_cost(i ,j, n)*10 + LTcost(j);
            DLn(i,j) = real_cost(i ,j, n,unit_cost) + LTcost(j);
            % 经纬度转换
        end
    end 
end

end
%------------------------------------------------------------------------------------------------------%

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
%------------------------------------------------------------------------------------------------------%

%------------------------------------------------
%--------------------------------------------------
%“选择”操作，返回所选择染色体在种群中对应的位置
% cumulatedPro 所有染色体的累计概率
function selectedChromoNums = select(cumulatedPro)
selectedChromoNums = zeros(2, 1);
% 从种群中选择两个个体，最好不要两次选择同一个个体
for i = 1 : 2
   r = rand;  % 产生一个随机数
   prand = cumulatedPro - r;
   j = 1;
   while prand(j) < 0
       j = j + 1;
   end
   selectedChromoNums(i) = j; % 选中个体的序号
   if i == 2 && j == selectedChromoNums(i - 1)    % 若相同就再选一次
       r = rand;  % 产生一个随机数
       prand = cumulatedPro - r;
       j = 1;
       while prand(j) < 0
           j = j + 1;
       end
   end
end
end

%------------------------------------------------------------------------------------------------------%

%------------------------------------------------

%------------------------------------------------
% “交叉”操作
function crossedChromos = cross(population, selectedChromoNums, crossProb)
length = size(population, 2); % 染色体的长度(个体数量)
crossProbc = crossMuteOrNot(crossProb);  %根据交叉概率决定是否进行交叉操作，1则是，0则否
crossedChromos(1,:) = population(selectedChromoNums(1), :);
crossedChromos(2,:) = population(selectedChromoNums(2), :);
if crossProbc == 1
   c1 = round(rand * (length - 2)) + 1;  %在[1,bn - 2]范围内随机产生一个交叉位 c1
   c2 = round(rand * (length - 2)) + 1;  %在[1,bn - 2]（1，28）范围内随机产生一个交叉位 c2
   chb1 = min(c1, c2);
   chb2 = max(c1,c2);
   
   % 两条染色体（个体） chb1 到 chb2 之间互换位置
   middle = crossedChromos(1,chb1+1:chb2);
   crossedChromos(1,chb1 + 1 : chb2)= crossedChromos(2, chb1 + 1 : chb2);
   crossedChromos(2,chb1 + 1 : chb2)= middle;
   
   % 看交叉后，染色体上是否有相同编码的情况（路径上重复出现两个城市）。若有，则该编码不参与交叉
   for i = 1 : chb1 
       while find(crossedChromos(1,chb1 + 1: chb2) == crossedChromos(1, i))
           location = find(crossedChromos(1,chb1 + 1: chb2) == crossedChromos(1, i));
           y = crossedChromos(2,chb1 + location);
           crossedChromos(1, i) = y;
           % 还原出现相同的编码
       end
       while find(crossedChromos(2,chb1 + 1 : chb2) == crossedChromos(2, i))
           location = find(crossedChromos(2, chb1 + 1 : chb2) == crossedChromos(2, i));
           y = crossedChromos(1, chb1 + location);
           crossedChromos(2, i) = y;
       end
   end
   for i = chb2 + 1 : length
       while find(crossedChromos(1, 1 : chb2) == crossedChromos(1, i))
           location = logical(crossedChromos(1, 1 : chb2) == crossedChromos(1, i));
           y = crossedChromos(2, location);
           crossedChromos(1, i) = y;
       end
       while find(crossedChromos(2, 1 : chb2) == crossedChromos(2, i))
           location = logical(crossedChromos(2, 1 : chb2) == crossedChromos(2, i));
           y = crossedChromos(1, location);
           crossedChromos(2, i) = y;
       end
   end
end
end


%------------------------------------------------------------------------------------------------------%

%------------------------------------------------
%--------------------------------------------------
%“变异”操作
% choromo 为一条染色体
function snnew = mut(chromo,muteProb)
length = size(chromo, 2); % 染色体的的长度
snnew = chromo;
muteProbm = crossMuteOrNot(muteProb);  % 根据变异概率决定是否进行变异操作，1则是，0则否
if muteProbm == 1
    c1 = round(rand*(length - 2)) + 1;  % 在 [1, bn - 1]范围内随机产生一个变异位
    c2 = round(rand*(length - 2)) + 1;  % 在 [1, bn - 1]范围内随机产生一个变异位
    chb1 = min(c1, c2);
    chb2 = max(c1, c2);
    x = chromo(chb1 + 1 : chb2);
    snnew(chb1 + 1 : chb2) = fliplr(x); % 变异，则将两个变异位置的染色体倒转
end
end

%------------------------------------------------------------------------------------------------------%

%------------------------------------------------
 
%------------------------------------------------
% 画图
% Clist 为城市坐标
% route 为一条路径
function drawTSP(Clist, route, generationValue, generationNum,isBestGeneration)
CityNum = size(Clist, 1);
for i = 1 : CityNum - 1
    plot([Clist(route(i), 1),Clist(route(i + 1), 1)], [Clist(route(i),2),Clist(route(i+1),2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
    text(Clist(route(i), 1),Clist(route(i), 2), ['  ', int2str(route(i))]);
    text(Clist(route(i+1), 1),Clist(route(i + 1), 2), ['  ', int2str(route(i+1))]);
    hold on;
end
plot([Clist(route(CityNum), 1), Clist(route(1), 1)], [Clist(route(CityNum), 2), Clist(route(1), 2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
title([num2str(CityNum),'城市TSP']);
if isBestGeneration == 0 && CityNum ~= 10
    text(5, 5, ['第 ',int2str(generationNum),' 代','  最低费用为 ', num2str(generationValue)]);
else
    text(5, 5, ['最终搜索结果：最低费用 ',num2str(generationValue),'， 在第 ',num2str(generationNum),' 代达到']);
end
if CityNum == 10  % 因为文字显示位置不一样，所以将城市数目为 10 时单独编写
    if isBestGeneration == 0
        text(0, 0, ['第 ',int2str(generationNum),' 代','  最短距离为 ', num2str(generationValue)]);
    else
        text(0, 0, ['最终搜索结果：最低费用 ',num2str(generationValue),'， 在第 ', num2str(generationNum),' 代达到']);
    end
end
hold off;
pause(0.001);
end
%------------------------------------------------------------------------------------------------------%

%------------------------------------------------
function [ lt_cost ] = LTcost( j )
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
global cur_info;
value = 2.1; %这里是延迟到货费用因子
% city_pos = load('tsp_data');
data = cur_info;% city_pos.cur_info;
std_deviation = std(data,0,1);
agv = mean(data,1);
std_deviation_demand = std_deviation(3);
demand_avg = agv(3);
% 满意度满足一般正态分布曲线
N_distribution_rand = normrnd(agv(4),std_deviation(4));
lt_cost = ((demand_avg - data(j ,3))/std_deviation_demand  + (1 - N_distribution_rand) )* value;
end
%------------------------------------------------------------------------------------------------------%

%------------------------------------------------
function [ real_cost ] = real_cost(i, j, n, unit_cost )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明  
%   这个函数主要是将通过  城市经纬度，转化成地理直角坐标，求的是
global cur_info;

radius = 6371.393; % 地球半径
total_1 = 0;
total_2 = 0;
% city_pos = load('tsp_data');
data = cur_info; % city_pos.cur_info;
for loop=1: n
    total_1 = total_1 + data(loop, 1);
    total_2 = total_2 + data(loop, 2);
end
comm_langitude = (total_1/n - 90)* 2.132;% 椭球放大近似系数
comm_latitude = total_2/n;
one_langitude = (2*(radius*cos(comm_langitude/360* 2* pi))*pi)/360; % 经度转公里
one_latitude = (2*(radius*cos(comm_latitude/360* 2* pi))*pi)/360; % 纬度转公里
real_cost = (abs(data(i,1)-data(j,1))*one_langitude + abs(data(i,2)-data(j,2))*one_latitude)*unit_cost;
% 曼哈顿距离
end
%------------------------------------------------------------------------------------------------------%
 
%------------------------------------------------
% 计算一条染色体的适应度
% dislist 为所有城市相互之间的距离矩阵
% chromo 为一条染色体，即一条路径
function chromoValue = CalDist(dislist, chromo)
DistanV = 0;
n = size(chromo, 2); % 染色体的长度
for i = 1 : (n - 1)
    DistanV = DistanV + dislist(chromo(i), chromo(i + 1));
end
DistanV = DistanV + dislist(chromo(n), chromo(1));
chromoValue = DistanV;
end
%------------------------------------------------------------------------------------------------------%
%------------------------------------------------
% 根据变异或交叉概率，返回一个 0 或 1 的数
function crossProbc = crossMuteOrNot(crossMuteProb)
test(1: 100) = 0;
l = round(100 * crossMuteProb);% 取整
test(1 : l) = 1;
n = round(rand * 99) + 1;
crossProbc = test(n); % 根据交叉概率随机取一个值看看是1 还是0
end


