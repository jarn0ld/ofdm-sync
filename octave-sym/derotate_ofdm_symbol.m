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
## @deftypefn {Function File} {@var{retval} =} derotate_ofdm_symbol (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Julian Arnold <julian@juarnold-t440>
## Created: 2015-02-06

function [S_out, phi_new, phi_error] = derotate_ofdm_symbol (S, S_pilots, phi_old, polarity)
  S = S .* exp(-j*(phi_old));
  S_pilots = S_pilots .* exp(-j*(phi_old));
  Phi_error = arg(S_pilots(1));
  phi_error = mean(Phi_error);
  S_out = S .* exp(-j*(phi_error));
  phi_new = phi_error + phi_old;
endfunction
