function [ lt_cost ] = LTcost( j )
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
value = 2.1; %�������ӳٵ�����������
city_pos = load('tsp_data');
data = city_pos.cur_info;
std_deviation = std(data,0,1);
agv = mean(data,1);
std_deviation_demand = std_deviation(3);
demand_avg = agv(3);
% ���������һ����̬�ֲ�����
N_distribution_rand = normrnd(agv(4),std_deviation(4));
lt_cost = ((demand_avg - data(j ,3))/std_deviation_demand  + (1 - N_distribution_rand) )* value;
end

