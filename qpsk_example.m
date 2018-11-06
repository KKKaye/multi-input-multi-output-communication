%QPSK_AWGN.m Simulate the BER performance of QPSK in AWGN channels
clear all;
close all;
%M-PSK
M=4;
%Number of bits per symbol
k=log2(M);
%Total number of symbols per block
N_sym=10000;
%Total number of bits per block
N_bit=k*N_sym;
%Maximum number of blocks to simulate
N_block=100;
%Fix the symbol energy to 1
Es=1;
%Calculate bit energy
Eb=Es/k;
%Eb/N0 in dB
Eb_N0_dB=0:1:10;
%Convert Eb/N0 into the linear scale
Eb_N0=10.^(Eb_N0_dB/10);
%Calculate the corresponding noise power spectral density
N0=Eb./Eb_N0;
%Number of different SNRs
len_EbN0=length(Eb_N0);
%Eb/N0 index pointer
EbN0_pointer=1;
temp_EbN0_pointer=EbN0_pointer;
%Number of errors counted for each Eb/N0
errs=zeros(1,len_EbN0);
%Number of blocks simulated for each Eb/N0
block_count=zeros(1,len_EbN0);
%While the Eb/N0 index pointer has not reached the last value, and the
%number of blocks has not exceeded the maximum number, N_block,
%do the iterations
while (EbN0_pointer <= len_EbN0) && (block_count(len_EbN0) < N_block)
    %Generate a binary bit sequence
    B=round(rand(1,N_bit));
    %Demultiplexed bit sequence in the form of 0 and 1
    Dm=reshape(B,k,N_sym);
    
    D = Dm(1,:)+1i*Dm(2,:);
    %Transmitted signal after bipolar NRZ encoding.
    %1 is mapped to sqrt(Eb); 0 is mapped to -sqrt(Eb).
    Tx_data = sqrt(Eb) * (2*D-(1+1i));
    %AWGN with normalised power 1
    Noise=sqrt(0.5)*(randn(1, N_sym)+1i*randn(1, N_sym));
    
    %Simulate different Eb/N0 values
    for n = EbN0_pointer : len_EbN0
        %Received signal. The noise power is N0(n).
        Rx_data = Tx_data + sqrt(N0(n))*Noise;
        
        %Recover the transmitted data from the received data.
        %sign is used as a decision device with threshold 0.
        %If the input signal is >0, sign output is 1; otherwise sign output is -1.
        Recov_Tx_data= sqrt(Eb)*(sign(real(Rx_data))+1i*sign(imag(Rx_data)));
        
        %Get recovered demultiplexed bit sequence.
        Recov_D = 0.5*(1+1i+Recov_Tx_data/sqrt(Eb));
        
        %Count the number of errors
        errs(n)= errs(n)+sum(abs(Recov_D-D).^2);
        %If more than 500 errors have been counted, move the Eb/N0
        %index pointer to the next Eb/N0
        if errs(n)>=500
            temp_EbN0_pointer = temp_EbN0_pointer+1;
        end
        %Update the nubmer of blocks simulated
        block_count(n)=block_count(n)+1;
    end
    
    %Update Eb/N0 pointer
    EbN0_pointer=temp_EbN0_pointer;
    
    block_count
end

%Calculate the numerical BERs for different Eb/N0's. Each block has N_bit bits.
Num_BER = errs./(N_bit*block_count);
%Calculate the analytical BERs for different Eb/N0's
% Ana_BER=Q(sqrt(2*Eb_N0));
figure;
semilogy(Eb_N0_dB, Num_BER, '-s');
% hold on;
% semilogy(Eb_N0_dB, Ana_BER, 'r-*');
grid on;
legend('Numerical BER');
title('QPSK in AWGN Channels');
xlabel('Eb/N0 (dB)');
ylabel('BER');
