uses
dos,windows;
const
ln=chr(13)+chr(10);
h1:ansistring=
'<!DOCTYPE html>'+ln+
'<html lang="en">'+ln+
'<head>'+ln+
'    <meta charset="UTF-8">'+ln+
'    <link href="/favicon.ico" rel="shortcut icon">'+ln+
'    <meta content="IE=edge" http-equiv="X-UA-Compatible">'+ln+
'    <meta content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no, width=device-width" name="viewport">'+ln+
'    <title>';{title}h2:ansistring=' - dblark''s blog</title>'+ln+
ln+
ln+
'    <link href="/css/base.min.css" rel="stylesheet">'+ln+
'    <link href="/css/project.min.css" rel="stylesheet">'+ln+
'    <link href="/css/styles.css" rel="stylesheet">'+ln+
'    <link href="/css/gitalk.css" rel="stylesheet">'+ln+
ln+
ln+
'    <script type="text/x-mathjax-config">'+ln+
'  		MathJax.Hub.Config({tex2jax: {inlineMath: [[''$'',''$''], [''\\('',''\\)'']]}});'+ln+
'    </script>'+ln+
'    <script src="https://cdn.bootcss.com/mathjax/2.7.0/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>'+ln+
'    <script>'+ln+
'    function getCookie(c_name)'+ln+
'    {'+ln+
'    if (document.cookie.length>0)'+ln+
'      {'+ln+
'      c_start=document.cookie.indexOf(c_name + "=")'+ln+
'      if (c_start!=-1)'+ln+
'        {'+ln+
'        c_start=c_start + c_name.length+1'+ln+
'        c_end=document.cookie.indexOf(";",c_start)'+ln+
'        if (c_end==-1) c_end=document.cookie.length'+ln+
'        return unescape(document.cookie.substring(c_start,c_end))'+ln+
'        }'+ln+
'      }'+ln+
'    return ""'+ln+
'    }'+ln+
ln+
'    var cookie=getCookie("Language")'+ln+
'    if (cookie=="")'+ln+
'    {'+ln+
'      cookie="pascal"'+ln+
'    }'+ln+
'    if (cookie=="pascal")'+ln+
'    {'+ln+
'      document.write("<style type=\"text/css\">.c\\+\\+{display:none;}</style>")'+ln+
'    }'+ln+
'    if (cookie=="c++")'+ln+
'    {'+ln+
'      document.write("<style type=\"text/css\">.pascal{display:none;}</style>")'+ln+
'    }'+ln+
'    </script>'+ln+
ln+
'</head>'+ln+
'<body class="page-brand">'+ln+
ln+
ln;{nav}
b1:ansistring=ln+
'    <header class="header header-transparent header-waterfall ui-header">'+ln+
'        <ul class="nav nav-list pull-left hidden-md hidden-lg">'+ln+
'            <li>'+ln+
'                <a data-toggle="menu" href="#ui_menu">'+ln+
'                    <span class="icon icon-lg">menu</span>'+ln+
'                </a>'+ln+
'            </li>'+ln+
'        </ul>'+ln+
'        <span class="header-logo header-affix visible-md-block visible-lg-block margin-right-no" data-offset-top="0" data-spy="affix">'+ln+
'            <p class="pagetitle">';{title}b2:ansistring='</p>'+ln+
'        </span>'+ln+
ln+
'        <ul class="nav nav-list pull-right">'+ln+
'            <li>'+ln+
'                <a data-toggle="menu" href="/">'+ln+
'                    <span class="avatar avatar-sm"><img alt="icon" src="/favicon.ico"></span>'+ln+
'                </a>'+ln+
'            </li>'+ln+
'        </ul>'+ln+
'    </header>'+ln+
'    <main class="content">'+ln+
'        <div class="container">'+ln+
'            <div class="row">'+ln+
'                <div class="col-lg-6 col-lg-offset-3 col-md-10 col-md-offset-1">'+ln+
'                    <section class="content-inner margin-top-no">'+ln+
'                        <br>'+ln+
ln;
{markdown}
f1:ansistring=ln+
'                    </section>'+ln+
'                </div>'+ln+
'            </div>'+ln+
ln+
'            <div class="row">'+ln+
'                <div class="col-lg-6 col-lg-offset-3 col-md-10 col-md-offset-1">'+ln+
'                    <section class="content-inner margin-top-no">'+ln+
'                        <hr>'+ln+
ln+
'                            <p>版权？ 不存在的。</p>'+ln+
'                            <p><a style="float:left" href="/link.html">友链</a><a style="float:right" href="/about.html">关于我</a></p>'+ln+
'                            <br>'+ln+
'                            <p>选择语言：'+ln+
'                            <p><a style="float:left" href="/setLanguage.html?pascal">Pascal</a><a style="float:right" href="/setLanguage.html?c++">C++</a></p>'+ln+
'                    </section>'+ln+
'                </div>'+ln+
'            </div>'+ln+
ln+
'            <div id="gitalk-container"></div>'+ln+
'            <script src="/js/gitalk.min.js"></script>'+ln+
'            <script>'+ln+
'            var gitalk = new Gitalk({'+ln+
'              clientID: ''8fa4b6551a4d0d6a0d68'','+ln+
'              clientSecret: ''829f1d6cc0a2247ae3f33a1744337464d26e65a4'','+ln+
'              repo: ''zhoushengjie.pw'','+ln+
'              owner: ''dblark'','+ln+
'              admin: [''dblark''],'+ln+
'              id: location.pathname,'+ln+
'              distractionFreeMode: false'+ln+
'            })'+ln+
'            gitalk.render(''gitalk-container'')'+ln+
'            </script>'+ln+
ln+
'    </main>'+ln+
ln+
ln+
ln+
ln+
ln+
'    <script src="/js/jquery.min.js"></script>'+ln+
'    <script src="/js/base.min.js"></script>'+ln+
'</body>'+ln+
'</html>'+ln;
var
title,markdownfile,htmlfile,pandoc,nav,html:ansistring;
procedure fileread(fname:string;var fc:ansistring);
 var
 s:ansistring;
 begin
 assign(input,fname);
 reset(input);
 fc:='';
 while not eof do
 begin;
 readln(s);
 fc:=fc+s+ln;
 end;
 close(input);
 erase(input);
 end;
