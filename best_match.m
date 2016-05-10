function [ best_i, best_j ] = best_match( A_pyramid, A_prime_pyramid, B_pyramid, B_prime_pyramid,...
         s_pyramid, A_features, B_features, l, L, i, j)
%BEST_MATCH ...
%           The pixel (i,j) passed in is in terms of NON-EXTENDED pyramid

global N_BIG;
global kappa;

[best_app_i, best_app_j] = best_approximate_match(A_features, A_pyramid, ...
B_pyramid, B_features, l, i, j);
[h, w, ~] = size(B_pyramid{l});
if i <= 4 || j <= 4 || i >= h-4 || j >=w-4
  best_i = best_app_i;
  best_j = best_app_j;
  return
end

[best_coh_i, best_coh_j] = best_coherence_match(A_pyramid, A_prime_pyramid, ...
        B_pyramid, B_prime_pyramid, s_pyramid, l, L, i, j);

F_p_app = concat_feature(A_pyramid, A_prime_pyramid, l, ... 
  best_app_i, best_app_j, L);

F_p_coh = concat_feature(A_pyramid, A_prime_pyramid, l, best_coh_i, best_coh_j, L);

F_q = concat_feature(B_pyramid, B_prime_pyramid, l, i, j, L);

d_app = sum((F_p_app(:) - F_q(:)).^2);
d_coh = sum((F_p_coh(:) - F_q(:)).^2);

    
if d_coh <= d_app * (1 + 2^(l - L)*kappa)
  best_i = best_coh_i;
  best_j = best_coh_j;
%   'coh'
else
  best_i = best_app_i;
  best_j = best_app_j;
%   'app'
end
if A_prime_pyramid{l}(best_i, best_j, 1) < 0.2
%     best_i
%     best_j
  
end




% TODO: for now just return best_app_i, best_app_j for testing
% Once this works we can add in coherence to complete the algorithm.
% best_i = best_app_i;
% best_j = best_app_j;

% best_i = best_coh_i;
% best_j = best_coh_j;

% Convert back? Don't think is necessary.
% best_i = best_i - floor(N_BIG/2);
% best_j = best_j - floor(N_BIG/2);

end

