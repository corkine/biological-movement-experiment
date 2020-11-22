%=========================================================================
% cbxplot_format_line
%=========================================================================
% USAGE:
%  cbxplot_format_line( handle, width, spec, color )
%  cbxplot_format_line( handle, width, spec, color, mstyle, msize )
%  cbxplot_format_line( handle, width, spec, color, mstyle, msize, zdepth )
%
% Set the format of the line for the given handle. 
% See cbxplot-uguide.txt for more information.

function cbxplot_format_line( handle, width, spec, color, ...
                              marker_style, marker_size, zdepth )

  color = cbxplot_colors(color);

  % Parse marker style

  if ( (nargin > 4) && (length(marker_style) > 0) )
    marker_color = 'white';
    if ( (nargin >= 5) && (marker_style(length(marker_style)) == 'F') )
      marker_color = color;
      marker_style = marker_style(1:length(marker_style)-1);
    end
  end
  
  % Set the properties

  if ( length(spec) > 0 )
    set( handle, 'LineStyle', spec );
  else
    set( handle, 'LineStyle', 'none' ); 
  end
  
  if ( width > 0 )
    set( handle, 'LineWidth', width );
  end
  
  set( handle, 'Color', color );
  
  if ( (nargin > 4)  && (length(marker_style) > 0) )
    set( handle, ...
         'Marker',          marker_style, ...
         'MarkerEdgeColor', color, ...
         'MarkerFaceColor', marker_color, ...
         'MarkerSize',      marker_size );
  end

  % Handle the zdepth parameter
  
  if ( nargin >= 7 )
    xdata = get( handle, 'XData' );
    set( handle, 'ZData', ones(size(xdata,2),1).*zdepth );
  end
