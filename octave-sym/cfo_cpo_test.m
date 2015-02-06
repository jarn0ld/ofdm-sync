clc;
clear all;
close all;

t = [0:99];
N = length(t);
f = 0.01; #0.5 = f_max
phi = 0.1;
f_offset = 0.01;
r = sin(2*pi*f*t) + sin(2*pi*(f*8)*t);
r_shift = sin(2*pi*(f+f_offset)*t) + sin(2*pi*(f*8+f_offset)*t);

figure;
title("input signal");
plot(r);
hold on;
plot(r_shift, 'r');

R = 1/N * fftshift(fft(r));
R_shift = 1/N * fftshift(fft(r_shift));

figure;
hold on;
grid on;

title('FFT of sine wave');
#plot(abs(R));
stem(real(R), 'r');
stem(imag(R), 'g');
#plot(abs(R_shift));
stem(real(R_shift), 'r');
stem(imag(R_shift), 'b');