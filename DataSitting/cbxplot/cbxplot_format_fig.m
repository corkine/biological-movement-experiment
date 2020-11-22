%=========================================================================
% cbxplot_format_fig
%=========================================================================
% USAGE:
%  cbxplot_format_fig( width_px, height_px )
%
% Resize the current plot to the given width and height specified in
% pixels. See cbxplot-uguide.txt for more information.

function cbxplot_format_fig( width_px, height_px )

  clf;
  fpos = get(gcf,'Position');
  set(gcf,'MenuBar','none');
  set(gcf,'Position',[fpos(1) fpos(2) width_px height_px]);
