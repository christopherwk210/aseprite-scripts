local a=string.byte;local b=string.char;local c=string.dump;local d=string.find;local e=string.format;local f=string.len;local g=string.lower;local h=string.rep;local i=string.sub;local j=string.upper;local function k(l,m)m=m or 1;if type(l)~="string"then error("bad argument #1 to 'utf8charbytes' (string expected, got "..type(l)..")")end;if type(m)~="number"then error("bad argument #2 to 'utf8charbytes' (number expected, got "..type(m)..")")end;local n=a(l,m)if n>0 and n<=127 then return 1 elseif n>=194 and n<=223 then local o=a(l,m+1)if not o then error("UTF-8 string terminated early")end;if o<128 or o>191 then error("Invalid UTF-8 character")end;return 2 elseif n>=224 and n<=239 then local o=a(l,m+1)local p=a(l,m+2)if not o or not p then error("UTF-8 string terminated early")end;if n==224 and(o<160 or o>191)then error("Invalid UTF-8 character")elseif n==237 and(o<128 or o>159)then error("Invalid UTF-8 character")elseif o<128 or o>191 then error("Invalid UTF-8 character")end;if p<128 or p>191 then error("Invalid UTF-8 character")end;return 3 elseif n>=240 and n<=244 then local o=a(l,m+1)local p=a(l,m+2)local q=a(l,m+3)if not o or not p or not q then error("UTF-8 string terminated early")end;if n==240 and(o<144 or o>191)then error("Invalid UTF-8 character")elseif n==244 and(o<128 or o>143)then error("Invalid UTF-8 character")elseif o<128 or o>191 then error("Invalid UTF-8 character")end;if p<128 or p>191 then error("Invalid UTF-8 character")end;if q<128 or q>191 then error("Invalid UTF-8 character")end;return 4 else error("Invalid UTF-8 character")end end;local function r(l)if type(l)~="string"then for s,t in pairs(l)do print('"',tostring(s),'"',tostring(t),'"')end;error("bad argument #1 to 'utf8len' (string expected, got "..type(l)..")")end;local u=1;local v=f(l)local w=0;while u<=v do w=w+1;u=u+k(l,u)end;return w end;local function x(l,m,y)y=y or-1;local u=1;local v=f(l)local w=0;local z=m>=0 and y>=0 or r(l)local A=m>=0 and m or z+m+1;local B=y>=0 and y or z+y+1;if A>B then return""end;local C,D=1,v;while u<=v do w=w+1;if w==A then C=u end;u=u+k(l,u)if w==B then D=u-1;break end end;if A>w then C=v+1 end;if B<1 then D=0 end;return i(l,C,D)end;local function E(l)if type(l)~="string"then error("bad argument #1 to 'utf8reverse' (string expected, got "..type(l)..")")end;local v=f(l)local u=v;local F;local G=""while u>0 do local n=a(l,u)while n>=128 and n<=191 do u=u-1;n=a(l,u)end;F=k(l,u)G=G..i(l,u,u+F-1)u=u-1 end;return G end;local function H(I)if I<=0x7F then return b(I)end;if I<=0x7FF then local J=0xC0+math.floor(I/0x40)local K=0x80+I%0x40;return b(J,K)end;if I<=0xFFFF then local J=0xE0+math.floor(I/0x1000)local K=0x80+math.floor(I/0x40)%0x40;local L=0x80+I%0x40;return b(J,K,L)end;if I<=0x10FFFF then local M=I;local N=0x80+M%0x40;M=math.floor(M/0x40)local L=0x80+M%0x40;M=math.floor(M/0x40)local K=0x80+M%0x40;M=math.floor(M/0x40)local J=0xF0+M;return b(J,K,L,N)end;error'Unicode cannot be greater than U+10FFFF!'end;local O=2^6;local P=2^12;local Q=2^18;local R;R=function(S,m,y,T)m=m or 1;y=y or m;if m>y then return end;local U,v;if T then v=k(S,T)U=i(S,T,T-1+v)else U,T=x(S,m,m),0;v=#U end;local I;if v==1 then I=a(U)end;if v==2 then local V,W=a(U,1,2)local X,Y=V-0xC0,W-0x80;I=X*O+Y end;if v==3 then local V,W,Z=a(U,1,3)local X,Y,_=V-0xE0,W-0x80,Z-0x80;I=X*P+Y*O+_ end;if v==4 then local V,W,Z,a0=a(U,1,4)local X,Y,_,a1=V-0xF0,W-0x80,Z-0x80,a0-0x80;I=X*Q+Y*P+_*O+a1 end;return I,R(S,m+1,y,T+v)end;local function a2(S,a3)a3=a3 or 1;local T=1;local w=#S;return function(a4)if a4 then T=T+a4 end;local a5=0;local a6=T;repeat if T>w then return end;a5=a5+1;local v=k(S,T)T=T+v until a5==a3;local a7=T-1;local a8=i(S,a6,a7)return a8,a6,a7 end end;local function a9(aa,ab,ac)local ad,ae=1,#aa;local af=math.floor((ad+ae)/2)if not ac then while ae-ad>1 do if aa[tonumber(af)]>ab then ae=af else ad=af end;af=math.floor((ad+ae)/2)end end;if aa[tonumber(ad)]==ab then return true,tonumber(ad)elseif aa[tonumber(ae)]==ab then return true,tonumber(ae)else return false end end;local function ag(ah,ai)local aj={}local ak={}local al=false;local am=false;local an=true;local ao=false;local ap=a2(ah)local a4;for n,aq,ar in ap do a4=ar;if not al and not ai then if n=="%"then al=true elseif n=="-"then table.insert(aj,R(n))am=true elseif n=="^"then if not an then error('!!!')else ao=true end elseif n==']'then break else if not am then table.insert(aj,R(n))else table.remove(aj)table.insert(ak,{table.remove(aj),R(n)})am=false end end elseif al and not ai then if n=='a'then table.insert(ak,{65,90})table.insert(ak,{97,122})elseif n=='c'then table.insert(ak,{0,31})table.insert(aj,127)elseif n=='d'then table.insert(ak,{48,57})elseif n=='g'then table.insert(ak,{1,8})table.insert(ak,{14,31})table.insert(ak,{33,132})table.insert(ak,{134,159})table.insert(ak,{161,5759})table.insert(ak,{5761,8191})table.insert(ak,{8203,8231})table.insert(ak,{8234,8238})table.insert(ak,{8240,8286})table.insert(ak,{8288,12287})elseif n=='l'then table.insert(ak,{97,122})elseif n=='p'then table.insert(ak,{33,47})table.insert(ak,{58,64})table.insert(ak,{91,96})table.insert(ak,{123,126})elseif n=='s'then table.insert(ak,{9,13})table.insert(aj,32)table.insert(aj,133)table.insert(aj,160)table.insert(aj,5760)table.insert(ak,{8192,8202})table.insert(aj,8232)table.insert(aj,8233)table.insert(aj,8239)table.insert(aj,8287)table.insert(aj,12288)elseif n=='u'then table.insert(ak,{65,90})elseif n=='w'then table.insert(ak,{48,57})table.insert(ak,{65,90})table.insert(ak,{97,122})elseif n=='x'then table.insert(ak,{48,57})table.insert(ak,{65,70})table.insert(ak,{97,102})else if not am then table.insert(aj,R(n))else table.remove(aj)table.insert(ak,{table.remove(aj),R(n)})am=false end end;al=false else if not am then table.insert(aj,R(n))else table.remove(aj)table.insert(ak,{table.remove(aj),R(n)})am=false end;al=false end;an=false end;table.sort(aj)local function as(at)for aq,au in ipairs(ak)do if au[1]<=at and at<=au[2]then return true end end;return false end;if not ao then return function(at)return a9(aj,at)or as(at)end,a4 else return function(at)return at~=-1 and not(a9(aj,at)or as(at))end,a4 end end;local av=setmetatable({},{__mode='kv'})local aw=setmetatable({},{__mode='kv'})local function ax(ay,ai)local az={functions={},captures={}}if not ai then av[ay]=az else aw[ay]=az end;local function aA(aB)return function(aC)if aB(aC)then az:nextFunc()az:nextStr()else az:reset()end end end;local function aD(aB)return function(aC)if aB(aC)then az:fullResetOnNextFunc()az:nextStr()else az:nextFunc()end end end;local function aE(aB)return function(aC)if aB(aC)then az:fullResetOnNextStr()end;az:nextFunc()end end;local function aF(aB)return function(aC)if aB(aC)then az:fullResetOnNextFunc()az:nextStr()end;az:nextFunc()end end;local function aG(aH)return function(aq)local z=az.captures[aH][2]-az.captures[aH][1]local aI=x(az.string,az.captures[aH][1],az.captures[aH][2])local aJ=x(az.string,az.str,az.str+z)if aI==aJ then for aq=0,z do az:nextStr()end;az:nextFunc()else az:reset()end end end;local function aK(aH)return function(aq)az.captures[aH][1]=az.str;az:nextFunc()end end;local function aL(aH)return function(aq)az.captures[aH][2]=az.str-1;az:nextFunc()end end;local function aM(S)local aN=0;local aO,aP=x(S,1,1),x(S,2,2)local a4=f(aO)+f(aP)aO,aP=R(aO),R(aP)return function(aC)if aC==aP and aN>0 then aN=aN-1;if aN==0 then az:nextFunc()end;az:nextStr()elseif aC==aO then aN=aN+1;az:nextStr()else if aN==0 or aC==-1 then aN=0;az:reset()else az:nextStr()end end end,a4 end;az.functions[1]=function(aq)az:fullResetOnNextStr()az.seqStart=az.str;az:nextFunc()if az.str>az.startStr and az.fromStart or az.str>=az.stringLen then az.stop=true;az.seqStart=nil end end;local aQ;local al=false;local a4=nil;local ap=(function()local aR=a2(ay)return function()return aR(a4)end end)()local aS={}for n,aT,ar in ap do a4=nil;if ai then table.insert(az.functions,aA(ag(n,ai)))else if al then if d('123456789',n,1,true)then if aQ then table.insert(az.functions,aA(aQ))aQ=nil end;table.insert(az.functions,aG(tonumber(n)))elseif n=='b'then if aQ then table.insert(az.functions,aA(aQ))aQ=nil end;local aU;aU,a4=aM(i(ay,ar+1,ar+9))table.insert(az.functions,aU)else aQ=ag('%'..n)end;al=false else if n=='*'then if aQ then table.insert(az.functions,aD(aQ))aQ=nil else error('invalid regex after '..i(ay,1,aT))end elseif n=='+'then if aQ then table.insert(az.functions,aA(aQ))table.insert(az.functions,aD(aQ))aQ=nil else error('invalid regex after '..i(ay,1,aT))end elseif n=='-'then if aQ then table.insert(az.functions,aE(aQ))aQ=nil else error('invalid regex after '..i(ay,1,aT))end elseif n=='?'then if aQ then table.insert(az.functions,aF(aQ))aQ=nil else error('invalid regex after '..i(ay,1,aT))end elseif n=='^'then if aT==1 then az.fromStart=true else error('invalid regex after '..i(ay,1,aT))end elseif n=='$'then if ar==f(ay)then az.toEnd=true else error('invalid regex after '..i(ay,1,aT))end elseif n=='['then if aQ then table.insert(az.functions,aA(aQ))end;aQ,a4=ag(i(ay,ar+1))elseif n=='('then if aQ then table.insert(az.functions,aA(aQ))aQ=nil end;table.insert(az.captures,{})table.insert(aS,#az.captures)table.insert(az.functions,aK(aS[#aS]))if i(ay,ar+1,ar+1)==')'then az.captures[#az.captures].empty=true end elseif n==')'then if aQ then table.insert(az.functions,aA(aQ))aQ=nil end;local aV=table.remove(aS)if not aV then error('invalid capture: "(" missing')end;table.insert(az.functions,aL(aV))elseif n=='.'then if aQ then table.insert(az.functions,aA(aQ))end;aQ=function(aC)return aC~=-1 end elseif n=='%'then al=true else if aQ then table.insert(az.functions,aA(aQ))end;aQ=ag(n)end end end end;if#aS>0 then error('invalid capture: ")" missing')end;if aQ then table.insert(az.functions,aA(aQ))end;table.insert(az.functions,function()if az.toEnd and az.str~=az.stringLen then az:reset()else az.stop=true end end)az.nextFunc=function(self)self.func=self.func+1 end;az.nextStr=function(self)self.str=self.str+1 end;az.strReset=function(self)local aW=self.reset;local S=self.str;self.reset=function(l)l.str=S;l.reset=aW end end;az.fullResetOnNextFunc=function(self)local aW=self.reset;local aB=self.func+1;local S=self.str;self.reset=function(l)l.func=aB;l.str=S;l.reset=aW end end;az.fullResetOnNextStr=function(self)local aW=self.reset;local S=self.str+1;local aB=self.func;self.reset=function(l)l.func=aB;l.str=S;l.reset=aW end end;az.process=function(self,S,a6)self.func=1;a6=a6 or 1;self.startStr=a6>=0 and a6 or r(S)+a6+1;self.seqStart=self.startStr;self.str=self.startStr;self.stringLen=r(S)+1;self.string=S;self.stop=false;self.reset=function(l)l.func=1 end;local U;while not self.stop do if self.str<self.stringLen then U=x(S,self.str,self.str)self.functions[self.func](R(U))else self.functions[self.func](-1)end end;if self.seqStart then local aX={}for aq,aY in pairs(self.captures)do if aY.empty then table.insert(aX,aY[1])else table.insert(aX,x(S,aY[1],aY[2]))end end;return self.seqStart,self.str-1,unpack(aX)end end;return az end;local function aZ(S,ay,a_,ai)local az=av[ay]or ax(ay,ai)return az:process(S,a_)end;local function b0(S,ay,a_)a_=a_ or 1;local b1={aZ(S,ay,a_)}if b1[1]then if b1[3]then return unpack(b1,3)end;return x(S,b1[1],b1[2])end end;local function b2(S,ay,b3)ay=x(ay,1,1)~='^'and ay or'%'..ay;local b4=1;return function()local b1={aZ(S,ay,b4)}if b1[1]then b4=b1[2]+1;if b1[b3 and 1 or 3]then return unpack(b1,b3 and 1 or 3)end;return x(S,b1[1],b1[2])end end end;local function b5(b6,b7)local b8=''if type(b6)=='string'then local al=false;local b9;for n in a2(b6)do if not al then if n=='%'then al=true else b8=b8 ..n end else b9=tonumber(n)if b9 then b8=b8 ..b7[b9]else b8=b8 ..n end;al=false end end elseif type(b6)=='table'then b8=b6[b7[1]or b7[0]]or''elseif type(b6)=='function'then if#b7>0 then b8=b6(unpack(b7,1))or''else b8=b6(b7[0])or''end end;return b8 end;local function ba(S,ay,b6,bb)bb=bb or-1;local b8=''local bc=1;local ap=b2(S,ay,true)local b1={ap()}local bd=0;while#b1>0 and bb~=bd do local b7={[0]=x(S,b1[1],b1[2]),unpack(b1,3)}b8=b8 ..x(S,bc,b1[1]-1)..b5(b6,b7)bc=b1[2]+1;bd=bd+1;b1={ap()}end;return b8 ..x(S,bc),bd end;local be={}be.len=r;be.sub=x;be.reverse=E;be.char=H;be.unicode=R;be.gensub=a2;be.byte=R;be.find=aZ;be.match=b0;be.gmatch=b2;be.gsub=ba;be.dump=c;be.format=e;be.lower=g;be.upper=j;be.rep=h;local bf={}local bg={}function bg.new(bh)local self={data=bh.data}return setmetatable(self,{__index=bg})end;bf.NoteOnEvent=bg;local bi={}function bi.new(bh)local self={data=bh.data}return setmetatable(self,{__index=bi})end;bf.NoteOffEvent=bi;local bj={HEADER_CHUNK_TYPE={0x4D,0x54,0x68,0x64},HEADER_CHUNK_LENGTH={0x00,0x00,0x00,0x06},HEADER_CHUNK_FORMAT0={0x00,0x00},HEADER_CHUNK_FORMAT1={0x00,0x01},HEADER_CHUNK_DIVISION={0x00,0x80},TRACK_CHUNK_TYPE={0x4D,0x54,0x72,0x6B},META_EVENT_ID=0xFF,META_TEXT_ID=0x01,META_COPYRIGHT_ID=0x02,META_TRACK_NAME_ID=0x03,META_INSTRUMENT_NAME_ID=0x04,META_LYRIC_ID=0x05,META_MARKER_ID=0x06,META_CUE_POINT=0x07,META_TEMPO_ID=0x51,META_TIME_SIGNATURE_ID=0x58,META_KEY_SIGNATURE_ID=0x59,META_END_OF_TRACK_ID={0x2F,0x00},PROGRAM_CHANGE_STATUS=0xC0,NOTES={},METADATA_TYPES={"Text","Copyright","Name","Instrument","Lyric","Marker","Cue Point",[81]="Tempo",[88]="Time Signature",[89]="Key Signature"}}local bk={{'C','B#'},{'C#','Db'},{'D'},{'D#','Eb'},{'E','Fb'},{'F','E#'},{'F#','Gb'},{'G'},{'G#','Ab'},{'A'},{'A#','Bb'},{'B','Cb'}}local bl=0;for m=-1,9 do for bm,bn in ipairs(bk)do for aq,bo in ipairs(bn)do bj.NOTES[bo..m]=bl end;bl=bl+1 end end;bf.Constants=bj;local bp={}function bp.new(bh)local self={type=bh.type,data=bh.data,size={0,0,0,#bh.data}}return setmetatable(self,{__index=bp})end;bf.Chunk=bp;local bq={}bq.band=function(br,aU)return br&aU end;bq.bor=function(br,aU)return br|aU end;bq.lshift=function(br,aU)return br<<aU end;bq.rshift=function(br,aU)return br>>aU end;local bs={_TYPE='module',_NAME='bit.numberlua',_VERSION='0.3.1.20120131'}local bt=math.floor;local bu=2^32;local bv=bu-1;local function bw(bx)local by={}local bz=setmetatable({},by)function by:__index(s)local t=bx(s)bz[s]=t;return t end;return bz end;local function bA(bz,bB)local function bC(br,aU)local bD,bE=0,1;while br~=0 and aU~=0 do local bF,bG=br%bB,aU%bB;bD=bD+bz[bF][bG]*bE;br=(br-bF)/bB;aU=(aU-bG)/bB;bE=bE*bB end;bD=bD+(br+aU)*bE;return bD end;return bC end;local function bH(bz)local bI=bA(bz,2^1)local bJ=bw(function(br)return bw(function(aU)return bI(br,aU)end)end)return bA(bJ,2^(bz.n or 1))end;function bs.tobit(bK)return bK%2^32 end;bs.bxor=bH{[0]={[0]=0,[1]=1},[1]={[0]=1,[1]=0},n=4}local bL=bs.bxor;function bs.bnot(br)return bv-br end;local bM=bs.bnot;function bs.band(br,aU)return(br+aU-bL(br,aU))/2 end;local bN=bs.band;function bs.bor(br,aU)return bv-bN(bv-br,bv-aU)end;local bO=bs.bor;local bP,bQ;function bs.rshift(br,bR)if bR<0 then return bP(br,-bR)end;return bt(br%2^32/2^bR)end;bQ=bs.rshift;function bs.lshift(br,bR)if bR<0 then return bQ(br,-bR)end;return br*2^bR%2^32 end;bP=bs.lshift;function bs.tohex(bK,bd)bd=bd or 8;local bS;if bd<=0 then if bd==0 then return''end;bS=true;bd=-bd end;bK=bN(bK,16^bd-1)return('%0'..bd..(bS and'X'or'x')):format(bK)end;local bT=bs.tohex;function bs.extract(bd,bU,bV)bV=bV or 1;return bN(bQ(bd,bU),2^bV-1)end;local bW=bs.extract;function bs.replace(bd,t,bU,bV)bV=bV or 1;local bX=2^bV-1;t=bN(t,bX)local bY=bM(bP(bX,bU))return bN(bd,bY)+bP(t,bU)end;local b5=bs.replace;function bs.bswap(bK)local br=bN(bK,0xff)bK=bQ(bK,8)local aU=bN(bK,0xff)bK=bQ(bK,8)local n=bN(bK,0xff)bK=bQ(bK,8)local bZ=bN(bK,0xff)return bP(bP(bP(br,8)+aU,8)+n,8)+bZ end;local b_=bs.bswap;function bs.rrotate(bK,bR)bR=bR%32;local c0=bN(bK,2^bR-1)return bQ(bK,bR)+bP(c0,32-bR)end;local c1=bs.rrotate;function bs.lrotate(bK,bR)return c1(bK,-bR)end;local c2=bs.lrotate;bs.rol=bs.lrotate;bs.ror=bs.rrotate;function bs.arshift(bK,bR)local c3=bQ(bK,bR)if bK>=0x80000000 then c3=c3+bP(2^bR-1,32-bR)end;return c3 end;local c4=bs.arshift;function bs.btest(bK,c5)return bN(bK,c5)~=0 end;bs.bit32={}local function c6(bK)return(-1-bK)%bu end;bs.bit32.bnot=c6;local function c7(br,aU,n,...)local c3;if aU then br=br%bu;aU=aU%bu;c3=bL(br,aU)if n then c3=c7(c3,n,...)end;return c3 elseif br then return br%bu else return 0 end end;bs.bit32.bxor=c7;local function c8(br,aU,n,...)local c3;if aU then br=br%bu;aU=aU%bu;c3=(br+aU-bL(br,aU))/2;if n then c3=c8(c3,n,...)end;return c3 elseif br then return br%bu else return bv end end;bs.bit32.band=c8;local function c9(br,aU,n,...)local c3;if aU then br=br%bu;aU=aU%bu;c3=bv-bN(bv-br,bv-aU)if n then c3=c9(c3,n,...)end;return c3 elseif br then return br%bu else return 0 end end;bs.bit32.bor=c9;function bs.bit32.btest(...)return c8(...)~=0 end;function bs.bit32.lrotate(bK,bR)return c2(bK%bu,bR)end;function bs.bit32.rrotate(bK,bR)return c1(bK%bu,bR)end;function bs.bit32.lshift(bK,bR)if bR>31 or bR<-31 then return 0 end;return bP(bK%bu,bR)end;function bs.bit32.rshift(bK,bR)if bR>31 or bR<-31 then return 0 end;return bQ(bK%bu,bR)end;function bs.bit32.arshift(bK,bR)bK=bK%bu;if bR>=0 then if bR>31 then return bK>=0x80000000 and bv or 0 else local c3=bQ(bK,bR)if bK>=0x80000000 then c3=c3+bP(2^bR-1,32-bR)end;return c3 end else return bP(bK,-bR)end end;function bs.bit32.extract(bK,bU,...)local bV=...or 1;if bU<0 or bU>31 or bV<0 or bU+bV>32 then error'out of range'end;bK=bK%bu;return bW(bK,bU,...)end;function bs.bit32.replace(bK,t,bU,...)local bV=...or 1;if bU<0 or bU>31 or bV<0 or bU+bV>32 then error'out of range'end;bK=bK%bu;t=t%bu;return b5(bK,t,bU,...)end;bs.bit={}function bs.bit.tobit(bK)bK=bK%bu;if bK>=0x80000000 then bK=bK-bu end;return bK end;local ca=bs.bit.tobit;function bs.bit.tohex(bK,...)return bT(bK%bu,...)end;function bs.bit.bnot(bK)return ca(bM(bK%bu))end;local function cb(br,aU,n,...)if n then return cb(cb(br,aU),n,...)elseif aU then return ca(bO(br%bu,aU%bu))else return ca(br)end end;bs.bit.bor=cb;local function cc(br,aU,n,...)if n then return cc(cc(br,aU),n,...)elseif aU then return ca(bN(br%bu,aU%bu))else return ca(br)end end;bs.bit.band=cc;local function cd(br,aU,n,...)if n then return cd(cd(br,aU),n,...)elseif aU then return ca(bL(br%bu,aU%bu))else return ca(br)end end;bs.bit.bxor=cd;function bs.bit.lshift(bK,bd)return ca(bP(bK%bu,bd%32))end;function bs.bit.rshift(bK,bd)return ca(bQ(bK%bu,bd%32))end;function bs.bit.arshift(bK,bd)return ca(c4(bK%bu,bd%32))end;function bs.bit.rol(bK,bd)return ca(c2(bK%bu,bd%32))end;function bs.bit.ror(bK,bd)return ca(c1(bK%bu,bd%32))end;function bs.bit.bswap(bK)return ca(b_(bK%bu))end;local be=be or{}local ce=bit32 or nil;if _VERSION<="Lua 5.2"then be.len=be.len;if _VERSION=="Lua 5.1"then ce=bs end else ce=bq end;local bN=ce.band;local bO=ce.bor;local bP=ce.lshift;local bQ=ce.rshift;local cf={}function cf.string_to_bytes(string)local v={}for m=1,be.len(string)do v[m]=string:byte(m)end;return v end;function cf.is_number(bd)return tonumber(bd)~=nil end;function cf.get_pitch(cg)if cf.is_number(cg)then if cg>=0 and cg<=127 then return cg end end;cg=string.upper(cg:sub(1,1))..cg:sub(2)return bj.NOTES[cg]end;function cf.num_to_var_length(ch)local ci=bN(ch,0x7F)while bQ(ch,7)>0 do ch=bQ(ch,7)ci=bP(ci,8)ci=bO(ci,bO(bN(ch,0x7F),0x80))end;local cj={}while true do cj[#cj+1]=bN(ci,0xFF)if bN(ci,0x80)>0 then ci=bQ(ci,8)else break end end;return cj end;function cf.convert_base(ck,cl)if not ck then return ck end;if ck==tonumber(ck)then ck=math.floor(ck)end;if not cl or cl==10 then return tostring(ck)end;local cm="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"local bz={}local cn=""if tonumber(ck)<0 then cn="-"ck=-ck end;repeat local bZ=ck%cl+1;ck=math.floor(ck/cl)table.insert(bz,1,cm:sub(bZ,bZ))until ck==0;return cn..table.concat(bz,"")end;function cf.number_from_bytes(v)local co,bD=""for aq,a in ipairs(v)do bD=tostring(cf.convert_base(a,16))if#bD==1 then bD="0"..bD end;co=co..bD end;return tonumber(co,16)end;function cf.number_to_bytes(ck,cp)cp=cp or 1;local cq=tostring(cf.convert_base(ck,16))if bN(#cq,1)>0 then cq="0"..cq end;local cr={}while#cq>0 do table.insert(cr,cq:sub(1,2))cq=cq:sub(3)end;for m,cs in ipairs(cr)do cr[m]=tonumber(cf.convert_base(tonumber('0x'..cs),10))end;while#cr<cp do table.insert(cr,1,0)end;return cr end;function cf.table_concat(ct,cu)local bD={}for m=1,#ct do bD[m]=ct[m]end;for m=1,#cu do bD[#bD+1]=cu[m]end;return bD end;function cf.table_index_of(table,cv)if type(table)=='table'then for cw,cx in pairs(table)do if cv==cx then return cw end end;return false end end;function cf.table_invert(table)if type(table)=='table'then local cy={}for cw,cx in pairs(table)do cy[cx]=cw end;return cy end;return false end;function cf.round(b9)if b9>=0 then return math.floor(b9+.5)else return math.ceil(b9-.5)end end;function cf.is_track_header(v)return#v==4 and v[1]==0x4D and v[2]==0x54 and v[3]==0x72 and v[4]==0x6B end;bf.Util=cf;local cz={}function cz.new(bh)local cA=cf.num_to_var_length(0x00)cA=cf.table_concat(cA,{bj.META_EVENT_ID})cA=cf.table_concat(cA,bh.data)local self={type='meta',data=cA}return setmetatable(self,{__index=cz})end;function cz:print()local cB=""if cf.table_index_of(bj.METADATA_TYPES,self.subtype)<0x08 then for y=5,#self.data do cB=cB..string.char(self.data[y])end;cB='\t"'..cB..'"'elseif self.subtype=="Tempo"then local cC={self.data[5],self.data[6],self.data[7]}local cD=cf.number_from_bytes(cC)local cE=cf.round(60000000/cD)cB="\t"..cE.." bpm"elseif self.subtype=="Time Signature"then cB=self.data[5]cB=cB.."/"..math.ceil(2^self.data[6])elseif self.subtype=="Key Signature"then local cF={'major','minor'}local cG={{'C','A'},{'G','E'},{'D','B'},{'A','F#'},{'E','C#'},{'B','G#'},{'F#','D#'},{'C#','A#'}}local cH=tostring(self.data[5])cB=cH.."#"cB=cB.." ("..cG[cH+1][self.data[6]+1].." "..cF[self.data[6]+1]..")"end;print("\nClass / Type:\tMetaEvent / '"..self.type.."'")print(self.subtype..":",cB)end;bf.MetaEvent=cz;local cI={}function cI.new(bh)assert(type(bh.pitch)=='string'or type(bh.pitch)=='number'or type(bh.pitch)=='table',"'pitch' must be a string, a number or an array")if type(bh.pitch)=='string'or type(bh.pitch)=='number'then bh.pitch={bh.pitch}end;local self={type='note',pitch=bh.pitch,rest=bh.rest,duration=bh.duration,sequential=bh.sequential,velocity=bh.velocity,channel=bh.channel,repetition=bh.repetition}if self.duration~=nil then assert(type(self.duration)=='string'or type(self.duration)=='number',"'duration' must be a string or a number")else self.duration='4'end;if self.rest~=nil then assert(type(self.rest)=='string'or type(self.rest)=='number',"'rest' must be a string or a number")else self.rest=0 end;if self.velocity~=nil then assert(type(self.velocity)=='number'and self.velocity>=1 and self.velocity<=100,"'velocity' must be an integer from 1 to 100")else self.velocity=50 end;if self.sequential~=nil then assert(type(self.sequential)=='boolean',"'sequential' must be a boolean")else self.sequential=false end;if self.repetition~=nil then assert(type(self.repetition)=='number'and self.repetition>=1,"'repetition' must be a positive integer")else self.repetition=1 end;if self.channel~=nil then assert(type(self.channel)=='number'and self.channel>=1 and self.channel<=16,"'channel' must be an integer from 1 to 16")else self.channel=1 end;self.convert_velocity=function(cJ)return cf.round(cJ/100*127)end;self.velocity=self.convert_velocity(self.velocity)self.get_tick_duration=function(cK,type)if tostring(cK):lower():sub(1,1)=='t'then return string.match(tostring(cK),"%d+")end;local cL=cf.number_from_bytes(bj.HEADER_CHUNK_DIVISION)return cf.round(cL*self.get_duration_multiplier(cK,type))end;self.get_duration_multiplier=function(cK,type)cK=tostring(cK)if cK=='0'then return 0 elseif cK=='1'then return 4 elseif cK=='2'then return 2 elseif cK=='d2'then return 3 elseif cK=='4'then return 1 elseif cK=='d4'then return 1.5 elseif cK=='8'then return 0.5 elseif cK=='8t'then return 0.33 elseif cK=='d8'then return 0.75 elseif cK=='16'then return 0.25 else if type=='note'then return 1 end;return 0 end end;self.get_note_on_status=function()return 144+self.channel-1 end;self.get_note_off_status=function()return 128+self.channel-1 end;self.build_data=function()self.data={}local cM=self.get_tick_duration(self.duration,'note')local cN=self.get_tick_duration(self.rest,'rest')local cO,cP;if not self.sequential then for y=1,self.repetition do for m=1,#self.pitch do local bE=self.pitch[m]local bh={}local cA;if m==1 then cA=cf.num_to_var_length(cN)cA[#cA+1]=self.get_note_on_status()cA[#cA+1]=cf.get_pitch(bE)cA[#cA+1]=self.velocity else cA={0,cf.get_pitch(bE),self.velocity}end;bh.data=cA;cO=bg.new(bh)self.data=cf.table_concat(self.data,cO.data)end;for m=1,#self.pitch do local bE=self.pitch[m]local bh={}local cA;if m==1 then cA=cf.num_to_var_length(cM)cA[#cA+1]=self.get_note_off_status()cA[#cA+1]=cf.get_pitch(bE)cA[#cA+1]=self.velocity else cA={0,cf.get_pitch(bE),self.velocity}end;bh.data=cA;cP=bi.new(bh)self.data=cf.table_concat(self.data,cP.data)end end else for y=1,self.repetition do for m=1,#self.pitch do local bE=self.pitch[m]local bh={}if m>1 then cN=0 end;if self.duration=='8t'and m==#self.pitch then local cL=cf.number_from_bytes(bj.HEADER_CHUNK_DIVISION)cM=cL-cM*2 end;local cQ,cR={},{}local cS=cf.num_to_var_length(cN)cS[#cS+1]=self.get_note_on_status()cS[#cS+1]=cf.get_pitch(bE)cS[#cS+1]=self.velocity;cQ.data=cS;cO=bg.new(cQ)local cT=cf.num_to_var_length(cM)cT[#cT+1]=self.get_note_off_status()cT[#cT+1]=cf.get_pitch(bE)cT[#cT+1]=self.velocity;cR.data=cT;cP=bi.new(cR)self.data=cf.table_concat(self.data,cS)self.data=cf.table_concat(self.data,cT)end end end end;self.build_data()return setmetatable(self,{__index=cI})end;function cI:print()local function cU(S)if not tonumber(S:sub(1,1))then return"'"..S.."'"end;return S end;local cg=self.pitch;if#self.pitch>0 then cg="{ "for m=1,#self.pitch-1 do cg=cg..cU(self.pitch[m])cg=cg..", "end;cg=cg..cU(self.pitch[#self.pitch])cg=cg.." }"end;local S=string.format("Pitch:\t\t%s\n",tostring(cg))S=S..string.format("Duration:\t%s\n",tostring(self.duration))S=S..string.format("Rest:\t\t%s\n",tostring(self.rest))S=S..string.format("Velocity:\t%d\n",tostring(self.velocity))S=S..string.format("Sequential:\t%s\n",tostring(self.sequential))S=S..string.format("Repetition:\t%d\n",tostring(self.repetition))S=S..string.format("Channel:\t%d",tostring(self.channel))print("\nClass / Type:\tNoteEvent / '"..self.type.."'")print(S)end;function cI:set_pitch(cg)assert(type(cg)=='string'or type(cg)=='number'or type(cg)=='table',"'pitch' must be a string, a number or an array")if type(cg)=='string'or type(cg)=='number'then cg={cg}end;self.pitch=cg;self.build_data()return self end;function cI:set_duration(cK)assert(type(cK)=='string'or type(cK)=='number',"'duration' must be a string or a number")if type(cK)=='number'then cK=tostring(cK)end;self.duration=cK;self.build_data()return self end;function cI:set_rest(cV)assert(type(cV)=='string'or type(cV)=='number',"'rest' must be a string or a number")if type(cV)=='number'then cV=tostring(cV)end;self.rest=cV;self.build_data()return self end;function cI:set_velocity(cJ)assert(type(cJ)=='number'and cJ>=1 and cJ<=100,"'velocity' must be an integer from 1 to 100")self.velocity=self.convert_velocity(cJ)self.build_data()return self end;function cI:set_sequential(cW)assert(type(cW)=='boolean',"'sequential' must be a boolean")self.sequential=cW;self.build_data()return self end;function cI:set_repetition(cX)assert(type(cX)=='number'and cX>=1,"'repetition' must be a positive integer")self.repetition=cX;self.build_data()return self end;function cI:set_channel(cY)assert(type(cY)=='number'and cY>=1 and cY<=16,"'channel' must be an integer from 1 to 16")self.channel=cY;self.build_data()return self end;function cI:get_pitch()return self.pitch end;function cI:get_duration()return self.duration end;function cI:get_rest()return self.rest end;function cI:get_velocity()return self.velocity end;function cI:get_sequential()return self.sequential end;function cI:get_repetition()return self.repetition end;function cI:get_channel()return self.channel end;bf.NoteEvent=cI;local cZ={}function cZ.new(c_)local self={type='program-change',data={0x00,bj.PROGRAM_CHANGE_STATUS,c_}}return setmetatable(self,{__index=cZ})end;function cZ:print()print("\nClass / Type:\tProgramChangeEvent / '"..self.type.."'")print("Data:\t",self.data[3])end;function cZ:set_value(cx)if type(cx)~='number'then return false end;self.data[3]=cx;return self end;function cZ:get_value()return self.data[3]end;bf.ProgramChangeEvent=cZ;local d0={}function d0.new(d1)local self={type=bj.TRACK_CHUNK_TYPE,data={},size={},events={},metadata={}}local d2=setmetatable(self,{__index=d0})if d1~=nil then d2:set_name(d1)end;return d2 end;function d0:add_events(d3,d4)if d3.type then d3={d3}end;for m,d5 in ipairs(d3)do if type(d4)=='function'and d5.type=='note'then local d6=d4(m,d5)if type(d6)=='table'then d5.duration=d6.duration or d5.duration;d5.sequential=d6.sequential or d5.sequential;d5.velocity=d5.convert_velocity(d6.velocity or d5.velocity)end end;self.events[#self.events+1]=d5 end;return self end;function d0:get_events(d7)if d7~=nil then assert(d7=='note'or d7=='meta'or d7=='program-change',"Invalid filter")local d3={}for aq,d5 in ipairs(self.events)do if d5.type==d7 then d3[#d3+1]=d5 end end;return d3 end;return self.events end;local function d8(d9,da)if d9.metadata[bj.METADATA_TYPES[da]]then for m,cs in ipairs(d9.events)do if cs.subtype==bj.METADATA_TYPES[da]then d9.events[m]=cz.new({data={da}})return d9.events[m]end end end;return cz.new({data={da}})end;function d0:set_tempo(cE)assert(cE>0,"Invalid 'bpm' value")local da=bj.META_TEMPO_ID;local d5=d8(self,da)d5.data[#d5.data+1]=0x03;local db=cf.round(60000000/cE)d5.data=cf.table_concat(d5.data,cf.number_to_bytes(db,3))d5.subtype=bj.METADATA_TYPES[da]if self.metadata.Tempo then self.metadata.Tempo=cE;return self end;self.metadata.Tempo=cE;return self:add_events(d5)end;function d0:set_time_signature(b9,dc,dd,de)dd=dd or 24;de=de or 8;dc=math.log(dc,2)local da=bj.META_TIME_SIGNATURE_ID;local d5=d8(self,da)d5.data[#d5.data+1]=0x04;d5.data=cf.table_concat(d5.data,cf.number_to_bytes(b9,1))d5.data=cf.table_concat(d5.data,cf.number_to_bytes(dc,1))d5.data=cf.table_concat(d5.data,cf.number_to_bytes(dd,1))d5.data=cf.table_concat(d5.data,cf.number_to_bytes(de,1))d5.subtype=bj.METADATA_TYPES[da]if self.metadata['Time Signature']then self.metadata['Time Signature']=b9 ..'/'..math.ceil(2^dc)return self end;self.metadata['Time Signature']=b9 ..'/'..math.ceil(2^dc)return self:add_events(d5)end;function d0:set_key_signature(df,dg)local da=bj.META_KEY_SIGNATURE_ID;local d5=d8(self,da)d5.data[#d5.data+1]=0x02;df=df%8;dg=dg%2;local dh=dg or 0;df=df or 0;if not dg then local di={{'Cb','Gb','Db','Ab','Eb','Bb','F','C','G','D','A','E','B','F#','C#'},{'ab','eb','bb','f','c','g','d','a','e','b','f#','c#','g#','d#','a#'}}local bn=df or'C'if df:sub(1,1)==string.lower(df:sub(1,1))then dh=1 end;if#df>1 then local dj=df:sub(#df,#df)if dj=='m'or dj=='-'then dh=1;bn=string.lower(df:sub(1,1))elseif dj=='M'or start_with=='+'then dh=0;bn=string.upper(df:sub(1,1))end;bn=bn..df:sub(2,#df)end;local dk=cf.table_index_of(di[dh],bn)if not dk then df=0 else df=dk-7 end end;d5.data=cf.table_concat(d5.data,cf.number_to_bytes(df,1))d5.data=cf.table_concat(d5.data,cf.number_to_bytes(dh,1))d5.subtype=bj.METADATA_TYPES[da]local dl;do local cF={'major','minor'}local cG={{'C','A'},{'G','E'},{'D','B'},{'A','F#'},{'E','C#'},{'B','G#'},{'F#','D#'},{'C#','A#'}}local cH=tostring(cf.number_from_bytes({df}))dl=cH.."#"dl=dl.." ("..cG[cH+1][cf.number_from_bytes({dh})+1].." "..cF[cf.number_from_bytes({dh})+1]..")"end;if self.metadata['Key Signature']then self.metadata['Key Signature']=dl;return self end;self.metadata['Key Signature']=dl;return self:add_events(d5)end;local function dm(self,dn,da)local d5=d8(self,da)local dp=cf.string_to_bytes(dn)d5.data=cf.table_concat(d5.data,cf.num_to_var_length(#dp))d5.data=cf.table_concat(d5.data,dp)d5.subtype=bj.METADATA_TYPES[da]if self.metadata[bj.METADATA_TYPES[da]]then return self end;self.metadata[bj.METADATA_TYPES[da]]=dn;return self:add_events(d5)end;function d0:set_text(dq)assert(type(dq)=='string',"'text' must be a string")return dm(self,dq,bj.META_TEXT_ID)end;function d0:set_copyright(dr)assert(type(dr)=='string',"'copyright' must be a string")return dm(self,dr,bj.META_COPYRIGHT_ID)end;function d0:set_name(d1)assert(type(d1)=='string',"'name' must be a string")return dm(self,d1,bj.META_TRACK_NAME_ID)end;function d0:set_instrument_name(ds)assert(type(ds)=='string',"'instrument_name' must be a string")return dm(self,ds,bj.META_INSTRUMENT_NAME_ID)end;function d0:set_lyric(dt)assert(type(dt)=='string',"'lyric' must be a string")return dm(self,dt,bj.META_LYRIC_ID)end;function d0:set_marker(du)assert(type(du)=='string',"'marker' must be a string")return dm(self,du,bj.META_MARKER_ID)end;function d0:set_cue_point(dv)assert(type(dv)=='string',"'cue_point' must be a string")return dm(self,dv,bj.META_CUE_POINT)end;function d0:poly_mode_on()local d5=bg.new({data={0x00,0xB0,0x7E,0x00}})return self:add_events(d5)end;function d0:get_tempo()return self.metadata.Tempo end;function d0:get_time_signature()return self.metadata['Time Signature']end;function d0:get_key_signature()return self.metadata['Key Signature']end;function d0:get_text()return self.metadata.Text end;function d0:get_copyright()return self.metadata.Copyright end;function d0:get_name()return self.metadata.Name end;function d0:get_instrument_name()return self.metadata.Instrument end;function d0:get_lyric()return self.metadata.Lyric end;function d0:get_marker()return self.metadata.Marker end;function d0:get_cue_point()return self.metadata["Cue Point"]end;bf.Track=d0;local dw={}function dw.new(dx)assert(type(dx)=='table'and(dx.type or dx[1].type),"'tracks' must be a Track object or array of Track objects")if#dx==0 and dx.type then if cf.is_track_header(dx.type)then dx={dx}end end;local self={data={},tracks=dx}self.build_track=function(d9)for m=1,#d9.events do local d5=d9.events[m]if d5.type=='note'then d5.build_data()end;d9.data=cf.table_concat(d9.data,d5.data)d9.size=cf.number_to_bytes(#d9.data,4)end;return d9 end;self.build_writer=function(dy,dz)local dA=bj.HEADER_CHUNK_FORMAT0;if dz>1 then dA=bj.HEADER_CHUNK_FORMAT1 end;local dB=cf.table_concat(dA,cf.number_to_bytes(dz,2))dB=cf.table_concat(dB,bj.HEADER_CHUNK_DIVISION)self.data[1]=bp.new({type=bj.HEADER_CHUNK_TYPE,data=dB})for m=1,#dy do local d9=dy[m]d9:add_events(cz.new({data=bj.META_END_OF_TRACK_ID}))d9=self.build_track(d9)self.data[#self.data+1]=d9 end end;self.build_writer(self.tracks,#self.tracks)return setmetatable(self,{__index=dw})end;function dw:add_tracks(dy)assert(type(dy)=='table'and(dy.type or dy[1].type),"'new_tracks' must be a Track object or array of Track objects")if#dy==0 and dy.type then if cf.is_track_header(dy.type)then dy={dy}end end;self.tracks=cf.table_concat(self.tracks,dy)self.build_writer(dy,#self.tracks)end;function dw:build_file()local dC={}for m=1,#self.data do local cs=self.data[m]dC=cf.table_concat(dC,cs.type)dC=cf.table_concat(dC,cs.size)dC=cf.table_concat(dC,cs.data)end;return dC end;function dw:stdout(dD)local ci=self:build_file()print('{')for m=1,#ci do local a=ci[m]io.write('  ')if dD then io.write(m..' - ')end;io.write(a)if m<#ci then io.write(',')end;io.write('\n')end;print('}')end;function dw:save_MIDI(dE,dF)if dE:sub(#dE-3)~=".mid"then dE=dE..".mid"end;if type(dF)=='string'and#dF~=0 then os.execute("mkdir ".."'"..dF.."'")if dF:sub(-1)=='/'then dE=dF..dE else dE=dF..'/'..dE end end;local dG=io.open(dE,'wb')local v=self:build_file()local ci=""for m=1,#v do local a=v[m]ci=ci..string.char(a)end;dG:write(ci)dG:close()end;bf.Writer=dw
local LuaMidi = bf
-- End LuaMidi

