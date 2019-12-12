 
%------------------------------------------------
% 计算一条染色体的适应度
% dislist 为所有城市相互之间的距离矩阵
% chromo 为一条染色体，即一条路径
function chromoValue = CalDist(dislist, chromo)
DistanV = 0;
n = size(chromo, 2); % 染色体的长度
for i = 1 : (n - 1)
    DistanV = DistanV + dislist(chromo(i), chromo(i + 1));
end
DistanV = DistanV + dislist(chromo(n), chromo(1));
chromoValue = DistanV;
end