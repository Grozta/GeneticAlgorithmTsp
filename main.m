
clc;clear;
global vehicle; 
global center_position;
vehicle = [105 ;140];
center_position = [108.969337,34.276048]';


inn = 30; % ��ʼ��Ⱥ��С
gnMax = 50;  % ������
crossProb = 0.8; % �������
muteProb = 0.2; % �������
unit_cost = 2.1;% ��λ���� 


all_info = load('all_info_data');
city_info = load('tsp_data');
all_info_data = all_info.all_info_data;

% ��������
[demend_vehicle,] = vehicle_distribution(all_info_data);

while demend_vehicle
% ��·�滮-------
[cur_info, all_info_data] = route_devided(all_info_data); % TODO 1�����ڶԳ�������ķ���
% �����������·���ݳ��������ƣ����ֳɶ���·�ߣ�������һ��·�ߵ���Ϣ
center_info_one_row = [center_position' 0 0];
cur_info = [cur_info;center_info_one_row];
save('tsp_data','cur_info');
save('all_info_data','all_info_data');
length = size(cur_info,1);
% ·���Ż�-------
GaTSP(length, inn, gnMax, crossProb, muteProb, unit_cost);
% �⺯����tsp·�߽����Ż�
demend_vehicle = demend_vehicle - 1;
end