-- Photism note mapping
local noteMap = {
  A={
    r=254,
    g=98,
    b=1
  },
  Asharp={
    r=255,
    g=236,
    b=2
  },
  B={
    r=153,
    g=255,
    b=2
  },
  C={
    r=40,
    g=255,
    b=1
  },
  Csharp={
    r=22,
    g=255,
    b=232
  },
  D={
    r=0,
    g=124,
    b=255
  },
  Dsharp={
    r=5,
    g=23,
    b=255
  },
  E={
    r=68,
    g=19,
    b=235
  },
  F={
    r=87,
    g=7,
    b=158
  },
  Fsharp={
    r=116,
    g=0,
    b=0
  },
  G={
    r=179,
    g=1,
    b=0
  },
  Gsharp={
    r=238,
    g=0,
    b=2
  }
}

-- Midi instrument PC mapping
midiInstrumentMapping = {}
midiInstrumentMapping["Acoustic Grand Piano"] = 1
midiInstrumentMapping["Bright Acoustic Piano"] = 2
midiInstrumentMapping["Electric Grand Piano"] = 3
midiInstrumentMapping["Honky-tonk Piano"] = 4
midiInstrumentMapping["Electric Piano"] = 5
midiInstrumentMapping["Electric Piano"] = 6
midiInstrumentMapping["Harpsichord"] = 7
midiInstrumentMapping["Clavinet"] = 8
midiInstrumentMapping["Celesta"] = 9
midiInstrumentMapping["Glockenspiel"] = 10
midiInstrumentMapping["Music Box"] = 11
midiInstrumentMapping["Vibraphone"] = 12
midiInstrumentMapping["Marimba"] = 13
midiInstrumentMapping["Xylophone"] = 14
midiInstrumentMapping["Tubular Bells"] = 15
midiInstrumentMapping["Dulcimer"] = 16
midiInstrumentMapping["Drawbar Organ"] = 17
midiInstrumentMapping["Percussive Organ"] = 18
midiInstrumentMapping["Rock Organ"] = 19
midiInstrumentMapping["Church Organ"] = 20
midiInstrumentMapping["Reed Organ"] = 21
midiInstrumentMapping["Accordion"] = 22
midiInstrumentMapping["Harmonica"] = 23
midiInstrumentMapping["Tango Accordion"] = 24
midiInstrumentMapping["Acoustic Guitar (nylon)"] = 25
midiInstrumentMapping["Acoustic Guitar (steel)"] = 26
midiInstrumentMapping["Electric Guitar (jazz)"] = 27
midiInstrumentMapping["Electric Guitar (clean)"] = 28
midiInstrumentMapping["Electric Guitar (muted)"] = 29
midiInstrumentMapping["Overdriven Guitar"] = 30
midiInstrumentMapping["Distortion Guitar"] = 31
midiInstrumentMapping["Guitar harmonics"] = 32
midiInstrumentMapping["Acoustic Bass"] = 33
midiInstrumentMapping["Electric Bass (finger)"] = 34
midiInstrumentMapping["Electric Bass (pick)"] = 35
midiInstrumentMapping["Fretless Bass"] = 36
midiInstrumentMapping["Slap Bass 1"] = 37
midiInstrumentMapping["Slap Bass 2"] = 38
midiInstrumentMapping["Synth Bass 1"] = 39
midiInstrumentMapping["Synth Bass 2"] = 40
midiInstrumentMapping["Violin"] = 41
midiInstrumentMapping["Viola"] = 42
midiInstrumentMapping["Cello"] = 43
midiInstrumentMapping["Contrabass"] = 44
midiInstrumentMapping["Tremolo Strings"] = 45
midiInstrumentMapping["Pizzicato Strings"] = 46
midiInstrumentMapping["Orchestral Harp"] = 47
midiInstrumentMapping["Timpani"] = 48
midiInstrumentMapping["String Ensemble 1"] = 49
midiInstrumentMapping["String Ensemble 2"] = 50
midiInstrumentMapping["Synth Strings 1"] = 51
midiInstrumentMapping["Synth Strings 2"] = 52
midiInstrumentMapping["Choir Aahs"] = 53
midiInstrumentMapping["Voice Oohs"] = 54
midiInstrumentMapping["Synth Voice"] = 55
midiInstrumentMapping["Orchestra Hit"] = 56
midiInstrumentMapping["Trumpet"] = 57
midiInstrumentMapping["Trombone"] = 58
midiInstrumentMapping["Tuba"] = 59
midiInstrumentMapping["Muted Trumpet"] = 60
midiInstrumentMapping["French Horn"] = 61
midiInstrumentMapping["Brass Section"] = 62
midiInstrumentMapping["Synth Brass 1"] = 63
midiInstrumentMapping["Synth Brass 2"] = 64
midiInstrumentMapping["Soprano Sax"] = 65
midiInstrumentMapping["Alto Sax"] = 66
midiInstrumentMapping["Tenor Sax"] = 67
midiInstrumentMapping["Baritone Sax"] = 68
midiInstrumentMapping["Oboe"] = 69
midiInstrumentMapping["English Horn"] = 70
midiInstrumentMapping["Bassoon"] = 71
midiInstrumentMapping["Clarinet"] = 72
midiInstrumentMapping["Piccolo"] = 73
midiInstrumentMapping["Flute"] = 74
midiInstrumentMapping["Recorder"] = 75
midiInstrumentMapping["Pan Flute"] = 76
midiInstrumentMapping["Blown Bottle"] = 77
midiInstrumentMapping["Shakuhachi"] = 78
midiInstrumentMapping["Whistle"] = 79
midiInstrumentMapping["Ocarina"] = 80
midiInstrumentMapping["Lead 1 (square)"] = 81
midiInstrumentMapping["Lead 2 (sawtooth)"] = 82
midiInstrumentMapping["Lead 3 (calliope)"] = 83
midiInstrumentMapping["Lead 4 (chiff)"] = 84
midiInstrumentMapping["Lead 5 (charang)"] = 85
midiInstrumentMapping["Lead 6 (voice)"] = 86
midiInstrumentMapping["Lead 7 (fifths)"] = 87
midiInstrumentMapping["Lead 8 (bass + lead)"] = 88
midiInstrumentMapping["Sitar"] = 105
midiInstrumentMapping["Banjo"] = 106
midiInstrumentMapping["Shamisen"] = 107
midiInstrumentMapping["Koto"] = 108
midiInstrumentMapping["Kalimba"] = 109
midiInstrumentMapping["Bag pipe"] = 110
midiInstrumentMapping["Fiddle"] = 111
midiInstrumentMapping["Shanai"] = 112

