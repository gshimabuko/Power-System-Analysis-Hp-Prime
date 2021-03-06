clear
clc
basemva=100;
B=[0.0218 0.0093 0.0028; 0.0093 0.0228 0.0017; 0.0028 0.0017 0.0179]/basemva;
B0=[0.0003 0.0031 0.0015];
B00=0.00030523*basemva;

cost=[200 7 0.00800; 180 6.30000 0.00900; 140 6.80000 0.00700];
mwlimits =[10 85; 10 80; 10 70];
Pdt=150;
PLT=0;
lambda(1)=8;
n=1;
Err(1)=100;
Err(2)=100;
p1lim=false;
p2lim=false;
p3lim=false;

E=[cost(1,3)/lambda(n) 0 0; 0 cost(2,3)/lambda(n) 0; 0 0 cost(3,3)/lambda(n)];
E=E+B;
D=[1-B0(1)-(cost(1,2)/lambda(n));1-B0(2)-(cost(2,2)/lambda(n));1-B0(3)-(cost(1,3)/lambda(n))]/2
Pt=E\D;

P1(1)=Pt(1);
P2(1)=Pt(2);
P3(1)=Pt(3);
K1(1)=0;
K2(1)=0;
K3(1)=0;
lambda(2)=lambda(1);
n++;
while(Err(n)>0.0000001)
  
  P1(n)=lambda(n)*(1-B0(1))-cost(1,2)-2*lambda(n)*(B(1,2)*P2(n-1)+B(1,3)*P3(n-1));
  P1(n)=P1(n)/2;
  P1(n)=P1(n)/(cost(1,3)+lambda(n)*B(1,1))
  
  K1(n)=cost(1,3)*(1-B0(1))-B(1,1)*cost(1,2)-2*cost(1,3)*(B(1,2)*P2(n-1)+B(1,3)*P3(n-1));
  K1(n)=K1(n)/2;
  K1(n)=K1(n)/((cost(1,3)+lambda(n)*B(1,1))**2);
  
  P2(n)=lambda(n)*(1-B0(2))-cost(2,2)-2*lambda(n)*(B(2,1)*P1(n)+B(2,3)*P3(n-1));
  P2(n)=P2(n)/2;
  P2(n)=P2(n)/(cost(2,3)+lambda(n)*B(2,2))
  
  K2(n)=cost(2,3)*(1-B0(2))-B(2,2)*cost(2,2)-2*cost(2,3)*(B(2,1)*P1(n)+B(2,3)*P3(n-1));
  K2(n)=K2(n)/2;
  K2(n)=K2(n)/((cost(2,3)+lambda(n)*B(2,2))**2);

  P3(n)=lambda(n)*(1-B0(3))-cost(3,2)-2*lambda(n)*(B(3,1)*P1(n)+B(3,2)*P2(n));
  P3(n)=P3(n)/2;
  P3(n)=P3(n)/(cost(3,3)+lambda(n)*B(3,3))

  K3(n)=cost(3,3)*(1-B0(3))-B(3,3)*cost(3,2)-2*cost(3,3)*(B(3,1)*P1(n)+B(3,2)*P2(n));
  K3(n)=K3(n)/2;
  K3(n)=K3(n)/((cost(3,3)+lambda(n)*B(3,3))**2);
  
  kt(n)=K1(n)+K2(n)+K3(n);
  
  PL11(n)=P1(n)*P1(n)*B(1,1);
  PL12(n)=P1(n)*P2(n)*B(1,2);
  PL13(n)=P1(n)*P3(n)*B(1,3);
  PL1(n)=PL11(n)+PL12(n)+PL13(n)+B0(1)*P1(n);
  
  PL21(n)=P2(n)*P1(n)*B(2,1);
  PL22(n)=P2(n)*P2(n)*B(2,2);
  PL23(n)=P2(n)*P3(n)*B(2,3);
  PL2(n)=PL21(n)+PL22(n)+PL23(n)+B0(2)*P2(n);
  
  PL31(n)=P3(n)*P1(n)*B(3,1);
  PL32(n)=P3(n)*P2(n)*B(3,2);
  PL33(n)=P3(n)*P3(n)*B(3,3);
  PL3(n)=PL31(n)+PL32(n)+PL33(n)+B0(3)*P3(n);
  
  PLT(n)=PL1(n)+PL2(n)+PL3(n)+B00
  
  Pg(n)=P1(n)+P2(n)+P3(n)
  deltaP(n)=PLT(n)+Pdt-(Pg(n))
  deltaLambda(n)=deltaP(n)/kt(n)
  Err(n+1)=abs(deltaP(n));
  Err(n+1)=Err(n+1)./(Pdt+PLT(n))
  lambda(n+1)=lambda(n)+deltaLambda(n);
  n++;
