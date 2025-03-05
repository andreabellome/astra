function x_car = car2tnh_notused(x_tnh,s_car)

x_tnh = x_tnh(:);
s = s_car(:);
r = s(1:3);
v = s(4:6);
t_ = v/norm(v);
h = crossFast(r,v);
h_ = h/norm(h);
n_ = crossFast(h_,t_);

A = [t_ n_ h_];

x_car = A*x_tnh;

return