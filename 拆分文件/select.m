%--------------------------------------------------
%“选择”操作，返回所选择染色体在种群中对应的位置
% cumulatedPro 所有染色体的累计概率
function selectedChromoNums = select(cumulatedPro)
selectedChromoNums = zeros(2, 1);
% 从种群中选择两个个体，最好不要两次选择同一个个体
for i = 1 : 2
   r = rand;  % 产生一个随机数
   prand = cumulatedPro - r;
   j = 1;
   while prand(j) < 0
       j = j + 1;
   end
   selectedChromoNums(i) = j; % 选中个体的序号
   if i == 2 && j == selectedChromoNums(i - 1)    % 若相同就再选一次
       r = rand;  % 产生一个随机数
       prand = cumulatedPro - r;
       j = 1;
       while prand(j) < 0
           j = j + 1;
       end
   end
end
end