%=========================================================================
% cbxplot_split_subplots
%=========================================================================
% USAGE:
%  H = cbxplot_split_subplots()
%
% Splits each subplot into its own separate figure. See
% cbxplot-uguide.txt for more information.

function split_h = cbxplot_split_subplots()
      
  % First we need to get handles to all of the subplots. We also need
  % to exclude handles to legends since we don't want to move those.

  all_handles = get(gcf,'Children');
  H = [];
  for i = 1:length(all_handles)
    if ( ~strcmp(get(all_handles(i),'Tag'),'legend') )
      H(length(H)+1) = all_handles(i);
    end
  end

  % Loop through subplots and find the maximum insets in each column
  % and each row for both sides of the subplots. Note that we don't
  % really know which row and column each subplot is in, but we can
  % figure it out by comparing the position boxes. 

  row_pos     = []; % For each row what is the y axis of position box
  col_pos     = []; % For each col what is the x axis of position box

  inset_row_t = []; % Maximum top inset for each row
  inset_row_b = []; % Maximum bottom inset for each row
  inset_col_l = []; % Maximum left inset for each column
  inset_col_r = []; % Maximum right inset for each column

  for i = 1:length(H)
    pos   = get(H(i),'Position');
    inset = get(H(i),'TightInset');

    % Find max top and bottom insets
    if ( sum(row_pos == pos(2)) )      
      if ( inset(2) > inset_row_b(row_pos == pos(2)) )
        inset_row_b(row_pos == pos(2)) = inset(2);
      end
      if ( inset(4) > inset_row_t(row_pos == pos(2)) )
        inset_row_t(row_pos == pos(2)) = inset(4);
      end
    else
      row_pos(length(row_pos)+1) = pos(2);
      inset_row_b(length(inset_row_b)+1) = inset(2);
      inset_row_t(length(inset_row_t)+1) = inset(4);
    end    
  
    % Find max left and right insets
    if ( sum(col_pos == pos(1)) )      
      if ( inset(1) > inset_col_l(col_pos == pos(1)) )
        inset_col_l(col_pos == pos(1)) = inset(1);
      end
      if ( inset(3) > inset_col_r(col_pos == pos(1)) )
        inset_col_r(col_pos == pos(1)) = inset(3);
      end
    else
      col_pos(length(col_pos)+1) = pos(1);
      inset_col_l(length(inset_col_l)+1) = inset(1);
      inset_col_r(length(inset_col_r)+1) = inset(3);
    end    
  
  end

  % Now we need to figure out the subplot index for each axes. To do that
  % we first sort the positions so that they are in left to right, top
  % to bottom order. Then we go through the handles and see where each
  % handle fits into the sorted positions. That tells us the subplot
  % location. Then we create hmap which maps subplot indices to the
  % actual subplot handle. We also create new sorted inset vectors which
  % have the same data as inset_row_t, inset_row_b, inset_col_l, and
  % inset_col_r except that they are indexed by the subplot indices.
  
  num_rows = length(row_pos);
  num_cols = length(col_pos);
  sorted_row_pos = sort(row_pos);
  sorted_col_pos = sort(col_pos);

  for i = 1:length(H) 
    pos = get(H(i),'Position');
    col_idx = find(sorted_col_pos == pos(1));
    row_idx = find(sorted_row_pos == pos(2));
    hmap(row_idx,col_idx) = H(i);
    sorted_inset_row_t(row_idx,col_idx) = inset_row_t(find(row_pos == pos(2)));
    sorted_inset_row_b(row_idx,col_idx) = inset_row_b(find(row_pos == pos(2)));
    sorted_inset_col_l(row_idx,col_idx) = inset_col_l(find(col_pos == pos(1)));
    sorted_inset_col_r(row_idx,col_idx) = inset_col_r(find(col_pos == pos(1)));
  end

  % Calculate the size of each subplot (in pixels)

  fpos  = get(gcf,'Position');  
  fig_w = fpos(3);
  fig_h = fpos(4);
  
  % Now split each subplot by creating a new figure for each subplot
  % with the right dimensions.

  for row_idx = 1:num_rows
    for col_idx = 1:num_cols
   
      h = hmap(row_idx,col_idx);

      this_inset_col_l = sorted_inset_col_l(row_idx,col_idx);
      this_inset_col_r = sorted_inset_col_r(row_idx,col_idx);
      this_inset_row_b = sorted_inset_row_b(row_idx,col_idx);
      this_inset_row_t = sorted_inset_row_t(row_idx,col_idx);
      
      pos  = get(h,'Position');
      sp_w = pos(3);
      sp_h = pos(4);

      width  = ( this_inset_col_l + this_inset_col_r + sp_w ) * fig_w;
      height = ( this_inset_row_b + this_inset_row_t + sp_h ) * fig_h;
      
      figure;      
      cbxplot_format_fig( width, height );
      copyobj(h,gcf);

      new_inset_col_l = (this_inset_col_l*fig_w)/width;
      new_inset_col_r = (this_inset_col_r*fig_w)/width;
      new_inset_row_b = (this_inset_row_b*fig_h)/height;
      new_inset_row_t = (this_inset_row_t*fig_h)/height;
      
      set(gca,'Position',[ new_inset_col_l ...
                           new_inset_row_b ...
                           1 - new_inset_col_l - new_inset_col_r ...
                           1 - new_inset_row_b - new_inset_row_t ]);
      
      split_h((row_idx-1)*num_cols+col_idx) = gcf;      
      
    end
  end
  
