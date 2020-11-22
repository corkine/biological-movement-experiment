%=========================================================================
% cbxplot_test
%=========================================================================
% USAGE:
%  cbxplot_test()
%  cbxplot_test( test_num )
%
% Use the cbxplot functions to create a variety of plots for testing
% purposes. If a test_num is specified then only that test is run,
% otherwise all of the tests are run.
%
%  - Test 1 : Single plot figure
%  - Test 2 : Multiple subplot figure
%  - Test 3 : Multiple subplot figure (with split subplots)
%  - Test 4 : Multiple subplot figure (with no inner labels)
%

function cbxplot_test( test_num )

  if ( nargin == 0 )
    test_num = 0;
  end
  
  % Generate some data

  x  = [-2*pi:0.25:2*pi];
  y1 = sin(x);
  y2 = cos(x);

  %-----------------------------------------------------------------------
  % Single plot figure
  %-----------------------------------------------------------------------

  if ( (test_num == 0) || (test_num == 1) )

    figure(1);
    cbxplot_format_fig(600,300);
    
    H = plot(x,y1,x,2.*y1,x,1+y1,1+x,y1);
    
    title('Example Plot');
    xlabel('Input');
    ylabel('Output');
    set(gca,'XLim',[-3 3]);
    set(gca,'XGrid','on','YGrid','on','GridLineStyle',':');
    
    cbxplot_format_line(H(1),4,'-','dark-red');
    cbxplot_format_line(H(2),2,'-.','dark-green','oF',8);
    cbxplot_format_line(H(3),2,'-','dark-orange','sF',8);
    cbxplot_format_line(H(4),2,':','dark-blue','s',8);
    cbxplot_format_fonts('Times',16);
    cbxplot_format_margins(0);
    cbxplot_export_pdf('cbxplot_test1');
  
  end
  
  %-----------------------------------------------------------------------
  % Multiple subplot figure
  %-----------------------------------------------------------------------
  
  if ( (test_num == 0) || (test_num == 2) )

    figure(2);
    cbxplot_format_fig(500,700);
    
    cbxplot_subplot(2,1);
    
    cbxplot_subplot(1);
    H1 = plot(x,y1,x,2.*y1,x,1+y1,1+x,y1);
  
    title('Example Plot 1');
    xlabel('Input');
    ylabel('Output');
    legend('1','2','3','4');
    set(gca,'XLim',[-3 3]);
    cbxplot_format_fonts('Times',8);
    
    cbxplot_subplot(2);
    H2 = plot(x,y2,x,2.*y2,x,1+y2,1+x,y2);
     
    title('Example Plot 2');
    xlabel('Input');
    ylabel('Output');
    legend('1','2','3','4');
    set(gca,'XLim',[-3 3]);
    cbxplot_format_fonts('Times',18);
     
    cbxplot_format_margins(0.02,0.02);
    cbxplot_export_pdf('cbxplot_test2');
     
  end
  
  %-----------------------------------------------------------------------
  % Multiple subplot figure (with split subplots)
  %-----------------------------------------------------------------------
     
  if ( (test_num == 0) || (test_num == 3) )

    figure(3);
    cbxplot_format_fig(700,500);
     
    cbxplot_subplot(2,2);
     
    cbxplot_subplot(1);
    H1 = plot(x,y1,x,2.*y1,x,1+y1,1+x,y1);
     
    title('Example Plot 1');
    xlabel('Input');
    ylabel('Output');
    set(gca,'XLim',[-3 3]);
    cbxplot_format_fonts('Times',8);
     
    cbxplot_subplot(2);
    H2 = plot(x,y2,x,2.*y2,x,1+y2,1+x,y2);
     
    title('Example Plot 2');
    xlabel('Input');
    ylabel('Output');
    set(gca,'XLim',[-3 3]);
    cbxplot_format_fonts('Times',18);
     
    cbxplot_subplot(3);
    H1 = plot(x,y1,x,2.*y1,x,1+y1,1+x,y1);
     
    title('Example Plot 3');
    xlabel('Input');
    ylabel('Output');
    set(gca,'XLim',[-3 3]);
    cbxplot_format_fonts('Times',12);
     
    cbxplot_subplot(4);
    H2 = plot(x,y2,x,2.*y2,x,1+y2,1+x,y2);
     
    title('Example Plot 4');
    xlabel('Input');
    ylabel('Output');
    set(gca,'XLim',[-3 3]);
    cbxplot_format_fonts('Times',8);
     
    cbxplot_format_margins(0.01,0.01);
    cbxplot_export_pdf('cbxplot_test3');

    H3 = cbxplot_split_subplots();
    figure(H3(1)); cbxplot_export_pdf('cbxplot_test3a');
    figure(H3(2)); cbxplot_export_pdf('cbxplot_test3b');
    figure(H3(3)); cbxplot_export_pdf('cbxplot_test3c');
    figure(H3(4)); cbxplot_export_pdf('cbxplot_test3d');
    
  end
  
  %-----------------------------------------------------------------------
  % Multiple subplot figure (with no inner labels)
  %-----------------------------------------------------------------------
     
  if ( (test_num == 0) || (test_num == 4) )

    figure(4);
    cbxplot_format_fig(700,500);
     
    cbxplot_subplot(2,2);
     
    cbxplot_subplot(1);
    H1 = plot(x,y1,x,2.*y1,x,1+y1,1+x,y1);
     
    xlabel('Input');
    ylabel('Output');
    set(gca,'XLim',[-3 3]);
    cbxplot_format_fonts('Times',16);
     
    cbxplot_subplot(2);
    H2 = plot(x,y2,x,2.*y2,x,1+y2,1+x,y2);
     
    xlabel('Input');
    ylabel('Output');
    set(gca,'XLim',[-3 3]);
    cbxplot_format_fonts('Times',16);
     
    cbxplot_subplot(3);
    H1 = plot(x,y1,x,2.*y1,x,1+y1,1+x,y1);
     
    xlabel('Input');
    ylabel('Output');
    set(gca,'XLim',[-3 3]);
    cbxplot_format_fonts('Times',16);
     
    cbxplot_subplot(4);
    H2 = plot(x,y2,x,2.*y2,x,1+y2,1+x,y2);
     
    xlabel('Input');
    ylabel('Output');
    set(gca,'XLim',[-3 3]);
    cbxplot_format_fonts('Times',16);
     
    cbxplot_delete_inner_labels();
    cbxplot_format_margins(0.01,0);
    cbxplot_export_pdf('cbxplot_test4');

  end