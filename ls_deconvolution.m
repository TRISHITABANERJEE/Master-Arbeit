function [h_ls, drc] = ls_deconvolution(h1,h2,Lp,Lh1,Lh2,single_precision_ctrl)
%% derivation of primary path with LS

% operates on single precision 
if single_precision_ctrl
    h1 = single(h1);
    h2 = single(h2);
end

% match L2 = L1 + Lp -1
L2_zp = Lh1 + Lp - 1 - Lh2;
h2 = [h2;zeros(L2_zp,1)];

save('h2_to_mem_prim.mat','h2');
clear h2

% create an h1 for the dirac check
h1_zp = [h1 ; zeros(Lp-1,1)];

save('h1_zp_to_mem_prim.mat','h1_zp');
clear h1_zp

%H1inv = (H1'*H1)\(H1');
H1inv = pinv(convmtx(h1,Lp));
clear h1

% this calculation should be a perfect dirac
load('h1_zp_to_mem_prim.mat')
drc = H1inv*h1_zp;
save('drc_to_mem_prim.mat','drc','-v7.3')
clear drc h1_zp

% find (primary path) h3 = (H1'*H1)\(H1')*h2
load('h2_to_mem_prim.mat');
h_ls = H1inv*h2;
% reload drc for the output
load('drc_to_mem_prim.mat')
end