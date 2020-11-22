%=========================================================================
% cbxplot_export_pdf
%=========================================================================
% USAGE:
%  cbxplot_export_pdf
%  cbxplot_export_pdf( filename )
%
% Export the current figure to a PDF file. With no argument the pdf
% filename is the same as the function name which called the export
% function. Underscores in the function name are replaced with dashes
% and a .mat.pdf extension is added. See cbxplot-uguide.txt for more
% information.

function cbxplot_export_pdf( filename )

  if ( nargin == 0 )
    [stack,workspace_idx] = dbstack(1);
    calling_func_name = stack(1).name;
    filename = [regexprep(calling_func_name,'_','-') '.mat.pdf'];
  end
  
  % First determine the screen dpi dpi
  set(0,'Units','pixels');
  screen_size_px = get(0,'Screensize');
  set(0,'Units','inches');
  screen_size_in = get(0,'Screensize');
  dpi = screen_size_px./screen_size_in;

  % Now set the paper parameters
  fpos = get(gcf,'Position');
  set(gcf,'PaperUnits','inches');
  set(gcf,'PaperSize',[fpos(3)/dpi(3) fpos(4)/dpi(4)]);
  set(gcf,'PaperPosition',[0 0 fpos(3)/dpi(3) fpos(4)/dpi(4)]);
  
  % And generate the pdf
  print('-dpdf',filename);
  
  