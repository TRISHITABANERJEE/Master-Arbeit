function [h1_fadedin, h2_fadedin] = fadein_IRs(h1,h2,len,ctrl_plot)    

    t = 0:1/2*pi/(len-1):1/2*pi;
    fadein = flipud(cos(t)');
    
    h1_fadedin             = h1;
    h1_fadedin(1:len)      = h1(1:len)          .*fadein;
    h2_fadedin             = h2;
    h2_fadedin(1:len)      = h2(1:len)          .*fadein;

    if ctrl_plot
    figure;
    subplot(2,1,1)
    plot(20*log10(abs(h1)),'k');hold on
    plot(20*log10(abs(h1_fadedin)),'r');hold off
    title('Fade-in of h1 and h2')
    ylabel('h1 in dB \rightarrow')
    subplot(2,1,2)
    plot(20*log10(abs(h2)),'k');hold on
    plot(20*log10(abs(h2_fadedin)),'r');hold off
    ylabel('h2 in dB \rightarrow')
    end
    
end