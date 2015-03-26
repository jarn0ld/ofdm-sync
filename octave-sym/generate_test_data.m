clc;
close all;

data_type_int16 = 0;

#12/52 carrier used + DC
short_ts_f = [0,0,0,0,0,0,0,0,1+j,0,0,0,-1-j,0,0,0,1+j,0,0,0,-1-j,0,0,0,-1-j,0,0,0,1+j,0,0,0,0,0,0,0,-1-j,0,0,0,-1-j,0,0,0,1+j,0,0,0,1+j,0,0,0,1+j,0,0,0,1+j,0,0,0,0,0,0,0];
long_ts_f = [1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 0 1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1];
ifft_data = [long_ts_f(27:end) 0 0 0 0 0 0 0 0 0 0 0 long_ts_f(1:26)];
long_ts_t = ifft(ifft_data);

#figure;
#hold on;
#grid on;

#plot(abs(long_ts_t));
#plot(real(long_ts_t),'r');
#plot(imag(long_ts_t),'g');

short_ts_f = ifftshift(short_ts_f);
short_ts_t = ifft(short_ts_f);

test_data = [];
for i=1:10
  test_data = [test_data short_ts_t(1:(64/4))];
endfor
size(long_ts_t(end-31:end))
test_data = [zeros(1,128) test_data long_ts_t(end-31:end) long_ts_t long_ts_t zeros(1,4096)];

#test_data = awgn(test_data, 60);

##### Add frequency offset
#test_data = add_freq_offset(test_data, 0.001);

figure;
hold on;
grid on;
plot(real(test_data));
figure;
hold on;
grid on;
plot(imag(test_data), 'r');

[D, f, corr, power, frame_start, d_f, sig_out, sig_out_corr] = schmidl_corr(test_data, 32);

figure
hold on;
#plot(abs(corr));
plot(arg(corr), 'b');
#plot(power, 'r');
plot(D,'r')

if(data_type_int16)
  test_data = test_data .* ((2^15)-1);
endif

interleave = [];
index = 1;
for i=1:(length(test_data))
  interleave(index) = real(test_data(i));
  interleave(index+1) = imag(test_data(i)); 
  index = index + 2; 
endfor

if(data_type_int16)
  fileId = fopen('test-int16.bin', 'w');
  fwrite(fileId, interleave, 'int16');
else
  fileId = fopen('test-float.bin', 'w');
  fwrite(fileId, interleave, 'float');
endif

fclose(fileId);