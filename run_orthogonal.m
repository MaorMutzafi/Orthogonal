sbplt_ind = 0;
for jj=4:8
    sbplt_ind = sbplt_ind + 1 ;
fr = 1e3; 
dwn_smpl = 1; resz_fct = 2;
fs = fr / dwn_smpl;
fld = ['rec' num2str(jj)];
load([fld '\data.mat'])
nam = fld;

v_gray = imresize3(v_gray(:,:,1:dwn_smpl:end),size(v_gray)./[resz_fct,resz_fct,dwn_smpl]);
%%
% m_rct = 6; 
% cg = figure;
% imagesc(v_gray(:,:,1))
% axis equal off tight
% for ii=1:m_rct
%     [~,rect(ii,:)]=imcrop; rect(ii,:)=round(rect(ii,:));
%     s(:,ii) = squeeze(sum(v(rect(ii,2)+(0:rect(ii,4)-1),rect(ii,1)+(0:rect(ii,3)-1),:),[1,2]));
% end
% close(cg)
v_mean = mean(v_gray,3); v_mean_30 = double(v_mean>30);

% Frame1_vbox = insertObjectAnnotation(v_gray(:,:,1),'rectangle',rect,'',...
%     'TextBoxOpacity',0.1,'FontSize',40,'TextColor',[0 0 0]+255,'Color',lines(m_rct)*255,'LineWidth',3);
%%
op1 = 2;
if op1 == 1
% s_nrm = s-mean(s); s_nrm = s_nrm./sum(s_nrm.^2).^.5;
% [S, f, ph] = absfft(s_nrm, fs); S = S(end/2+1:end,:); f = f(end/2+1:end); 
[V, f, Vph] = absfft(v_gray, fs, 3);
% fourier_op = exp(2i*pi*(0:998)/999.*(100+(-1:1)'))'./999^.5;
% v_gray(:,:,1e3)=0;
% fourier_op = exp(2i*pi*(0:998)/999.*(100+(-1:1))').';
% V = abs(reshape(double(reshape(v_gray,[],999))*fourier_op,size(v_gray,1),size(v_gray,2),[]));

ind_f100 = find(abs(f-100)<1.01*min(abs(f-100))); 
df = f(2)-f(1);
f100 = f(ind_f100);

V = V(:,:,ind_f100+(-1:1)); Vph = Vph(:,:,ind_f100+(-1:1));
DF = convn(V,permute([-1 0 1],[3 1 2]),'valid')./convn(V,permute([1 -2 1],[3 1 2]),'valid');
DF(abs(DF)>3 | isnan(DF)) = 0;
DF_30 = v_mean_30.*DF;
else
    v_sz = size(v_gray); ns = 2^14;
    [V, f, Vph] = absfft(v_gray, fs, 3, ns);
    df = f(2)-f(1);
    f99_101 = find(f>97 & f<103); 

%     ns = 2^8; f2 = (-.5:1/ns:(.5-1/ns))*fs; df = fs/ns;  
%     F = exp(-2i*pi*(0:ns-1)'*(0:ns-1)/ns);
%     x = randn(ns,1) + 1i*randn(ns,1);
%     y1 = F*x;
%     y2 = fft(x);
% for it=1:ns
%     f2_99_101 = (0:1)+it;
%     fourier_op = exp(2i*pi*(0:v_sz(3)-1)/ns.*f2_99_101')';
%     V2 = abs(reshape(double(v_gray),[],v_sz(3))*fourier_op);
%     ts(it) = norm(V3(:)-V2(:));
%     semilogy(ts)
%     drawnow
% end
%     V3 = reshape(V(:,:,f99_101),[],length(f99_101)); 
    V = reshape(V(:,:,f99_101),[],length(f99_101)); 
    Vt=V';
    [~,ind]=max(V,[],2);
    ind2 = ind(:) + (0:(v_sz(1)*v_sz(2)-1))'*32;
%     v3 = Vt(ind2);
    V_DF = conv2(-1:1,1,Vt,'same')./conv2([1 -2 1],1,Vt,'same');
%     V_DF = permute(convn(V(:,:,f99_101),permute([-1 0 1],[3 1 2]),'same')./convn(V(:,:,f99_101),permute([1 -2 1],[3 1 2]),'same'),[3 1 2]);
    DF = reshape(f(f99_101(1) + ind) + df*V_DF(ind2)',v_sz(1),[]);
%     DF(abs(DF)>3 | isnan(DF)) = 0;
    DF_30 = v_mean_30.*(DF-100);
end
%%
DF_30_med = medfilt2(DF_30,[5,5]);
% DF_30_med = ordfilt2(DF_30,100,true(10));
% DF_30_med(DF_30_med==0) = mean(DF_30_med(DF_30_med~=0));
subplot(5,1,sbplt_ind)
ga = imagesc(DF_30_med);
title(nam)
colormap(hot)
axis equal tight off
ga.Parent.CLim=[-1 1]*.4;
drawnow
end
% ga.Parent.CLim=[-.1 .1]/2;
%%

% [f100 + df/2*conv2([-1 0 1],1,S(ind_f100+(-1:1),:),'valid')...
%     ./conv2([1 -2 1],1,S(ind_f100+(-1:1),:),'valid')]
%%
% cls = 1; try ca101.Color; catch cls=0; end; if cls; close(ca101); end
% ca101 = figure(101);
% 
% axes('Position',[0 0 1 size(Frame1_vbox,1)/size(Frame1_vbox,2)*2]);
% imagesc(Frame1_vbox)
% axis equal off tight
% 
% axes('Position',[.05 .15 .93 .4]);
% plot(f,ph)
% leg = legend(num2str((1:6)'));
% axes('Position',[.05 .6 .93 .4]);
% 
% n_flt = 150; frq_flt = [0 .08 .12 1]; a = [0 1 0]; d = 1e-3;
% b = fircls(n_flt,frq_flt,a,a+d,a-d);
% plot(conv2(b,1,s_nrm,'valid'))
% % xlim([1 200])
% legend(num2str((1:6)'))