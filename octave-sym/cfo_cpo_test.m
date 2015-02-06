clc;
clear all;
close all;

t = [0:99];
N = length(t);
f = 0.01; #0.5 = f_max
phi = 0.2;
f_offset = 0.00;
r = sin(2*pi*f*t) + sin(2*pi*(f*8)*t);
r_shift = sin(2*pi*(f+f_offset)*t + phi*2*pi) + sin(2*pi*(f*8+f_offset)*t + phi*2*pi);

figure;
title("Input Signal");
plot(r);
hold on;
plot(r_shift, 'r');

R = 1/N * fftshift(fft(r));
R_shift = 1/N * fftshift(fft(r_shift));

figure;
hold on;
grid on;
title('FFT of Input Signal');
#plot(abs(R));
stem(real(R), 'r');
stem(imag(R), 'b');
legend('real', 'imag');

figure;
hold on;
grid on;
title('FFT of Input Signal w/ Phase Offset');
#plot(abs(R_shift));
stem(real(R_shift), 'r');
stem(imag(R_shift), 'b');
legend('real', 'imag');