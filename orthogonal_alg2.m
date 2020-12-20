function [DF_30] = orthogonal_alg2(v_gray,fs)
    v_mean = mean(v_gray,3); v_mean_30 = double(v_mean>(max(v_mean(:))*.3));
    v_sz = size(v_gray); ns = 2^16;
    %%
    f = fftshift(-(.5-1/ns/2):1/ns:(.5-1/ns/2))*fs;
    f99_101 = find(f>99 & f<101);
    v_gray1 = double(reshape(v_gray,[],v_sz(3)));
    I = exp(2i*pi*(f99_101-1)'.*(0:v_sz(3)-1)/ns);
    V = abs(I*v_gray1')'/ns^.5;
    %%
%     [V, f] = absfft(v_gray, fs, 3, ns);
    df = f(2)-f(1);
%     f99_101 = find(f>99 & f<101); 
%     V = reshape(V(:,:,f99_101),[],length(f99_101)); 
    [~,ind]=max(V,[],2);
%     ind2 = ind(:) + (0:(v_sz(1)*v_sz(2)-1))'*length(f99_101);
%     V_DF = conv2(-1:1,1,V','same')./conv2([1 -2 1],1,V','same');
%     DF = reshape(f(f99_101(1) + ind - 1) + df*V_DF(ind2)',v_sz(1),[]);
    DF = reshape(f(f99_101(1) + ind - 1),v_sz(1),[]);
    DF_30 = v_mean_30.*(DF-100);
%     DF_30_med = medfilt2(DF_30,[5,5]);
end

