%------------------------------------------------
% “交叉”操作
function crossedChromos = cross(population, selectedChromoNums, crossProb)
length = size(population, 2); % 染色体的长度(个体数量)
crossProbc = crossMuteOrNot(crossProb);  %根据交叉概率决定是否进行交叉操作，1则是，0则否
crossedChromos(1,:) = population(selectedChromoNums(1), :);
crossedChromos(2,:) = population(selectedChromoNums(2), :);
if crossProbc == 1
   c1 = round(rand * (length - 2)) + 1;  %在[1,bn - 2]范围内随机产生一个交叉位 c1
   c2 = round(rand * (length - 2)) + 1;  %在[1,bn - 2]（1，28）范围内随机产生一个交叉位 c2
   chb1 = min(c1, c2);
   chb2 = max(c1,c2);
   
   % 两条染色体（个体） chb1 到 chb2 之间互换位置
   middle = crossedChromos(1,chb1+1:chb2);
   crossedChromos(1,chb1 + 1 : chb2)= crossedChromos(2, chb1 + 1 : chb2);
   crossedChromos(2,chb1 + 1 : chb2)= middle;
   
   % 看交叉后，染色体上是否有相同编码的情况（路径上重复出现两个城市）。若有，则该编码不参与交叉
   for i = 1 : chb1 
       while find(crossedChromos(1,chb1 + 1: chb2) == crossedChromos(1, i))
           location = find(crossedChromos(1,chb1 + 1: chb2) == crossedChromos(1, i));
           y = crossedChromos(2,chb1 + location);
           crossedChromos(1, i) = y;
           % 还原出现相同的编码
       end
       while find(crossedChromos(2,chb1 + 1 : chb2) == crossedChromos(2, i))
           location = find(crossedChromos(2, chb1 + 1 : chb2) == crossedChromos(2, i));
           y = crossedChromos(1, chb1 + location);
           crossedChromos(2, i) = y;
       end
   end
   for i = chb2 + 1 : length
       while find(crossedChromos(1, 1 : chb2) == crossedChromos(1, i))
           location = logical(crossedChromos(1, 1 : chb2) == crossedChromos(1, i));
           y = crossedChromos(2, location);
           crossedChromos(1, i) = y;
       end
       while find(crossedChromos(2, 1 : chb2) == crossedChromos(2, i))
           location = logical(crossedChromos(2, 1 : chb2) == crossedChromos(2, i));
           y = crossedChromos(1, location);
           crossedChromos(2, i) = y;
       end
   end
end
end