call
SetDefualtPlotParams

roi = [1704 652];
fs = 1023;
% roi = [40 0 232];
% fold_name = 'Capture 7';
% fid = fopen(['C:\Users\Lenovo\Downloads\Mafaat_new_Topics\orthogonal\Exp2\data\' fold_name '.raw']);
% y = fread(fid,inf,'uint16=>uint16');
% fclose(fid);
% y = reshape(y,roi(1),roi(2),[]);

file_lst = ls('data\capture 7\*.tif');
for ii=1:size(file_lst,1)
    y(:,:,ii) = imread(['data\capture 7\' file_lst(ii,:)]);
end

ys = imresize3(y,size(y)./[4 4 1]);
%%
stps = 50; intrv_dur = 400;
iimax = floor(size(y,3)/stps - intrv_dur/stps + 1);
d_out2 = zeros(size(ys,1),size(ys,2),iimax);

for ii=1:iimax
    inds = (ii-1)*stps + (1:intrv_dur);
    d_out2(:,:,ii) = orthogonal_alg2(ys(:,:,inds),fs);
    disp(ii/iimax);
end

%%
% subplot(212)
fig1 = figure('Position',[438 25 1106 970]);
ax1 = axes(...
    'Position',[0.00534701579069423 0.01 0.991216558092467 0.438399513266291]);
mm = imread('C:\Users\Lenovo\Downloads\Mafaat_new_Topics\orthogonal\Exp2\WhatsApp Image 2020-12-10 at 16.42.16.jpeg');
imagesc(mm)
axis equal off tight

v = VideoWriter('Capture 6 - Max frq.avi','Motion JPEG AVI');
v.FrameRate = 5;
open(v)

ax2 = axes(...
    'Position',[0.00534701579069423 0.52485768633649 0.991216558092467 0.438399513266291]);
for ii=1:iimax
% subplot(211)
imagesc(d_out2(:,:,ii))
title('Capture 6 - Max frq.')
caxis([-1 1])
% colorbar
axis equal off tight
pause(.1)
writeVideo(v,getframe(gcf));
end
close(v)