function [m,g,R2,m0,lfe,x0,Afe,mu_r,mu,N,theta_fe,rho,diameter] = data_variables()
m = 0.8199;
g = 9.80665;
R2=3.3; %coil resistivity measured from the voltmeter at the coils
m0 = 4*pi*10^(-7); %magnetic permeability of the air
lfe = 0.2855; % length of ferrite
x0 = 0.013; % initial distance
Afe = 0.0306*0.0286;
mu_r = 2000; %can be 1000/3000 not influence the result
mu = m0*mu_r; %magnetic permeability of the ferrite
N = 860; % valore dato dai datasheet
theta_fe=lfe/(Afe*mu); %riluctanze of the ferrite

rho=1.68*10^(-8); %resistivity
diameter=0.0011;%of the wire
end