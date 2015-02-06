close all;
clear all;
clc;

r = read_complex_binary('samples.dat');
r = r(9.404e6:9.414e6);

#figure;
#plot(abs(r));
#hold on;

#########################################
#########################################
##### Run Sync ##########################
#########################################
#########################################
if(1)

[D, f, corr, power, frame_start, d_f, sig_out, sig_out_corr] = schmidl_corr(r, 32);
#plot(D,'r');
#plot(f,'g');
#title('Schmidl Cox out');

long_preamble_f = [1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 0 1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1];

##############################################################
######### Find Correlation with long preamble ################
##############################################################
ifft_data = [long_preamble_f(27:end) 0 0 0 0 0 0 0 0 0 0 0 long_preamble_f(1:26)];
long_preamble_t = ifft(ifft_data);
correlation = conv(conj(sig_out_corr), fliplr(long_preamble_t));
[max, long_preamble_start] = max(abs(correlation));
long_preamble_start
###############################################################

###############################################################
########## Run FFT on LP ######################################
###############################################################
sig_out_corr = sig_out_corr(long_preamble_start-63:end);

fft_input = sig_out_corr(1:64);
fft_out = fft(fft_input);
fft_out = fftshift(fft_out);
fft_out = circshift(fft_out, [0 0]);
###############################################################

long_preamble_f_trim = [1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1];
data_out = fft_out(7:end-5);

###############################################################
############## Run LLSE correction? ###########################
###############################################################
p = llse([fft_out(7:32) fft_out(34:59)], long_preamble_f_trim);
if(0)
  fft_out = fft_out.*exp(i*p(2));
  data_out = [];
  for k=7:length(fft_out)-5
   data_out = [data_out fft_out(k).*exp(i*(p(1).*(k-7)))];
  endfor

figure;
plot(abs(fft_out));
hold on;
plot(real(fft_out), 'r');
plot(imag(fft_out), 'g');

endif
###############################################################

###############################################################
###################### Run channel equalizer ##################
###############################################################
H_ls = inv(diag(circshift([0 0 0 0 0 0 long_preamble_f 0 0 0 0 0], [0 0])))*transpose([0 0 0 0 0 0 data_out 0 0 0 0 0]);

figure;
hold on;
plot(abs(H_ls));
plot(arg(H_ls), 'r');
title('Channel response H(f)');

data_out = data_out ./ transpose(H_ls)(7:end-5);
figure;
plot(abs(data_out));
hold on;
plot(real(data_out), 'r');
plot(imag(data_out), 'g');
title('OFDM frame after equalization');

figure;
plot(real(data_out), imag(data_out), '.');
axis([-1 1 -1 1], "manual");
title('OFDM frame after equalization');
#######################################################################

#######################################################################
################ Move to first data symbol ############################
#######################################################################

fft_input = sig_out_corr(145:145+63);
fft_out = fft(fft_input);
fft_out = fftshift(fft_out);

##########################################################################
############ Apply LLSE? #################################################
##########################################################################
if(0)
fft_out = fft_out.*exp( i * p(2) );

data_out = [];
for k=1:length(fft_out)
  data_out = [data_out fft_out(k).*exp(i*((p(1).*(k-7))))];
endfor

fft_out = data_out;
endif
##########################################################################

##########################################################################
################ Aplly channel equalizer #################################
##########################################################################
fft_out = fft_out ./ transpose(H_ls);

figure;
plot(abs(fft_out));
hold on;
plot(real(fft_out), 'r');
plot(imag(fft_out), 'g');
title('OFDM frame 2 after equalization');

figure;
plot(real(fft_out), imag(fft_out), '.');
axis([-1 1 -1 1], "manual");
title('OFDM frame 2 after equalization');
###########################################################################

endif