procedure print(fname:string;fc:ansistring);
 begin
 assign(output,fname);
 rewrite(output);
 write(fc);
 close(output);
 end;
procedure replace(var s:ansistring;s1,s2:string);   // for pandoc LaTeX
 var
 t:ansistring;
 k:longint;
 begin
 t:='';
 k:=pos(s1,s);
 while k>0 do
 begin
 t:=t+copy(s,1,k-1)+s2;
 delete(s,1,k+length(s1)-1);
 k:=pos(s1,s);
 end;
 s:=t+s;
 end;
procedure markdown;   //GFM //use the pandoc 2.0.3
 var
 s:ansistring;
 t:text;
 begin
 //LaTeX
 s:=markdownfile;
 replace(s,'/','\');
 copyfile(pchar(s),pchar('\temp\temp.md'),true);
 fileread('\temp\temp.md',s);
 replace(s,'\\','\\\\');
 replace(s,'\{','\\{');
 replace(s,'\}','\\}');
 print('\temp\temp.md',s);
 exec('pandoc','-f gfm -t html \temp\temp.md -o \temp\gfm.html');
 assign(t,'\temp\temp.md');
 erase(t);
 end;
procedure list; //nav
 begin
 print('temp.dat',htmlfile);
 exec('nav','');
 end;
begin
assign(input,'temp.dat');
reset(input);
readln(title);
readln(markdownfile);
readln(htmlfile);
close(input);
markdown;
list;
fileread('\temp\gfm.html',pandoc);
fileread('\temp\nav.html',nav);
html:=h1+title+h2+nav+b1+title+b2+pandoc+f1;
print(htmlfile,html);
end.
