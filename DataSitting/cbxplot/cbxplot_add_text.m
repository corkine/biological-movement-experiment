%=========================================================================
% cbxplot_add_text
%=========================================================================
% USAGE:
%  cbxplot_add_text( pt, str )
%  cbxplot_add_text( pt, str, font, size )
%  cbxplot_add_text( pt, str, font, size, color )
%  cbxplot_add_text( pt, str, font, size, color, pos )
%  cbxplot_add_text( pt, str, font, size, color, pos, rotation )
%
% Draw the given text string on the current plot. See
% cbxplot-uguide.txt for more information.

function H = cbxplot_add_text( pt, str, name, size, color, pos, rotation )

  H = text(pt(1),pt(2),str);

  % Font name and size
  
  if ( nargin >= 3 )
    set(H(1),'FontName',name);
  end

  if ( nargin >= 4 )
    set(H(1),'FontSize',size);
  end

  % Font color 
  
  if ( nargin >= 5 )
    set(H(1),'Color',cbxplot_colors(color));  
  end

  % Text position
  
  if ( nargin < 6 )
    pos = 'cc';
  end

  if ( strcmp(pos,'tl') )
    set(H(1),'HorizontalAlignment','right');
    set(H(1),'VerticalAlignment','bottom');
  elseif ( strcmp(pos,'cl') )
    set(H(1),'HorizontalAlignment','right');
    set(H(1),'VerticalAlignment','middle');
  elseif ( strcmp(pos,'bl') )
    set(H(1),'HorizontalAlignment','right');
    set(H(1),'VerticalAlignment','top');
  elseif ( strcmp(pos,'tc') )
    set(H(1),'HorizontalAlignment','center');
    set(H(1),'VerticalAlignment','bottom');
  elseif ( strcmp(pos,'cc') )
    set(H(1),'HorizontalAlignment','center');
    set(H(1),'VerticalAlignment','middle');
  elseif ( strcmp(pos,'bc') )
    set(H(1),'HorizontalAlignment','center');
    set(H(1),'VerticalAlignment','top');
  elseif ( strcmp(pos,'tr') )
    set(H(1),'HorizontalAlignment','left');
    set(H(1),'VerticalAlignment','bottom');
  elseif ( strcmp(pos,'cr') )
    set(H(1),'HorizontalAlignment','left');
    set(H(1),'VerticalAlignment','middle');
  elseif ( strcmp(pos,'br') )
    set(H(1),'HorizontalAlignment','left');
    set(H(1),'VerticalAlignment','top');
  else
    error('Invalid position string');    
  end

  % Text rotation
  
  if ( nargin >= 7 )
    set(H(1),'Rotation',rotation);
  end