end

if(P1(n-1)<mwlimits(1,1))
  disp("P1 abaixo do limite inferior.")
  P1(n)=mwlimits(1,1)
  p1lim=true;
  K1(n)=0;
elseif(P1(n-1)>mwlimits(1,2))
  disp("P1 acima do limite superior.")
  P1(n)=mwlimits(1,2)
  p1lim=true;
  K1(n)=0;
endif

if(P2(n-1)<mwlimits(2,1))
  disp("P2 abaixo do limite inferior.")
  P2(n)=mwlimits(2,1)
  p2lim=true;
  K2(n)=0;
elseif(P2(n-1)>mwlimits(2,2))
  disp("P2 acima do limite superior.")
  P2(n)=mwlimits(2,2)
  p2lim=true;
  K2(n)=0;
endif

if(P3(n-1)<mwlimits(3,1))
  disp("P3 abaixo do limite inferior.")
  P3(n)=mwlimits(3,1)
  p3lim=true;
  K3(n)=0;
elseif(P3(n-1)>mwlimits(3,2))
  disp("P3 acima do limite superior.")
  P3(n)=mwlimits(3,2)
  p3lim=true;
  K3(n)=0;
endif
if ((p1lim==true)||(p2lim==true)||(p3lim==true))
  Err(n)=10
endif

while(Err(n)>0.0000006)
disp("Recalculando com Limites")
  if(p1lim==false)
    P1(n)=lambda(n)-cost(1,2);
    P1(n)=P1(n)/2;
    P1(n)=P1(n)/(cost(1,3)+lambda(n)*B(1,1))
  
    K1(n)=cost(1,3)-cost(1,2)*B(1,1);
    K1(n)=K1(n)/2;
    K1(n)=K1(n)/((cost(1,3)+lambda(n)*B(1,1))**2);
  endif
  
  if(p2lim==false)
    P2(n)=lambda(n)-cost(2,2);
    P2(n)=P2(n)/2;
    P2(n)=P2(n)/(cost(2,3)+lambda(n)*B(2,2))
  
    K2(n)=cost(2,3)-cost(2,2)*B(2,2);
    K2(n)=K2(n)/2;
    K2(n)=K2(n)/((cost(2,3)+lambda(n)*B(2,2))**2);
  endif
  
  if(p3lim==false)
    P3(n)=lambda(n)-cost(3,2);
    P3(n)=P3(n)/2;
    P3(n)=P3(n)/(cost(3,3)+lambda(n)*B(3,3))
   
    K3(n)=cost(3,3)-cost(3,3)*B(3,3);
    K3(n)=K3(n)/2;
    K3(n)=K3(n)/((cost(3,3)+lambda(n)*B(3,3))**2);
  endif
  
  
  kt(n)=K1(n)+K2(n)+K3(n);
  
  PL1(n)=B(1,1)*(P1(n))**2;
  PL2(n)=B(2,2)*(P2(n))**2;
  PL3(n)=B(3,3)*(P3(n))**2;
  
  PLT(n)=PL1(n)+PL2(n)+PL3(n)
  Pg(n)=P1(n)+P2(n)+P3(n)
  deltaP(n)=PLT(n)+Pdt-(Pg(n))
  deltaLambda(n)=deltaP(n)/kt(n)
  Err(n+1)=abs(deltaP(n));
  Err(n+1)=Err(n+1)./(Pdt+PLT(n))
  lambda(n+1)=lambda(n)+deltaLambda(n)
  n++;
end
n--;
Ct=cost(1,1)+cost(1,2)*P1(n)+cost(1,3)*P1(n)**2;
Ct=Ct+cost(1,1)+cost(2,2)*P2(n)+cost(2,3)*P2(n)**2;
Ct=Ct+cost(3,1)+cost(3,2)*P3(n)+cost(3,3)*P3(n)**2

