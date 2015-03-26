## Copyright (C) 2015 Julian Arnold
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*- 
## @deftypefn {Function File} {@var{retval} =} decode_ofdm_symbol (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Julian Arnold <julian@juarnold-t440>
## Created: 2015-02-06
function [S_ofdm, S_pilots] = decode_ofdm_symbol (r, H)
debug = 0;
fft_input = r;
fft_out = fft(fft_input);
fft_out = fftshift(fft_out);

#########################################################
################ Aplly channel equalizer ################
#########################################################
fft_out = fft_out ./ transpose(H);
#########################################################

fft_out = fft_out(7:end-5); # remove guard carriers
S_ofdm = [fft_out(1:5) fft_out(7:19) fft_out(21:26) fft_out(28:33) fft_out(35:47) fft_out(49:end)];
S_pilots = [fft_out(6) fft_out(20) fft_out(34) fft_out(48)];

if(debug == 1)
  figure;
  plot(abs(fft_out));
  hold on;
  plot(real(fft_out), 'r');
  plot(imag(fft_out), 'g');
  title('OFDM frame after equalization');
endif
if(debug == 2)
  plot(real(fft_out), imag(fft_out), '.');
  axis([-1 1 -1 1], "manual");
  title('OFDM frame after equalization');
endif

endfunction
