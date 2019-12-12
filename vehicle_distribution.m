function [ vehicle_count ] = vehicle_distribution( all_info_data )
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
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

