function x_out = PAAHT_Deblurring(f,ker,blur,lambda,mu,dk,tol,frame,Level,oimg,opts)
[D,R]=GenerateFrameletFilter(frame);nD=length(D);
W  = @(x) FraDecMultiLevel(x,D,Level); % Frame decomposition
WT = @(x) FraRecMultiLevel(x,R,Level); % Frame reconstruction
[m,n]=size(f); cker=rot90(ker,2);
A = @(x) blur(x,ker); AT = @(x) blur(x,cker); % Convolution operator
eigenP=eigenofP(ker,mu,m,n);
FT = @(x)fft2(x); IFT = @(x)ifft2(x);
normg=norm(f,'fro');normW=cellnorm(W(f)); 
x = opts.Init ; %% initialization
maxit = opts.maxit; 
a = W(x) ; 
logicalsupport = compute_logicalsupport(x,Level,frame,opts) ;  %% support detection
for nstep=1:maxit
 % solve x-subproblem.
  x_previous = x ;
  x = IFT(FT(mu*WT(a)+AT(f))./eigenP);  
  x(x>255)=255;x(x<0)=0; 
 % solve a-subproblem.
% %  alpha = W(x);
  a = SAHT(x,a,W,lambda,mu,dk,logicalsupport) ;
 % check the tolerance condition
  itr_error=norm(x-x_previous,'fro')/norm(x,'fro'); 
disp(['error on step ' num2str(nstep)  ' is ' num2str(itr_error) ', ' 'PSNR is ' num2str(psnr(x/255,oimg/255)) ', SSIM is ' num2str(ssim_index(x,oimg)) ] );  
   if itr_error<tol
        break;
    end
end

x_out = x ;  %% Final output

function eigenP=eigenofP(ker,mu,m,n)
[nker,mker]=size(ker);
tmp=zeros(m,n);tmp(1:nker,1:mker)=ker;
tmp=circshift(tmp,[-floor(nker/2),-floor(mker/2)]);
eigenP=abs(fft2(tmp)).^2 + mu;

function [D,R]=GenerateFrameletFilter(frame)
if frame==0          %Haar Wavelet
    D{1}=[0 1 1]/2;
    D{2}=[0 1 -1]/2;
    D{3}='cc';
    R{1}=[1 1 0]/2;
    R{2}=[-1 1 0]/2;
    R{3}='cc';
elseif frame==1      %Piecewise Linear Framelet
    D{1}=[1 2 1]/4;
    D{2}=[1 0 -1]/4*sqrt(2);
    D{3}=[-1 2 -1]/4;
    D{4}='ccc';
    R{1}=[1 2 1]/4;
    R{2}=[-1 0 1]/4*sqrt(2);
    R{3}=[-1 2 -1]/4;
    R{4}='ccc';
elseif frame==3      %Piecewise Cubic Framelet
    D{1}=[1 4 6 4 1]/16;
    D{2}=[1 2 0 -2 -1]/8;
    D{3}=[-1 0 2 0 -1]/16*sqrt(6);
    D{4}=[-1 2 0 -2 1]/8;
    D{5}=[1 -4 6 -4 1]/16;
    D{6}='ccccc';
    R{1}=[1 4 6 4 1]/16;
    R{2}=[-1 -2 0 2 1]/8;
    R{3}=[-1 0 2 0 -1]/16*sqrt(6);
    R{4}=[1 -2 0 2 -1]/8;
    R{5}=[1 -4 6 -4 1]/16;
    R{6}='ccccc';
end

function muLevel=getwThresh(mu,wLevel,Level,D)
nfilter=1;
nD=length(D);
if wLevel<=0
    for ki=1:Level
        for ji=1:nD-1
            for jj=1:nD-1
                muLevel{ki}{ji,jj}=mu*nfilter*norm(D{ji})*norm(D{jj});
            end
        end
        nfilter=nfilter*norm(D{1});
    end
else
    for ki=1:Level
        for ji=1:nD-1
            for jj=1:nD-1
                if ji==1 && jj==1
                    muLevel{ki}{ji,jj}=0;
                else
                    muLevel{ki}{ji,jj}=mu*nfilter;
                end
            end
        end
        %         muLevel{ki}{1,2}=0;muLevel{ki}{2,1}=0;
        %         muLevel{ki}{2,2}=0;
        %muLevel{ki}{2,3}=0;muLevel{ki}{3,2}=0;
        %muLevel{ki}{3,3}=0;
        nfilter=nfilter*wLevel;
    end
end
