close all
clear
clc

SNR = 0:1:20;              % SNR Value which is Eb/No (dB)
Eb_No = 10.^(SNR./10);     % onvert the SNR in dB to its linear SNR equivalent.

% We know that;
% BER for Binary ASK is: Q(sqrt(Eb/No))
% BER for Binary PSK is: Q(sqrt(2*Eb/No))
% BER for Binary FSK is: Q(sqrt(Eb/No))
% BER for QAM is       : 2*Q(sqrt(2*Eb/No)) - Q^2(sqrt(2*Eb/No)

BER_BASK = qfunc(sqrt(Eb_No));      % Calculate BER for ASK
BER_BPSK = qfunc(sqrt(2*Eb_No));    % Calculate BER for PSK
BER_BFSK = qfunc(sqrt(Eb_No));      % Calculate BER for FSK
BER_QAM  = 2.*qfunc(sqrt(2*Eb_No)) - qfunc(sqrt(2*Eb_No)) .* qfunc(sqrt(2*Eb_No)); % Calculate BER for QAM

% Plot Graps
semilogy(SNR, BER_BASK, Color = "r", Marker = "square", LineWidth=2);
hold on
semilogy(SNR, BER_BPSK, Color = "g", Marker = "^", LineWidth=2);
semilogy(SNR, BER_BFSK, Color = "b", Marker = "*", LineWidth=2, LineStyle = "--");
semilogy(SNR, BER_QAM,  Color = "m", Marker = "x", LineWidth=2);

legend("BASK", "BPSK", "BFSK", "QAM");
grid on
title('Theoretical SNR-BER Graph');
xlabel('Signal to Noise Ratio in dB');
ylabel('Bit Error Rate');
hold off

