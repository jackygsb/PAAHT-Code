% -------------------------------------------------------------------------%
%%% PAAHT for L2-relaxed truncated L0 regularization model
%%%% Demo of the six deblurring benchmark experiments 
%   Written by Liangtian He; Email:  helt@ahu.edu.cn;
%   Last modified by Liangtian He, July.11, 2020
%   The updated version of our source code will be released later
clear,
clc,
clf,
addpath('../')
randn('seed',0); %  Fix random seed
if ~exist('experiment_number','var'), experiment_number=1; end
if ~exist('test_image_name','var'), test_image_name='Cameraman256.png'; end
%% IDD-BM3D test images
test_image_name           =    'cameraman256.png';
% test_image_name           =    'house.png';
% test_image_name           =    'lena512.png';
% test_image_name           =    'barbara.png';
filename=test_image_name;

fprintf('Experiment number: %d\n', experiment_number);
fprintf('Image: %s\n', filename);

%%% ------- Generating bservation ---------------------------------------------
disp('--- Generating observation ----');
y=im2double(imread(filename)); %% 
y = y(:,:,1); %% 
[yN,xN]=size(y);
%% ---------------------------------------------------------------%%
experiment_number  =   3  ;
switch experiment_number
    case 1
        noise_std=sqrt(2); 
        for x1=-7:7; for x2=-7:7; h(x1+8,x2+8)=1/(x1^2+x2^2+1); end, end; h=h./sum(h(:));
    case 2
        noise_std=sqrt(8);
        s1=0; for a1=-7:7; s1=s1+1; s2=0; for a2=-7:7; s2=s2+1; h(s1,s2)=1/(a1^2+a2^2+1); end, end;  h=h./sum(h(:));
    case 3 
        BSNR=40;
        noise_std=-1; % if "sigma=-1", then the value of sigma depends on the BSNR
        h=ones(9); h=h./sum(h(:));
    case 4
        noise_std=7;
        h=[1 4 6 4 1]'*[1 4 6 4 1]; h=h./sum(h(:));  % PSF
    case 5
        noise_std=2;
        h=fspecial('gaussian', 25, 1.6);
    case 6
       noise_std=8;
        h=fspecial('gaussian', 25, .4);
end
ker = h ; sigma = noise_std ; %% 
y_blur = imfilter(y, h, 'circular'); % performs blurring (by circular convolution)
if sigma == -1;   %% check whether to use BSNR in order to define value of sigma
    sigma = sqrt(norm(y_blur(:)-mean(y_blur(:)),2)^2 /(yN*xN*10^(BSNR/10))),     
end
sigma = sigma/255 ; 
%%%% Create a blurred and noisy observation
randn('seed',0);
z = y_blur + sigma*randn(yN, xN);

bsnr=10*log10(norm(y_blur(:)-mean(y_blur(:)),2)^2 /sigma^2/yN/xN);
psnr_z =psnr(y,z);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Observation BSNR: %4.2f, PSNR: %4.2f\n', bsnr, psnr_z);

%% IDD-BM3D deblurring inputs
%% CASE 1 :
% load IDDBM3Dcameraman256BM3Dscenario1.mat ;
% load IDDBM3Dhouse256BM3Dscenario1.mat ;
% load IDDBM3Dlena512BM3Dscenario1.mat ;
% load IDDBM3Dbarbara512BM3Dscenario1.mat ;

%% CASE 2 :
% load IDDBM3Dcameraman256BM3Dscenario2.mat ; 
% load IDDBM3Dhouse256BM3Dscenario2.mat ;
% load IDDBM3Dlena512BM3Dscenario2.mat ;
% load IDDBM3Dbarbara512BM3Dscenario2.mat ;

%% CASE 3 :
load IDDBM3Dcameraman256BM3Dscenario3.mat ; 
% load IDDBM3Dhouse256BM3Dscenario3.mat ;
% load IDDBM3Dlena512BM3Dscenario3.mat ;
% load IDDBM3Dbarbara512BM3Dscenario3.mat ;

%% CASE 4 :
% load IDDBM3Dcameraman256BM3Dscenario4.mat ; 
% load IDDBM3Dhouse256BM3Dscenario4.mat ;
% load IDDBM3Dlena512BM3Dscenario4.mat ;
% load IDDBM3Dbarbara512BM3Dscenario4.mat ;

