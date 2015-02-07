close all;
clear all;
clc;

r = read_complex_binary('samples.dat');
r = r(9.404e6:9.414e6);

#figure;
#plot(abs(r));
#hold on;

#########################################
##### Run Sync ##########################
#########################################

if(1)

[D, f, corr, power, frame_start, d_f, sig_out, sig_out_corr] = schmidl_corr(r, 32);
#figure;
#hold on;
#grid on;
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

###############################################################
###################### Run channel equalizer ##################
###############################################################
data_out = fft_out(7:end-5);
H_ls = inv(diag(circshift([0 0 0 0 0 0 long_preamble_f 0 0 0 0 0], [0 0])))*transpose([0 0 0 0 0 0 data_out 0 0 0 0 0]);

#figure;
#hold on;
#plot(abs(H_ls));
#plot(arg(H_ls), 'r');
#title('Channel response H(f)');

#figure;
#plot(abs(data_out));
#hold on;
#plot(real(data_out), 'r');
#plot(imag(data_out), 'g');
#title('OFDM frame 1 before equalization');

#figure;
#plot(real(data_out), imag(data_out), '.');
#axis([-1 1 -1 1], "manual");
#title('OFDM frame 1 before equalization');

data_out = data_out ./ transpose(H_ls)(7:end-5);

#figure;
#plot(abs(data_out));
#hold on;
#plot(real(data_out), 'r');
#plot(imag(data_out), 'g');
#title('OFDM frame after equalization');

#figure;
#plot(real(data_out), imag(data_out), '.');
#axis([-1 1 -1 1], "manual");
#title('OFDM frame after equalization');
###########################################################

###########################################################
################ Decode, baby! ############################
###########################################################
### Pilots can be found in bins -21, -7, 7, 21
### For the SYMBOL symbol their values are 1, 1, 1, -1
close all;
fig = figure;

curr_ofdm_sym_start_index = 129;
phi = 0;
phi_log = [];
pilot_zero = [];
polarity_seq = [1 1 1 1 -1 -1 -1 1 -1 -1 -1 -1 1 1 -1 1 -1 -1 1 1 -1 1]
for ii = 1:100

  curr_ofdm_sym = sig_out_corr(curr_ofdm_sym_start_index:curr_ofdm_sym_start_index+63+16);
  curr_ofdm_sym = remove_cp(curr_ofdm_sym);
  [curr_ofdm_sym curr_ofdm_pilots] = decode_ofdm_symbol(curr_ofdm_sym, H_ls);
  pilot_zero = [pilot_zero curr_ofdm_pilots(1)];
  [curr_ofdm_sym, phi, phi_curr] = derotate_ofdm_symbol(curr_ofdm_sym, curr_ofdm_pilots, phi);
  phi_log = [phi_log phi_curr];
   
  curr_ofdm_sym_start_index = curr_ofdm_sym_start_index+16+64;

  ############## DEBUG PLOTS ##############################
  plot(real(curr_ofdm_sym), imag(curr_ofdm_sym), '.');
  axis([-2 2 -2 2], "manual");
  title('OFDM Symbol after equalization');
  drawnow;
  #figure;
  #plot(real(curr_ofdm_pilots), imag(curr_ofdm_pilots), '.');
  #axis([-2 2 -2 2], "manual");
  #title('OFDM Pilots after equalization');
  #drawnow;
  pause(0.1);
  ##########################################################
endfor
figure;
plot(phi_log./(2*pi));
figure;
plot(arg(pilot_zero)./(2*pi));
endif