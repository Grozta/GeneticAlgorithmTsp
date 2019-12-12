function [ lt_cost ] = LTcost( j )
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
value = 2.1; %这里是延迟到货费用因子
city_pos = load('tsp_data');
data = city_pos.cur_info;
std_deviation = std(data,0,1);
agv = mean(data,1);
std_deviation_demand = std_deviation(3);
demand_avg = agv(3);
% 满意度满足一般正态分布曲线
N_distribution_rand = normrnd(agv(4),std_deviation(4));
lt_cost = ((demand_avg - data(j ,3))/std_deviation_demand  + (1 - N_distribution_rand) )* value;
end

