function run_gui()
% RUN_GUI Launches an interactive application for the Ultrasonic Echo project.
% Allows dynamic real-time adjustment of the Signal-to-Noise Ratio (SNR) 
% via a slider, instantly applying the denoising algorithms and plotting results.

    % --- Simulation Parameters ---
    fs = 10e6;           % Sampling frequency (10 MHz)
    t_duration = 10e-6;  % Duration of 10 microseconds
    f0 = 2e6;            % Center frequency of ultrasonic pulse (2 MHz)
    
    % Initial SNR
    current_snr = 5;

    % --- Create UI Figure ---
    fig = uifigure('Name', 'Ultrasonic Echo Signal Processing', 'Position', [100, 100, 1000, 800]);
    
    % --- UI Layout ---
    gl = uigridlayout(fig, [6, 1]);
    gl.RowHeight = {'1x', '1x', '1x', '1x', '1x', 50};
    
    % Create axes
    ax1 = uiaxes(gl); title(ax1, 'Original Clean Signal'); ylabel(ax1, 'Amplitude'); grid(ax1, 'on');
    ax2 = uiaxes(gl); title(ax2, 'Noisy Signal'); ylabel(ax2, 'Amplitude'); grid(ax2, 'on');
    ax3 = uiaxes(gl); title(ax3, 'Bandpass Filter'); ylabel(ax3, 'Amplitude'); grid(ax3, 'on');
    ax4 = uiaxes(gl); title(ax4, 'Tikhonov Regularization'); ylabel(ax4, 'Amplitude'); grid(ax4, 'on');
    ax5 = uiaxes(gl); title(ax5, 'Total Variation Denoising'); xlabel(ax5, 'Time (\mus)'); ylabel(ax5, 'Amplitude'); grid(ax5, 'on');
    
    % Create control panel at the bottom
    pnl = uipanel(gl);
    pnl_gl = uigridlayout(pnl, [1, 2]);
    pnl_gl.ColumnWidth = {150, '1x'};
    
    lbl = uilabel(pnl_gl, 'Text', sprintf('Target SNR: %d dB', current_snr), 'FontWeight', 'bold');
    
    sld = uislider(pnl_gl);
    sld.Limits = [-5, 20];
    sld.Value = current_snr;
    sld.ValueChangedFcn = @(src, event) update_simulation(src.Value);
    
    % --- Run Initial Simulation ---
    update_simulation(current_snr);
    
    % --- Callback Function ---
    % update_simulation: Recalculates and redraws plots based on new SNR
    function update_simulation(snr_val)
        lbl.Text = sprintf('Target SNR: %d dB', round(snr_val));
        
        % 1. Generate Signals
        [t, clean_signal, noisy_signal] = simulate_echo(fs, t_duration, f0, snr_val);
        input_snr = 10 * log10( sum(clean_signal.^2) / sum((clean_signal - noisy_signal).^2) );
        
        % 2. Apply Filters
        bpf_signal = bandpass_filter(noisy_signal, fs, 1e6, 3e6, 4);
        tikhonov_signal = tikhonov_regularization(noisy_signal, 2.0);
        tv_signal = tv_denoising(noisy_signal, 0.5, 200);
        
        % 3. Calculate SNRs
        bpf_snr = 10 * log10( sum(clean_signal.^2) / sum((clean_signal - bpf_signal).^2) );
        tik_snr = 10 * log10( sum(clean_signal.^2) / sum((clean_signal - tikhonov_signal).^2) );
        tv_snr = 10 * log10( sum(clean_signal.^2) / sum((clean_signal - tv_signal).^2) );
        
        % 4. Update Plots
        plot(ax1, t*1e6, clean_signal, 'k', 'LineWidth', 1.5);
        
        plot(ax2, t*1e6, noisy_signal, 'r');
        title(ax2, sprintf('Noisy Signal (Actual SNR: %.2f dB)', input_snr));
        
        plot(ax3, t*1e6, bpf_signal, 'b');
        title(ax3, sprintf('Bandpass Filter (Output SNR: %.2f dB)', bpf_snr));
        
        plot(ax4, t*1e6, tikhonov_signal, 'm');
        title(ax4, sprintf('Tikhonov Regularization (Output SNR: %.2f dB)', tik_snr));
        
        plot(ax5, t*1e6, tv_signal, 'g');
        title(ax5, sprintf('Total Variation Denoising (Output SNR: %.2f dB)', tv_snr));
    end
end