-- Construct midi instrument string table
local midiInstruments = {}
table.insert(midiInstruments, "Acoustic Grand Piano")
table.insert(midiInstruments, "Bright Acoustic Piano")
table.insert(midiInstruments, "Electric Grand Piano")
table.insert(midiInstruments, "Honky-tonk Piano")
table.insert(midiInstruments, "Electric Piano")
table.insert(midiInstruments, "Electric Piano")
table.insert(midiInstruments, "Harpsichord")
table.insert(midiInstruments, "Clavinet")
table.insert(midiInstruments, "Celesta")
table.insert(midiInstruments, "Glockenspiel")
table.insert(midiInstruments, "Music Box")
table.insert(midiInstruments, "Vibraphone")
table.insert(midiInstruments, "Marimba")
table.insert(midiInstruments, "Xylophone")
table.insert(midiInstruments, "Tubular Bells")
table.insert(midiInstruments, "Dulcimer")
table.insert(midiInstruments, "Drawbar Organ")
table.insert(midiInstruments, "Percussive Organ")
table.insert(midiInstruments, "Rock Organ")
table.insert(midiInstruments, "Church Organ")
table.insert(midiInstruments, "Reed Organ")
table.insert(midiInstruments, "Accordion")
table.insert(midiInstruments, "Harmonica")
table.insert(midiInstruments, "Tango Accordion")
table.insert(midiInstruments, "Acoustic Guitar (nylon)")
table.insert(midiInstruments, "Acoustic Guitar (steel)")
table.insert(midiInstruments, "Electric Guitar (jazz)")
table.insert(midiInstruments, "Electric Guitar (clean)")
table.insert(midiInstruments, "Electric Guitar (muted)")
table.insert(midiInstruments, "Overdriven Guitar")
table.insert(midiInstruments, "Distortion Guitar")
table.insert(midiInstruments, "Guitar harmonics")
table.insert(midiInstruments, "Acoustic Bass")
table.insert(midiInstruments, "Electric Bass (finger)")
table.insert(midiInstruments, "Electric Bass (pick)")
table.insert(midiInstruments, "Fretless Bass")
table.insert(midiInstruments, "Slap Bass 1")
table.insert(midiInstruments, "Slap Bass 2")
table.insert(midiInstruments, "Synth Bass 1")
table.insert(midiInstruments, "Synth Bass 2")
table.insert(midiInstruments, "Violin")
table.insert(midiInstruments, "Viola")
table.insert(midiInstruments, "Cello")
table.insert(midiInstruments, "Contrabass")
table.insert(midiInstruments, "Tremolo Strings")
table.insert(midiInstruments, "Pizzicato Strings")
table.insert(midiInstruments, "Orchestral Harp")
table.insert(midiInstruments, "Timpani")
table.insert(midiInstruments, "String Ensemble 1")
table.insert(midiInstruments, "String Ensemble 2")
table.insert(midiInstruments, "Synth Strings 1")
table.insert(midiInstruments, "Synth Strings 2")
table.insert(midiInstruments, "Choir Aahs")
table.insert(midiInstruments, "Voice Oohs")
table.insert(midiInstruments, "Synth Voice")
table.insert(midiInstruments, "Orchestra Hit")
table.insert(midiInstruments, "Trumpet")
table.insert(midiInstruments, "Trombone")
table.insert(midiInstruments, "Tuba")
table.insert(midiInstruments, "Muted Trumpet")
table.insert(midiInstruments, "French Horn")
table.insert(midiInstruments, "Brass Section")
table.insert(midiInstruments, "Synth Brass 1")
table.insert(midiInstruments, "Synth Brass 2")
table.insert(midiInstruments, "Soprano Sax")
table.insert(midiInstruments, "Alto Sax")
table.insert(midiInstruments, "Tenor Sax")
table.insert(midiInstruments, "Baritone Sax")
table.insert(midiInstruments, "Oboe")
table.insert(midiInstruments, "English Horn")
table.insert(midiInstruments, "Bassoon")
table.insert(midiInstruments, "Clarinet")
table.insert(midiInstruments, "Piccolo")
table.insert(midiInstruments, "Flute")
table.insert(midiInstruments, "Recorder")
table.insert(midiInstruments, "Pan Flute")
table.insert(midiInstruments, "Blown Bottle")
table.insert(midiInstruments, "Shakuhachi")
table.insert(midiInstruments, "Whistle")
table.insert(midiInstruments, "Ocarina")
table.insert(midiInstruments, "Lead 1 (square)")
table.insert(midiInstruments, "Lead 2 (sawtooth)")
table.insert(midiInstruments, "Lead 3 (calliope)")
table.insert(midiInstruments, "Lead 4 (chiff)")
table.insert(midiInstruments, "Lead 5 (charang)")
table.insert(midiInstruments, "Lead 6 (voice)")
table.insert(midiInstruments, "Lead 7 (fifths)")
table.insert(midiInstruments, "Lead 8 (bass + lead)")
table.insert(midiInstruments, "Sitar")
table.insert(midiInstruments, "Banjo")
table.insert(midiInstruments, "Shamisen")
table.insert(midiInstruments, "Koto")
table.insert(midiInstruments, "Kalimba")
table.insert(midiInstruments, "Bag pipe")
table.insert(midiInstruments, "Fiddle")
table.insert(midiInstruments, "Shanai")

