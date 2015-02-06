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
## @deftypefn {Function File} {@var{retval} =} schmidl_corr_vect (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Julian Arnold <julian@juarnold-t440>
## Created: 2015-01-22

function [retval] = schmidl_corr_vect(r, N)
  tmp = r(1:end-N).*conj(r(N+1:end));
  out = [];
  for i=1:(length(r)-(2*N))
    out = [out sum(tmp(i:(i+32)))];
  endfor
  retval = out;
endfunction
