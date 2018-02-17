close all
clear all
clc
%% --------------KHOI TAO THAM SO CHO KENH TRUYEN---------------%%
N=[1 2 4 8 16];                 % so luong song mang 
L=1e3;                          % do dai duong truyen [m]
Rb=1e6*[100 155 625 1000 1250]; % toc do phat [bps]
lamda=(1e-9)*(830:10:1550);     % buoc song [m]
I=logspace(-6,-4.5,30);         % buc xa quang thu duoc [W]
IdBm=10*log10(I*1e3) ;          % buc xa quang thu duoc [dBm]
%% -------------------------------------------------------------%%
k=1.38e-23;                     % hang so Boltzmann [J/K]
h=6.625e-34;                    % hang so Planck [J.s]
q=1.602e-19;                    % dien tich cua dien tu [C]
c=3e8;                          % van toc anh sang trong chan khong [m/s]
RL=50;                          % dien tro tai cua photodIde[Om]
hslt=0.8;                       % hieu suat luong tu
T=300;                          % nhiet do tai may thu [do K]
Cn=0.8e-15;                     % tham so cau truc khuc xa [m^(-2/3)]
A=1;                            % bien do song mang
Pm=(A^2)/2;                     % Cong suat song mang
sky_irra=1e-3;                  % pho buc xa tu bau troi[W/((cm^2)um-sr)]
sun_irra=550e-4;                % pho buc xa tu mat troi [W/((cm^2)um)]
FOV=0.6;                        % do rong goc quang sat [rad]
OBP=1e-3;                       % Bang thong bo loc quang [um] 
%% -------TRONG SO VA DIEM KHONG CUA TICH PHAN GAUSS-HERMITE---------%%
w20=[2.22939364554e-13,4.39934099226e-10,1.08606937077e-7,...
     7.8025564785e-6,0.000228338636017,0.00324377334224,...
     0.0248105208875,0.10901720602,0.286675505363,0.462243669601,...
     0.46224669601,0.286675505363,0.10901720602,0.0248105208875,...
     0.00324377334224,0.000228338636017,7.8025564785e-6,...
     1.08606937077e-7,4.39934099226e-10,2.22939364554e-13];
 
x20=[-5.38748089001,-4.60368244955,-3.94476404012,-3.34785456738,...
     -2.78880605843,-2.25497400209,-1.73853771212,-1.2340762154,...
     -0.737473728545,-0.245340708301,0.245340708301,0.737473728545,...
     1.2340762154,1.73853771212,2.25497400209,2.78880605843,...
     3.34785456738,3.94476404012,4.60368244955,5.38748089001];
%% -------------------------------------------------------------------%%
Isky=sky_irra*OBP*(4/pi)*FOV^2; % buc xa bau troi
Isun=sun_irra*OBP;              % buc xa mat troi
for i1=1:length(N)                         % quet so luong song mang
  M_ind(i1)=1/(N(i1));                     % do sau dieu che
     for k1=1:length(Rb)                   % quet toc bo bit
         for m1=1:length(lamda)            % quet buoc song
            R(m1)=(hslt*q*lamda(m1))/(h*c);% he so chuyen doi quang dien [A/W]
            for n1=1:length(I)             % quet buc xa thu
                % phuong sai Rytov  
                Varl(i1,k1,m1,n1)=1.23*Cn*((2*pi/(lamda(m1)))^(7/6))*((L)^(11/6));
                % nhieu nhiet+ nhieu buc xa nen   
                Noise(i1,k1,m1,n1)=(4*k*T*Rb(k1)/RL)+2*q*Rb(k1)*R(m1)*I(n1);  
                SNR(i1,k1,m1,n1)=(Pm*((M_ind(i1)*R(m1)*I(n1))^2))/(Noise(i1,k1,m1,n1));
            end
         end
     end
