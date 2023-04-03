
%%%%%%%%%%%%%%%%%%%%
%SCQ-SSA
%%%%%%%%%%%%%%%%%%%%

function [FoodFitness,FoodPosition,Convergence_curve]=SCQSSA(N,Max_iter,lb,ub,dim,fobj)

if size(ub,1)==1 %size(X,dim)返回矩阵的行数或列数，dim=1返回行数，dim=2返回列数
    ub=ones(dim,1)*ub;
    lb=ones(dim,1)*lb;
end

Convergence_curve = zeros(1,Max_iter);

%Initialize the positions of salps
%initialization
%iterative
%logistic
SalpPositions=chaosinitialization(N,dim,ub,lb);

%%%%%%量子正余弦方法，个体概率幅表示方式%%%%%%
for i=1:N
    for j=1:dim
        r=rand();
        popu(1,j,i)=r;
        popu(2,j,i)=(1-r*r)^0.5;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FoodPosition=zeros(1,dim);
FoodFitness=inf;


%calculate the fitness of initial salps

for i=1:size(SalpPositions,1)
    SalpFitness(1,i)=fobj(SalpPositions(i,:));
end

[sorted_salps_fitness,sorted_indexes]=sort(SalpFitness);

%按照SalpFitness值从小到大将SalpPositions行调整为Sorted_salps
for newindex=1:N
    Sorted_salps(newindex,:)=SalpPositions(sorted_indexes(newindex),:);
end

%选定食物。由于实际定位时我们不知道目标 (即食物)的位置，因此，将樽海鞘群按照适应度值 进行排序，排在首位的适应度最优的樽海鞘的位置设为当前食物位置
FoodPosition=Sorted_salps(1,:);
FoodFitness=sorted_salps_fitness(1);

%Main loop
l=2; % start from the second iteration since the first iteration was dedicated to calculating the fitness of salps
while l<Max_iter+1
    %收敛因子 c1
    c1 = 2*exp(-(4*l/Max_iter)^2); % Eq. (3.2) in the paper
    
    for i=1:size(SalpPositions,1)
        %转置
        SalpPositions= SalpPositions';
        %前一半为领导者
        if i<=N/2
            for j=1:1:dim
                c2=rand();
                c3=rand();
                %%%%%%%%%%%%% % Eq. (3.1) in the paper %%%%%%%%%%%%%%
                if c3<0.5 
                    SalpPositions(j,i)=FoodPosition(j)+c1*((ub(j)-lb(j))*c2+lb(j));
                else
                    SalpPositions(j,i)=FoodPosition(j)-c1*((ub(j)-lb(j))*c2+lb(j));
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%  
                %计算正余弦的相移量X_new%
                a=2;
                r1=a-a*l/Max_iter;
                r2=rand(1)*2*pi;
                r3=rand(1)*2;
                r4=rand(1);
                r=0.5;
                x1=FoodPosition(j);
                if r4<r
                    X_new=r1*sin(r2)*abs(r3.*x1-SalpPositions(j,i));
                end
                if r4>=r
                    X_new=r1*cos(r2)*abs(r3.*x1-SalpPositions(j,i));
                end
                %根据X_new更新个体位置
                popu(1,j,i)=popu(1,j,i)*cos(X_new)-popu(2,j,i)*sin(X_new);
                popu(2,j,i)=popu(1,j,i)*sin(X_new)+popu(2,j,i)*cos(X_new);
                c4=rand();
                if(c4<0.5)
                    SalpPositions(j,i)=popu(1,j,i)^2*((ub(j)-lb(j))+lb(j));
                else
                    SalpPositions(j,i)=popu(2,j,i)^2*((ub(j)-lb(j))+lb(j));
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%
            end
        elseif i>N/2 && i<N+1
            point1=SalpPositions(:,i-1);
            point2=SalpPositions(:,i);
            SalpPositions(:,i)=(point2+point1)/2; % % Eq. (3.4) in the paper
        end  
        SalpPositions= SalpPositions';
    end
    
    %计算迁徙到搜寻空间外的个体
    for i=1:size(SalpPositions,1)
        
        Tp=SalpPositions(i,:)>ub';
        Tm=SalpPositions(i,:)<lb';
        SalpPositions(i,:)=(SalpPositions(i,:).*(~(Tp+Tm)))+ub'.*Tp+lb'.*Tm;
        
        SalpFitness(1,i)=fobj(SalpPositions(i,:));
        
        if SalpFitness(1,i)<FoodFitness
            FoodPosition=SalpPositions(i,:);
            FoodFitness=SalpFitness(1,i);
            
        end
    end
    
    Convergence_curve(l)=FoodFitness;
    l = l + 1;
end



