
clear all 
clc


SearchAgents_no=5; % Number of search agents
runTime=2;
Max_iteration=2; % Maximum numbef of iterations
Function_names=[1 2];
for j=1:2
    globalbest=ones(runTime,1);% 生成 runTime×1 全1阵 
    for i=1:runTime
        % Load details of the selected benchmark function
        Function_name = ['F',num2str(Function_names(j))];%[]来连接字符串
        [lb,ub,dim,fobj]=Get_Functions_details_Test(Function_name); %ub 上限 lb下限 dim维度
        [Best_score,Best_pos,SSA_cg_curve]=SCQSSA(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
        globalbest(i,1)=Best_score;
        %将数据写入表格
        %data = {min(globalbest(:)) max(globalbest(:)) median(globalbest(:)) mean(globalbest(:)) std(globalbest(:));};
        xlswrite('D:\data\temp1.xlsx', [min(globalbest(:)) std(globalbest(:)) mean(globalbest(:)) max(globalbest(:)) median(globalbest(:))], 1, ['A',num2str(j)]);
    end
end
figure('Position',[500 500 660 290]) %创建窗口并指定大小和位置，用来提示代码运行结束

