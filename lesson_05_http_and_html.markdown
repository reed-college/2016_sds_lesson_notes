The General Idea: Web Servers
-----------------------------

You would like a Web Page to Appear on the Internet – *but how?* What is the mechanism by which we arrive at a Web Page being On the Internet? What if that web page is "interactive" – what then?

The answer is a web server – a piece of software that runs on a computer and provides (that is, *serves*) content using a communication protocol called HTTP (sometimes HTTPS). In this way, two computers – say, your computer and a server – can have a conversation roughly like this:

-   Your Computer: Hey Server! Gimme thewebpage.com!
-   The Server: You got it! Here it is.

Today we're going to expand the above exchange – make it considerably more detailed and accurate. Note that our goal is a working mental model, **not** an exhaustive representation of how the modern internet functions. We'll be eliding a number of details, though I'll try to be very clear about which ones and when. This section will be considerably heavier on the "want to learn more? click here!" links than our previous topics.

Ready? Here we go!

A note about `cURL`, `sed`, and newline characters
--------------------------------------------------

`cURL` (more commonly `curl`) is a command-line utility for interacting with The Internet. I'll be using it here to get raw content from the internet. You'll see a certain amount of the `-i` (include headers) and `-I` (only the headers) flags.

`curl` is veryvery powerful, and also a little arcane. It's not completely ubiquitous, but it's close – so I'm using it here. Personally, I prefer [httpie](https://github.com/jkbrzt/httpie), but you do you.

Also appearing: `sed`, the Unix Stream EDitor. `sed` allows you to take a stream of text – for instance, returned from `cat` – and make a change to each line, frequently using this syntax:

``` example
sed -e "s/value to find/value to replace it with/"
```

For instance, imagine we have a text file like:

``` src
echo "fizz" >> /tmp/fizz.txt
echo "fizz" >> /tmp/fizz.txt
echo "fizz" >> /tmp/fizz.txt
```

We could change all the "fizz"s to "buzz"s so:

``` src
cat /tmp/fizz.txt | sed -e "s/fizz/buzz/"
```

``` example
buzz
buzz
buzz
buzz
buzz
buzz
buzz
buzz
buzz
buzz
buzz
buzz
```

`sed` has absolutely nothing to do with `curl`, or even HTTP. `sed` is frequently used to clean up the output of other commands; in this document, I'll use it to clean up *newline characters*. A newline character tells your computer – you'll never guess – that you've hit the end of one line and it's time to start a new one. But: there is no one universal newline character. On Unix, the newline character is `\n`. On some windows machines, it's `\r\n`. And on some Windows and DOS machines, it's a character usually written `^M` (control-m).

So. When you see in the code examples, for instance:

``` src
curl -i http://www.google.com | sed -e "s/^M//"
```

That means, "take the output from `curl` and use `sed` to remove the non-Unix line endings", which makes these documents nicer to work with on \*nix machines.

**Note**: in these notes, I've taken steps to strip all the nonsense out already. You might see Nonsense out in the world in places it isn't visibly present in these notes.

HTTP: Hypertext Transfer Protocol
---------------------------------

