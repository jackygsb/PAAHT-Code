function  c = SAHT(x,a,W,lambda,mu,dk,logicalsupport) 
% W  = @(x) FraDecMultiLevel(x,D,Level); % Frame decomposition
% WT = @(x) FraRecMultiLevel(x,R,Level); % Frame reconstruction
alpha = W(x) ;
Level=length(alpha);
lambda0=lambda;
[nD,nD1]=size(alpha{1});
c=alpha;

for ki=1:Level
    for ji=1:nD
        for jj=1:nD
            if (ji~=1 || jj~=1)
  lambda=lambda0*((0.25)^(ki-1));    
  t1 = 2*lambda*(mu+dk); %% threshold value
  T=(mu*alpha{ki}{ji,jj}+dk*a{ki}{ji,jj}).^2;
 c{ki}{ji,jj}=double(T-t1>0).*(mu./(mu+dk).*alpha{ki}{ji,jj}+dk./(mu+dk).*a{ki}{ji,jj});   
% % %  Truncated implementation
 A{ki}{ji,jj} = (mu*alpha{ki}{ji,jj}+dk*a{ki}{ji,jj})./(mu+dk) ; 
 c{ki}{ji,jj}(logicalsupport{ki}{ji,jj}) = A{ki}{ji,jj}(logicalsupport{ki}{ji,jj}) ;
            else
 c{ki}{ji,jj}=(mu.*alpha{ki}{ji,jj}+dk.*a{ki}{ji,jj})./(mu+dk);
            end
         end
    end
end
 
 
 
 
 