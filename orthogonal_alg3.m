function [s_bb_lp] = orthogonal_alg3(v_gray,fs)
v_sz = size(v_gray); 
v_gray = double(reshape(v_gray,[],v_sz(3)));
f1=100;

n_flt = 700; frq_flt = [0 .0125 1]; a = [1 0 ]; d = 1e-5;
b = fircls(n_flt,frq_flt,a,a+d,a-d);

I = exp(-2i*pi*(0:v_sz(3)-2)*f1/fs);
s_bb_lp = reshape(abs(conv2(1,b,conv2(1,b,diff(v_gray,[],2).*I,'valid'),'valid')),v_sz(1),v_sz(2),[]);

end