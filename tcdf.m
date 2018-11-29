% Student-t-Verteilung in Matlab
%BEISPIEL von webseite
%wird nicht mehr gebraucht
% mu = mean(peakMaty);     % Population mean
% sigma = std(peakMaty);   % Population standard deviation
% n = anzSub;     % Sample size
% 
% rng default   % For reproducibility
% x = normrnd(mu,sigma,n,n);  % Random sample from population
% 
% xbar = mean(x);  % Sample mean
% s = std(x);      % Sample standard deviation
% t = (xbar - mu)/(s/sqrt(n))
% 
% p = 1-tcdf(t,n-1) % Probability of larger t-statistic
% 
% This probability is the same as the p value returned by a t test of the null hypothesis that the sample comes from a normal population with mean
% 
% [h,ptest] = ttest(x,mu,0.05,'right')
%nu = N
% p = tcdf(x,nu)
% x = 1.05;
% nu = 4;
% p = tcdf(x,nu);

clear all; 

M = magic(3);

for i = 1:3
    for j = 1:3
    if M(i,j) < 5
        M(i,j) = 10;
    end
    
    disp(M(i,j));
    end
end