function [ real_cost ] = real_cost(i, j, n, unit_cost )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��  
%   ���������Ҫ�ǽ�ͨ��  ���о�γ�ȣ�ת���ɵ���ֱ�����꣬�����

radius = 6371.393; % ����뾶
total_1 = 0;
total_2 = 0;
city_pos = load('tsp_data');
data = city_pos.cur_info;
for loop=1: n
    total_1 = total_1 + data(loop, 1);
    total_2 = total_2 + data(loop, 2);
end
comm_langitude = (total_1/n - 90)* 2.132;% ����Ŵ����ϵ��
comm_latitude = total_2/n;
one_langitude = (2*(radius*cos(comm_langitude/360* 2* pi))*pi)/360; % ����ת����
one_latitude = (2*(radius*cos(comm_latitude/360* 2* pi))*pi)/360; % γ��ת����
real_cost = (abs(city_pos.cur_info(i,1)-city_pos.cur_info(j,1))*one_langitude + abs(city_pos.cur_info(i,2)-city_pos.cur_info(j,2))*one_latitude)*unit_cost;
disp(real_cost);
% �����پ���
end
