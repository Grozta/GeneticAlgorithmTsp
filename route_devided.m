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

