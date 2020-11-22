%=========================================================================
% cbxplot_delete_inner_labels
%=========================================================================
% USAGE:
%  cbxplot_delete_inner_labels()
%
% Remove the inner labels from the subplots in the current plot. 
% See cbxplot-uguide.txt for more information.

function cbxplot_delete_inner_labels()
      
  % First we need to get handles to all of the subplots. We also need
  % to exclude handles to legends since we don't want to move those.

  all_handles = get(gcf,'Children');
  H = [];
  for i = 1:length(all_handles)
    if ( ~strcmp(get(all_handles(i),'Tag'),'legend') )
      H(length(H)+1) = all_handles(i);
    end
  end

  % Since we don't really know which row and column each subplot is
  % in, we need to figure it out by comparing the position boxes.
  
  row_pos = []; % For each row what is the y axis of position box
  col_pos = []; % For each row what is the x axis of position box
  
  for i = 1:length(H)
    pos   = get(H(i),'Position');

    % If we haven't seen this subplot's row, add it's x position
    if ( ~sum(row_pos == pos(2)) )      
      row_pos(length(row_pos)+1) = pos(2);
    end    
  
    % If we haven't seen this subplot's column, add it's y position
    if ( ~sum(col_pos == pos(1)) )      
      col_pos(length(col_pos)+1) = pos(1);
    end    
  
  end

  % Now we need to figure out the subplot index for each axes. To do that
  % we first sort the positions so that they are in left to right, top
  % to bottom order. Then we go through the handles and see where each
  % handle fits into the sorted positions. That tells us the subplot
  % location. Then we create hmap which maps subplot indices to the
  % actual subplot handle.
  
  num_rows = length(row_pos);
  num_cols = length(col_pos);
  sorted_row_pos = sort(row_pos);
  sorted_col_pos = sort(col_pos);

  for i = 1:length(H) 
    pos = get(H(i),'Position');
    col_idx = find(sorted_col_pos == pos(1));
    row_idx = find(sorted_row_pos == pos(2));
    hmap(row_idx,col_idx) = H(i);
  end
  
  % We can now go through the subplots and based on where they are in the
  % figure we can remove the inner labels. For the top row we remove
  % just the x-axis labels, and for the bottom row we remove just the
  % title, and for all other rows we remove both the x-axis labels and
  % the title. Similarly, for all but the first column we remove the
  % y-axis labels.

  for row_idx = 1:num_rows
    for col_idx = 1:num_cols
      h = hmap(row_idx,col_idx);
      if ( h == 0 )
        continue;
      end
      
      if ( row_idx ~= 1 )
        delete(get(h,'XLabel'));
        set(h,'XTickLabel',[]);
      end

      if ( row_idx ~= num_rows )
        delete(get(h,'Title'));
      end

      if ( col_idx ~= 1 )
        delete(get(h,'YLabel'));
        set(h,'YTickLabel',[]);
      end
        
    end
  end
  
  