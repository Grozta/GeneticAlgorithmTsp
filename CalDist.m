 
%------------------------------------------------
% ����һ��Ⱦɫ�����Ӧ��
% dislist Ϊ���г����໥֮��ľ������
% chromo Ϊһ��Ⱦɫ�壬��һ��·��
function chromoValue = CalDist(dislist, chromo)
DistanV = 0;
n = size(chromo, 2); % Ⱦɫ��ĳ���
for i = 1 : (n - 1)
    DistanV = DistanV + dislist(chromo(i), chromo(i + 1));
end
DistanV = DistanV + dislist(chromo(n), chromo(1));
chromoValue = DistanV;
end