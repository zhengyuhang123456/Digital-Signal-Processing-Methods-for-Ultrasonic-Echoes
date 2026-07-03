function denoised_signal = tv_denoising(noisy_signal, lambda, num_iter)
% TV_DENOISING Performs Total Variation (TV) denoising on a 1D signal.
% Minimizes ||x - y||_2^2 + lambda * ||Dx||_1
% We use the Forward-Backward Splitting (Proximal Gradient) method.
%
% Inputs:
%   noisy_signal - The input noisy signal
%   lambda       - Regularization parameter
%   num_iter     - Number of iterations for optimization
%
% Outputs:
%   denoised_signal - The TV denoised signal

    if nargin < 3
        num_iter = 100;
    end
    
    N = length(noisy_signal);
    x = noisy_signal; % Initialize with noisy signal
    
    % Step size for gradient descent (must be <= 2 / max_eigenvalue(D'D))
    % For 1D difference operator, max eigenvalue is ~4
    tau = 0.25; 
    
    for i = 1:num_iter
        % 1. Forward step: Gradient of data fidelity term ||x - y||_2^2
        % Not explicitly needed if we formulate the dual problem, but here 
        % we can use Chambolle's projection algorithm for TV.
    end
    
    % Using Chambolle's algorithm (Dual formulation) for 1D TV
    % Minimizing ||x - y||^2 + lambda*||Dx||_1
    % This handles piecewise constant signals effectively.
    
    p = zeros(N-1, 1); % Dual variable
    tau_dual = 0.25;
    
    for iter = 1:num_iter
        % Compute divergence of p
        div_p = [-p(1); -diff(p); p(end)];
        
        % Compute x from dual
        x = noisy_signal - div_p;
        
        % Compute gradient of x
        dx = diff(x);
        
        % Update p with projection step
        p = p - tau_dual * dx;
        p = p ./ max(1, abs(p) / lambda);
    end
    
    % Final reconstruction
    div_p = [-p(1); -diff(p); p(end)];
    denoised_signal = noisy_signal - div_p;
end
