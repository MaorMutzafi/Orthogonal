function [DF_30_med] = orthogonal_alg1(v_gray,fs)
    v_mean = mean(v_gray,3); v_mean_30 = double(v_mean>30);
    [V, f] = absfft(v_gray, fs, 3);
    ind_f100 = find(abs(f-100)<1.01*min(abs(f-100))); 
    df = f(2)-f(1);
%     f100 = f(ind_f100);
    V = V(:,:,ind_f100+(-1:1));
    DF = convn(V,permute([-1 0 1],[3 1 2]),'valid')./convn(V,permute([1 -2 1],[3 1 2]),'valid');
    DF(abs(DF)>3 | isnan(DF)) = 0;
    DF_30 = v_mean_30.*DF*df;
    DF_30_med = medfilt2(DF_30,[5,5]);
end

