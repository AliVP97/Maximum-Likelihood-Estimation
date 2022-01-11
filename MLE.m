clear all
close all
clc
image=double(imread('2006F.tif'));
red=image(:,:,1);green=image(:,:,2);blue=image(:,:,3);
trainPoints=dlmread('IRSP6_2006Train.txt');
testPoints=dlmread('IRSP6_2006Test.txt');
building=find(trainPoints==1);
A1=[red(building),green(building),blue(building)];
C1=inv(cov(A1));
btr1(1,1)=mean(red(building)); btr1(1,2)=mean(green(building)); btr1(1,3)=mean(blue(building));
btr1(2,1)=std(red(building));  btr1(2,2)=std(green(building)); btr1(2,3)=std(blue(building));

road=find(trainPoints==2);
%%%%%%
rtr1=zeros(2,3);
rtr1(1,1)=mean(red(road)); rtr1(1,2)=mean(green(road)); rtr1(1,3)=mean(blue(road));
rtr1(2,1)=std(red(road));  rtr1(2,2)=std(green(road)); rtr1(2,3)=std(blue(road));
A2=[red(road),green(road),blue(road)];
C2=inv(cov(A2));
veg=find(trainPoints==3);
vtr1=zeros(2,3);
vtr1(1,1)=mean(red(veg)); vtr1(1,2)=mean(green(veg)); vtr1(1,3)=mean(blue(veg));
vtr1(2,1)=std(red(veg));  vtr1(2,2)=std(green(veg)); vtr1(2,3)=std(blue(veg));
A3=[red(veg),green(veg),blue(veg)];
C3=inv(cov(A3));
bayerD=find(trainPoints==4);
Dtr1=zeros(2,3);
Dtr1(1,1)=mean(red(bayerD)); Dtr1(1,2)=mean(green(bayerD)); Dtr1(1,3)=mean(blue(bayerD));
Dtr1(2,1)=std(red(bayerD));  Dtr1(2,2)=std(green(bayerD)); Dtr1(2,3)=std(blue(bayerD));
A4=[red(bayerD),green(bayerD),blue(bayerD)];
C4=inv(cov(A4));
bayerB=find(trainPoints==5);
Btr1=zeros(2,3);
Btr1(1,1)=mean(red(bayerB)); Btr1(1,2)=mean(green(bayerB)); Btr1(1,3)=mean(blue(bayerB));
Btr1(2,1)=std(red(bayerB));  Btr1(2,2)=std(green(bayerB)); Btr1(2,3)=std(blue(bayerB));
A5=[red(bayerB),green(bayerB),blue(bayerB)];
C5=inv(cov(A5));
A(:,:,1)=cov(A1); A(:,:,2)=cov(A2); A(:,:,3)=cov(A3);A(:,:,4)=cov(A4);A(:,:,5)=cov(A5);
c(:,:,1)=C1; c(:,:,2)=C2; c(:,:,3)=C3;c(:,:,4)=C4;c(:,:,5)=C5;
%IMG1=image;
M1=[btr1(1,1) btr1(1,2) btr1(1,3)
    rtr1(1,1) rtr1(1,2) rtr1(1,3)
    vtr1(1,1) vtr1(1,2) vtr1(1,3)
    Dtr1(1,1) Dtr1(1,2) Dtr1(1,3) 
    Btr1(1,1) Btr1(1,2) Btr1(1,3)];

%save('M1');
m0=size(image,1);
n0=size(image,2);
I=zeros(m0,n0);
clustering1=zeros(m0,n0);
 d=zeros(5,1);
 dist=zeros(3,1);
for i=1:m0
    for j=1:n0
        for k=1:5
           
            for L=1:3
                dist(L,1)=(image(i,j,L)-M1(k,L));
            end
           d(k)=log(det(A(:,:,k)))+(dist'*c(:,:,k)*dist);
        end
        [d, id]=sort(d);
        if id(1)==1
            clustering1(i,j)=1;
            I(i,j,1)=150;
            I(i,j,2)=0;
            I(i,j,3)=150;
        elseif id(1,1)==2
            clustering1(i,j)=2;
            I(i,j,1)=0;
            I(i,j,2)=1;
            I(i,j,3)=1;
        elseif id(1,1)==3
            clustering1(i,j)=3;
            I(i,j,1)=0;
            I(i,j,2)=1;
            I(i,j,3)=0;
        elseif id(1)==4
           clustering1(i,j)=4;
            I(i,j,1)=1;
            I(i,j,2)=0;
            I(i,j,3)=0;
        else
            clustering1(i,j)=5;
            I(i,j,1)=0;
            I(i,j,2)=0;
            I(i,j,3)=1;
        end
    end
end
% f=figure;
% set(f,'name','Image1 classification','numbertitle','off');
% imshow(I(:,:,1:3));
build1=find(testPoints==1);build2=clustering1(build1);
road1=find(testPoints==2); road2=clustering1(road1);
veg1=find(testPoints==3); veg2=clustering1(veg1); 
bayerD1=find(testPoints==4); bayerD2=clustering1(bayerD1);
bayerB1=find(testPoints==5); bayerB2=clustering1(bayerB1);
t=zeros(6,6); 
for i=1:5
t(1,i)=length(find(build2==i));
end
t(1,6)=sum(t(1,1:5));
for i=1:5
t(2,i)=length(find(road2==i));
end
t(2,6)=sum(t(2,1:5));
for i=1:5
t(3,i)=length(find(veg2==i));
end
t(3,6)=sum(t(3,1:5));
for i=1:5
t(4,i)=length(find(bayerD2==i));
end
t(4,6)=sum(t(4,1:5));
for i=1:5
t(5,i)=length(find(bayerB2==i));
end
t(5,6)=sum(t(5,1:5));
t(6,1)=sum(t(1:5,1));t(6,2)=sum(t(1:5,2));t(6,3)=sum(t(1:5,3));t(6,4)=sum(t(1:5,4));
t(6,5)=sum(t(1:5,5));t(6,6)=sum(t(1:5,6));

q=t(1,1)+t(2,2)+t(3,3)+t(4,4)+t(5,5);
overalacc=(q/t(6,6))*100;
T1=t(1,6)*t(6,1); T2=t(2,6)*t(6,2);T3=t(3,6)*t(6,3);
T4=t(4,6)*t(6,4);T5=t(5,6)*t(6,5); T=T1+T2+T3+T4+T5; N=t(6,6)
kappaacc=(((t(6,6)*(q))-T)/((N^2)-T))*100;