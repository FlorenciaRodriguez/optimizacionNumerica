function [Py,gradPy]=funcionP(y,z)
lambda=0.3;%lambda>0 parametro de regularización
N=size(y,1);
n=sqrt(N);

% Matriz A
A = zeros(2,N);
for l=1:N
    if ((mod(l,n))~=0)
        if (l<=(N-n))
            A(1,l)=y(l+1)-y(l);
            A(2,l)=y(l+n)-y(l);
        else
            A(1,l)=y(l+1)-y(l);
            A(2,l)=0;
        end;
    else
        if (l<=(N-n))
            A(1,l)=0;
            A(2,l)=y(l+n)-y(l);
        else
            A(1,l)=0;
            A(2,l)=0;
        end;
    end;
end;

% Derivada de la primer componente de A_l con respecto a y_i
dA1 = zeros(N,N);
for i=1:N
    for l=1:N
        if (mod(l,n)==0)
            dA1(i,l)=0;
        else
            if (i==(l+1))
                dA1(i,l)=1;
            else
                if (i==l)
                    dA1(i,l)=-1;
                end;
            end;
        end;
        
    end;
end;

% Derivada de la segunda componente de A_l con respecto a y_i
dA2 = zeros(N,N);
for i=1:N
    for l=1:N
        if (l>N-n)
            dA2(i,l)=0;
        else
            if(i==l)
                dA2(i,l)=-1;
            else
                if(i==(l+n))
                    dA2(i,l)=1;
                end;
            end
        end;
        
    end;
end;

%Gradiente P(y)
gradPy = zeros(1,N);
for i=1:N
    acum=0;
    for l=1:N
        if (~(A(1,l)==0 && A(2,l)==0))
            acum = acum + ((dA1(i,l)+dA2(i,l))/(sqrt((A(1,l)^2)+(A(2,l)^2))));
        end;
    end;
    gradPy(i)= acum + (y(i)-z(i));
end;

%Función P(y)
acum1=0;
for i=1:N
    acum1=acum1+(y(i)-z(i))^2;
end;
acum2=0;
for i=1:N
    acum2=acum2+A(1,l)^2+A(2,l)^2;
end;
Py=sqrt(acum2) + (lambda/2)*sqrt(acum1);