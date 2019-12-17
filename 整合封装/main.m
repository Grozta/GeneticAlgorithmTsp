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


inn = 50; % ��ʼ��Ⱥ��С
gnMax = 200;  % ������
crossProb = 0.8; % �������
muteProb = 0.25; % �������
unit_cost = 2.1;% ��λ���� 



all_info_data = all_info_data_info;

cur_info = [];
% ��������
[demend_vehicle,] = vehicle_distribution(all_info_data);
count = 1;
while demend_vehicle
% ��·�滮-------
[cur_info, all_info_data] = route_devided(all_info_data); % TODO 1�����ڶԳ�������ķ���
% �����all_info_data�ǽ���ȷ��Ҫ�滮��������Ϣ�޳�����ʣ�µ���Ϣ

% �����������·���ݳ��������ƣ����ֳɶ���·�ߣ�������һ��·�ߵ���Ϣ
center_info_one_row = [center_position' 0 0];
cur_info = [center_info_one_row;cur_info];
length = size(cur_info,1);
% ·���Ż�-------
cur_best_route = GaTSP(length, inn, gnMax, crossProb, muteProb, unit_cost);
% �⺯����tsp·�߽����Ż�


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
%UNTITLED4 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

global vehicle;
global center_position;
%  ---- ����ȫ------
if isempty(vehicle)||isempty(center_position)||isempty(all_info_data)
    return;
end
%  ---- ����ȫ------
demand_count = size(all_info_data,1);
add_head_col= (1:demand_count)';
add_end_col = linspace(0,0,demand_count)';
new_all_info_data = [add_head_col, all_info_data, add_end_col add_end_col];

vehicle_capatity = vehicle(1);
vehicle(1,:) = [];
% �������������������ѡ���������򣬴Ӱ�������˳ʱ�뿪ʼѡ�������
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
% ����ģ���ʱnew_all_info_data�������������ʱ��鲼�ĳ����Ų�
[~,I] = sortrows(new_all_info_data,-4); % ������������
 head_num  = I(1);% ����һ��new_all_info_data������������Ϣ�����
 if head_num~=1
    new_all_info_data = [new_all_info_data(head_num:size(new_all_info_data,1),:); new_all_info_data(1:head_num - 1,:)];
    % ��ͷ
    % ��ţ� ���ȣ� γ�� �� �������� ����ȣ� ����ֱ������ϵ�ķ����� �� ֵ��1��2������sinֵ��3��4������cosֵ��
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


% ѡ����������
% ���Դ���
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
best_route =  bestRoute(index, :);
end
%-------------------------------------------------------------------------------------------------%
 
%------------------------------------------------
%����λ������
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
            % ��γ��ת��
        end
    end 
end

end
%------------------------------------------------------------------------------------------------------%

%------------------------------------------------
% ��������Ⱦɫ�����Ӧ��
function [chromoValues, cumulativeProbs] = calPopulationValue(s, dislist)
inn = size(s, 1);  % ��ȡ��Ⱥ��С
chromoValues = zeros(inn, 1);
for i = 1 : inn
    chromoValues(i) = CalDist(dislist, s(i, :));  % ����ÿ��Ⱦɫ�����Ӧ�ȡ�tsp���ȡ��� chromoValues��һ��������Ӧ�ȼ���
end
chromoValues = 1./chromoValues'; % ��Ϊ�þ���ԽС��ѡȡ�ĸ���Խ�ߣ�����ȡ���뵹�� [������ʱ�����������������]
% chromoValues�������Ⱥ�и����ۼӸ���
% ���ݸ������Ӧ�ȼ����䱻ѡ��ĸ���

fsum = 0;
for i = 1 : inn
    % ����15�η���ԭ�����úõĸ��屻ѡȡ�ĸ��ʸ�����Ϊ��Ӧ��ȡ����ĵ����������˴η���������໥֮�����Ӧ�Ȳ�𲻴󣩣�����һ���ϴ����Ҳ��
    fsum = fsum + chromoValues(i)^15;   
end
% ���㵥������
probs = zeros(inn, 1);
for i = 1: inn
    probs(i) = chromoValues(i)^15 / fsum;
end
% �����ۻ�����
cumulativeProbs = zeros(inn,1);
cumulativeProbs(1) = probs(1);
for i = 2 : inn
    cumulativeProbs(i) = cumulativeProbs(i - 1) + probs(i);
end
cumulativeProbs = cumulativeProbs'; % ������ת��������
end
%------------------------------------------------------------------------------------------------------%

%------------------------------------------------
%--------------------------------------------------
%��ѡ�񡱲�����������ѡ��Ⱦɫ������Ⱥ�ж�Ӧ��λ��
% cumulatedPro ����Ⱦɫ����ۼƸ���
function selectedChromoNums = select(cumulatedPro)
selectedChromoNums = zeros(2, 1);
% ����Ⱥ��ѡ���������壬��ò�Ҫ����ѡ��ͬһ������
for i = 1 : 2
   r = rand;  % ����һ�������
   prand = cumulatedPro - r;
   j = 1;
   while prand(j) < 0
       j = j + 1;
   end
   selectedChromoNums(i) = j; % ѡ�и�������
   if i == 2 && j == selectedChromoNums(i - 1)    % ����ͬ����ѡһ��
       r = rand;  % ����һ�������
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
% �����桱����
function crossedChromos = cross(population, selectedChromoNums, crossProb)
length = size(population, 2); % Ⱦɫ��ĳ���(��������)
crossProbc = crossMuteOrNot(crossProb);  %���ݽ�����ʾ����Ƿ���н��������1���ǣ�0���
crossedChromos(1,:) = population(selectedChromoNums(1), :);
crossedChromos(2,:) = population(selectedChromoNums(2), :);
if crossProbc == 1
   c1 = round(rand * (length - 2)) + 1;  %��[1,bn - 2]��Χ���������һ������λ c1
   c2 = round(rand * (length - 2)) + 1;  %��[1,bn - 2]��1��28����Χ���������һ������λ c2
   chb1 = min(c1, c2);
   chb2 = max(c1,c2);
   
   % ����Ⱦɫ�壨���壩 chb1 �� chb2 ֮�以��λ��
   middle = crossedChromos(1,chb1+1:chb2);
   crossedChromos(1,chb1 + 1 : chb2)= crossedChromos(2, chb1 + 1 : chb2);
   crossedChromos(2,chb1 + 1 : chb2)= middle;
   
   % �������Ⱦɫ�����Ƿ�����ͬ����������·�����ظ������������У������У���ñ��벻���뽻��
   for i = 1 : chb1 
       while find(crossedChromos(1,chb1 + 1: chb2) == crossedChromos(1, i))
           location = find(crossedChromos(1,chb1 + 1: chb2) == crossedChromos(1, i));
           y = crossedChromos(2,chb1 + location);
           crossedChromos(1, i) = y;
           % ��ԭ������ͬ�ı���
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
%�����족����
% choromo Ϊһ��Ⱦɫ��
function snnew = mut(chromo,muteProb)
length = size(chromo, 2); % Ⱦɫ��ĵĳ���
snnew = chromo;
muteProbm = crossMuteOrNot(muteProb);  % ���ݱ�����ʾ����Ƿ���б��������1���ǣ�0���
if muteProbm == 1
    c1 = round(rand*(length - 2)) + 1;  % �� [1, bn - 1]��Χ���������һ������λ
    c2 = round(rand*(length - 2)) + 1;  % �� [1, bn - 1]��Χ���������һ������λ
    chb1 = min(c1, c2);
    chb2 = max(c1, c2);
    x = chromo(chb1 + 1 : chb2);
    snnew(chb1 + 1 : chb2) = fliplr(x); % ���죬����������λ�õ�Ⱦɫ�嵹ת
end
end

%------------------------------------------------------------------------------------------------------%

%------------------------------------------------
 
%------------------------------------------------
% ��ͼ
% Clist Ϊ��������
% route Ϊһ��·��
function drawTSP(Clist, route, generationValue, generationNum,isBestGeneration)
CityNum = size(Clist, 1);
for i = 1 : CityNum - 1
    plot([Clist(route(i), 1),Clist(route(i + 1), 1)], [Clist(route(i),2),Clist(route(i+1),2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
    text(Clist(route(i), 1),Clist(route(i), 2), ['  ', int2str(route(i))]);
    text(Clist(route(i+1), 1),Clist(route(i + 1), 2), ['  ', int2str(route(i+1))]);
    hold on;
end
plot([Clist(route(CityNum), 1), Clist(route(1), 1)], [Clist(route(CityNum), 2), Clist(route(1), 2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
title([num2str(CityNum),'����TSP']);
if isBestGeneration == 0 && CityNum ~= 10
    text(5, 5, ['�� ',int2str(generationNum),' ��','  ��ͷ���Ϊ ', num2str(generationValue)]);
else
    text(5, 5, ['���������������ͷ��� ',num2str(generationValue),'�� �ڵ� ',num2str(generationNum),' ���ﵽ']);
end
if CityNum == 10  % ��Ϊ������ʾλ�ò�һ�������Խ�������ĿΪ 10 ʱ������д
    if isBestGeneration == 0
        text(0, 0, ['�� ',int2str(generationNum),' ��','  ��̾���Ϊ ', num2str(generationValue)]);
    else
        text(0, 0, ['���������������ͷ��� ',num2str(generationValue),'�� �ڵ� ', num2str(generationNum),' ���ﵽ']);
    end
end
hold off;
pause(0.001);
end
%------------------------------------------------------------------------------------------------------%

%------------------------------------------------
function [ lt_cost ] = LTcost( j )
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
global cur_info;
value = 2.1; %�������ӳٵ�����������
% city_pos = load('tsp_data');
data = cur_info;% city_pos.cur_info;
std_deviation = std(data,0,1);
agv = mean(data,1);
std_deviation_demand = std_deviation(3);
demand_avg = agv(3);
% ���������һ����̬�ֲ�����
N_distribution_rand = normrnd(agv(4),std_deviation(4));
lt_cost = ((demand_avg - data(j ,3))/std_deviation_demand  + (1 - N_distribution_rand) )* value;
end
%------------------------------------------------------------------------------------------------------%

%------------------------------------------------
function [ real_cost ] = real_cost(i, j, n, unit_cost )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��  
%   ���������Ҫ�ǽ�ͨ��  ���о�γ�ȣ�ת���ɵ���ֱ�����꣬�����
global cur_info;

radius = 6371.393; % ����뾶
total_1 = 0;
total_2 = 0;
% city_pos = load('tsp_data');
data = cur_info; % city_pos.cur_info;
for loop=1: n
    total_1 = total_1 + data(loop, 1);
    total_2 = total_2 + data(loop, 2);
end
comm_langitude = (total_1/n - 90)* 2.132;% ����Ŵ����ϵ��
comm_latitude = total_2/n;
one_langitude = (2*(radius*cos(comm_langitude/360* 2* pi))*pi)/360; % ����ת����
one_latitude = (2*(radius*cos(comm_latitude/360* 2* pi))*pi)/360; % γ��ת����
real_cost = (abs(data(i,1)-data(j,1))*one_langitude + abs(data(i,2)-data(j,2))*one_latitude)*unit_cost;
% �����پ���
end
%------------------------------------------------------------------------------------------------------%
 
%------------------------------------------------
% ����һ��Ⱦɫ�����Ӧ��
% dislist Ϊ���г����໥֮��ľ������
% chromo Ϊһ��Ⱦɫ�壬��һ��·��
function chromoValue = CalDist(dislist, chromo)
DistanV = 0;
n = size(chromo, 2); % Ⱦɫ��ĳ���
for i = 1 : (n - 1)
    DistanV = DistanV + dislist(chromo(i), chromo(i + 1));
end
DistanV = DistanV + dislist(chromo(n), chromo(1));
chromoValue = DistanV;
end
%------------------------------------------------------------------------------------------------------%
%------------------------------------------------
% ���ݱ���򽻲���ʣ�����һ�� 0 �� 1 ����
function crossProbc = crossMuteOrNot(crossMuteProb)
test(1: 100) = 0;
l = round(100 * crossMuteProb);% ȡ��
test(1 : l) = 1;
n = round(rand * 99) + 1;
crossProbc = test(n); % ���ݽ���������ȡһ��ֵ������1 ����0
end


