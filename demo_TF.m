
clc
clear 
close all

m=cell2mat(struct2cell(load('Noisy.mat')))
data.org = m; 
data_e=cell2mat(struct2cell(load('Pure.mat')))
%%%%%%%%%%%%%%%%%%%%%%%   Parameters input
sample = 6000;  % Sampling rate of seismic record
opt.f_s = 20;   % The cut-off frequency1 
opt.f_e =80;%  The cut-off frequency2
%%%%%%%%%%%%%%%%%% 
opt.dt = 1/sample; 
opt.nrs = 10;
opt.nnum = 0.7;
[Tx_e, f] = wsst(data_e,sample);
Lg = length(data_e);
timeg =(1:Lg)/sample;
opt.dt = 1/sample; 
t1 = opt.dt : opt.dt: length(timeg)*opt.dt;%
%%  input denoising parameters 
opt.ecdf_thre = 0.99; % ECDF threshold
opt.bwconn = 8;    %  4 or 8
[dn] = Thresholding_denoising(data, opt);
t = opt.dt : opt.dt: length(data_e)*opt.dt;
%%  Hard and soft thresholding
m=cell2mat(struct2cell(load('matlab_noisy_10.mat')))
org_data = m;
type1 = 'hard';
[dn1.hard_Tx, dn1.hard_dw] = dn_Thresh(org_data, type1, sample);
type2 = 'soft';
[dn1.soft_Tx, dn1.soft_dw] = dn_Thresh(org_data, type2, sample);
%%  Band-pass filtering
input = m;
low_f =30;
high_f = 400;
filter_type =0.01;
[bp_dw] = Two_D_filter_bp(input,1/sample,low_f,high_f,filter_type);
%% wavelet denoising
 X6=wden(m,'heursure','h','mln',5,'sym8');
