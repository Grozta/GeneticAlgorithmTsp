%--------------------------------------------------
%��ѡ�񡱲�����������ѡ��Ⱦɫ������Ⱥ�ж�Ӧ��λ��
% cumulatedPro ����Ⱦɫ����ۼƸ���
function selectedChromoNums = select(cumulatedPro)
selectedChromoNums = zeros(2, 1);
% ����Ⱥ��ѡ���������壬��ò�Ҫ����ѡ��ͬһ������
for i = 1 : 2
   r = rand;  % ����һ�������
   prand = cumulatedPro - r;
   j = 1;
   while prand(j) < 0
       j = j + 1;
   end
   selectedChromoNums(i) = j; % ѡ�и�������
   if i == 2 && j == selectedChromoNums(i - 1)    % ����ͬ����ѡһ��
       r = rand;  % ����һ�������
       prand = cumulatedPro - r;
       j = 1;
       while prand(j) < 0
           j = j + 1;
       end
   end
end
end