-- Mathematical mean from table of values
function mean( t )
  local sum = 0
  local count= 0

  for k,v in pairs(t) do
    if type(v) == 'number' then
      sum = sum + v
      count = count + 1
    end
  end

  return (sum / count)
end

-- Determines the closest color in the note mapping to the given RGB values
local function determineNoteFromColor(r, g, b)
  local noteAlikeness = {}
  for k, v in pairs(noteMap) do
    noteAlikeness[k] = mean({
      math.abs(v.r - r),
      math.abs(v.g - g),
      math.abs(v.b - b)
    });
  end

  local mostAlikeNote = 'A';
  for k, v in pairs(noteAlikeness) do
    if (noteAlikeness[k] < noteAlikeness[mostAlikeNote]) then
      mostAlikeNote = k;
    end
  end

  return mostAlikeNote;
end

-- Determines octave and note length based on its consecutive appearance
local function getNoteOctaveLength(count)
  local noteProperties = {}

  if count < 6 then
    noteProperties.octave = "4"
  elseif count > 5 and count < 11 then
    noteProperties.octave = "5"
  elseif count > 10 and count < 16 then
    noteProperties.octave = "6"
  else
    noteProperties.octave = "3"
  end

  if count == 1 then noteProperties.duration = "16"
  elseif count == 2 then noteProperties.duration = "8"
  elseif count == 3 then noteProperties.duration = "4"
  elseif count == 4 then noteProperties.duration = "2"
  elseif count == 5 then noteProperties.duration = "1"
  elseif count == 6 then noteProperties.duration = "16"
  elseif count == 7 then noteProperties.duration = "8"
  elseif count == 8 then noteProperties.duration = "4"
  elseif count == 9 then noteProperties.duration = "2"
  elseif count == 10 then noteProperties.duration = "1"
  elseif count == 11 then noteProperties.duration = "16"
  elseif count == 12 then noteProperties.duration = "8"
  elseif count == 13 then noteProperties.duration = "4"
  elseif count == 14 then noteProperties.duration = "2"
  elseif count == 15 then noteProperties.duration = "1"
  else noteProperties.duration = "1"
  end

  return noteProperties
