# FFT详解

> 话说这个算法是大佬才能写的
>
> 可是为了写库，只好学了一下

FFT，就是快速傅里叶转换（Fast Fourier Transition）。这个算法可以把高精度乘法的复杂度$O(n^2)$降到$O(n log n)$。另外，它还有很多的用途。

但在这之前，让我们先了解一下高精度乘法为何需要FFT的帮助。

## 多项式乘法

了解一下，事实上，我们一般用的手工乘法就是多项式乘法。

比如两个三位数相乘：

$$f(x)=a_1x^2+a_2x+a_3$$

$$g(x)=b_1x^2+b_2x+b_3$$

令它们的积为$p(x)$：

$$p(x)=f(x)\times g(x)=a_1b_1x^4+(a_1b_2+a_2+b_1)x^3+(a_1b_3+b_2a_2+a_2+b_2)x^2+(a_2+b_3+b_2+a_3)x+a_3+b_3$$

但是，一般来说我们都是用点值表达法而不是系数表达法。比如：

$$f(x)=a_0+a_1x+a_2x^2+\cdots +a_nx^n \Leftrightarrow f(x)=\{a_n,a_n-1,\cdots ,a_1,a_0\}$$

不过，一般来说我们不可能写出这样的运算结果：$f(x)=\{5,16,2,4\}$，所以，还需要把它整理一下。这是题外话。

反正，这样乘下来，复杂度就是$O(length(f(x))\times length(g(x)))=O(n^2)$，如果$length(f(x))\times length(g(x))>10^5$，那么时间就会炸。

所以，在处理特别大的数字时，这样肯定不行的。

那么，FFT就神奇的帮上了忙。实现的办法待会再说。

## 傅里叶级数

傅里叶变换的本源是傅里叶级数。就跟幂级数差不多。

幂级数：“我用$x^na_n+x^{n-1}a_{n-1}+\cdots+x^1a_1+x^0a_0$可以表示世界上所有的函数！”

傅里叶级数：“我用$sinx\times1,sinx\times2,sinx\times3\cdots$和$cosx\times1,cosx\times2,cosx\times3\cdots$加上系数也可以表示世界上所有的函数！”

**所以，我们知道傅里叶级数的所有系数，就能够求出对应的函数式。**

**反过来，知道函数式，也能求出傅里叶级数的所有系数。**

这就是傅里叶变换的基础。

~~傅里叶系数就是一个函数的**坐标**。真是弱爆了。~~

## 离散傅里叶变换

离散傅里叶变换就是DFT。看上去很高深，实际上很简单。

我们知道，一个函数有系数表达法和点值表达法。

那么，将$f(x)$转换成在不同的$x$时的$y$，就是DFT。

当然，还有对应的逆傅里叶变换IDFT。

就是给定不同的坐标，求出函数式。

但是，IDFT有一个限制，就是一个$n$次的$f(x)$有$n+1$个系数，必须要$n+1$个不同的坐标才能求出函数式，这个~~线性代数~~可以自己去推导。

~~傅里叶变换中将**坐标称为时域**，**系数称为频域**，很奇怪是吧。~~

为什么傅里叶变换能实现快速乘法呢？因为时域相乘不是多项式乘法，只要一项一项乘过来就行了。听上去不错。

但是，既然DFT是个算法，就要谈谈它的复杂度。

一个坐标需要$O(n)$，那么整个DFT就需要$O(n^2)$的复杂度。

然后……跟多项式乘法的复杂度一样了。

IDFT更高，根据高斯消元，复杂度变成了$O(n^3)$。

那么，这个算法不就没用了吗？

不过，它给FFT提供了基础。主人公就要出场了。

## 快速傅里叶变换

### 递归实现

FFT很奇妙，它只要$O(n log n)$就能搞定频域到时域，IFFT的时域到频域也只需要这么点复杂度。

当然，这么好的东西，也是要付出代价的。

首先，这个函数里的次数必须要是$2^n-1$，不是的话可以强行用0补上。这是小问题。

还有一个限制，$x$也不能任意取。

我们知道，只要任意$n$个$x$就能构成时域。（这里的$n$是系数的个数）

但是，FFT告诉你，做不到。如果你要$x=1,2,3,4,\cdots$，只能老老实实$O(n^2)$。