Boy is there a lot we *could* say about HTTP. There's a whole lot to be said about how it works (much of which I do not, frankly, know). There's even more to be said about how it developed. HTTP is an amazing study in how the *specification* of a piece of technology and the implementation of it might entirely diverge once the world at large is involved. For instance: HTTP 1.1 was specified in [1997](https://tools.ietf.org/html/rfc2068), was obsolete by [1999](https://tools.ietf.org/html/rfc2616), and is still the most common version of the protocol in use today. In 2016. Just… let that sink in. The format of HTTP messages was defined in 1982. The specifying [RFC](https://tools.ietf.org/html/rfc822) is still titled, *Standard for the Format of ARPA Internet Text Messages*.

Good news: unless you want to deal with HTTP professionally – as in, after Reed – you don't especially need to get your head around a **lot** of the stuff you *could* know about HTTP. Here's the stuff you do need to grok:

### HTTP Messages

An HTTP Message consists of a set of *headers* followed by a body, thus:

``` src
curl -i http://www.google.com
```

``` example
HTTP/1.1 200 OK
Date: Mon, 04 Apr 2016 04:12:01 GMT
Expires: -1
Cache-Control: private, max-age=0
Content-Type: text/html; charset=ISO-8859-1
P3P: CP="This is not a P3P policy! See https://www.google.com/support/accounts/answer/151657?hl=en for more info."
Server: gws
X-XSS-Protection: 1; mode=block
X-Frame-Options: SAMEORIGIN
Set-Cookie: NID=78=kS5zJCdwLzEM4BjgtLd3SjiQ3sn7E9jpNOWRk_yNSYsaTPsgvuBnH6xz4TL0f-nRbmqB1pPI75bk3QLMYKGtb-3Yv64ikjQPPsmxnnvi2ffP-v7PHJafqt0bDbQxJF5DyJ5gRleV8HlKoX4; expires=Tue, 04-Oct-2016 04:12:01 GMT; path=/; domain=.google.com; HttpOnly
Accept-Ranges: none
Vary: Accept-Encoding
Transfer-Encoding: chunked

<!doctype html><html itemscope="" itemtype="http://schema.org/WebPage" lang="en"><head><meta content="Search the world's information, including webpages, images, videos and more. Google has many special features to help you find exactly what you're looking for." name="description"><meta content="noodp" name="robots"><meta content="text/html; charset=UTF-8" http-equiv="Content-Type"><meta content="/images/branding/googleg/1x/googleg_standard_color_128dp.png" itemprop="image"><title>Google</title><script>(function(){window.google={kEI:'kekBV9S1JOm7jgS0kpW4AQ',kEXPI:'18168,3700300,3700388,3700389,3700393,4029815,4031109,4032678,4033307,4036509,4036527,4038012,4039268,4042784,4042792,4043492,4045841,4046304,4048347,4049549,4049557,4051033,4051159,4052304,4053261,4054284,4054551,4055202,4055722,4055724,4055917,4055945,4056037,4057169,4057316,4057739,4057834,4058085,4058337,4058543,4059767,4060681,4060726,4061089,4061125,4061155,4061181,4061303,4061393,4061552,4061781,4061925,4062221,4062222,4062333,4062406,4062409,4062535,4062630,4062645,4062680,4062708,4062789,4062949,4062972,4062983,4063117,4063361,4063367,4063735,4063779,4063929,4064058,8300272,8300306,8300310,8502095,8502947,8503512,8503584,8503647,8503811,8503926,8503928,8503932,8503934,8504031,8504107,8504110,10200083',authuser:0,kscs:'c9c918f0_24'};google.kHL='en';})();(function(){google.lc=[];google.li=0;google.getEI=function(a){for(var b;a&&(!a.getAttribute||!(b=a.getAttribute("eid")));)a=a.parentNode;return b||google.kEI};google.getLEI=function(a){for(var b=null;a&&(!a.getAttribute||!(b=a.getAttribute("leid")));)a=a.parentNode;return b};google.https=function(){return"https:"==window.location.protocol};google.ml=function(){return null};google.wl=function(a,b){try{google.ml(Error(a),!1,b)}catch(d){}};google.time=function(){return(new Date).getTime()};google.log=function(a,b,d,e,g){a=google.logUrl(a,b,d,e,g);if(""!=a){b=new Image;var c=google.lc,f=google.li;c[f]=b;b.onerror=b.onload=b.onabort=function(){delete c[f]};window.google&&window.google.vel&&window.google.vel.lu&&window.google.vel.lu(a);b.src=a;google.li=f+1}};google.logUrl=function(a,b,d,e,g){var c="",f=google.ls||"";if(!d&&-1==b.search("&ei=")){var h=google.getEI(e),c="&ei="+h;-1==b.search("&lei=")&&((e=google.getLEI(e))?c+="&lei="+e:h!=google.kEI&&(c+="&lei="+google.kEI))}a=d||"/"+(g||"gen_204")+"?atyp=i&ct="+a+"&cad="+b+c+f+"&zx="+google.time();/^http:/i.test(a)&&google.https()&&(google.ml(Error("a"),!1,{src:a,glmm:1}),a="");return a};google.y={};google.x=function(a,b){google.y[a.id]=[a,b];return!1};google.load=function(a,b,d){google.x({id:a+k++},function(){google.load(a,b,d)})};var k=0;})();var _gjwl=location;function _gjuc(){var a=_gjwl.href.indexOf("#");if(0<=a&&(a=_gjwl.href.substring(a),0<a.indexOf("&q=")||0<=a.indexOf("#q="))&&(a=a.substring(1),-1==a.indexOf("#"))){for(var d=0;d<a.length;){var b=d;"&"==a.charAt(b)&&++b;var c=a.indexOf("&",b);-1==c&&(c=a.length);b=a.substring(b,c);if(0==b.indexOf("fp="))a=a.substring(0,d)+a.substring(c,a.length),c=d;else if("cad=h"==b)return 0;d=c}_gjwl.href="/search?"+a+"&cad=h";return 1}return 0}
function _gjh(){!_gjuc()&&window.google&&google.x&&google.x({id:"GJH"},function(){google.nav&&google.nav.gjh&&google.nav.gjh()})};window._gjh&&_gjh();</script><style>#gbar,#guser{font-size:13px;padding-top:1px !important;}#gbar{height:22px}#guser{padding-bottom:7px !important;text-align:right}.gbh,.gbd{border-top:1px solid #c9d7f1;font-size:1px}.gbh{height:0;position:absolute;top:24px;width:100%}@media all{.gb1{height:22px;margin-right:.5em;vertical-align:top}#gbar{float:left}}a.gb1,a.gb4{text-decoration:underline !important}a.gb1,a.gb4{color:#00c !important}.gbi .gb4{color:#dd8e27 !important}.gbf .gb4{color:#900 !important}
</style><style>body,td,a,p,.h{font-family:arial,sans-serif}body{margin:0;overflow-y:scroll}#gog{padding:3px 8px 0}td{line-height:.8em}.gac_m td{line-height:17px}form{margin-bottom:20px}.h{color:#36c}.q{color:#00c}.ts td{padding:0}.ts{border-collapse:collapse}em{font-weight:bold;font-style:normal}.lst{height:25px;width:496px}.gsfi,.lst{font:18px arial,sans-serif}.gsfs{font:17px arial,sans-serif}.ds{display:inline-box;display:inline-block;margin:3px 0 4px;margin-left:4px}input{font-family:inherit}a.gb1,a.gb2,a.gb3,a.gb4{color:#11c !important}body{background:#fff;color:black}a{color:#11c;text-decoration:none}a:hover,a:active{text-decoration:underline}.fl a{color:#36c}a:visited{color:#551a8b}a.gb1,a.gb4{text-decoration:underline}a.gb3:hover{text-decoration:none}#ghead a.gb2:hover{color:#fff !important}.sblc{padding-top:5px}.sblc a{display:block;margin:2px 0;margin-left:13px;font-size:11px}.lsbb{background:#eee;border:solid 1px;border-color:#ccc #999 #999 #ccc;height:30px}.lsbb{display:block}.ftl,#fll a{display:inline-block;margin:0 12px}.lsb{background:url(/images/nav_logo229.png) 0 -261px repeat-x;border:none;color:#000;cursor:pointer;height:30px;margin:0;outline:0;font:15px arial,sans-serif;vertical-align:top}.lsb:active{background:#ccc}.lst:focus{outline:none}</style><script></script><link href="/images/branding/product/ico/googleg_lodp.ico" rel="shortcut icon"></head><body bgcolor="#fff"><script>(function(){var src='/images/nav_logo229.png';var iesg=false;document.body.onload = function(){window.n && window.n();if (document.images){new Image().src=src;}
if (!iesg){document.f&&document.f.q.focus();document.gbqf&&document.gbqf.q.focus();}
}
})();</script><div id="mngb">    <div id=gbar><nobr><b class=gb1>Search</b> <a class=gb1 href="http://www.google.com/imghp?hl=en&tab=wi">Images</a> <a class=gb1 href="http://maps.google.com/maps?hl=en&tab=wl">Maps</a> <a class=gb1 href="https://play.google.com/?hl=en&tab=w8">Play</a> <a class=gb1 href="http://www.youtube.com/?tab=w1">YouTube</a> <a class=gb1 href="http://news.google.com/nwshp?hl=en&tab=wn">News</a> <a class=gb1 href="https://mail.google.com/mail/?tab=wm">Gmail</a> <a class=gb1 href="https://drive.google.com/?tab=wo">Drive</a> <a class=gb1 style="text-decoration:none" href="https://www.google.com/intl/en/options/"><u>More</u> &raquo;</a></nobr></div><div id=guser width=100%><nobr><span id=gbn class=gbi></span><span id=gbf class=gbf></span><span id=gbe></span><a href="http://www.google.com/history/optout?hl=en" class=gb4>Web History</a> | <a  href="/preferences?hl=en" class=gb4>Settings</a> | <a target=_top id=gb_70 href="https://accounts.google.com/ServiceLogin?hl=en&passive=true&continue=http://www.google.com/" class=gb4>Sign in</a></nobr></div><div class=gbh style=left:0></div><div class=gbh style=right:0></div>    </div><center><span id="prt" style="display:block"> <div><style>.pmoabs{background-color:#fff;border:1px solid #E5E5E5;color:#666;font-size:13px;padding-bottom:20px;position:absolute;right:2px;top:3px;z-index:986}#pmolnk{border-radius:2px;-moz-border-radius:2px;-webkit-border-radius:2px}.kd-button-submit{border:1px solid #3079ed;background-color:#4d90fe;background-image:-webkit-gradient(linear,left top,left bottom,from(#4d90fe),to(#4787ed));background-image:-webkit-linear-gradient(top,#4d90fe,#4787ed);background-image:-moz-linear-gradient(top,#4d90fe,#4787ed);background-image:-ms-linear-gradient(top,#4d90fe,#4787ed);background-image:-o-linear-gradient(top,#4d90fe,#4787ed);background-image:linear-gradient(top,#4d90fe,#4787ed);filter:progid:DXImageTransform.Microsoft.gradient(startColorStr='#4d90fe',EndColorStr='#4787ed')}.kd-button-submit:hover{border:1px solid #2f5bb7;background-color:#357ae8;background-image:-webkit-gradient(linear,left top,left bottom,from(#4d90fe),to(#357ae8));background-image:-webkit-linear-gradient(top,#4d90fe,#357ae8);background-image:-moz-linear-gradient(top,#4d90fe,#357ae8);background-image:-ms-linear-gradient(top,#4d90fe,#357ae8);background-image:-o-linear-gradient(top,#4d90fe,#357ae8);background-image:linear-gradient(top,#4d90fe,#357ae8);filter:progid:DXImageTransform.Microsoft.gradient(startColorStr='#4d90fe',EndColorStr='#357ae8')}.kd-button-submit:active{-webkit-box-shadow:inset 0 1px 2px rgba(0,0,0,0.3);-moz-box-shadow:inset 0 1px 2px rgba(0,0,0,0.3);box-shadow:inset 0 1px 2px rgba(0,0,0,0.3)}#pmolnk a{color:#fff;display:inline-block;font-weight:bold;padding:5px 20px;text-decoration:none;white-space:nowrap}.xbtn{color:#999;cursor:pointer;font-size:23px;line-height:5px;padding-top:5px}.padi{padding:0 8px 0 10px}.padt{padding:5px 20px 0 0;color:#444}.pads{text-align:left;max-width:200px}</style> <div class="pmoabs" id="pmocntr2" style="behavior:url(#default#userdata);display:none"> <table border="0"> <tr> <td colspan="2"> <div class="xbtn" onclick="google.promos&&google.promos.toast&& google.promos.toast.cpc()" style="float:right">&times;</div> </td> </tr> <tr> <td class="padi" rowspan="2"> <img src="/images/icons/product/chrome-48.png"> </td> <td class="pads">Try a fast, secure browser with updates built in.</td> </tr> <tr> <td class="padt"> <div class="kd-button-submit" id="pmolnk"> <a href="/chrome/browser/?hl=en&amp;brand=CHNG&amp;utm_source=en-hpp&amp;utm_medium=hpp&amp;utm_campaign=en" onclick="google.promos&&google.promos.toast&& google.promos.toast.cl()">Yes, get Chrome now</a> </div> </td> </tr> </table> </div> <script type="text/javascript">(function(){var a={v:{}};a.v.mb=50;a.v.kb=10;a.v.La="body";a.v.Nb=!0;a.v.Qb=function(b,c){var d=a.v.Db();a.v.Fb(d,b,c);a.v.Rb(d);a.v.Nb&&a.v.Ob(d)};a.v.Rb=function(b){(b=a.v.Na(b))&&0<b.forms.length&&b.forms[0].submit()};a.v.Db=function(){var b=document.createElement("iframe");b.height=0;b.width=0;b.style.overflow="hidden";b.style.top=b.style.left="-100px";b.style.position="absolute";document.body.appendChild(b);return b};a.v.Na=function(b){return b.contentDocument||b.contentWindow.document};a.v.Fb=function(b,c,d){b=a.v.Na(b);b.open();d=["<",a.v.La,'><form method=POST action="',d,'">'];for(var e in c)c.hasOwnProperty(e)&&d.push('<textarea name="',e,'">',c[e],"</textarea>");d.push("</form></",a.v.La,">");b.write(d.join(""));b.close()};a.v.Pa=function(b,c){c>a.v.kb?google&&google.ml&&google.ml(Error("ogcdr"),!1,{cause:"timeout"}):b.contentWindow?a.v.Pb(b):window.setTimeout(function(){a.v.Pa(b,c+1)},a.v.mb)};a.v.Pb=function(b){document.body.removeChild(b)};a.v.Ob=function(b){a.v.Bb(b,"load",function(){a.v.Pa(b,0)})};a.v.Bb=function(b,c,d){b.addEventListener?b.addEventListener(c,d,!1):b.attachEvent&&b.attachEvent("on"+c,d)};var m={Vb:0,$:1,ka:2,va:5,Ub:6};a.s={};a.s.ya={Ya:"i",ta:"d",$a:"l"};a.s.U={Aa:"0",ma:"1"};a.s.Ba={wa:1,ta:2,ra:3};a.s.S={Sa:"a",Wa:"g",W:"c",vb:"u",ub:"t",Aa:"p",lb:"pid",Ua:"eid",wb:"at"};a.s.Za=window.location.protocol+"//www.google.com/_/og/promos/";a.s.Va="g";a.s.yb="z";a.s.Fa=function(b,c,d,e){var f=null;switch(c){case m.$:f=window.gbar.up.gpd(b,d,!0);break;case m.va:f=window.gbar.up.gcc(e)}return null==f?0:parseInt(f,10)};a.s.Jb=function(b,c,d){return c==m.$?null!=window.gbar.up.gpd(b,d,!0):!1};a.s.Ca=function(b,c,d,e,f,h,k,l){var g={};g[a.s.S.Aa]=b;g[a.s.S.Wa]=c;g[a.s.S.Sa]=d;g[a.s.S.wb]=e;g[a.s.S.Ua]=f;g[a.s.S.lb]=1;k&&(g[a.s.S.W]=k);l&&(g[a.s.S.vb]=l);if(h)g[a.s.S.ub]=h;else return google.ml(Error("knu"),!1,{cause:"Token is not found"}),null;return g};a.s.Ia=function(b,c,d){if(b){var e=c?a.s.Va:a.s.yb;c&&d&&(e+="?authuser="+d);a.v.Qb(b,a.s.Za+e)}};a.s.Eb=function(b,c,d,e,f,h,k){b=a.s.Ca(c,b,a.s.ya.ta,a.s.Ba.ta,d,f,null,e);a.s.Ia(b,h,k)};a.s.Hb=function(b,c,d,e,f,h,k){b=a.s.Ca(c,b,a.s.ya.Ya,a.s.Ba.wa,d,f,e,null);a.s.Ia(b,h,k)};a.s.Mb=function(b,c,d,e,f,h,k,l,g,n){switch(c){case m.va:window.gbar.up.dpc(e,f);break;case m.$:window.gbar.up.spd(b,d,1,!0);break;case m.ka:g=g||!1,l=l||"",h=h||0,k=k||a.s.U.ma,n=n||0,a.s.Eb(e,h,k,f,l,g,n)}};a.s.Kb=function(b,c,d,e,f){return c==m.$?0<d&&a.s.Fa(b,c,e,f)>=d:!1};a.s.Gb=function(b,c,d,e,f,h,k,l,g,n){switch(c){case m.va:window.gbar.up.iic(e,f);break;case m.$:c=a.s.Fa(b,c,d,e)+1;window.gbar.up.spd(b,d,c.toString(),!0);break;case m.ka:g=g||!1,l=l||"",h=h||0,k=k||a.s.U.Aa,n=n||0,a.s.Hb(e,h,k,1,l,g,n)}};a.s.Lb=function(b,c,d,e,f,h){b=a.s.Ca(c,b,a.s.ya.$a,a.s.Ba.ra,d,e,null,null);a.s.Ia(b,f,h)};var p={Sb:"a",Wb:"l",Tb:"c",Ta:"d",ra:"h",wa:"i",mc:"n",ma:"x",jc:"ma",kc:"mc",lc:"mi",Xb:"pa",Yb:"pc",$b:"pi",dc:"pn",ac:"px",Zb:"pd",nc:"gpa",sc:"gpi",tc:"gpn",uc:"gpx",qc:"gpd"};a.o={};a.o.R={ab:"hplogo",tb:"pmocntr2"};a.o.U={rb:"0",ma:"1",Ra:"2"};a.o.w=document.getElementById(a.o.R.tb);a.o.Xa=16;a.o.nb=2;a.o.qb=20;google.promos=google.promos||{};google.promos.toast=google.promos.toast||{};a.o.qa=function(b){a.o.w&&(a.o.w.style.display=b?"":"none",a.o.w.parentNode&&(a.o.w.parentNode.style.position=b?"relative":""))};a.o.Qa=function(b){try{if(a.o.w&&b&&b.es&&b.es.m){var c=window.gbar.rtl(document.body)?"left":"right";a.o.w.style[c]=b.es.m-a.o.Xa+a.o.nb+"px";a.o.w.style.top=a.o.qb+"px"}}catch(d){google.ml(d,!1,{cause:a.o.T+"_PT"})}};google.promos.toast.cl=function(){try{a.o.Da==m.ka&&a.s.Lb(a.o.Ga,a.o.V,a.o.U.Ra,a.o.Ka,a.o.Ha,a.o.Ja),window.gbar.up.sl(a.o.V,a.o.T,p.ra,a.o.Ea(),1)}catch(b){google.ml(b,!1,{cause:a.o.T+"_CL"})}};google.promos.toast.cpc=function(){try{a.o.w&&(a.o.qa(!1),a.s.Mb(a.o.w,a.o.Da,a.o.R.Ma,a.o.Ga,a.o.Cb,a.o.V,a.o.U.ma,a.o.Ka,a.o.Ha,a.o.Ja),window.gbar.up.sl(a.o.V,a.o.T,p.Ta,a.o.Ea(),1))}catch(b){google.ml(b,!1,{cause:a.o.T+"_CPC"})}};a.o.Oa=function(){try{if(a.o.w){var b=276,c=document.getElementById(a.o.R.ab);c&&(b=Math.max(b,c.offsetWidth));var d=parseInt(a.o.w.style.right,10)||0;a.o.w.style.visibility=2*(a.o.w.offsetWidth+d)+b>document.body.clientWidth?"hidden":""}}catch(e){google.ml(e,!1,{cause:a.o.T+"_HOSW"})}};a.o.Ab=function(){var b=["gpd","spd","aeh","sl"];if(!window.gbar||!window.gbar.up)return!1;for(var c=0,d;d=b[c];c++)if(!(d in window.gbar.up))return!1;return!0};a.o.Ib=function(){return a.o.w.currentStyle&&"absolute"!=a.o.w.currentStyle.position};google.promos.toast.init=function(b,c,d,e,f,h,k,l,g,n,q,r){try{if(!a.o.Ab())google.ml(Error("apa"),!1,{cause:a.o.T+"_INIT"});else if(a.o.w)if(e==m.ka&&!l==!g)google.ml(Error("tku"),!1,{cause:"zwieback: "+g+", gaia: "+l}),a.o.qa(!1);else if(a.o.R.W="toast_count_"+c+(q?"_"+q:""),a.o.R.Ma="toast_dp_"+c+(r?"_"+r:""),a.o.T=d,a.o.V=b,a.o.Da=e,a.o.Ga=c,a.o.Cb=f,a.o.Ka=l?l:g,a.o.Ha=!!l,a.o.Ja=k,a.s.Jb(a.o.w,e,a.o.R.Ma,c)||a.s.Kb(a.o.w,e,h,a.o.R.W,c)||a.o.Ib())a.o.qa(!1);else{a.s.Gb(a.o.w,e,a.o.R.W,c,f,a.o.V,a.o.U.rb,a.o.Ka,a.o.Ha,a.o.Ja);if(!n){try{window.gbar.up.aeh(window,"resize",a.o.Oa)}catch(t){}window.lol=a.o.Oa;window.gbar.elr&&a.o.Qa(window.gbar.elr());window.gbar.elc&&window.gbar.elc(a.o.Qa);a.o.qa(!0)}window.gbar.up.sl(a.o.V,a.o.T,p.wa,a.o.Ea())}}catch(t){google.ml(t,!1,{cause:a.o.T+"_INIT"})}};a.o.Ea=function(){var b=a.s.Fa(a.o.w,a.o.Da,a.o.R.W,a.o.Ga);return"ic="+b};})();</script> <script type="text/javascript">(function(){var sourceWebappPromoID=144002;var sourceWebappGroupID=5062030;var payloadType=5;var cookieMaxAgeSec=2592000;var dismissalType=5;var impressionCap=30;var gaiaXsrfToken='';var zwbkXsrfToken='';var kansasDismissalEnabled=false;var sessionIndex=0;var invisible=false;window.gbar&&gbar.up&&gbar.up.r&&gbar.up.r(payloadType,function(show){if (show){google.promos.toast.init(sourceWebappPromoID,sourceWebappGroupID,payloadType,dismissalType,cookieMaxAgeSec,impressionCap,sessionIndex,gaiaXsrfToken,zwbkXsrfToken,invisible,'0612');}
});})();</script> </div> </span><br clear="all" id="lgpd"><div id="lga"><img alt="Google" height="92" src="/images/branding/googlelogo/1x/googlelogo_white_background_color_272x92dp.png" style="padding:28px 0 14px" width="272" id="hplogo" onload="window.lol&&lol()"><br><br></div><form action="/search" name="f"><table cellpadding="0" cellspacing="0"><tr valign="top"><td width="25%">&nbsp;</td><td align="center" nowrap=""><input name="ie" value="ISO-8859-1" type="hidden"><input value="en" name="hl" type="hidden"><input name="source" type="hidden" value="hp"><input name="biw" type="hidden"><input name="bih" type="hidden"><div class="ds" style="height:32px;margin:4px 0"><input style="color:#000;margin:0;padding:5px 8px 0 6px;vertical-align:top" autocomplete="off" class="lst" value="" title="Google Search" maxlength="2048" name="q" size="57"></div><br style="line-height:0"><span class="ds"><span class="lsbb"><input class="lsb" value="Google Search" name="btnG" type="submit"></span></span><span class="ds"><span class="lsbb"><input class="lsb" value="I'm Feeling Lucky" name="btnI" onclick="if(this.form.q.value)this.checked=1; else top.location='/doodles/'" type="submit"></span></span></td><td class="fl sblc" align="left" nowrap="" width="25%"><a href="/advanced_search?hl=en&amp;authuser=0">Advanced search</a><a href="/language_tools?hl=en&amp;authuser=0">Language tools</a></td></tr></table><input id="gbv" name="gbv" type="hidden" value="1"></form><div id="gac_scont"></div><div style="font-size:83%;min-height:3.5em"><br></div><span id="footer"><div style="font-size:10pt"><div style="margin:19px auto;text-align:center" id="fll"><a href="/intl/en/ads/">AdvertisingPrograms</a><a href="/services/">Business Solutions</a><a href="https://plus.google.com/116899029375914044550" rel="publisher">+Google</a><a href="/intl/en/about.html">About Google</a></div></div><p style="color:#767676;font-size:8pt">&copy; 2016 - <a href="/intl/en/policies/privacy/">Privacy</a> - <a href="/intl/en/policies/terms/">Terms</a></p></span></center><script>(function(){window.google.cdo={height:0,width:0};(function(){var a=window.innerWidth,b=window.innerHeight;if(!a||!b)var c=window.document,d="CSS1Compat"==c.compatMode?c.documentElement:c.body,a=d.clientWidth,b=d.clientHeight;a&&b&&(a!=google.cdo.width||b!=google.cdo.height)&&google.log("","","/client_204?&atyp=i&biw="+a+"&bih="+b+"&ei="+google.kEI);})();})();</script><div id="xjsd"></div><div id="xjsi"><script>(function(){function c(b){window.setTimeout(function(){var a=document.createElement("script");a.src=b;document.getElementById("xjsd").appendChild(a)},0)}google.dljp=function(b,a){google.xjsu=b;c(a)};google.dlj=c;})();(function(){window.google.xjsrm=[];})();if(google.y)google.y.first=[];if(!google.xjs){window._=window._||{};window._._DumpException=function(e){throw e};if(google.timers&&google.timers.load.t){google.timers.load.t.xjsls=new Date().getTime();}google.dljp('/xjs/_/js/k\x3dxjs.hp.en_US.JYNNhRR1vUI.O/m\x3dsb_he,d/rt\x3dj/d\x3d1/t\x3dzcms/rs\x3dACT90oGKeyuixW2vug5z6_hvD7hYKD06QA','/xjs/_/js/k\x3dxjs.hp.en_US.JYNNhRR1vUI.O/m\x3dsb_he,d/rt\x3dj/d\x3d1/t\x3dzcms/rs\x3dACT90oGKeyuixW2vug5z6_hvD7hYKD06QA');google.xjs=1;}google.pmc={"sb_he":{"agen":true,"cgen":true,"client":"heirloom-hp","dh":true,"dhqt":true,"ds":"","fl":true,"host":"google.com","isbh":28,"jam":0,"jsonp":true,"msgs":{"cibl":"Clear Search","dym":"Did you mean:","lcky":"I\u0026#39;m Feeling Lucky","lml":"Learn more","oskt":"Input tools","psrc":"This search was removed from your \u003Ca href=\"/history\"\u003EWeb History\u003C/a\u003E","psrl":"Remove","sbit":"Search by image","srch":"Google Search"},"ovr":{},"pq":"","refpd":true,"rfs":[],"scd":10,"sce":5,"stok":"wBiTuhnVfat-ZKAHHLwQHDNa-fk"},"d":{}};google.y.first.push(function(){if(google.med){google.med('init');google.initHistory();google.med('history');}});if(google.j&&google.j.en&&google.j.xi){window.setTimeout(google.j.xi,0);}
</script></div></body></html>
```

So that's the homepage for Google. Don't worry too much about what the headers *are* right now; the important part is that there's a whole bunch of 'em, then an empty line, then then some HTML. This is a standard HTTP Message – headers, newline, body. Boom.

### Request / Response

HTTP interactions have two parts: a *request* and a *response*. This is about what it sounds like:

-   &lt;REQUEST&gt; Your Computer: Hey Server! Gimme thewebpage.com!
-   &lt;RESPONSE&gt; The Server: You got it! Here it is.

HTTP uses the same message format for both requests and responses. From here, we'll refer to the requestor by a more accurate, general name: the *client*. The client requests information of the server, then renders it for you, the user, to interact with.

### Status Codes

Let's take a simpler example: the server that serves my personal website. I'll show *only* the headers with `curl`'s `-I` flag:

``` src
curl -I http://thermador.herokuapp.com
```

``` example
HTTP/1.1 200 OK
Connection: keep-alive
Date: Mon, 04 Apr 2016 04:12:03 GMT
Content-Type: text/plain
Server: Jetty(7.6.1.v20120215)
Via: 1.1 vegur
```

That first like is the one we care about: `HTTP/1.1 200 OK`. `HTTP/1.1` is our HTTP version, low excitement there, but `200 OK` is our *status code*. Status codes are how the server tells us about the success (or failure) of our request. There are quite a few status codes, and a well-setup web server can give fairly precise information about an HTTP request using them. [Here's the full list](https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html); for now, some common codes are:

-   200 OK: our favorite. 200 is the "everything worked and is great!" status code
-   403 Forbidden: you are not authorized to access whatever it was you were trying to get
-   404 Not Found: the thing you asked for isn't there
-   500 Internal Server Error: the server is borked, somehow

It's worth realizing that the correct implementation of HTTP status codes is not a solved problem. For instance, what do you do if a request is valid **and** you are authorized to make it **and** the resource is found, **but** there is a problem in your request? For instance, if have a correctly implemented Slack bot with a valid token and you try to open a direct message channel with a non-existent user, Slack will return something like:

``` example
HTTP/1.1 200 OK

{
  'ok': 'false',
  'error': 'user_not_found'
}
```

They return a `200 OK`, because your request is valid, but then the response body specifies `ok: false`, and tells you the user wasn't found. Neat? Neat. Point is: there are usual practices and things one expects, and then there's The Internet.

### More About Headers

``` src
curl -I http://www.google.com
```

``` example
HTTP/1.1 200 OK
Date: Mon, 04 Apr 2016 04:12:04 GMT
Expires: -1
Cache-Control: private, max-age=0
Content-Type: text/html; charset=ISO-8859-1
P3P: CP="This is not a P3P policy! See https://www.google.com/support/accounts/answer/151657?hl=en for more info."
Server: gws
X-XSS-Protection: 1; mode=block
X-Frame-Options: SAMEORIGIN
Set-Cookie: NID=78=Qc41SqNxipxJXpxJ1-u7Clb3VKDF0ueBKceaWrPILi5VR2ABKPa3lTMmANFVbKzm7l420HfStC4ivNSt9QMZGDP9nIMtCq3XSbsjK48WDp6xJvHhB_58uYq3n9EEgHCjxGWoOWkteacwN1c; expires=Tue, 04-Oct-2016 04:12:04 GMT; path=/; domain=.google.com; HttpOnly
Transfer-Encoding: chunked
Accept-Ranges: none
Vary: Accept-Encoding
```

We can think of headers, *generally* as sets of key-value pairs, which you can see up above – the key `Expires` has the value `-1`, for instance. In this way, a client and the responding HTTP server convey useful information to each other. `Content-Type`, for instance, is how the server tells the client, "here is what I'm going to give you" – plain text, or JSON, or a PNG or a JavaScript application. A client might set authorization information as a header, so the server knows the client is allowed access to a given URL. Cookies are passed back and forth in headers, allowing a site to (on the benign end of the spectrum) color links you've already clicked.

### HTTP Verbs and Resources

So: we know that clients and servers exchange messages using the same format. We've seen status codes in an HTTP response; for a request, the equivalent piece of the puzzle is a *verb* and a *resource*. Let's use `curl -v` to see what our *request* looks like – what the server is actually responding to:

``` example
curl -v http://thermador.herokuapp.com
 Rebuilt URL to: http://thermador.herokuapp.com/
   Trying 50.17.220.70...
 Connected to thermador.herokuapp.com (50.17.220.70) port 80 (#0)
> GET / HTTP/1.1
> Host: thermador.herokuapp.com
> User-Agent: curl/7.43.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Connection: close
< Date: Tue, 22 Mar 2016 17:30:04 GMT
< Content-Type: text/plain;charset=ISO-8859-1
< Server: Jetty(7.6.1.v20120215)
< Via: 1.1 vegur
<
 Closing connection 0
["Hello" :from Heroku]
```

The line we care about right now is: `GET / HTTP/1.1`. And really, only the first two things – `HTTP/1.1` specifies the version of HTTP our request is speaking, which is useful but not particularly interesting (it'll almost always be 1.1). Let's focus on `GET /`.

`/` is our *resource*. In much the same way `/` represents the root of the file system on our Linux computers, here `/` is the root of the website we're viewing. Now, several fun bits of obfuscation on the modern web: notice that in my `curl` request, I didn't specify I wanted `/` – `curl` automatically "rebuilt" the URL to include it. Remember the format of URIs? As a reminder, it's this:

``` example
scheme:[//[user:password@]host[:port]][/]path[?query][#fragment]
```

A URL (Uniform Resource *Locator*) is a more specific form of URI in which the scheme<sup><a href="#fn.1" id="fnr.1" class="footref">1</a></sup> is always specified. For instance, in the URL `http://www.google.com`, `http` is the *scheme*. User and password are omitted most of the time on the Internet-at-large, so they're absent; `www.google.com` is the *host*. What `curl` has implicitly added is the `/` that indicates the root resource at the given host. (Modern web browsers make this all even more opaque by eliding more and more of a given URL – for instance, we typically don't see the scheme or the port in a URL, even if we specify them.)

There's a second tier of obfuscation: by convention, specifying a resource either as `/` or ending in `/` means, "give me a document named index.html at location `/`". So we ask for `www.google.com`, which implicitly means `www.google.com/`. A web server can return whatever it likes for the root resource; in the absence of anything else, by convention a page called `index.html` is returned. So the URL we've gotten might *actually* be `wwww.google.com/index.html`, while the browser just shows us that we're at `www.google.com`. Great.

`GET` is an HTTP *verb* (technically *methods*, but *verb* is common parlance and I find it to be clearer). It describes what action we want to take on the thing we're requesting. `GET` is far and away the most common – it means, "just give me the thing I asked for, maybe with some parameters". (`GET` is so common that it's the default for tools like `curl`, though other verbs can be specified.) There are others; the other two you're likely to come across are:

-   `POST` – "Upload this information to this resource"; commonly used in web forms.
-   `DELETE` – Delete whatever is described by this resource

### Updating our Client/Server Conversation

Our conversation between client and server could now be fleshed out to look like this:

-   &lt;REQUEST&gt; Your Computer: Hey thewebpage.com! I'd like to `GET` the root resource at `/`, please!
-   &lt;RESPONSE&gt; The Server: 200 OK you got it! Here's a `text/html` response body for my root `index.html`. Also can you hang on to this cookie for me? Send it back to me next time so I can keep track of you a little.

### But Wait, There's More: IP Addresses, `localhost`, ports, and a touch of DNS

Okay, here's a fun one: there is no such thing as `www.google.com`. Or, more precisely: there is no *one* thing that is `www.google.com`, and none of the things that serve `www.google.com` URLs have any idea what this "google dot com" nonsense is. `www.google.com` is a *host name*, which servers don't speak. Instead, servers speak *Internet Protocol Addresses* – IP addresses for short. Bad news: the systems that handle IP addresses are monstrously complicated. Good news: while it's good to know those systems are there and what their names are, you don't need to know much at all about how they actually work.

The system that maps host names to IP Addresses is called a *Domain Name System*, or DNS. Here's a gross oversimplification of how this works:

-   You, the User: Computer, bring me www.google.com
-   Computer: Great. Do I know the IP address of a DNS server? **checks** Yes, I do. Hey DNS Server! What the hell is www.google.com?
-   DNS Server: I'm not sure, but I know a DNS Server who does. Talk to Google's DNS Server – have an IP address.
-   Computer : Hokay. Hey Google's DNS Server. What the hell is www.google.com?
-   Google's DNS Server : Oh, it's this – have an IP Addres.

So: DNS is a hierarchical system by which a computer can talk to a general lookup service and reach more specific lookup services until it can talk to a specific server that can fulfill its request. **Whew**. That is more than enough DNS for our purposes.

I bring all of this up in part because we need to talk about a special hostanme/IP Address combo: `localhost`. `localhost`, which on Macs has the default IP address of 127.0.0.1, is your computers way to refer to itself. When you run a web server on your laptop for local development, the *host* you'll specify in your URL is `localhost`.

A cool true fact:

Desperately want to know more about DNS? Start with Monica Dinculescu's [Cat DNS](http://meowni.ca/posts/go-cat-dns-go/) – the DNS server that resolves everything to cats.

### One Last Thing: Public vs. Private

Most often, when we say "on the Internet", we mean we'll be serving content *publicly* – available to the world at large – but there's nothing about HTTP that requires it to be public. I can, for example, start an HTTP server on my laptop, accessibly only to web browsers also on my computer. Businesses often create a variety of flavors of Walled Garden for themselves, in which a thing might be "on the Internet", but not available to the public at large. A Virtual Private Network – usually just VPN – is a common approach to this. Real Talk, VPNs are too big a topic for us to get in to, but the extra-short version goes like this: a VPN allows a set of computers to behave as though they are all on the same private network while being connected to the public internet. This is done (again, a gross simplification) by encrypting communication between members of the network. Wanna be on the VPN? You'll need a password or key, and a client. Anywho, [here's a lot more about VPNs](https://en.wikipedia.org/wiki/Virtual_private_network).

You should know that you *can* serve content to the Public Internet from your laptop. You almost certainly don't want to do this. Beware of any bug fix or problem solving suggestion that suggests you serve your content on `0.0.0.0` – that means, "respond to requests from the public internet" and it's very likely not what you're trying to do.

### Let's check in with that computer/server conversation again

So now, with DNS and a sense of the basics of HTTP, our conversation looks like this:

-   You, the User: Computer, bring me thewebpage.com
-   Computer: Great. Do I know the IP address of a DNS server? **checks** Yes, I do. Hey DNS Server! What the hell is thewebpage.com?
-   DNS Server: I'm not sure, but I know a DNS Server who does. Talk to the server at this IP Address.
-   Computer: Hokay. Hey next DNS Server. What the hell is thewebpage.com?
-   Next DNS Server : Oh, it's this – have an IP Addres.
-   Computer: Great. Hey thewebpage.com! I'd like to `GET` the root resource at `/`, please!
-   The Server: 200 OK you got it! Here's a `text/html` response body for my root `index.html`. Also can you hang on to this cookie for me? Send it back to me next time so I can keep track of you a little.
-   Computer: Great. Hey the User: here is some rendered HTML.

Now. A *lot* of how that last bit goes is actually a function of the *architecture* of the web application in question. So:

What the crap is "architecture"
-------------------------------

A shorter, clearer way to frame this is, "how is your application built?" What are the pieces? Is there a database? What is the client like? How do you scale your app for traffic? Now: this is a whole buuuuunch of questions, and there are a lot we aren't going to get to just yet. For now, we're going to ignore the computer that runs your code and only talk about the code, which will have one or both of these components:

-   A Web Server: some flavor of code you've written that responds to HTTP requests with HTTP/JavaScript/images/etc.
-   A Client: Probably almost entirely JavaScript; might talk to a Server, rendering results. Might be the entire deal, for sufficiently simple apps.

You might also have a database! We're gonna start talking about them next week. Right now, what you need to know is that a database stores stuff, in a durable way, for repeat access and manipulation.

Yes OK Good let's look at a web app
-----------------------------------

[Here's a demo web app!](https://github.com/Gastove/http-demo) We'll be working our way through the pieces. You can clone and virtualenv it, in the traditional manner.

Turn on yer virtualenv and run this thing with:

``` src
python http-demo
```

If it works, you should see a little bit of logging in your terminal. You should also be able to go to <http://localhost:5000/> in your web browser of choice and see a tiny little message. Wee!

So what's going on here?
------------------------

There's now a little Python web server running on your computer. It's host is `localhost` (127.0.0.1, as you'll recall), and its port is 5000. (When we develop locally, we almost always have to specify a port; when we use the Internet at Large we almost never do.) You'll notice you'll get the same web page if you ask for localhost:5000, localhost:5000/, or localhost:5000/index.html.

Inside `http-demo` is a method that listens for `/` or `/index.html`, and responds by "serving static HTML". *Static* here means, "unchanging" – the opposite of *dynamic*, which we'll define in just a few more paragraphs. Look in `static/html`; you'll see a file named `index.html`. Its contents are precisely identical to what you'll see in your web browser if you inspect the source of the page you're seeing.

In Flask, at least, your methods barely have to do anything at all. Go to `localhost:5000/minimal`; those words are the only words in the corresponding method in `http-demo`. Flask adds just a *touch* of wrapping HTML, and it appears in the browser. Neat.

It turns out that when we talk about serving static files, we're almost never talking about serving pure HTML files. More commonly, we'll talk about *static assets*, and what we'll be referring to is content like images and CSS (we'll be discussing what CSS is Soon). If you make a directory inside `static` called `gifs`, and put a gif in there, you can now access it by name at `localhost:5000/gifs/<gif_name>`. Neat? Neat.

Now let's head to <http://localhost:5000/helloworld>. It's got… slightly more to it! (Very, very slightly.) In fact, it can do a trick. Try <http://localhost:5000/helloworld/> + your name (<http://localhost:5000/helloworld/Ross>, for instance). Neat, eh?

The `helloworld` resource is returning HTML, but it's doing a handy trick called *server-side rendering*. It works like this: there is a template called `hello.html`, which uses a templating system called Jinja. When you ask for `helloworld/Ross`, for instance, the *Ross* part of the URL is captured as a variable. Flask then loads and *renders* the `hello.html` template, which creates the HTML that's then sent back to your browser.

Here's another way this can be used: head to <http://localhost:5000/form>. Pick a beverage and hit `Yar`. Now there's a result! M A G I C. Okay, more template rendering – in this case, `form` is a static page (not a template) that uses `POST` to pass data from itself to the `yousaid` resource, which renders a template.

So where does JavaScript fit in?
--------------------------------

Terrific question. This demo doesn't currently account for JavaScript, because there's a *lot* JS can do. This gets us back to the slowly-expanding idea of Architecture. See, right now, `http-demo` is an entirely server-side application. A little Flask app serves rendered HTML to your browser *and that's pretty much it*. These pages are still basically static – they arrive at the browser fully formed and with very litter interactivity, save for what HTML itself provides (forms, for instance).

We could change this by adding a little JavaScript. HTML pages can define a `script` tag, which will cause that page to load in, well, a script (almost always JavaScript). Our app can serve JS scripts just like any other static asset, and now our page can have a little interactivity – maybe a little navigation menu, say. Fundamentally, all the action still really happens on the server, but with JS we can program in the browser and Do More. HTML is what you can *see*; JS is really what you can *do*. (It will accomplish this task, almost always, by creating either HTML or SVG images, or by modifying CSS.)

But there's another option: make a *client out of pure JavaScript*. My personal web site works like this. There are, in effect, *two* HTTP servers. One is the server-side application, which is written in Clojure, and has routes like <http://thermador.herokuapp.com/api/page/about> – which you can go to in your browser. Looks… pretty weird, right? Not super useful.

But then you head to <http://www.gastove.com/>, and you see a Real Thing. This is the *second* HTTP server, which really actually only serves one thing – a JavaScript application. When you click on links in that application, JavaScript intercepts the routes, parses them, and then asks the server for content. This is called a *Single Page Application* – the only "page" in my client is an index.html that loads JavaScript, and then JS does *everything else*. Specifically, it communicates with my server using a paradigm called REST (REpresentational State Transfer) – the JS client says, "hey, I need the pages of this site!", and the Server responds with a JSON blob describing all of them, which the JS then turns in to HTML.

As you might apprehend, this can get complex in a hurry.

Footnotes:
----------

<sup><a href="#fnr.1" id="fn.1" class="footnum">1</a></sup>
Sometimes the scheme is also referred to as the *network transport*. Thank god we aren't stuck with only one name for one thing – can you imagine.

Author: Ross Donaldson

Created: 2016-04-03 Sun 21:12

[Validate](http://validator.w3.org/check?uri=referer)


