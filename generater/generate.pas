uses
dos,windows;
label
brk2;
var
param,fname:ansistring;
com:char;
procedure readcom; // Read Command
 var
 c:char;
 begin
 read(com);
 read(c); // ' '
 readln(param);
 end;
procedure exeg(com1,com2,com3:string);
 begin
 assign(output,'temp.dat');
 rewrite(output);
 writeln(com1);
 writeln(com2);
 writeln(com3);
 close(output);
 exec('gfm2html','');
 erase(output);
 end;
begin
mkdir('\temp');
copyfile(pchar('config.dat'),pchar('tempconfig.dat'),true);
exeg('首页','\index.md','\index.html');
exeg('关于我','\about.md','\about.html');
exeg('友链','\link.md','\link.html');
exeg('404 Not Found','\404.md','\404.html');
assign(input,'config.dat');
reset(input);
com:='#';
while not eof do
begin;
 while com<>'F' do
 begin;
  if eof then
  goto brk2; //break; break;
 readcom;
 end;
fname:=param;
delete(fname,length(fname)-4,5);
readcom;
exeg(param,fname+'.md',fname+'.html');
end;
brk2:
close(input);
assign(input,'tempconfig.dat');
erase(input);
rmdir('\temp');
end.
