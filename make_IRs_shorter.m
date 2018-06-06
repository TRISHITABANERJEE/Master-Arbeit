function [h1_short, h2_short] = make_IRs_shorter(h1_long, h2_long, Lh1, Lh2, ctrl_plot )
%% Shortens IRs to desired length without loosing parity
if isrow(h1_long)
   error('Vectors should be column vectors')    
end
if Lh1~=Lh2
    error('The code is prepared only for Lh1 equals to Lh2')
end

[~,indx_ref] = max(abs(h1_long));
[~,indx_err] = max(abs(h2_long));
indx_mid = floor((indx_ref+indx_err)/2)+1;

smpl_start = indx_mid - floor(Lh1/10);
smpl_end_h1 = smpl_start+Lh1-1;
smpl_end_h2 = smpl_start+Lh2-1;

h1_short = h1_long(smpl_start:smpl_end_h1);
h2_short = h2_long(smpl_start:smpl_end_h2);

if ctrl_plot
    figure
    subplot(2,1,1);
    plot(20*log10(abs(h1_long(smpl_start:smpl_end_h1))))
    title('Shortened Linear Impulse Responses')
    grid on
    ylabel('h1 \rightarrow dB')
    subplot(2,1,2);
    plot(20*log10(abs(h2_long(smpl_start:smpl_end_h2))))
    ylabel('h2 \rightarrow dB')
    grid on
    
    figure
    subplot(2,1,1);
    plot(h1_long(smpl_start:smpl_end_h1))
    title('Shortened Linear Impulse Responses')
    grid on
    ylabel('h1')
    subplot(2,1,2);
    plot(h2_long(smpl_start:smpl_end_h2))
    ylabel('h2')
    grid on
end


end