end

-- Ensure we can use UI stuff
if not app.isUIAvailable then
  return
end

-- Ensure a sprite is loaded
if app.activeSprite == nil then
  app.alert("You must open a sprite first to use this script!")
  return
end

-- Ensure the current layer is a valid one
if not app.activeLayer.isImage or not app.activeLayer.isEditable then
  app.alert("You must have an editable image layer selected!")
  return
end

-- Determines if a pixel has any data in it
local function pixelHasData(pixel)
  local rgbaAlpha = app.pixelColor.rgbaA(pixel)
  local grayAlpha = app.pixelColor.grayaA(pixel)

  return rgbaAlpha ~= 0 or grayAlpha ~= 0
end

-- Polyfil for active frame
local function activeFrameNumber()
  local f = app.activeFrame
  if f == nil then
    return 1
  else
    return f
  end
end

-- Returns the cel in the given layer and frame
local function getActiveCel(layer, frame)
  -- Loop through cels
  for i,cel in ipairs(layer.cels) do

    -- Find the cell in the given frame
    if cel.frame == frame then
      return cel
    end
  end
end

-- Get sprite data
local sprite = app.activeSprite
local currentLayer = app.activeLayer
local activeFrame = activeFrameNumber()
local pixelColor = app.pixelColor
local cel = getActiveCel(currentLayer, activeFrame)

