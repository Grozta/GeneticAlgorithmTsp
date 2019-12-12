function result_out = main(result_in)
if isempty(result_in)
    return;
end
global vehicle; 
global center_position;
% vehicle = [105 ,140]';
% center_position = [108.969337,34.276048]';
vehicle = result_in.vehicle';

center_position = result_in.center_position';


% inn = 30; % ��ʼ��Ⱥ��С
% gnMax = 50;  % ������
% crossProb = 0.8; % �������
% muteProb = 0.2; % �������
% unit_cost = 2.1;% ��λ���� 
inn = result_in.inn; % ��ʼ��Ⱥ��С
gnMax = result_in.gnMax;  % ������
crossProb = result_in.crossProb; % �������
muteProb = result_in.muteProb; % �������
unit_cost = result_in.unit_cost;% ��λ���� 


% all_info = load('all_info_data');
% city_info = load('tsp_data');
% all_info_data = all_info.all_info_data;
all_info_data = result_in.all_info_data;
save('all_info_data','all_info_data');

% ��������
[demend_vehicle,] = vehicle_distribution(all_info_data);
count = 1;
while demend_vehicle
% ��·�滮-------
[cur_info, all_info_data] = route_devided(all_info_data); % TODO 1�����ڶԳ�������ķ���
% �����������·���ݳ��������ƣ����ֳɶ���·�ߣ�������һ��·�ߵ���Ϣ
center_info_one_row = [center_position' 0 0];
cur_info = [center_info_one_row;cur_info];
save('tsp_data','cur_info');
save('all_info_data','all_info_data');
length = size(cur_info,1);
% ·���Ż�-------
cur_best_route = GaTSP(length, inn, gnMax, crossProb, muteProb, unit_cost);
% �⺯����tsp·�߽����Ż�


result_out.vehicle = vehicle;
result_out.remind_all_info = all_info_data;
result_out.tsp(count).best_route = cur_best_route;
result_out.tsp(count).route_info = cur_info;

demend_vehicle = demend_vehicle - 1;
count = count + 1;
end

end