所以，到底$x$要取什么？

答案：$x^n=1$的所有根。

好吧，所以我们就知道了，这是一系列的复根：$\{w_n^0,w_n^1,w_n^2,\cdots,w_n^{n-1}\}$在算法导论上定义了一个符号：$w_n^k$。$k$是$k$次方的意思。通过关于复数的知识，我们可以推导出：

$$w_n=e^{2\pi i}$$

那么，$x$的问题就解决了。

FFT是如何求出对应的$y$的呢？跟另一种快速多项式乘法差不多，也是分治。

我们可以构造两个次数为$n/2$的函数。

$$f_1(x)=a_0+a_2x+a_4x^2+...+a_{n-2}x^{n/2-1}$$

$$f_2(x)=a_1+a_3x+a_5x^2+...+a_{n-1}x^{n/2-1}$$

所以，原问题就变成了：

$$f(x)=f_1(x^2)+x\times f_2(x^2)$$

如此下去，直到只有一项为止。这时问题就变成了常数项，直接返回即可。这是边界条件。

然而，现在又有个小问题，函数里多了一个平方。根据棣莫弗公式，复数的平方就是辐角乘二，因此，根据$w_{dn}^{dk}=w_n^k$相消定理，$(w_n)^2$就能变成$w_{n/2}$了。

那么，我们如此递归下去，就跑出了结果。

但是，还有时域到频域的IFFT。这部分比较复杂，不愿意看的可以略过（结果很简单）。

~~呵呵又是线性代数~~

从频域到时域，其实就是频域的$n$个系数组成一个列，然后乘一个$n^2$矩阵，得到另一个列，而这个列就是$y$坐标组成的列。

$$
\left(
\begin{matrix}
y_0     \\
y_1     \\
y_2     \\
y_3     \\
\vdots  \\
y_{n-1} \\
\end{matrix}
\right)
=\left(
\begin{matrix}
1 &   1   &   1   &   1   & \cdots &      1       \\
1 &  w_n  & w_n^2 & w_n^3 & \cdots &  w_n^{n-1}   \\
1 & w_n^2 & w_n^4 & w_n^6 & \cdots & w_n^{2(n-1)} \\
1 & w_n^3 & w_n^6 & w_n^9 & \cdots & w_n^{3(n-1)} \\
\vdots&\vdots&\vdots&\vdots&\ddots&\vdots         \\
1 & w_n^{n-1} & w_n^{2(n-1)} & w_n^{3(n-1)} & \cdots & w_n^{(n-1)(n-1)} \\
\end{matrix}
\right)
\left(
\begin{matrix}
a_0     \\
a_1     \\
a_2     \\
a_3     \\
\vdots  \\
a_{n-1} \\
\end{matrix}
\right)
$$

这其实就是把$w_n^k$带进多项式后的式子。

为什么我用矩阵乘法呢？那是因为，一个矩阵$M$如果是可逆的，那么$y=a\times M$就可以变成$y\times \frac{1}{M}=a$了。就是说，可以完成从时域到频域的转换。

线性代数中，把这个矩阵称作**范德蒙矩阵**，是可逆的。还帮我们算好了它的逆：

$$
\frac{1}{n}
\left(
\begin{matrix}
1 &     1    &     1    &     1    & \cdots &        1      \\
1 & w_n^{-1} & w_n^{-2} & w_n^{-3} & \cdots & w_n^{-(n-1)}  \\
1 & w_n^{-2} & w_n^{-4} & w_n^{-6} & \cdots & w_n^{-2(n-1)} \\
1 & w_n^{-3} & w_n^{-6} & w_n^{-9} & \cdots & w_n^{-3(n-1)} \\
\vdots&\vdots&\vdots&\vdots&\ddots&\vdots                   \\
1 & w_n^{-(n-1)} & w_n^{-2(n-1)} & w_n^{-3(n-1)} & \cdots & w_n^{-(n-1)(n-1)} \\
\end{matrix}
\right)
$$

你可能会想：矩阵乘法可是$O(n^3)$的，有这个矩阵有什么用啊？

没事，既然我们当初把FFT理解成了矩阵，再把矩阵理解成FFT就行了。

~~理解结束了，下面是结果~~

