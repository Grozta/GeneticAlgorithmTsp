% ���ݱ���򽻲���ʣ�����һ�� 0 �� 1 ����
function crossProbc = crossMuteOrNot(crossMuteProb)
test(1: 100) = 0;
l = round(100 * crossMuteProb);% ȡ��
test(1 : l) = 1;
n = round(rand * 99) + 1;
crossProbc = test(n); % ���ݽ���������ȡһ��ֵ������1 ����0
end