label
brk2,brk3;
const
ln=chr(13)+chr(10);
h:ansistring=
'	 <nav class="menu menu-left nav-drawer nav-drawer-md" id="ui_menu">'+ln+
'		 <div class="menu-scroll">'+ln+
'			 <div class="menu-content">'+ln+
'				 <a class="menu-logo" href="/">周圣杰的博客</a>'+ln+
'				 <ul class="nav">'+ln+
'					 <li>'+ln+
ln;nd1:ansistring=
'						 <a class="collapsed waves-attach waves-effect" data-toggle="collapse" href="#';{dfile}nd2:ansistring='">';{dtitle}nd3:ansistring='</a>'+ln+
'						 <ul class="menu-collapse collapse in" id="';{dfile}nd4:ansistring='">'+ln+
ln;nf1:ansistring=
'							 <li';{if active then}nfa:ansistring=' class="active"';nf2:ansistring='>'+ln+
'								 <a class="waves-attach" href="';{ffile}nf3:ansistring='">';{ftitle}nf4:ansistring='</a>'+ln+
'							 </li>'+ln;nd5:ansistring=
ln+
'						 </ul>'+ln;f:ansistring=
ln+
'					 </li>'+ln+
ln+
'				 </ul>'+ln+
'			 </div>'+ln+
'		 </div>'+ln+
'	 </nav>'+ln;
var
title,param,dfile,fc:ansistring;
com:char;
procedure readcom; // Read Command
 var
 c:char;
 begin
 read(com);
 read(c); // ' '
 readln(param);
 end;
procedure print(fname:string;fc:ansistring);
 begin
 assign(output,fname);
 rewrite(output);
 write(fc);
 close(output);
 end;
begin
assign(input,'temp.dat');
reset(input);
readln(title);
close(input);
assign(input,'tempconfig.dat');
reset(input);
fc:=h;
com:='#';
while not eof do // D 's repeat
begin;
 while com<>'D' do
 begin;
  if eof then
  goto brk3; // BUG repair
 readcom;
 end;
dfile:=param;
fc:=fc+nd1+dfile+nd2;
 while com<>'T' do
 readcom;
fc:=fc+param+nd3+dfile+nd4;
 while com<>'D' do // F 's repeat
 begin;
  while com<>'F' do
  begin;
   if eof then
   goto brk3;//break; break; break;
  readcom;
   if com='D' then
   goto brk2; //break; break;
  end;
 fc:=fc+nf1;
  if param=title then //active
  fc:=fc+nfa;
 fc:=fc+nf2+param+nf3;
  while com<>'T' do
  readcom;
 fc:=fc+param+nf4;
 end;
brk2:
fc:=fc+nd5;
end;
brk3:
fc:=fc+f;
print('\temp\nav.html',fc);
end.
