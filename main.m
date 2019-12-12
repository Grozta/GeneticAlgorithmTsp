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


% inn = 30; % 初始种群大小
% gnMax = 50;  % 最大代数
% crossProb = 0.8; % 交叉概率
% muteProb = 0.2; % 变异概率
% unit_cost = 2.1;% 单位费率 
inn = result_in.inn; % 初始种群大小
gnMax = result_in.gnMax;  % 最大代数
crossProb = result_in.crossProb; % 交叉概率
muteProb = result_in.muteProb; % 变异概率
unit_cost = result_in.unit_cost;% 单位费率 


% all_info = load('all_info_data');
% city_info = load('tsp_data');
% all_info_data = all_info.all_info_data;
all_info_data = result_in.all_info_data;
save('all_info_data','all_info_data');

% 车辆分配
[demend_vehicle,] = vehicle_distribution(all_info_data);
count = 1;
while demend_vehicle
% 线路规划-------
[cur_info, all_info_data] = route_devided(all_info_data); % TODO 1、对于对车量情况的分析
% 这个函数将线路根据车容量限制，划分成多条路线，将返回一条路线的信息
center_info_one_row = [center_position' 0 0];
cur_info = [center_info_one_row;cur_info];
save('tsp_data','cur_info');
save('all_info_data','all_info_data');
length = size(cur_info,1);
% 路径优化-------
cur_best_route = GaTSP(length, inn, gnMax, crossProb, muteProb, unit_cost);
% 这函数将tsp路线进行优化


result_out.vehicle = vehicle;
result_out.remind_all_info = all_info_data;
result_out.tsp(count).best_route = cur_best_route;
result_out.tsp(count).route_info = cur_info;

demend_vehicle = demend_vehicle - 1;
count = count + 1;
end

end
