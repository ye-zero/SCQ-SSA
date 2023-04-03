
clear all 
clc


SearchAgents_no=5; % Number of search agents
runTime=2;
Max_iteration=2; % Maximum numbef of iterations
Function_names=[1 2];
for j=1:2
    globalbest=ones(runTime,1);% ���� runTime��1 ȫ1�� 
    for i=1:runTime
        % Load details of the selected benchmark function
        Function_name = ['F',num2str(Function_names(j))];%[]�������ַ���
        [lb,ub,dim,fobj]=Get_Functions_details_Test(Function_name); %ub ���� lb���� dimά��
        [Best_score,Best_pos,SSA_cg_curve]=SCQSSA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
        globalbest(i,1)=Best_score;
        %������д����
        %data = {min(globalbest(:)) max(globalbest(:)) median(globalbest(:)) mean(globalbest(:)) std(globalbest(:));};
        xlswrite('D:\data\temp1.xlsx', [min(globalbest(:)) std(globalbest(:)) mean(globalbest(:)) max(globalbest(:)) median(globalbest(:))], 1, ['A',num2str(j)]);
    end
end
figure('Position',[500 500 660 290]) %�������ڲ�ָ����С��λ�ã�������ʾ�������н���

