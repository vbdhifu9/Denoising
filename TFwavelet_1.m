function TFwavelet_1(fs,Z)

l = length(Z);
Ts = l / fs;
x = 1:1:l;
Tt = 1/fs .* x;
t=Ts:1/fs:Ts;
s=Z; 

wavename='sym4';
totalscal=512;
wcf=centfrq(wavename);
cparam=2*wcf*totalscal; 
a=totalscal:-1:1; 
scal=cparam./a; 
coefs=cwt(s,scal,wavename);
f=scal2frq(scal,wavename,1/fs);

N_gap = [15 20 50 50];
basedColor = [8	46	84;128 138 135;255 128 0;46	139	87;227 23 13];
mycamp = customized_colormap(basedColor, N_gap);
h=imagesc(Tt,f,abs(coefs));
g=get(h,'Parent');
set(g,'linewidth',1.6);
colormap(mycamp);
axis xy;
colorbar;

xlabel('Time','fontname','Times New Roman','FontSize',10);
ylabel('Frequency','fontname','Times New Roman','FontSize',10);

