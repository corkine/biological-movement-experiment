%=========================================================================
% cbxplot_export_deps
%=========================================================================
% USAGE:
%  cbxplot_export_deps
%  cbxplot_export_deps( filename )
%  cbxplot_export_deps( extra_deps )
%  cbxplot_export_deps( filename, extra_deps )
%
% This function will generate .d makefile fragments which can then be
% included as part of the automatic LaTeX build system. The filename
% should be the name of the generated pdf file (with a .mat.pdf
% extension) and the extra_deps can be a cell array of strings for
% additional dependencies. If no filename is given then the filename is
% the same as the function name which called the export function.
% Underscores in the function name are replaced with dashes and a
% .mat.pdf extension is added. See cbxplot-uguide.txt for more
% information.

function cbxplot_export_deps( pdf_file_name, extra_deps )

  % If only one option determin if it is actually extra_deps as
  % opposed to a filename

  pdf_file_name_valid = (nargin > 0);
  if ( nargin == 0 )
    extra_deps = {};
  elseif ( nargin == 1 )
    if ( iscell(pdf_file_name) )
      pdf_file_name_valid = 0;
      extra_deps = pdf_file_name;
    else
      extra_deps = {};
    end
  end
  
  % Determine the calling function name

  [stack,workspace_idx] = dbstack(1);
  calling_func_name = stack(1).name;

  % If no filename is specified use calling function with .mat.pdf ext
  
  if ( ~pdf_file_name_valid )
    pdf_file_name = [regexprep(calling_func_name,'_','-') '.mat.pdf'];
  end

  % Create .d filename
  
  dep_file_name = regexprep(pdf_file_name,'.mat.pdf','.d');
  
  % Find the dependencies
  
  deps = depfun(calling_func_name,'-quiet');

  % Turn the dependency list into a list of only "local" mfiles (ie.
  % mfiles which are in the same directory as the calling function or
  % in a subdirectory)
  
  m_dir_name  = regexprep(which(calling_func_name),'[^/]+$','');

  match_idx   = strmatch(m_dir_name,deps);
  local_deps  = deps(match_idx);
  m_base_name = regexprep(local_deps,m_dir_name,'');

  % Write the dependency file
  
  fid = fopen(dep_file_name,'wt');
  fprintf(fid,'%s : \\\n',pdf_file_name);
  for i = 1:length(m_base_name)
    fprintf(fid,'  %s \\\n',char(m_base_name(i)));
  end 
  for i = 1:length(extra_deps)
    fprintf(fid,'  %s \\\n',char(extra_deps(i)));
  end 
  fclose(fid);
  
