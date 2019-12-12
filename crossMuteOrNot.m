% 根据变异或交叉概率，返回一个 0 或 1 的数
function crossProbc = crossMuteOrNot(crossMuteProb)
test(1: 100) = 0;
l = round(100 * crossMuteProb);% 取整
test(1 : l) = 1;
n = round(rand * 99) + 1;
crossProbc = test(n); % 根据交叉概率随机取一个值看看是1 还是0
end