end
SNR0=sqrt(SNR);
Varl0=sqrt(2.*Varl);
a=[ 1 1 1 1; 1 1 1 1; 1 1 1 1; length(N) length(Rb) length(lamda) length(I)];       
temp2=accumarray(a,[0  0 0 0]); % tao ma tran 4 chieu toan so 0
for n1=1:length(w20)
   temp1(:,:,:,:)=w20(n1).*qfunc(SNR0(:,:,:,:).*exp(Varl0(:,:,:,:).*x20(n1)-(0.5).*Varl0(:,:,:,:)));  
   temp2(:,:,:,:)=temp1(:,:,:,:)+temp2(:,:,:,:);
end
BER=temp2/sqrt(pi);     
SNRdB=10*log10(SNR);             % chuyen SNR sang dB
%% --------------------- VE DO THI --------------------------%%
%% ----------------------------------------------------------%%
%% 111 I va BER o Rb=1,25Gbps, lamda=1550nm voi su thay doi cua N
figure(1)
for i=1:length(N) 
    for n=1:length(I)
        BER1(i,n)=BER(i,5,73,n);
    end
end
semilogy(IdBm,BER1(1,:),'-ob','LineWidth',2);hold on;
semilogy(IdBm,BER1(2,:),'-c+','LineWidth',2);hold on;
semilogy(IdBm,BER1(3,:),'-*r','LineWidth',2);hold on;
semilogy(IdBm,BER1(4,:),'-sg','LineWidth',2);hold on;
semilogy(IdBm,BER1(5,:),'-dm','LineWidth',2);hold on;
grid on
axis([-30 -15 1e-10 1])
xlabel('Buc xa quang thu duoc I [dBm]');
ylabel('Ti le loi bit BER');
title('I va BER voi Rb=1,25Gbps, \lambda=1550nm');
legend('N=1','N=2','N=4','N=8','N=16')

%% 222 I va BER o N=1, lamda=1550nm voi su thay doi cua Rb
figure(2)
for k=1:length(Rb) 
    for n=1:length(I)
        BER3(k,n)=BER(1,k,73,n);
    end
end
semilogy(IdBm,BER3(1,:),'-ob','LineWidth',2);hold on;
semilogy(IdBm,BER3(2,:),'-c+','LineWidth',2);hold on;
semilogy(IdBm,BER3(3,:),'-*r','LineWidth',2);hold on;
semilogy(IdBm,BER3(4,:),'-sg','LineWidth',2);hold on;
semilogy(IdBm,BER3(5,:),'-dm','LineWidth',2);hold on;
grid on
axis([-30 -15 1e-10 1])
xlabel('Buc xa quang thu duoc I [dBm]');
ylabel('Ti le loi bit BER');
title('I va BER voi N=1, \lambda=1550nm');
legend('Rb=100Mbps','Rb=155Mbps','Rb=625Mbps','Rb=1Gbps','Rb=1,25Gbps')
%% 3333 I va BER o N=1, Rb=1.25Gbps voi su thay doi cua lamda
figure(3)
for m=1:length(lamda) 
    for n=1:length(I)
        BER4(m,n)=BER(1,5,m,n);
    end
end
semilogy(IdBm,BER4(3,:),'-ob','LineWidth',2);hold on;
semilogy(IdBm,BER4(23,:),'-c+','LineWidth',2);hold on;
semilogy(IdBm,BER4(42,:),'-*r','LineWidth',2);hold on;
semilogy(IdBm,BER4(48,:),'-sg','LineWidth',2);hold on;
semilogy(IdBm,BER4(73,:),'-dm','LineWidth',2);hold on;
grid on
axis([-30 -15 1e-10 1])
xlabel('Buc xa quang thu duoc I [dBm]');
ylabel('Ti le loi bit BER');
title('I va BER voi N=1,Rb=1,25Gbps');
legend('\lambda=850nm','\lambda=1050nm','\lambda=1240nm','\lambda=1300nm','\lambda=1550nm')
