clear all; close all; clc;

%Normal modes in seismic data--Revisited (Landro and Hatchell)

%n ~ Mode number
%k ~ wave number
%H ~ water depth
%a1 ~ speed of sound in water
%a2 ~ speed of sound along sea bed
%rho1 ~ density of water
%rho2 ~ density of sea bed
%c_f ~ freq dependent phase velocity (between a1 and a2)
%U ~ group velocity

%eq 1: period equation constraining frequency dependent phase velocity.
%eq 2: group velocity related to phase velocity and wave number.
%eq 7: minimum group velocity related to mode number
%eq B-4: aproximation of frequency based on phase velocity and mode #

fs = 500;
start_f = 1;
stop_f = 120;
num_points = 100;

[U,c] = v_loop(linspace(start_f,stop_f,num_points),1,1,2000,1485,2000,10,30);
%[U,c] = v_loop(f,n,k,H,a1,a2,rho1,rho2)

function U = group_velocity(c,n,k,H,a1,a2,rho1,rho2) %eq 2
    K_1 = sqrt(c^2/a1^2-1);
	K_2 = sqrt(1-c^2/a2^2);
    D = 1 + (rho2/(rho1*H*k))*(1/K_2+(K_1^2*a1^2)/(K_2^3*a2^2))*cos(k*H*K_1)^2;
    U = c-a1^2*K_1^2/(c*D);
end

function f_n = freq_eq(c,n,H,a1,a2,rho1,rho2)%eq B-4
    K_1 = sqrt(c^2/a1^2-1);
	K_2 = sqrt(1-c^2/a2^2);
	Z = 1/(4*K_1)+rho1*K_2/(2*pi*K_1^2);
	f_n = c*Z*(2*n-1)/H;
end

function [U,c] = v_solve(f,n,k,H,a1,a2,rho1,rho2)%compute both phase and group velocity at a particular frequency
    syms c
    eqn = f == freq_eq(c,n,H,a1,a2,rho1,rho2);
    c = solve(eqn, c);
    %c = abs(c);%workaround for negatives?
    U = group_velocity(c,n,k,H,a1,a2,rho1,rho2);
end

function [U,c] = v_loop(f,n,k,H,a1,a2,rho1,rho2)%compute both phase and group velocity at a frequency sweep
    f_len = size(f,2);
    U = zeros(1,f_len);
    c = zeros(1,f_len);
    parfor i=(1:f_len)
        [U(i), c(i)] = v_solve(f(i),n,k,H,a1,a2,rho1,rho2);
    end
end