我们把得到的时域$y$理解为新的一组系数，把要求的频域$a$理解为新的一组$y$坐标，然后新选取的一组$x$坐标是$w_n^{-1},w_n^{-2},\cdots$

也就是说，我们可以依葫芦画瓢，使用FFT实现从时域到频域，只是选取的$x$坐标换了，并且最后得到的结果要除以一个$n$。

好了这个问题就解决了。

### 蝴蝶操作

我们都知道，复数的乘法速度很慢。所以，我们要尽量避免单位复根的计算~~或者打表~~。

我们知道每个$f_1$和$f_2$的系数都要用两次，让我们把这两次写出来看看：

第一次：

$$f(w_n^k)=f_1(w_n^{2k})+w_n^kf_2(w_n^{2k})$$

第二次：

$$f(w_n^{k+\frac{n}{2}})=f_1(w_n^{2k+n})+w_n^{k+\frac{n}{2}}f_2(w_n^{2k+n})$$

整理后得到：

$$f(w_n^{k+\frac{n}{2}})=f_1(w_n^{2k})-f_2(w_n^{2k})$$

所以呢，这个结论大家应该一看就明白了，我们把复杂度降低了一半！

~~这个速度也快了没多少啊~~

递归版代码：

```pascal
//Pascal没有关于复数的库，所以自己写了个imaginary库，代码详见我的GitHub
{$M 100000000,0,0}             //栈容量扩充，不然会炸
uses
math,imaginary;
type                           //数组定义
arr=array[0..8191]of complex;
var
n1,n2,n3,i:longint;
a,b,c:arr;
s:array[0..8191]of longint;
s1,s2:string;
procedure fft(a:arr;var y:arr;n,s:longint);
 var
 f1,f2,y1,y2:arr;
 w:complex;
 x,i:longint;
 begin
 if n=1 then                   //边界条件
 begin
 y:=a;
 exit;
 end;
 for i:=0 to n div 2-1 do      //将数组分割成两部分
 begin
 f1[i]:=a[i*2];
 f2[i]:=a[i*2+1];
 end;
 fft(f1,y1,n div 2,s);         //递归
 fft(f2,y2,n div 2,s);
 for i:=0 to n div 2-1 do
 begin
 w:=exp(comp(0,2*pi*i*s/n));   //复根的计算
 y[i]:=y1[i mod (n div 2)]+w*y2[i mod (n div 2)];//计算出结果
 y[i+n div 2]:=y1[i mod (n div 2)]-w*y2[i mod (n div 2)];//蝴蝶操作
 end;
 end;
begin
readln(s1);                    //输入两个数字，使用字符串
readln(s2);
n1:=length(s1);                //两个数分别的长度
n2:=length(s2);
for i:=1 to n1 do              //转换
a[n1-i]:=ord(s1[i])-48;
for i:=1 to n2 do
b[n2-i]:=ord(s2[i])-48;
n3:=n1+n2-1;                   //乘法后长度
if trunc(math.log2(n3))<math.log2(n3) then//补位
n3:=2 shl trunc(math.log2(n3));
fft(a,a,n3,1);                 //FFT
fft(b,b,n3,1);
for i:=0 to n3-1 do            //插值
c[i]:=a[i]*b[i];
fft(c,c,n3,-1);                //IFFT
fillchar(s,sizeof(s),0);
for i:=0 to n3-1 do            //转换成十进制
begin
inc(s[i],round(real(c[i])/n3));//这里IFFT后要除以n，注意！
inc(s[i+1],s[i] div 10);
s[i]:=s[i] mod 10;
end;
while (s[n3]=0) and (n3>0) do  //去掉前导0
dec(n3);
for i:=n3 downto 0 do          //输出
write(s[i]);
writeln;
end.
```

