close all
clear
clc

number_of_bits = 1e5;
% Create modulaation signnls
ASK_tx = NaN(1,number_of_bits); 
PSK_tx = NaN(1,number_of_bits); 
FSK_tx = NaN(1,number_of_bits); 
QAM_tx = NaN(2,number_of_bits); 

% create random bits
ASK_bits= randi([0,1],1,number_of_bits);
PSK_bits = randi([0,1],1,number_of_bits);
FSK_bits = randi([0,1],1,number_of_bits);
QAM_bits = randi([0,1],2,number_of_bits);


% TRANSMITTER SECTION -----------------------------------------------------
% For ASK; and assign 0 if bit is 0, +1 if bit is 1
for i=1:number_of_bits
    if ASK_bits(i)==0
        ASK_tx(i)=0;
    else
        ASK_tx(i)=1;
    end
end

% For PSK; and assign -1 if bit is 0, +1 if bit is 1
for i=1:number_of_bits
    if PSK_bits(i)==0
        PSK_tx(i)=-1;
    else
        PSK_tx(i)=1;
    end
end

% For FSK; and assign -1 if bit is 0, +1 if bit is 1
for i=1:number_of_bits
    if FSK_bits(i)==0
        FSK_tx(i)=0;
    else
        FSK_tx(i)=1;
    end
end

% For QAM; and assign (1,1) if bit is 00, (-1,1) if bit is 01
% (-1,-1) if bit is 10, (1,-1) if bit is 11
for i=1:number_of_bits

    if QAM_bits(1,i)==0 && QAM_bits(2,i)==0
        QAM_tx(1,i)=1;
        QAM_tx(2,i)=1;

    elseif QAM_bits(1,i)==0 && QAM_bits(2,i)==1
        QAM_tx(1,i)=-1;
        QAM_tx(2,i)=1;

    elseif QAM_bits(1,i)==1 && QAM_bits(2,i)==1
        QAM_tx(1,i)=-1;
        QAM_tx(2,i)=-1; 

    else
        QAM_tx(1,i)=1;
        QAM_tx(2,i)=-1;
    end
end


%RECEIVER SECTION----------------------------------------------------------

SNR = 0:1:20;              % SNR Value which is Eb/No (dB)
Eb_No = 10.^(SNR./10);     % Convert the SNR in dB to its linear SNR equivalent.

% reveiver bit array
ASK_rx = NaN(1,number_of_bits); 
PSK_rx = NaN(1,number_of_bits); 
FSK_rx = NaN(1,number_of_bits); 
QAM_rx = NaN(2,number_of_bits); 

% Bit Error Rates for each SNR
ASK_ber = NaN(1,21);
PSK_ber = NaN(1,21);
FSK_ber = NaN(1,21);
QAM_ber = NaN(1,21);

k=1;
for SNR_iteration = 0:1:20

    %Calculate error bits for Binary ASK
    received_signal = awgn(ASK_tx,SNR_iteration,'measured');
    for j=1:number_of_bits
        if received_signal(j) > 0.5
            ASK_rx(j) = 1;
        else
            ASK_rx(j) = 0;
        end
    end

    %Calculate error bits for Binary PSK
    received_signal = awgn(PSK_tx,SNR_iteration,'measured');
    for j=1:number_of_bits
        if received_signal(j) > 0
            PSK_rx(j)=1;
        else
            PSK_rx(j)=0;
        end
    end

    %Calculate error bits for Binary FSK
    received_signal = awgn(FSK_tx,SNR_iteration,'measured');
    for j=1:number_of_bits
        if received_signal(j) > 0.5
            FSK_rx(j)=1;
        else
            FSK_rx(j)=0;
        end
    end

    % For QAM; and assign (1,1) if bit is 00, (-1,1) if bit is 01
    % (-1,-1) if bit is 10, (1,-1) if bit is 11

    %Calculate error bits for QAM
    received_signal = awgn(QAM_tx,SNR_iteration,'measured');
    for j=1:number_of_bits

        if received_signal(1,j) > 0 && received_signal(2,j) > 0
            QAM_rx(1,j)=0;
            QAM_rx(2,j)=0;

        elseif received_signal(1,j) < 0 && received_signal(2,j) > 0
            QAM_rx(1,j)=0;
            QAM_rx(2,j)=1;

        elseif received_signal(1,j) < 0 && received_signal(2,j) < 0
            QAM_rx(1,j)=1;
            QAM_rx(2,j)=1;

        else
            QAM_rx(1,j)=1;
            QAM_rx(2,j)=0;
        end
    end

    % Calculate Bit Error Rates
    error = length(find(ASK_rx ~= ASK_bits));
    ASK_ber(k)=error/number_of_bits;

    error = length(find(PSK_rx ~= PSK_bits));
    PSK_ber(k)=error/number_of_bits;

    error = length(find(FSK_rx ~= FSK_bits));
    FSK_ber(k)=error/number_of_bits;

    error = length(find(QAM_rx ~= QAM_bits));
    QAM_ber(k)=error/(number_of_bits*2);

    k=k+1;
end

% Plot Graps
semilogy(SNR, ASK_ber, Color = "r", Marker = "square", LineWidth=2);
hold on
semilogy(SNR, PSK_ber, Color = "g", Marker = "^", LineWidth=2);
semilogy(SNR, FSK_ber, Color = "b", Marker = "*", LineWidth=2, LineStyle = "--");
semilogy(SNR, QAM_ber,  Color = "m", Marker = "x", LineWidth=2);

legend("BASK", "BPSK", "BFSK", "QAM");
grid on
title('Simulation Results of SNR-BER Graph');
xlabel('Signal to Noise Ratio in dB');
ylabel('Bit Error Rate');
hold off

