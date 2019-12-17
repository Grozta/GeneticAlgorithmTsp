function [ real_cost ] = real_cost(i, j, n, unit_cost )
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明  
%   这个函数主要是将通过  城市经纬度，转化成地理直角坐标，求的是
global cur_info;
radius = 6371.393; % 地球半径
total_1 = 0;
total_2 = 0;

data = cur_info;
for loop=1: n
    total_1 = total_1 + data(loop, 1);
    total_2 = total_2 + data(loop, 2);
end
comm_langitude = (total_1/n - 90)* 2.132;% 椭球放大近似系数
comm_latitude = total_2/n;
one_langitude = (2*(radius*cos(comm_langitude/360* 2* pi))*pi)/360; % 经度转公里
one_latitude = (2*(radius*cos(comm_latitude/360* 2* pi))*pi)/360; % 纬度转公里
real_cost = (abs(cur_info(i,1)-cur_info(j,1))*one_langitude + abs(cur_info(i,2)-cur_info(j,2))*one_latitude)*unit_cost;
% 曼哈顿距离
end

