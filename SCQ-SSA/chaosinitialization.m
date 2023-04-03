% This function initialize the first population of search agents
function Positions=chaosinitialization(SearchAgents_no,dim,ub,lb)

Boundary_no= size(ub,1); % numnber of boundaries


y=rand(SearchAgents_no,dim);

y=mod(y+0.2-(0.5/(2*pi))*sin(2*pi*y),1);%circle


if Boundary_no==1
    Positions=y.*(ub-lb)+lb;
end

% If each variable has a different lb and ub
if Boundary_no>1
    for i=1:dim
        ub_i=ub(i);
        lb_i=lb(i);
        Positions(:,i)=y(:,i).*(ub_i-lb_i)+lb_i;
    end
end
