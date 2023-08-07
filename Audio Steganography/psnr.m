function [MSE,PSNR]=psnr(Y,Z)
input=Y; 
Embedded=Z;
[r c p]=size(Embedded);
input=double(input); 
Embedded=double(Embedded);
MSE =sum(sum((input-Embedded).^2))/(r*c);
disp(MSE);
% calculating power signal noise ratio
PSNR = 10*log10(1*1/MSE);  
disp(PSNR);
return