-- Get system home directory
local homePath = os.getenv("HOME") or os.getenv("HOMEPATH")

-- Default options
local filePath = homePath.."/audio"..".mid"
local tempo = 120

-- Prepare the dialog
local dlg = Dialog()

-- Main inputs
dlg:label{ text="This will generate a piece of music in the form of a midi file" }
dlg:newrow()
dlg:label{ text="based ONLY on the currently selected layer/frame." }
dlg:separator{ text="Options" }
dlg:entry{ id="path", label="Output path", text=filePath }
dlg:slider{ id="tempo", label="Tempo (BPM)", min=40, max=240, value=tempo }
dlg:combobox{
  id="instrument",
  label="Instrument",
  option="Acoustic Grand Piano",
  options=midiInstruments
}

-- Buttons
dlg:button{ id="ok", text="Generate MIDI" }
dlg:button{ id="cancel", text="Cancel" }

-- Show the dialog
dlg:show()

-- Get dialog data
local data = dlg.data

-- Only proceed if needed
if not data.ok then
  return
end

local compressedImageData = {}

-- Loop through the image pixels
for it in cel.image:pixels() do
  local pixel = it()

  -- Only save if the pixel has data
  if pixelHasData(pixel) then
    local r = pixelColor.rgbaR(pixel)
    local g = pixelColor.rgbaG(pixel)
    local b = pixelColor.rgbaB(pixel)

    local note = determineNoteFromColor(r, g, b)
    local lastNoteData = compressedImageData[#compressedImageData]

    if lastNoteData ~= nil and note == lastNoteData.note then
      lastNoteData.count = lastNoteData.count + 1
    else
      table.insert(compressedImageData, { note=note, count=1 })
    end
  end
end

-- Extract LuaMidi stuffs
local Track = LuaMidi.Track
local NoteEvent = LuaMidi.NoteEvent
local Writer = LuaMidi.Writer
local ProgramChangeEvent = LuaMidi.ProgramChangeEvent

-- Create a track
local track = Track.new("Track 1")
track:set_instrument_name(data.instrument)
track:set_tempo(data.tempo)
track:add_events( ProgramChangeEvent.new( midiInstrumentMapping[data.instrument] - 1 ) )

-- Loop through compressed image note data
for k, v in pairs(compressedImageData) do
  local pitch
  local duration
  local note = v.note
  local count = v.count

  local noteProperties = getNoteOctaveLength(count)

  -- Determine note
  if note == "A" then
    pitch = "A"
  elseif note == "Asharp" then
    pitch = "A#"
  elseif note == "B" then
    pitch = "B"
  elseif note == "C" then
    pitch = "C"
  elseif note == "Csharp" then
    pitch = "C#"
  elseif note == "D" then
    pitch = "D"
  elseif note == "Dsharp" then
    pitch = "D#"
  elseif note == "E" then
    pitch = "E"
  elseif note == "F" then
    pitch = "F"
  elseif note == "Fsharp" then
    pitch = "F#"
  elseif note == "G" then
    pitch = "G"
  elseif note == "Gsharp" then
    pitch = "G#"
  end

  -- Append Octave
  pitch = pitch..noteProperties.octave

  track:add_events({
    NoteEvent.new({ pitch = pitch, duration = noteProperties.duration }),
  })
end

local writer = Writer.new(track)
writer:save_MIDI(data.path, 0)
