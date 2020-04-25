function [pstat,params]=twosampF(y1,y2,method,parflag)
%%function [pstat,params]=twosampF(y1,y2,method,parflag)
%% F-type test for two sample; 
%% similar to Dempster (1958, 1960)
%% Similar to Demspter test but not eactly
%% y1,y2: n1xp, n2x p  sample matrices, each row: discretization of a function
%% 
%% method  = 1  2-c matched F-approx, 
%%         = 2  bootstrap
%% parflag=0 naive method
%%        =1 bias-reduced method
%%  Outputs
%%  pstat=[stat,pvalue], params=[kappa, (n-1)*kappa] when method =1
%%                       params= a bootstrap sample of statistic  when
%%                       method=2
%%  Jin-Ting Zhang
%%  March 13, 2008; Revised July 11, 2008    NUS, Singapore
%%  Revised Oct 18, 2011 Princeton University

[n1,p]=size(y1);mu1=mean(y1)';z1=y1-ones(n1,1)*mu1';
[n2,p]=size(y2);mu2=mean(y2)';z2=y2-ones(n2,1)*mu2';
n=n1+n2;

if nargin<3|length(method)==0,method=1;end
if nargin<4|length(parflag)==0,
    if method==1,
        parflag=0;
    elseif method==2,
        parflag=10000;
    end
end

z=[z1;z2];
if n>p,
    Sigma=z'*z/(n-2);  %% pxp covariance matrix
else
    Sigma=z*z'/(n-2); %% nxn matrix, having the same eigenvalues with cov. funct
end
A=trace(Sigma);B=trace(Sigma^2);
 
cn=n1*n2/n;mu12=mu1-mu2;
stat=cn*mu12'*mu12/A;
    
if method==1,%% 2-c matched F-approx

    %%Compute the baseline degrees of freedom
if parflag==0,%% naive method
   kappa=A^2/B;
elseif  parflag==1,%%  bias-reduced method
  kappa=(1+1/(n-2))*(A^2-2*B/(n-1))/(B-A^2/(n-2));
end

pvalue=1-fcdf(stat,kappa,(n-2)*kappa);
pstat=[stat,pvalue];params=[kappa,(n-2)*kappa];

elseif method==2, %% Bootstrap method
    if parflag<=10,
       Nsim=10000;
   else
       Nsim=parflag;
   end
   for ii=1:Nsim,
      btflag1=fix(rand(n1,1)*(n1-1))+1;bty1=y1(btflag1,:);btmu1=mean(bty1)';btz1=bty1-ones(n1,1)*btmu1';
      btflag2=fix(rand(n2,1)*(n2-1))+1;bty2=y2(btflag2,:);btmu2=mean(bty2)';btz2=bty2-ones(n2,1)*btmu2';
      btz=[btz1;btz2];
      if n>p,
          btSigma=btz'*btz/(n-2);
      else
          btSigma=btz*btz'/(n-2);
      end
      btmu12=(btmu1-btmu2)-mu12;
      btstat(ii)=cn*btmu12'*btmu12/trace(btSigma);
   end
   pvalue=mean(btstat>=stat);
   pstat=[stat,pvalue];params=btstat;
end

