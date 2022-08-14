%% Cap Filter Alpha & Beta
clc
clear
Po = 4000;
C = 10e-3;
Vin = 240*sqrt(2);
VD  = 1.8;
Vdc = Vin - 2*VD;
f = 50;
R = Vdc^2 / Po;

w = 2*pi*f;

%% Section 3.4 Power Supplied to the Load

beta = pi-atan(w*R*C);
alpha_hi = pi;
alpha_lo = pi/8;

for k = 1:100
    alpha = (alpha_hi+alpha_lo)/2;
    fn_for_alpha = (Vdc*sin(2*pi + alpha)) - (Vdc*sin(beta)*exp(-(pi+alpha-beta)/(w*R*C)));

    if fn_for_alpha > 0
        alpha_hi = alpha;
    elseif fn_for_alpha < 0
        alpha_lo = alpha;

    end
end

fprintf("alpha in radians: %f\nalpha in degrees: %f\n\n",alpha,alpha/pi*180);
fprintf("beta in radians: %f\nbeta in degrees: %f\n\n",beta,beta/pi*180);
fprintf("conduction period degrees: %f\n",(beta-alpha)/pi*180);
fprintf("conduction period time: %f\n\n",(beta-alpha)/(2*pi*f));

fn_source = @(wt)Vdc*sin(wt);
fn_discharge = @(wt)Vdc*sin(beta)*exp(-(wt-beta)/(w*R*C));

int_source = integral(fn_source,alpha,beta);
int_discharge = integral(fn_discharge,beta,pi + alpha);

Vdc_avg = (int_source + int_discharge)/(pi);
fprintf("Vdc (average) = %f V\n", Vdc_avg);

P_load = Vdc_avg^2 / R;
fprintf("Power supplied to load = %f W\n",P_load);

