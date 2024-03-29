function d = Distance(T1,m1,T2,m2,Scale,Move)
scale = Scale;
move = Move;
if(-move>0)
    s = 0;
else
    s = ceil(move/scale);
end
if((m1-1)*scale-move)<(m2-1)
    e = m1-1;
else
    e = floor((m2-1+move)/scale);
end
if(ceil(e*scale-move)>m2-1)
    e = e-1;
end
%以上，s（起始索引）e（结束索引）：
% s 代表了在经过缩放和平移后，两个时间序列共享的起始位置。
% 具体来说，当平移量 move 为负时，意味着序列向右移动，因此 s 被设置为0，表示共享的起始位置从第一个时间序列的起始位置开始。
% 当平移量 move 为非负数时，s 的计算是通过将 move 除以缩放因子 scale 并向上取整得到的。这是为了确保共享区域的起始位置不会落在小数点之后。
% e 代表了在经过缩放和平移后，两个时间序列共享的结束位置。
% e 的计算依赖于两个时间序列的长度和缩放、平移的影响。其目的是将两个序列的共享区域匹配起来。
% 具体计算是通过将 (m1-1)*scale - move 与 (m2-1) 进行比较得到的，其中 m1 和 m2 分别是两个时间序列的长度。
% 如果 (m1-1)*scale - move 小于 (m2-1)，意味着第一个时间序列的共享区域结束在第二个时间序列之前。此时，e 被设置为 m1-1。
% 如果 (m1-1)*scale - move 不小于 (m2-1)，则 e 的计算是通过将 (m2-1+move)/scale 向下取整得到的。
% 最后，如果 ceil(e*scale - move) > m2-1，则 e 减去1，以确保共享区域的结束位置不会超出第二个时间序列的范围。
% 综上所述，s 和 e 的计算是为了找到在缩放和平移后两个时间序列共享的区域，以便进行后续的相似性度量计算。
L = (s:e)';
Y1 = T1(L+1);%曲线1的部分区域
X2 = L*scale-move;
if(ceil(X2(end))+1>m2)||(floor(X2(1))+1<=0)
    d = 10000;
    return;
end
Y2 = (X2 - floor(X2)).*(T2(ceil(X2)+1)-T2(floor(X2)+1))+T2(floor(X2)+1);%插值，使y2经过运算后没有空
% Y2 = (Y2-mean(Y2));
% Y1 = (Y1-mean(Y1));
t = (Y2'*Y1)/((Y2'*Y2)^0.5)/((Y1'*Y1)^0.5);%点积（内积）在向量空间中是一种常用的相似度度量方式，它可以用于衡量两个向量之间的相似性或者夹角的余弦值
%在统计学中，corr(X, Y) = (X · Y) / (||X|| * ||Y||)相关性表示两个变量之间的线性关系的强度和方向。当相关性为1时，表示两个变量完全正相关；当相关性为-1时，表示两个变量完全负相关。
d = 1000*exp(-(t+1)/2);
end
