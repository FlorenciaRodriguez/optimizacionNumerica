n = 3; %Dimensión de la matriz (imagen) "u"
u = [130 78 154; 230 25 143; 65 235 115]; %Matriz u - Imagen de entrada
% Defino z -- La función "f" de entrada (ruido)
ruido =[120   210    5    8    250   235   154   123   100];
N = n^2;  
% y = Transformo "u" a vector "y"
y=reshape(u,N,1);
z0=y;
%% gradiente a paso optimal
lz=z0;
z=z0;
niter=0;niterA=0;niterAT=0;
grad=1;tic;
while norm(grad)>1e-6 && niter<1000,
    niter=niter+1;
    [f0,grad]=funcionP(z,ruido);
    d=-grad;
    aa=1;beta=0.9;sigma=0.5; 
    zn = transpose(z) + (aa*d);
    [fn,gradn]=funcionP(zn,ruido);
    niterA2=0;
    while ((fn-f0)/aa > sigma*grad'*d) & (niterA2<200)
      aa = aa*beta;
      zn = transpose(z) + aa*d;
     [fn,gradn]=funcionP(zn,ruido);
      niterA2=niterA2+1;
    end
    niterA=max(niterA,niterA2);
    niterAT=niterAT+niterA2;
    z=zn;
    z1= transpose(z);
    if (size(z,1)==size(lz,1))
        lz=[lz z];
    else
        lz=[lz z1];
    end;
    if norm(grad)<1e-6,
        break
    end
end
tt=toc;
clc;
p3=plot(lz(1,:),lz(2,:),'k');plot(lz(1,:),lz(2,:),'k.');
fprintf('%22s %10.5e %10.5e %10.5e %10.5e %5.0f %5.0f %5.0f\n','Gradiente Paso Opt.',norm(transpose(z)-y),funcionP(z,ruido),norm(grad),tt,niter,niterA,niterAT); 
