% C0 = birim uzunluk başına toplam maliyet
% C0 = C*Cc
% C0 = [Cc*b*d+Cs*As] = Betonarme ve donatı çeliğinin maliyetini temsil eden amaç fonksiyonu
% C = b*d + (Cs/Cc)*As
% Cs = çeliğin birim maliyeti
% Cc = betonun birim maliyeti
% Es = çelik elastik modülü
% MEd= nihai bükülme moment kapasitesi ( kendi ağırlığı dahil)
% VEd= nihai kesme kapasitesi ( kendi ağırlığı dahil)
% V(Rd,max,min) = kesme kuvvetinin tasarım değeri
% p(min,max) = çelik yüzdesi
% v1 = 0.60(1-fck/250) = boyutsuz katsayı
% z = d-0.42*d = kaldıraç kolu
% theta = beton sıkıştırma payandaları ile ana kiriş arasındaki açı
% Cs/Cc = birim maliyet oranı = 36
% w = sıkıştırılmış beton bölgesinin bağıl derinliği

fck=20; fcd=11.33; fyk=400; fyd=348;
Es=2*10^5; theta= 30; birimMaliyetOrani = 36;
MEd=500000000; VEd=100000;
pmin=13/10000; pmax=4/100;
bmin=300; bmax=900;
dmin=500; dmax=1500;
pn=15;
maxiter=2000000;
sp=0.5;
for i=1:pn
 b=bmin+(bmax-bmin)*rand;
 d=dmin+(dmax-dmin)*rand;
 p=pmin+(pmax-pmin)*rand;
 As= p*b*d;
 z = d-0.42*d;
 w = (As/(b*d))*fyd/fcd; 
 v1 = 0.60*(1-fck/250);
 VRdmax = v1*fcd*b*z/(tand(theta)+ cotd(theta));
% Eğilme momenti kısıtları
% Çelik ve betonda gerinim uyumluluğu kısıtları
% Kayma gerilmesi kısıtları
if MEd <= fcd*b*(d^2)*w*(1-0.5*w) && 0.0035*(0.8-w)/w >= fyd/Es && VEd <= VRdmax && w*(1-0.5*w)<=0.392 
    C = b*(d/0.9)*(10^-6)+ (birimMaliyetOrani)*As*(10^-6); 
else
 C=10^6;
end
OPT(1,i)=b ;
OPT(2,i)=d ;
OPT(3,i)=p ;
OPT(4,i)=C ;
end
for iter=1:maxiter
[a,t]=min(OPT(4,:));
[ab,tb]=max(OPT(4,:));
bestb=OPT(1,t);
bestd=OPT(2,t);
bestp=OPT(3,t);
if sp<rand()
for i=1:pn
    L=(1/(2*pi))*((rand)^(-1.5))*(exp(-1/(2*rand)));
     b=OPT(1,i) + L*(bestb-OPT(1,i));
     d=OPT(2,i) + L*(bestd-OPT(2,i));
     p=OPT(3,i) + L*(bestp-OPT(3,i));
 if b>bmax
 b=bmax;
 end
 if b<bmin
 b=bmin;
 end
 if d>dmax
 d=dmax;
 end
 if d<dmin
 d=dmin;
 end
 if p<pmin
 p=pmin;
 end
 if p>pmax
 p=pmax;
 end
 As= p*b*d;
 z = d-0.42*d;
 w = (As/(b*d))*fyd/fcd; 
 v1 = 0.60*(1-fck/250);
 VRdmax = v1*fcd*b*z/(tand(theta)+ cotd(theta));
% Eğilme momenti kısıtları
% Çelik ve betonda gerinim uyumluluğu kısıtları
% Kayma gerilmesi kısıtları
if MEd <= fcd*b*(d^2)*w*(1-0.5*w) && 0.0035*(0.8-w)/w >= fyd/Es && VEd <= VRdmax && w*(1-0.5*w)<=0.392
 C = b*(d/0.9)*(10^-6)+ (birimMaliyetOrani)*As*(10^-6); 
else
 C=10^6;
end
 OPT1(1,i)=b ;
 OPT1(2,i)=d ;
 OPT1(3,i)=p ;
 OPT1(4,i)=C ;
end
for i=1:pn
 if OPT(4,i)>OPT1(4,i)
 OPT(1,i)=OPT1(1,i);
 OPT(2,i)=OPT1(2,i);
 OPT(3,i)=OPT1(3,i);
 OPT(4,i)=OPT1(4,i);
 end
end
else
for i=1:pn
    v1= (ceil(rand*pn));
    v2= (ceil(rand*pn));
if OPT(4,v1)<OPT(4,v2)
        b=OPT(1,i)+rand*OPT(1,v1)-OPT(1,v2);
        d=OPT(2,i)+rand*OPT(2,v1)-OPT(2,v2);
        p=OPT(3,i)+rand*OPT(3,v1)-OPT(3,v2);
else
        b=OPT(1,i)+rand*OPT(1,v2)-OPT(1,v1);
        d=OPT(2,i)+rand*OPT(2,v2)-OPT(2,v1);
        p=OPT(3,i)+rand*OPT(3,v2)-OPT(3,v1);
end
if b>bmax
 b=bmax;
 end
 if b<bmin
 b=bmin;
 end
 if d>dmax
 d=dmax;
 end
 if d<dmin
 d=dmin;
 end
 if p<pmin
 p=pmin;
 end
 if p>pmax
 p=pmax;
 end
if MEd <= fcd*b*(d^2)*w*(1-0.5*w) && 0.0035*(0.8-w)/w >= fyd/Es && VEd <= VRdmax && w*(1-0.5*w)<=0.392
 C = b*(d/0.9)*(10^-6)+(birimMaliyetOrani)*As*(10^-6);
else
 C=10^6;
end
 OPT1(1,i)=b ;
 OPT1(2,i)=d ;
 OPT1(3,i)=p ;
 OPT1(4,i)=C ;
end
for i=1:pn
 if OPT(4,i)>OPT1(4,i)
 OPT(1,i)=OPT1(1,i);
 OPT(2,i)=OPT1(2,i);
 OPT(3,i)=OPT1(3,i);
 OPT(4,i)=OPT1(4,i);
 end
end
end
end
