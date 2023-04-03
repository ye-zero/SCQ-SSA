
%%%%%%%%%%%%%%%%%%%%
%SCQ-SSA
%%%%%%%%%%%%%%%%%%%%

function [FoodFitness,FoodPosition,Convergence_curve]=SCQSSA(N,Max_iter,lb,ub,dim,fobj)

if size(ub,1)==1 %size(X,dim)���ؾ����������������dim=1����������dim=2��������
    ub=ones(dim,1)*ub;
    lb=ones(dim,1)*lb;
end

Convergence_curve = zeros(1,Max_iter);

%Initialize the positions of salps
%initialization
%iterative
%logistic
SalpPositions=chaosinitialization(N,dim,ub,lb);

%%%%%%���������ҷ�����������ʷ���ʾ��ʽ%%%%%%
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

%����SalpFitnessֵ��С����SalpPositions�е���ΪSorted_salps
for newindex=1:N
    Sorted_salps(newindex,:)=SalpPositions(sorted_indexes(newindex),:);
end

%ѡ��ʳ�����ʵ�ʶ�λʱ���ǲ�֪��Ŀ�� (��ʳ��)��λ�ã���ˣ����׺���Ⱥ������Ӧ��ֵ ��������������λ����Ӧ�����ŵ��׺��ʵ�λ����Ϊ��ǰʳ��λ��
FoodPosition=Sorted_salps(1,:);
FoodFitness=sorted_salps_fitness(1);

%Main loop
l=2; % start from the second iteration since the first iteration was dedicated to calculating the fitness of salps
while l<Max_iter+1
    %�������� c1
    c1 = 2*exp(-(4*l/Max_iter)^2); % Eq. (3.2) in the paper
    
    for i=1:size(SalpPositions,1)
        %ת��
        SalpPositions= SalpPositions';
        %ǰһ��Ϊ�쵼��
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
                %���������ҵ�������X_new%
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
                %����X_new���¸���λ��
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
    
    %����Ǩ�㵽��Ѱ�ռ���ĸ���
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



