%=========================================================================
% cbxplot_subplot
%=========================================================================
% USAGE:
%  cbxplot_subplot( num_rows, num_cols )
%  cbxplot_subplot( id )
%
% Manage subplots in a slightly simpler way than the built-in matlab
% subplot function. See cbxplot-uguide.txt for more information.

function cbxplot_subplot( arg1, arg2 )

  global s_subplot_num_rows;
  global s_subplot_num_cols;
    
  if ( nargin == 2 )
    s_subplot_num_rows = arg1;
    s_subplot_num_cols = arg2;
  else
    subplot( s_subplot_num_rows, s_subplot_num_cols, arg1 );
  end
  