```c++
#include<cstdio>
#include<cmath>
#include<complex>
#include<cstring>
using namespace std;
const double pi=acos(-1);      //圆周率，不解释
typedef complex<double> cp;    //复数定义
void fft(cp a[8192],cp y[8192],int n,int s)
{
	if (n==1)                  //边界条件
	{
		y[0]=a[0];
		return;
	}
	cp f1[8192],f2[8192];
	for (int i=0;i<n/2;i++)    //将数组分割成两部分
	{
		f1[i]=a[i*2];
		f2[i]=a[i*2+1];
	}
	cp y1[8192],y2[8192];
	fft(f1,y1,n/2,s);          //递归
	fft(f2,y2,n/2,s);
	cp w;
	for (int i=0;i<n/2;i++)
	{
		w=exp(cp(0,2*pi*i*s/n));//复根的计算
		y[i]=y1[i%(n/2)]+w*y2[i%(n/2)];//计算出结果
		y[i+n/2]=y1[i%(n/2)]-w*y2[i%(n/2)];//蝴蝶操作
	}
}
int main()
{
    char s1[8192],s2[8192];
    scanf("%s\n%s",&s1,&s2);   //输入两个数字，使用字符串
    int n1,n2,n3;
    n1=strlen(s1);             //两个数分别的长度
    n2=strlen(s2);
    cp a[8192],b[8192];
    for (int i=0;i<n1;i++)     //转换
    a[n1-i-1]=s1[i]-'0';
    for (int i=0;i<n2;i++)
    b[n2-i-1]=s2[i]-'0';
    n3=n1+n2-1;                //乘法后长度
    if ((int)(log2(n3))<log2(n3))//补位
    n3=2<<(int)log2(n3);
    fft(a,a,n3,1);             //FFT
    fft(b,b,n3,1);
    cp c[8192];
    for (int i=0;i<n3;i++)     //插值
    c[i]=a[i]*b[i];
    fft(c,c,n3,-1);            //IFFT
    int s[8192];
    for (int i=0;i<n3;i++)     //转换成十进制
    {
    	s[i]+=(int)(c[i].real()/n3+0.5);//这里IFFT后要除以n，注意！
		s[i+1]+=s[i]/10;
		s[i]%=10;
	}
	for (;!s[n3]&&n3;n3--);    //去掉前导0
	for (int i=n3;i>=0;i--)    //输出
	printf("%d",s[i]);
	putchar('\n');
	return 0;
}
```

~~神奇的是，Pascal开了栈扩充以后，数组可以开好大，C++到了16384就炸了。~~

### 迭代版代码

我们知道，递归版的跑的很慢，很浪费栈空间~~废话~~，还容易炸掉。所以，我们自然要把它改写成迭代版的。

我们来看看一个项数为8的函数通过分割后会怎么样：

$$a_0,a_1,a_2,a_3,a_4,a_5,a_6,a_7$$

$$\downarrow$$

$$a_0,a_2,a_4,a_6\quad a_1,a_3,a_5,a_7$$

$$\downarrow\quad\quad\quad\quad\quad\quad\downarrow$$

$$a_0,a_4\quad a_2,a_6\quad a_1,a_5\quad a_3,a_7$$

$$\downarrow\quad\quad\quad\downarrow\quad\quad\quad\downarrow\quad\quad\quad\downarrow$$

$$ a_0\quad a_4\quad a_2\quad a_6\quad a_1\quad a_5\quad a_3\quad a_7$$

~~话说用$\LaTeX$的排版不太好（不用图片的结果）~~。

当然，$\{0,4,2,6,1,5,3,7\}$表面看上去没什么规律。

转换成二进制：$000,100,010,110,001,101,011,111$

好吧，还是看不出来，虽然有点感觉。再翻转看看：$000,001,010,011,100,101,110,111$

哇！这不是0到7吗？

那么，我们只要将初始的数组按顺序翻转，就能不断合并，就能完成FFT了。

迭代版代码：

