%=========================================================================
% cbxplot_add_line
%=========================================================================
% USAGE:
%  cbxplot_add_line( pt1, pt2 )
%  cbxplot_add_line( pt1, pt2, width, style, color )
%
% Draw a line on the current plot. See cbxplot-uguide.txt for more
% information.

function H = cbxplot_add_line( pt1, pt2, width, style, color );
                                  
  H = line([pt1(1) pt2(1)],[pt1(2) pt2(2)]);
  if ( nargin > 2 )
    cbxplot_format_line( H(1), width, style, color );
  end
  