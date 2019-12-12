%------------------------------------------------
% ��������Ⱦɫ�����Ӧ��
function [chromoValues, cumulativeProbs] = calPopulationValue(s, dislist)
inn = size(s, 1);  % ��ȡ��Ⱥ��С
chromoValues = zeros(inn, 1);
for i = 1 : inn
    chromoValues(i) = CalDist(dislist, s(i, :));  % ����ÿ��Ⱦɫ�����Ӧ�ȡ�tsp���ȡ��� chromoValues��һ��������Ӧ�ȼ���
end
chromoValues = 1./chromoValues'; % ��Ϊ�þ���ԽС��ѡȡ�ĸ���Խ�ߣ�����ȡ���뵹�� [������ʱ�����������������]
% chromoValues�������Ⱥ�и����ۼӸ���
% ���ݸ������Ӧ�ȼ����䱻ѡ��ĸ���

fsum = 0;
for i = 1 : inn
    % ����15�η���ԭ�����úõĸ��屻ѡȡ�ĸ��ʸ�����Ϊ��Ӧ��ȡ����ĵ����������˴η���������໥֮�����Ӧ�Ȳ�𲻴󣩣�����һ���ϴ����Ҳ��
    fsum = fsum + chromoValues(i)^15;   
end
% ���㵥������
probs = zeros(inn, 1);
for i = 1: inn
    probs(i) = chromoValues(i)^15 / fsum;
end
% �����ۻ�����
cumulativeProbs = zeros(inn,1);
cumulativeProbs(1) = probs(1);
for i = 2 : inn
    cumulativeProbs(i) = cumulativeProbs(i - 1) + probs(i);
end
cumulativeProbs = cumulativeProbs'; % ������ת��������
end
