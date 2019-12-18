 
%------------------------------------------------
% 画图
% Clist 为城市坐标
% route 为一条路径
function drawTSP(Clist, route, generationValue, generationNum,isBestGeneration)
CityNum = size(Clist, 1);
for i = 1 : CityNum - 1
    plot([Clist(route(i), 1),Clist(route(i + 1), 1)], [Clist(route(i),2),Clist(route(i+1),2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
    text(Clist(route(i), 1),Clist(route(i), 2), ['  ', int2str(route(i))]);
    text(Clist(route(i+1), 1),Clist(route(i + 1), 2), ['  ', int2str(route(i+1))]);
    hold on;
end
plot([Clist(route(CityNum), 1), Clist(route(1), 1)], [Clist(route(CityNum), 2), Clist(route(1), 2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
title([num2str(CityNum),'城市TSP']);
if isBestGeneration == 0 && CityNum ~= 10
    text(5, 5, ['第 ',int2str(generationNum),' 代','  最低费用为 ', num2str(generationValue)]);
else
    text(5, 5, ['最终搜索结果：最低费用 ',num2str(generationValue),'， 在第 ',num2str(generationNum),' 代达到']);
end
if CityNum == 10  % 因为文字显示位置不一样，所以将城市数目为 10 时单独编写
    if isBestGeneration == 0
        text(0, 0, ['第 ',int2str(generationNum),' 代','  最短距离为 ', num2str(generationValue)]);
    else
        text(0, 0, ['最终搜索结果：最低费用 ',num2str(generationValue),'， 在第 ', num2str(generationNum),' 代达到']);
    end
end
hold off;
pause(0.001);
end