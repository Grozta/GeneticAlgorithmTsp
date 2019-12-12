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

