function [pstat,params]=ksampL2(yy,method,biasflag)
%%function [pstat,params]=ksampL2(yy,method,biasflag)
%% L2-norm based  test for k-sample problem with a common cov funct.
%%   One-way ANOVA for functional data: Main-effects test
%% yy=[A,y1,y2,...,yp]  
%%   A: nx1  indicator of the levels of Factor A
%%  Matrix [y1,y2,...,yp]: nxp data matrix,  each row: discretization of a func.
%% method  = 1  2-c matched x2-approx, 
%%         = 2  3-c matched x2-approx
%%         = [3, Nboot]  bootstrapping
%% biasflag=0 naive method
%%        =1 bias-reduced method
%%  Outputs
%%  pstat=[stat,pvalue], params=[alpha,df] when method =1
%%                       params=[alpha,df,beta] when method=2
%%                       params= a bootstrap sample of statistic
%%  Jin-Ting Zhang
%%  March 13, 2008; Revised July 11, 2008  NUS, Singapore
%%  Revised Oct 19, 2011 Princeton University

if nargin<2|length(method)==0,
    method=1;
elseif length(method)==1,
    if method==3, Nboot=1000;end
elseif length(method)==2,
    Nboot=method(2);method=method(1);
end
if nargin<3|length(biasflag)==0,
   biasflag=0;
end

%% Some basic calculations
[n,p]=size(yy);p=p-1;
aflag=yy(:,1);aflag0=unique(aflag); k=length(aflag0); %% Level of Factor A
yy=yy(:,2:(p+1)); %% nxp data matrix,  each row: discretization of a func.

mu0=mean(yy); %% pooled sample mean function
gsize=[];vmu=[];z=[];SSR=0;
for i=1:k,
   iflag=(aflag==aflag0(i));yi=yy(iflag,:); %%Samle i
   ni=size(yi,1);mui=mean(yi);zi=yi-ones(ni,1)*mui;
   gsize=[gsize;ni];vmu=[vmu;mui]; %% each row is a group mean vector
   z=[z;zi];
   SSR=SSR+ni*(mui-mu0).^2; %% 1xp vector
end
stat=sum(SSR);

if n>p,
    Sigma=z'*z/(n-k);  %% pxp pooled covar. matrix
else
    Sigma=z*z'/(n-k); %% nxn matrix, having the same eigenvalues with pooled cov. matrix
end
 A=trace(Sigma);B=trace(Sigma^2);C=trace(Sigma^3);
    
if biasflag==0, %% naive method
   A2=A^2;B2=B;
elseif biasflag==1,  %% bias-reduced method
   A2=(n-k)*(n-k+1)/(n-k-1)/(n-k+2)*(A^2-2*B/(n-k+1));
   B2=(n-k)^2/(n-k-1)/(n-k+2)*(B-A^2/(n-k));
end

if method==1, %% 2-c x2-approx
   alpha=B2/A;kappa=A2/B2;
   pvalue=1-chi2cdf(stat/alpha,(k-1)*kappa);
   pstat=[stat,pvalue]; params=[alpha,(k-1)*kappa,kappa];
elseif method==2, %% 3-c x2-approx
   alpha=C/B2;df=(k-1)*B^3/C^2;beta=(k-1)*(A-B2/C);
   pvalue=1-chi2cdf((stat-beta)/alpha,df);
   pstat=[stat,pvalue]; 
   params=[alpha,df,beta]; 
elseif method==3, %% bootstrapping method
   
   
   for ii=1:Nboot,
      btvmu=[]; 
      for i=1:k,
          iflag=(aflag==aflag0(i));yi=yy(iflag,:);ni=gsize(i);
          btflag=fix(rand(ni,1)*(ni-1))+1; btyi=yi(btflag,:);
          btmui=mean(btyi)-vmu(i,:);
          btvmu=[btvmu;btmui];
      end
      btmu0=gsize'*btvmu/n;
      btSSR=0;
      for i=1:k,
         btSSR=btSSR+gsize(i)*(btvmu(i,:)-btmu0).^2;
      end
      btstat(ii)=sum(btSSR);
   end
   pvalue=mean(btstat>=stat);
   pstat=[stat,pvalue];params=btstat;
end
 