```pascal
uses
math,imaginary;
type
arr=array[0..8191]of complex;
var
n1,n2,n3,i:longint;
a,b,c:arr;
rev,s:array[0..8191]of longint;
s1,s2:string;
procedure getrev(n:longint);   //获取开始的顺序
 var
 i:longint;
 begin
 rev[0]:=0;
 for i:=0 to n-1 do            //递推求解
 rev[i]:=(rev[i shr 1] shr 1) or ((i and 1) shl (trunc(math.log2(n))-1));
 end;
procedure fft(var a:arr;n,s:longint);
 var
 i,j,k:longint;
 w,t,x,y:complex;
 begin
 for i:=0 to n-1 do            //数组翻转
  if i<rev[i] then
  begin
  t:=a[i];
  a[i]:=a[rev[i]];
  a[rev[i]]:=t;
  end;
 for i:=0 to trunc(math.log2(n))-1 do//1 shl i是n的一半
  for j:=0 to n div (2 shl i)-1 do//第j块
   for k:=j shl (i+1) to j shl (i+1)+1 shl i-1 do//k相当于递归版中的i
   begin
   w:=exp(comp(0,pi/(1 shl i)*k*s));//复根的计算
   x:=a[k];
   y:=w*a[k+1 shl i];
   a[k]:=x+y;                  //更新
   a[k+1 shl i]:=x-y;          //蝴蝶操作
   end;
 if s=-1 then                  //IFFT要除以n
  for i:=0 to n-1 do
  a[i]:=a[i]/n;
 end;
begin                          //基本上一样
readln(s1);
readln(s2);
n1:=length(s1);
n2:=length(s2);
for i:=1 to n1 do
a[n1-i]:=ord(s1[i])-48;
for i:=1 to n2 do
b[n2-i]:=ord(s2[i])-48;
n3:=n1+n2-1;
if trunc(math.log2(n3))<math.log2(n3) then
n3:=2 shl trunc(math.log2(n3));
getrev(n3);
fft(a,n3,1);
fft(b,n3,1);
for i:=0 to n3-1 do
c[i]:=a[i]*b[i];
fft(c,n3,-1);
fillchar(s,sizeof(s),0);
for i:=0 to n3-1 do
begin
inc(s[i],round(real(c[i])));
inc(s[i+1],s[i] div 10);
s[i]:=s[i] mod 10;
end;
while (s[n3]=0) and (n3>0) do
dec(n3);
for i:=n3 downto 0 do
write(s[i]);
writeln;
end.
```

```c++
#include<cstdio>
#include<cmath>
#include<complex>
#include<cstring>
using namespace std; 
const double pi=acos(-1);
typedef complex<double> cp;    //复数定义
int rev[8192];
void getrev(int n)
{
	for (int i=0;i<n;i++)
	rev[i]=(rev[i>>1]>>1)|((i&1)<<(int(log2(n))-1));
}
void fft(cp a[8192],int n,int s)
{
	for (int i=0;i<n;i++)      //数组翻转
		if (i<rev[i])
		swap(a[i],a[rev[i]]);
	for (int i=1;i<n;i*=2)     //i是n的一半
		for (int j=0;j<n;j+=i*2)//j是这一块的开始位置
			for (int k=j;k<i+j;k++)//k相当于递归版中的i
			{
				cp w=exp(cp(0,pi/i*k*s));//复根的计算
				cp x=a[k],y=w*a[k+i];
				a[k]=x+y;      //更新
				a[k+i]=x-y;    //蝴蝶操作
			}
	if (s==-1)                 //IFFT要除以n
		for (int i=0;i<n;i++)
		a[i]/=n;
}
int main()                     //基本上一样
{
    char s1[8192],s2[8192];
    scanf("%s\n%s",&s1,&s2);
    int n1,n2,n3;
    n1=strlen(s1);
    n2=strlen(s2);
    cp a[8192],b[8192];
    for (int i=0;i<n1;i++)
    a[n1-i-1]=s1[i]-'0';
    for (int i=0;i<n2;i++)
    b[n2-i-1]=s2[i]-'0';
    n3=n1+n2-1;
    if ((int)(log2(n3))<log2(n3))
    n3=2<<(int)log2(n3);
    getrev(n3);
    fft(a,n3,1);
    fft(b,n3,1);
    cp c[8192];
    for (int i=0;i<n3;i++)
    c[i]=a[i]*b[i];
    fft(c,n3,-1);
    int s[8192];
    for (int i=0;i<n3;i++)
    {
    	s[i]+=(int)(c[i].real()/n3+0.5);
		s[i+1]+=s[i]/10;
		s[i]%=10;
	}
	for (;!s[n3]&&n3;n3--);
	for (int i=n3;i>=0;i--)
	printf("%d",s[i]);
	putchar('\n');
	return 0;
}
```

> 其他：
> 
> FFT的可视化（翻译）：[B站链接](http://www.bilibili.com/video/av19141078)
