%=========================================================================
% cbxplot_data2fig_point
%=========================================================================
% USAGE:
%  fig_pt = cbxplot_data2fig_point( data_pt )
%
% Convert the given data point (in data coordinates) into a figure point
% (in figure coordinates). See cbxplot-uguide.txt for more information.

function fig_pt = cbxplot_data2fig_point( data_pt )

  ax_units = get(gca,'Units');

  set(gca,'Units','normalized');
  ax_pos    = get(gca,'Position');
  ax_lim    = axis(gca);
  ax_width  = diff(ax_lim(1:2));
  ax_height = diff(ax_lim(3:4));

  fig_pt(1) = (data_pt(1) - ax_lim(1))/ax_width*ax_pos(3)  + ax_pos(1);
  fig_pt(2) = (data_pt(2) - ax_lim(3))/ax_height*ax_pos(4) + ax_pos(2);

  set(gca,'Units',ax_units);