%% CASE 5 :
% load IDDBM3Dcameraman256BM3Dscenario5.mat ; 
% load IDDBM3Dhouse256BM3Dscenario5.mat ;
% load IDDBM3Dlena512BM3Dscenario5.mat ;
% load IDDBM3Dbarbara512BM3Dscenario5.mat ;

%% CASE 6 :
% load IDDBM3Dcameraman256BM3Dscenario6.mat ; 
% load IDDBM3Dhouse256BM3Dscenario6.mat ;
% load IDDBM3Dlena512BM3Dscenario6.mat ;
% load IDDBM3Dbarbara512BM3Dscenario6.mat ;

y_hat = y_hat(:,:,1) ;

psnr_final = psnr(y,y_hat);
isnr_final = psnr_final-psnr_z;
ssim_final = ssim_index(y_hat*255,y*255);
% fsim_final = FeatureSIM(y_hat*255,y*255) ;

figure(499);imshow(y_hat,[0 1]);
title(sprintf('BM3D(Final),PSNR: %4.2fdB,SSIM: %4.4f',psnr_final,ssim_final),'fontsize',13);
disp('-------- Results --------');
fprintf('Final estimate ISNR: %4.2f, PSNR: %4.2f SSIM: %4.4f  \n', isnr_final, psnr_final, ssim_final);

img = y*255 ; sigma = sigma*255 ;  
ker = h ;
blur=@(f,k)imfilter(f,k,'circular');
og=blur(img,ker); % adding blur
g=og+sigma*randn(size(img)); % adding noise

Im0 = y_hat*255 ;  
psnr_initial = psnr(Im0/255,img/255) ; ssim_initial = ssim_index(Im0,img) ;
fprintf('Observation Initial PSNR: %4.2f SSIM: %4.4f \n', psnr_initial, ssim_initial);

psnr_blur = psnr(g/255,img/255) ; ssim_blur = ssim_index(g,img) ;
fprintf('Observation Blurring PSNR: %4.2f SSIM: %4.4f \n', psnr_blur, ssim_blur);

opts.Init= Im0 ;  
opts.I=img;
PSNR_Initial = psnr(Im0/255,img/255);  
SSIM_Initial = ssim_index(Im0,img);  
% FSIM_Initial = FeatureSIM(Im0,img) ;
disp([ 'Initial PSNR is ' num2str(PSNR_Initial),', Initial SSIM is ' num2str(SSIM_Initial) ]);

%% -----------------------Main function of PAAHT-----------------------%%
frame = 1; tol = 1e-8; Level = 1; opts.maxit = 1000 ;
switch experiment_number %% BM3D benchmark
    case 1
       lambda = 0.1 ; 
    case 2
       lambda = 0.2 ; 
    case 3
       lambda = 0.001 ; 
    case 4
       lambda = 2.0 ; 
    case 5
       lambda = 0.1 ; 
%      lambda = 0.15 ; 
    case 6
       lambda = 10.0 ; 
%      lambda = 15.0 ; 
end
% mu = lambda*5.0; %% properly tuned
mu = lambda*10.0; %% properly tuned
dk = mu*1.0; %% properly tuned
% dk = mu*5.0; %% other choices
% dk = mu*10.0; %% other choices
opts.rho = 300;
x_out = PAAHT_Deblurring(g,ker,blur,lambda,mu,dk,tol,frame,Level,img,opts);
[mssim_out ssim_map] = ssim_index(x_out,img); psnr_out = psnr(x_out/255,img/255) ;
ISNR_out = psnr_out - psnr_blur ;
fprintf('Final estimate ISNR: %4.2f, PSNR: %4.2f SSIM: %4.4f  \n', ISNR_out, psnr_out, mssim_out);

%%  Show the recovery image
figure(1); imshow(img,[]); 
title('Original image','fontsize',13) ;
figure(2); imshow(g,[]); 
title('Blurry and Noisy image','fontsize',13) ;
figure(3); imshow(x_out,[]); 
title(sprintf('Proposed,PSNR: %4.2fdB,SSIM: %4.4f, ISNR: %4.2fdB',psnr_out,mssim_out,ISNR_out),'fontsize',13);

