% MAIN: Digital Signal Processing Methods for Ultrasonic Echoes
% This script simulates an ultrasonic echo, add noise, and compares
% three denoising techniques: Bandpass Filtering, Tikhonov Regularization,
% and Total Variation (TV) Denoising.

clear; clc; close all;

%% 1. Simulation Parameters
fs = 10e6;              % Sampling frequency (10 MHz)
t_duration = 10e-6;     % Duration of 10 microseconds
f0 = 2e6;               % Center frequency of ultrasonic pulse (2 MHz)
target_snr_db = 5;       %Target SNR in dB

%% 2. Generate Signals
fprintf('Generating simulated ultrasonic echo (Target SNR = %d dB)...\n', target_snr_db);
[t, clean_signal, noisy_signal] = simulate_echo(fs, t_duration, f0, target_snr_db);

%% Calculate actual input SNR 
input_snr = 10 * log10( sum(clean_signal.^2) / sum((clean_signal - noisy_signal).^2) );
fprintf('Actual Input SNR: %.2f dB\n\n', input_snr);

%% Apply Denoising Techniques

% 3.1 Bandpass Filter
fprintf('Applying Bandpass Filter...\n');
f_low = 1e6;    %Lower cutoff 1 MHz
f_high = 3e6;   %Upper cutoff 3 MHz
order = 4;
bpf_signal = bandpass_filter(noisy_signal, fs, f_low, f_high, order);

% 3.2 Tikhonov Regularization
fprintf(['Applying Tikhonov Regularization...\n');
lambda_tikhonov = 2.0;% Regularization parameter
tikhonov_signal = tikhonov_regularization(noisy_signal, lambda_tikhonov);

% 3.3 Total Variation (TV) Denoising
fprintf('Applying TV Denoising...\n');
lambda_tv = 0.5;%TV regularization parameter
num_iter_tv = 200;
tv_signal = tv_denoising(noisy_signal, lambda_tv, num_iter_tv);










