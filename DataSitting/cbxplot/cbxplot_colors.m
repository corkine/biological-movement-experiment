%=========================================================================
% cbxplot_colors
%=========================================================================
% USAGE:
%  C = cbxplot_colors( [R,G,B] )
%  C = cbxplot_colors( 'color-string' )
%
% Translate cbxplot predefined colors into RGB values. See
% cbxplot-uguide.txt for more information.

function C = cbxplot_colors( color )

  C = color;
  if     ( strcmp(color,'dark-red')    || strcmp(color,'dr') ) 
    C = [ 0.75 0.00 0.00 ];
  elseif ( strcmp(color,'dark-blue')   || strcmp(color,'db') ) 
    C = [ 0.00 0.00 0.75 ];
  elseif ( strcmp(color,'dark-green')  || strcmp(color,'dg') ) 
    C = [ 0.00 0.75 0.00 ];
  elseif ( strcmp(color,'dark-orange') || strcmp(color,'do') ) 
    C = [ 0.75 0.20 0.00 ];
  end

  