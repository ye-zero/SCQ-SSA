

function [lb,ub,dim,fobj] = Get_Functions_details_Test(F)


switch F
    case 'F1'
        fobj = @F1;
        lb=-100;
        ub=100;
        dim=1000;
        
    case 'F2'
        fobj = @F2;
        lb=-10;
        ub=10;
        dim=1000;
        

end

end

% F1

function o = F1(x)
o=sum(x.^2);
end

% F2

function o = F2(x)
o=sum(abs(x))+prod(abs(x));
end

