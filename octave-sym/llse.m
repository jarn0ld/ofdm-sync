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
## @deftypefn {Function File} {@var{retval} =} llse (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Julian Arnold <julian@juarnold-t440>
## Created: 2015-01-26

function [retval] = llse (s, preamble)

diff = preamble./complex(s);
#figure;
#plot(arg(diff));
args = [];
adder = 0;
prev_arg = arg(diff(1));

for ii = 1:length(diff)

  if((arg(diff(ii)) < 0) & ( prev_arg > 0 ))
    adder = adder + 2*pi;
  endif
  if((arg(diff(ii)) > 0) & (prev_arg < 0))
    adder = adder - 2*pi;
  endif
  args = [args arg(diff(ii))+adder];
  prev_arg = arg(diff(ii));
  
endfor
retval = polyfit([1:1:52],args,1);
#hold on;
#stem(args);

endfunction