%%
xmax = 0.4;
cmax = 0.5;
fontsize1 = 15;
fontsize2 = 25;
line_w1 = 1;
line_w2 = 0.5;
%%
gcolorR1 = [0.5 0 0];
gcolorR = [0.8 0.15 0.2];
gcolorR2 = [1 0 0];
gcolorG = [0.25 0.45 0.2];
gcolorB = [0 0.44 0.74];
gcolorQ = [1 0 1];
gcolorL = [0 0 0.6];
ClimMax = 3;
YMax = 600;
sampfre = 0.25;
fs = 6000;
figure(1)
[ha,pos]=tight_subplot(6,2,[.06 .1],[.08 .04],[.12 .12]);
axes(ha(1))
data_e = data_e./max(abs(data_e));   % Normalized
plot(t1, data_e, 'color',[0.06275 0.30588 0.5451],'linewidth',1.5);
xlim([0 0.3]);
ylim([-1 1]);
ylabel('Amplitude','FontWeight','bold','fontname','Times New Roman','FontSize', 12);
set(gca, 'xtick',[0:0.1:0.3],'xticklabel',[0:0.1:0.3] , 'fontsize', fontsize1+2, 'linewidth', line_w2,'fontname','Times New Roman');
title('Original signal','fontname','Times New Roman','FontSize',25)
text(0,0.8,'(a-1)','FontWeight','bold','fontname','Times New Roman','FontSize',30);
grid off;
axes(ha(2))
TFwavelet_1(fs,data_e);
ylim([0 3000]);
xlim([0 0.3]);
xlabel('');
ylabel('Frequency (Hz)','FontWeight','bold','fontname','Times New Roman','FontSize', 12);
set(gca, 'xtick',[0:0.1:0.3],'xticklabel',[0:0.1:0.3] , 'fontsize', fontsize1+2, 'linewidth', line_w2,'fontname','Times New Roman');
text(0,2700,'(a-2)','FontWeight','bold','color','w','fontname','Times New Roman','FontSize',30);
set(gca,'Clim',[0, ClimMax]);
c=colorbar;
set(c,'YTick',0:1.5:3);
set(c,'YTickLabel',{'0','0.5','1'});
axes(ha(3))
m = m./max(abs(m)); 
plot(t1, m, 'color',[0.06275 0.30588 0.5451],'linewidth',1.5);
xlim([0 0.3]);
xlabel('');
ylim([-1 1]);
ylabel('Amplitude','FontWeight','bold','fontname','Times New Roman','FontSize', 12);
set(gca, 'xtick',[0:0.1:0.3],'xticklabel',[0:0.1:0.3] , 'fontsize', fontsize1+2, 'linewidth', line_w2,'fontname','Times New Roman');
title('Noisy signal','fontname','Times New Roman','FontSize',25)
text(0,0.8,'(b-1)','FontWeight','bold','fontname','Times New Roman','FontSize',30);
grid off;
axes(ha(4))
TFwavelet_1(fs,m);
ylim([0 3000]);
xlim([0 0.3]);
xlabel('');
ylabel('Frequency (Hz)','FontWeight','bold','fontname','Times New Roman','FontSize', 12);
set(gca, 'xtick',[0:0.1:0.3],'xticklabel',[0:0.1:0.3] , 'fontsize', fontsize1+2, 'linewidth', line_w2,'fontname','Times New Roman');
text(0,2700,'(b-2)','FontWeight','bold','color','w','fontname','Times New Roman','FontSize',30);
set(gca,'Clim',[0, ClimMax]);
c=colorbar;
set(c,'YTick',0:1.5:3);
set(c,'YTickLabel',{'0','0.5','1'});
axes(ha(5))
bp_dw = bp_dw./max(abs(bp_dw));  
plot(t1, bp_dw, 'color',[0.06275 0.30588 0.5451],'linewidth',1.5);
xlim([0 0.3]);
xlabel('');
ylim([-1 1]);
ylabel('Amplitude','FontWeight','bold','fontname','Times New Roman','FontSize', 12);
set(gca, 'xtick',[0:0.1:0.3],'xticklabel',[0:0.1:0.3] , 'fontsize', fontsize1+2, 'linewidth', line_w2,'fontname','Times New Roman');
title('BP denoising','fontname','Times New Roman','FontSize',25)
text(0,0.8,'(c-1)','FontWeight','bold','fontname','Times New Roman','FontSize',30);
grid off;
axes(ha(6))
TFwavelet_1(fs,bp_dw);
ylim([0 3000]);
xlim([0 0.3]);
xlabel('');
ylabel('Frequency (Hz)','FontWeight','bold','fontname','Times New Roman','FontSize', 12);
set(gca, 'xtick',[0:0.1:0.3],'xticklabel',[0:0.1:0.3] , 'fontsize', fontsize1+2, 'linewidth', line_w2,'fontname','Times New Roman');
text(0,2700,'(c-2)','FontWeight','bold','color','w','fontname','Times New Roman','FontSize',30);
set(gca,'Clim',[0, ClimMax]);
c=colorbar;
set(c,'YTick',0:1.5:3);
set(c,'YTickLabel',{'0','0.5','1'});
axes(ha(7))
X6 = X6./max(abs(X6)); 
plot(t, X6, 'color',[0.06275 0.30588 0.5451],'linewidth',1.5);
xlim([0 0.3]);
xlabel('');
ylim([-1 1]);
ylabel('Amplitude','FontWeight','bold','fontname','Times New Roman','FontSize', 12);
set(gca, 'xtick',[0:0.1:0.3],'xticklabel',[0:0.1:0.3] , 'fontsize', fontsize1+2, 'linewidth', line_w2,'fontname','Times New Roman');
title('Wavelet denoising','fontname','Times New Roman','FontSize',25)
text(0,0.8,'(d-1)','FontWeight','bold','fontname','Times New Roman','FontSize',30);
grid off;
axes(ha(8))
TFwavelet_1(fs,X6);
ylim([0 3000]);
xlim([0 0.3]);
xlabel('');
ylabel('Frequency (Hz)','FontWeight','bold','fontname','Times New Roman','FontSize', 12);
set(gca, 'xtick',[0:0.1:0.3],'xticklabel',[0:0.1:0.3] , 'fontsize', fontsize1+2, 'linewidth', line_w2,'fontname','Times New Roman');
text(0,2700,'(d-2)','FontWeight','bold','color','w','fontname','Times New Roman','FontSize',30);
set(gca,'Clim',[0, ClimMax]);
c=colorbar;
set(c,'YTick',0:1.5:3);
set(c,'YTickLabel',{'0','0.5','1'});
axes(ha(9))
dn1.soft_dw = dn1.soft_dw./max(abs(dn1.soft_dw)); 
plot(t, dn1.soft_dw, 'color',[0.06275 0.30588 0.5451],'linewidth',1.5);
xlim([0 0.3]);
ylim([-1 1]);
ylabel('Amplitude','FontWeight','bold','fontname','Times New Roman','FontSize', 12);
set(gca, 'xtick',[0:0.1:0.3],'xticklabel',[0:0.1:0.3] , 'fontsize', fontsize1+2, 'linewidth', line_w2,'fontname','Times New Roman');
title('Soft denoising','fontname','Times New Roman','FontSize',25)
text(0,0.8,'(e-1)','FontWeight','bold','fontname','Times New Roman','FontSize',30);
grid off;
axes(ha(10))
TFwavelet_1(fs,dn1.soft_dw);
ylim([0 3000]);
xlim([0 0.3]);
xlabel('');
ylabel('Frequency (Hz)','FontWeight','bold','fontname','Times New Roman','FontSize', 12);
set(gca, 'xtick',[0:0.1:0.3],'xticklabel',[0:0.1:0.3] , 'fontsize', fontsize1+2, 'linewidth', line_w2,'fontname','Times New Roman');
text(0,2700,'(e-2)','FontWeight','bold','color','w','fontname','Times New Roman','FontSize',30);
set(gca,'Clim',[0, ClimMax]);
c=colorbar;
set(c,'YTick',0:1.5:3);
set(c,'YTickLabel',{'0','0.5','1'});
axes(ha(11))
plot(t1, dn.dw, 'color',[0.06275 0.30588 0.5451],'linewidth',1.5);
xlim([0 0.3]);
ylim([-1 1]);
xlabel({'Time (s)'},'fontsize', fontsize1,'fontweight', 'bold');
ylabel('Amplitude','FontWeight','bold','fontname','Times New Roman','FontSize', 12);
set(gca, 'xtick',[0:0.1:0.3],'xticklabel',[0:0.1:0.3] , 'fontsize', fontsize1+2, 'linewidth', line_w2,'fontname','Times New Roman');
title('The proposed method','fontname','Times New Roman','FontSize',25)
text(0,0.8,'(f-1)','FontWeight','bold','fontname','Times New Roman','FontSize',30);
grid off;
axes(ha(12))
TFwavelet_1(fs,dn.dw);
ylim([0 3000]);
xlim([0 0.3]);
ylabel('Frequency (Hz)','FontWeight','bold','fontname','Times New Roman','FontSize', 12);
xlabel({'Time (s)'},'fontsize', fontsize1,'fontweight', 'bold');
set(gca, 'xtick',[0:0.1:0.3],'xticklabel',[0:0.1:0.3] , 'fontsize', fontsize1+2, 'linewidth', line_w2,'fontname','Times New Roman');
text(0,2700,'(f-2)','FontWeight','bold','color','w','fontname','Times New Roman','FontSize',30);
set(gca,'Clim',[0, ClimMax]);
c=colorbar;
set(c,'YTick',0:1.5:3);
set(c,'YTickLabel',{'0','0.5','1'});






