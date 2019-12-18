 
%------------------------------------------------
% ��ͼ
% Clist Ϊ��������
% route Ϊһ��·��
function drawTSP(Clist, route, generationValue, generationNum,isBestGeneration)
CityNum = size(Clist, 1);
for i = 1 : CityNum - 1
    plot([Clist(route(i), 1),Clist(route(i + 1), 1)], [Clist(route(i),2),Clist(route(i+1),2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
    text(Clist(route(i), 1),Clist(route(i), 2), ['  ', int2str(route(i))]);
    text(Clist(route(i+1), 1),Clist(route(i + 1), 2), ['  ', int2str(route(i+1))]);
    hold on;
end
plot([Clist(route(CityNum), 1), Clist(route(1), 1)], [Clist(route(CityNum), 2), Clist(route(1), 2)],'ms-','LineWidth',2,'MarkerEdgeColor','k','MarkerFaceColor','g');
title([num2str(CityNum),'����TSP']);
if isBestGeneration == 0 && CityNum ~= 10
    text(5, 5, ['�� ',int2str(generationNum),' ��','  ��ͷ���Ϊ ', num2str(generationValue)]);
else
    text(5, 5, ['���������������ͷ��� ',num2str(generationValue),'�� �ڵ� ',num2str(generationNum),' ���ﵽ']);
end
if CityNum == 10  % ��Ϊ������ʾλ�ò�һ�������Խ�������ĿΪ 10 ʱ������д
    if isBestGeneration == 0
        text(0, 0, ['�� ',int2str(generationNum),' ��','  ��̾���Ϊ ', num2str(generationValue)]);
    else
        text(0, 0, ['���������������ͷ��� ',num2str(generationValue),'�� �ڵ� ', num2str(generationNum),' ���ﵽ']);
    end
end
hold off;
pause(0.001);
end