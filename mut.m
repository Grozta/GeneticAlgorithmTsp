%--------------------------------------------------
%�����족����
% choromo Ϊһ��Ⱦɫ��
function snnew = mut(chromo,muteProb)
length = size(chromo, 2); % Ⱦɫ��ĵĳ���
snnew = chromo;
muteProbm = crossMuteOrNot(muteProb);  % ���ݱ�����ʾ����Ƿ���б��������1���ǣ�0���
if muteProbm == 1
    c1 = round(rand*(length - 2)) + 1;  % �� [1, bn - 1]��Χ���������һ������λ
    c2 = round(rand*(length - 2)) + 1;  % �� [1, bn - 1]��Χ���������һ������λ
    chb1 = min(c1, c2);
    chb2 = max(c1, c2);
    x = chromo(chb1 + 1 : chb2);
    snnew(chb1 + 1 : chb2) = fliplr(x); % ���죬����������λ�õ�Ⱦɫ�嵹ת
end
end