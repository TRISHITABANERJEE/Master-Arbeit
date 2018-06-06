function [h1, h2, h1_nl, h2_nl] = farina_deconvolution(y1,y2,xinv,CorrFac,ctrl_plot_var )
    %% Farina Deconvolution
    % Convolves the measured signals y1 and y2 with xinv and separates
    % their linear and non-linear impulse responses

    L1      = length(xinv);
    L2      = length(y1);
    Lin     = L1+L2-1;
    XINV1    = fft(xinv,Lin);
    Y1  = fft(y1,Lin);
    h1_complete = ifft(XINV1.*Y1);

    L1      = length(xinv);
    L2      = length(y2);
    Lin     = L1+L2-1;
    XINV2    = fft(xinv,Lin);
    Y2  = fft(y2,Lin);
    h2_complete = ifft(XINV2.*Y2);

    % extract linear impulse response part
    h1 =  h1_complete  (length(xinv):end)/CorrFac;
    h2 =  h2_complete  (length(xinv):end)/CorrFac;

    % extract non-linear impulse response part    
    h1_nl =  h1_complete  (1:length(xinv)-1)/CorrFac;
    h2_nl =  h2_complete  (1:length(xinv)-1)/CorrFac;
        
    if ctrl_plot_var
        figure
        subplot(2,1,1);
        plot(20*log10(abs(h1_complete)))
        title('Complete Impulse Responses')
        grid on
        ylabel('h1 \rightarrow dB')
        subplot(2,1,2);
        plot(20*log10(abs(h2_complete)))
        ylabel('h2 \rightarrow dB')
        grid on
        
        figure
        subplot(2,1,1);
        plot(20*log10(abs(h1)))
        title('Linear Impulse Responses')
        grid on
        ylabel('h1 \rightarrow dB')
        subplot(2,1,2);
        plot(20*log10(abs(h2)))
        ylabel('h2 \rightarrow dB')
        grid on
        
        figure
        subplot(2,1,1);
        plot(h1)
        title('Linear Impulse Responses')
        grid on
        ylabel('h1 \rightarrow dB')
        subplot(2,1,2);
        plot(h2)
        ylabel('h2 \rightarrow dB')
        grid on
    end
end