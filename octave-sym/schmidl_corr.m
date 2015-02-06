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
## @deftypefn {Function File} {@var{retval} =} schmidl_corr (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Julian Arnold <julian@juarnold-t440>
## Created: 2015-01-15

function [D, f, corr, power, frame_start, d_f, sig_out, sig_out_corr] = schmidl_corr (rec, N)
  corr = [];
  power = [];
  plateau_count = 0;
  plateau_index = 0;
  last_div = 0;
  edge_found = 0;
  frame_start = 0;
  d_f = 0;
  sig_out_corr = [];
  
  for ii=1:(length(rec)-2*N)
    curr_corr = 0+0i;
    curr_power = 0;
  
    for jj=1:N
      curr_corr += conj(rec(ii+jj)).*rec(ii+jj+N);
      curr_power += abs((rec(ii+jj+N))).^2;
    endfor
  
    corr = [corr curr_corr];
    power = [power curr_power];
    div_corr = abs(curr_corr).^2;
    div_power = curr_power.^2; 
    curr_div = div_corr/div_power;
    
    
    if(curr_div > 0.8)
      plateau_count++;
      if((curr_div-last_div > 0) && (edge_found==0))
        plateau_index = ii;
      else
        edge_found = 1;
      endif
    else
      plateau_count = 0;
    endif
    
    if(plateau_count>((2*N)-10))
      frame_start = plateau_index
      d_phi = arg(corr(plateau_index+N))
      d_w = d_phi/(N*(1/20e6))
      d_f = d_w/(2*pi)
      
      sig_out = rec(frame_start:end);
      for k=1:length(sig_out)
        d_phi_curr = exp(-i*2*pi*d_f*k*(1/20e6));
        sig_out_corr = [sig_out_corr (sig_out(k).*d_phi_curr)];
      endfor
      
      plateau_count = 0;
      plateau_index = 0;
    endif
    
    last_div = curr_div;
    
  endfor
  
  D = ((abs(corr)).^2) ./ (power.^2);
  f = arg(corr);
  
endfunction
