# The General Idea: Web Servers

You would like a Web Page to Appear on the Internet &#x2013; *but how?* What is the mechanism by which we arrive at a Web Page being On the Internet? What if that web page is "interactive" &#x2013; what then?

The answer is a web server &#x2013; a piece of software that runs on a computer and provides (that is, *serves*) content using a communication protocol called HTTP (sometimes HTTPS). In this way, two computers &#x2013; say, your computer and a server &#x2013; can have a conversation roughly like this:

-   Your Computer: Hey Server! Gimme thewebpage.com!
-   The Server: You got it! Here it is.

Today we're going to expand the above exchange &#x2013; make it considerably more detailed and accurate. Note that our goal is a working mental model, **not** an exhaustive representation of how the modern internet functions. We'll be eliding a number of details, though I'll try to be very clear about which ones and when. This section will be considerably heavier on the "want to learn more? click here!" links than our previous topics.

Ready? Here we go!


# A note about `cURL`, `sed`, and newline characters

`cURL` (more commonly `curl`) is a command-line utility for interacting with The Internet. I'll be using it here to get raw content from the internet. You'll see a certain amount of the `-i` (include headers) and `-I` (only the headers) flags.

`curl` is veryvery powerful, and also a little arcane. It's not completely ubiquitous, but it's close &#x2013; so I'm using it here. Personally, I prefer [httpie](https://github.com/jkbrzt/httpie), but you do you.

Also appearing: `sed`, the Unix Stream EDitor. `sed` allows you to take a stream of text &#x2013; for instance, returned from `cat` &#x2013; and make a change to each line, frequently using this syntax:

    sed -e "s/value to find/value to replace it with/g"

For instance, imagine we have a text file like:

```sh
echo "fizz" >> /tmp/fizz.txt
echo "fizz" >> /tmp/fizz.txt
echo "fizz" >> /tmp/fizz.txt
```

We could change all the "fizz"s to "buzz"s so:

```sh
cat /tmp/fizz.txt | sed -e "s/fizz/buzz/"
```

    buzz
    buzz
    buzz

`sed` has absolutely nothing to do with `curl`, or even HTTP. `sed` is frequently used to clean up the output of other commands; in this document, I'll use it to clean up *newline characters*. A newline character tells your computer &#x2013; you'll never guess &#x2013; that you've hit the end of one line and it's time to start a new one. But: there is no one universal newline character. On Unix, the newline character is `\n`. On some windows machines, it's `\r\n`. And on some Windows and DOS machines, it's a character usually written `^M` (control-m).

So. When you see in the code examples, for instance:

```sh
curl -i http://www.google.com | sed -e "s/^M//"
```

That means, "take the output from `curl` and use `sed` to remove the non-Unix line endings", which makes these documents nicer to work with on \*nix machines.

**Note**: in these notes, I've taken steps to strip all the nonsense out already. You might see Nonsense out in the world in places it isn't visibly present in these notes.


# HTTP: Hypertext Transfer Protocol

Boy is there a lot we *could* say about HTTP. There's a whole lot to be said about how it works (much of which I do not, frankly, know). There's even more to be said about how it developed. HTTP is an amazing study in how the *specification* of a piece of technology and the implementation of it might entirely diverge once the world at large is involved. For instance: HTTP 1.1 was specified in [1997](https://tools.ietf.org/html/rfc2068), was obsolete by [1999](https://tools.ietf.org/html/rfc2616), and is still the most common version of the protocol in use today. In 2017. Just&#x2026; let that sink in. The format of HTTP messages was defined in 1982. The specifying [RFC](https://tools.ietf.org/html/rfc822) is still titled, *Standard for the Format of ARPA Internet Text Messages*.

Good news: unless you want to deal with HTTP professionally &#x2013; as in, after Reed &#x2013; you don't especially need to get your head around a **lot** of the stuff you *could* know about HTTP. Here's the stuff you do need to grok:


## HTTP Messages

An HTTP Message consists of a set of *headers* followed by a body, thus:

```sh
curl -i http://www.google.com
```

    HTTP/1.1 200 OK
    Date: Wed, 01 Mar 2017 05:10:53 GMT
    Expires: -1
    Cache-Control: private, max-age=0
    Content-Type: text/html; charset=ISO-8859-1
    P3P: CP="This is not a P3P policy! See https://www.google.com/support/accounts/answer/151657?hl=en for more info."
    Server: gws
    X-XSS-Protection: 1; mode=block
    X-Frame-Options: SAMEORIGIN
    Set-Cookie: NID=98=G-WffdB7Tatg0_gaSKFTwnapnTUwm4r_9bnPkypOeA00ff25DiKGSoz4MqhM_KxrrXimLJKNjijhQuiH56je57H2r3EihA44JU0zDLhd-B4UtqkAKl_5-zfcaYWUQgFes_oMo9AvNU2veyUJ; expires=Thu, 31-Aug-2017 05:10:53 GMT; path=/; domain=.google.com; HttpOnly
    Accept-Ranges: none
    Vary: Accept-Encoding
    Transfer-Encoding: chunked

    <!doctype html><html itemscope="" itemtype="http://schema.org/WebPage" lang="en"><head><meta content="Search the world's information, including webpages, images, videos and more. Google has many special features to help you find exactly what you're looking for." name="description"><meta content="noodp" name="robots"><meta content="text/html; charset=UTF-8" http-equiv="Content-Type"><meta content="/images/branding/googleg/1x/googleg_standard_color_128dp.png" itemprop="image"><title>Google</title><script>(function(){window.google={kEI:'3Ve2WLacLciD0gKkg7qQDA',kEXPI:'1351827,1351903,1352241,1352465,1352624,1352994,3700306,3700347,3700383,4026240,4029815,4031109,4032677,4036527,4038012,4039268,4043492,4045841,4048347,4062666,4064904,4065787,4069773,4071842,4072364,4072773,4073405,4073728,4073958,4075963,4076096,4076999,4078430,4078438,4078767,4079107,4079894,4081039,4081165,4083113,4083476,4084179,4085627,4086011,4088340,4089003,4089183,4090352,4090550,4090806,4090893,4091060,4092182,4092475,4092479,4092897,4092934,4093191,4093224,4093498,4093598,4093792,4093813,4093948,4094231,4094251,4094544,4094674,4094730,4094766,4094837,4094839,4095381,4095907,4095967,4095997,4096323,4096472,4096742,4097082,4097153,4097204,4097865,4097922,4097929,4097998,4098052,4098089,4098733,4098740,4098752,4099809,4099810,4099881,4099914,4100141,4100331,4100728,4101122,8300096,8300272,8503585,8503596,8505259,8506340,8507380,8507420,8507920,8507940,8508043,8508207,8508229,8508395,8508624,8508931,8509037,8509178,8509243,8509373,8509870,10200083,10200095,16200027,19001698',authuser:0,kscs:'c9c918f0_24'};google.kHL='en';})();(function(){google.lc=[];google.li=0;google.getEI=function(a){for(var b;a&&(!a.getAttribute||!(b=a.getAttribute("eid")));)a=a.parentNode;return b||google.kEI};google.getLEI=function(a){for(var b=null;a&&(!a.getAttribute||!(b=a.getAttribute("leid")));)a=a.parentNode;return b};google.https=function(){return"https:"==window.location.protocol};google.ml=function(){return null};google.wl=function(a,b){try{google.ml(Error(a),!1,b)}catch(c){}};google.time=function(){return(new Date).getTime()};google.log=function(a,b,c,d,g){a=google.logUrl(a,b,c,d,g);if(""!=a){b=new Image;var e=google.lc,f=google.li;e[f]=b;b.onerror=b.onload=b.onabort=function(){delete e[f]};window.google&&window.google.vel&&window.google.vel.lu&&window.google.vel.lu(a);b.src=a;google.li=f+1}};google.logUrl=function(a,b,c,d,g){var e="",f=google.ls||"";c||-1!=b.search("&ei=")||(e="&ei="+google.getEI(d),-1==b.search("&lei=")&&(d=google.getLEI(d))&&(e+="&lei="+d));a=c||"/"+(g||"gen_204")+"?atyp=i&ct="+a+"&cad="+b+e+f+"&zx="+google.time();/^http:/i.test(a)&&google.https()&&(google.ml(Error("a"),!1,{src:a,glmm:1}),a="");return a};google.y={};google.x=function(a,b){google.y[a.id]=[a,b];return!1};google.lq=[];google.load=function(a,b,c){google.lq.push([[a],b,c])};google.loadAll=function(a,b){google.lq.push([a,b])};}).call(this);var a=window.location,b=a.href.indexOf("#");if(0<=b){var c=a.href.substring(b+1);/(^|&)q=/.test(c)&&-1==c.indexOf("#")&&a.replace("/search?"+c.replace(/(^|&)fp=[^&]*/g,"")+"&cad=h")};</script><style>#gbar,#guser{font-size:13px;padding-top:1px !important;}#gbar{height:22px}#guser{padding-bottom:7px !important;text-align:right}.gbh,.gbd{border-top:1px solid #c9d7f1;font-size:1px}.gbh{height:0;position:absolute;top:24px;width:100%}@media all{.gb1{height:22px;margin-right:.5em;vertical-align:top}#gbar{float:left}}a.gb1,a.gb4{text-decoration:underline !important}a.gb1,a.gb4{color:#00c !important}.gbi .gb4{color:#dd8e27 !important}.gbf .gb4{color:#900 !important}
    </style><style>body,td,a,p,.h{font-family:arial,sans-serif}body{margin:0;overflow-y:scroll}#gog{padding:3px 8px 0}td{line-height:.8em}.gac_m td{line-height:17px}form{margin-bottom:20px}.h{color:#36c}.q{color:#00c}.ts td{padding:0}.ts{border-collapse:collapse}em{font-weight:bold;font-style:normal}.lst{height:25px;width:496px}.gsfi,.lst{font:18px arial,sans-serif}.gsfs{font:17px arial,sans-serif}.ds{display:inline-box;display:inline-block;margin:3px 0 4px;margin-left:4px}input{font-family:inherit}a.gb1,a.gb2,a.gb3,a.gb4{color:#11c !important}body{background:#fff;color:black}a{color:#11c;text-decoration:none}a:hover,a:active{text-decoration:underline}.fl a{color:#36c}a:visited{color:#551a8b}a.gb1,a.gb4{text-decoration:underline}a.gb3:hover{text-decoration:none}#ghead a.gb2:hover{color:#fff !important}.sblc{padding-top:5px}.sblc a{display:block;margin:2px 0;margin-left:13px;font-size:11px}.lsbb{background:#eee;border:solid 1px;border-color:#ccc #999 #999 #ccc;height:30px}.lsbb{display:block}.ftl,#fll a{display:inline-block;margin:0 12px}.lsb{background:url(/images/nav_logo229.png) 0 -261px repeat-x;border:none;color:#000;cursor:pointer;height:30px;margin:0;outline:0;font:15px arial,sans-serif;vertical-align:top}.lsb:active{background:#ccc}.lst:focus{outline:none}</style><script></script><link href="/images/branding/product/ico/googleg_lodp.ico" rel="shortcut icon"></head><body bgcolor="#fff"><script>(function(){var src='/images/nav_logo229.png';var iesg=false;document.body.onload = function(){window.n && window.n();if (document.images){new Image().src=src;}
    if (!iesg){document.f&&document.f.q.focus();document.gbqf&&document.gbqf.q.focus();}
    }
    })();</script><div id="mngb"> <div id=gbar><nobr><b class=gb1>Search</b> <a class=gb1 href="http://www.google.com/imghp?hl=en&tab=wi">Images</a> <a class=gb1 href="http://maps.google.com/maps?hl=en&tab=wl">Maps</a> <a class=gb1 href="https://play.google.com/?hl=en&tab=w8">Play</a> <a class=gb1 href="http://www.youtube.com/?tab=w1">YouTube</a> <a class=gb1 href="http://news.google.com/nwshp?hl=en&tab=wn">News</a> <a class=gb1 href="https://mail.google.com/mail/?tab=wm">Gmail</a> <a class=gb1 href="https://drive.google.com/?tab=wo">Drive</a> <a class=gb1 style="text-decoration:none" href="https://www.google.com/intl/en/options/"><u>More</u> &raquo;</a></nobr></div><div id=guser width=100%><nobr><span id=gbn class=gbi></span><span id=gbf class=gbf></span><span id=gbe></span><a href="http://www.google.com/history/optout?hl=en" class=gb4>Web History</a> | <a  href="/preferences?hl=en" class=gb4>Settings</a> | <a target=_top id=gb_70 href="https://accounts.google.com/ServiceLogin?hl=en&passive=true&continue=http://www.google.com/" class=gb4>Sign in</a></nobr></div><div class=gbh style=left:0></div><div class=gbh style=right:0></div> </div><center><br clear="all" id="lgpd"><div id="lga"><img alt="Google" height="92" src="/images/branding/googlelogo/1x/googlelogo_white_background_color_272x92dp.png" style="padding:28px 0 14px" width="272" id="hplogo" onload="window.lol&&lol()"><br><br></div><form action="/search" name="f"><table cellpadding="0" cellspacing="0"><tr valign="top"><td width="25%">&nbsp;</td><td align="center" nowrap=""><input name="ie" value="ISO-8859-1" type="hidden"><input value="en" name="hl" type="hidden"><input name="source" type="hidden" value="hp"><input name="biw" type="hidden"><input name="bih" type="hidden"><div class="ds" style="height:32px;margin:4px 0"><input style="color:#000;margin:0;padding:5px 8px 0 6px;vertical-align:top" autocomplete="off" class="lst" value="" title="Google Search" maxlength="2048" name="q" size="57"></div><br style="line-height:0"><span class="ds"><span class="lsbb"><input class="lsb" value="Google Search" name="btnG" type="submit"></span></span><span class="ds"><span class="lsbb"><input class="lsb" value="I'm Feeling Lucky" name="btnI" onclick="if(this.form.q.value)this.checked=1; else top.location='/doodles/'" type="submit"></span></span></td><td class="fl sblc" align="left" nowrap="" width="25%"><a href="/advanced_search?hl=en&amp;authuser=0">Advanced search</a><a href="/language_tools?hl=en&amp;authuser=0">Language tools</a></td></tr></table><input id="gbv" name="gbv" type="hidden" value="1"></form><div id="gac_scont"></div><div style="font-size:83%;min-height:3.5em"><br></div><span id="footer"><div style="font-size:10pt"><div style="margin:19px auto;text-align:center" id="fll"><a href="/intl/en/ads/">AdvertisingPrograms</a><a href="/services/">Business Solutions</a><a href="https://plus.google.com/116899029375914044550" rel="publisher">+Google</a><a href="/intl/en/about.html">About Google</a></div></div><p style="color:#767676;font-size:8pt">&copy; 2017 - <a href="/intl/en/policies/privacy/">Privacy</a> - <a href="/intl/en/policies/terms/">Terms</a></p></span></center><script>(function(){window.google.cdo={height:0,width:0};(function(){var a=window.innerWidth,b=window.innerHeight;if(!a||!b)var c=window.document,d="CSS1Compat"==c.compatMode?c.documentElement:c.body,a=d.clientWidth,b=d.clientHeight;a&&b&&(a!=google.cdo.width||b!=google.cdo.height)&&google.log("","","/client_204?&atyp=i&biw="+a+"&bih="+b+"&ei="+google.kEI);}).call(this);})();</script><div id="xjsd"></div><div id="xjsi"><script>(function(){function c(b){window.setTimeout(function(){var a=document.createElement("script");a.src=b;document.getElementById("xjsd").appendChild(a)},0)}google.dljp=function(b,a){google.xjsu=b;c(a)};google.dlj=c;}).call(this);(function(){window.google.xjsrm=[];})();if(google.y)google.y.first=[];if(!google.xjs){window._=window._||{};window._._DumpException=function(e){throw e};if(google.timers&&google.timers.load.t){google.timers.load.t.xjsls=new Date().getTime();}google.dljp('/xjs/_/js/k\x3dxjs.hp.en_US.f4gP1yQlKSI.O/m\x3dsb_he,d/am\x3dIg/rt\x3dj/d\x3d1/t\x3dzcms/rs\x3dACT90oGEsf9mjr1quyiZsqE1ygzJquiJhw','/xjs/_/js/k\x3dxjs.hp.en_US.f4gP1yQlKSI.O/m\x3dsb_he,d/am\x3dIg/rt\x3dj/d\x3d1/t\x3dzcms/rs\x3dACT90oGEsf9mjr1quyiZsqE1ygzJquiJhw');google.xjs=1;}google.pmc={"sb_he":{"agen":true,"cgen":true,"client":"heirloom-hp","dh":true,"dhqt":true,"ds":"","fl":true,"host":"google.com","isbh":28,"jam":0,"jsonp":true,"msgs":{"cibl":"Clear Search","dym":"Did you mean:","lcky":"I\u0026#39;m Feeling Lucky","lml":"Learn more","oskt":"Input tools","psrc":"This search was removed from your \u003Ca href=\"/history\"\u003EWeb History\u003C/a\u003E","psrl":"Remove","sbit":"Search by image","srch":"Google Search"},"nds":true,"ovr":{},"pq":"","refpd":true,"rfs":[],"sbpl":24,"sbpr":24,"scd":10,"sce":5,"stok":"tTOwHHK9nmT1yOC_DUBuy7CGikk"},"d":{},"YFCs/g":{}};google.y.first.push(function(){if(google.med){google.med('init');google.initHistory();google.med('history');}});if(google.j&&google.j.en&&google.j.xi){window.setTimeout(google.j.xi,0);}
    </script></div></body></html>

So that's the homepage for Google. Don't worry too much about what the headers *are* right now; the important part is that there's a whole bunch of 'em, then an empty line, then then some HTML. This is a standard HTTP Message &#x2013; headers, newline, body. Boom.


## Request / Response

HTTP interactions have two parts: a *request* and a *response*. This is about what it sounds like:

-   <REQUEST> Your Computer: Hey Server! Gimme thewebpage.com!
-   <RESPONSE> The Server: You got it! Here it is.

HTTP uses the same message format for both requests and responses. From here, we'll refer to the requestor by a more accurate, general name: the *client*. The client requests information of the server, then renders it for you, the user, to interact with.


## Status Codes

Let's take a simpler example: the server that serves my personal website. I'll show *only* the headers with `curl`'s `-I` flag:

```sh
curl -I http://thermador.herokuapp.com
```

    HTTP/1.1 200 OK
    Connection: keep-alive
    Date: Wed, 01 Mar 2017 05:10:54 GMT
    Content-Type: text/plain
    Server: Jetty(7.6.1.v20120215)
    Via: 1.1 vegur

That first like is the one we care about: `HTTP/1.1 200 OK`. `HTTP/1.1` is our HTTP version, low excitement there, but `200 OK` is our *status code*. Status codes are how the server tells us about the success (or failure) of our request. There are quite a few status codes, and a well-setup web server can give fairly precise information about an HTTP request using them. [Here's the full list](https://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html); for now, some common codes are:

-   200 OK: our favorite. 200 is the "everything worked and is great!" status code
-   403 Forbidden: you are not authorized to access whatever it was you were trying to get
-   404 Not Found: the thing you asked for isn't there
-   500 Internal Server Error: the server is borked, somehow

It's worth realizing that the correct implementation of HTTP status codes is not a solved problem. For instance, what do you do if a request is valid **and** you are authorized to make it **and** the resource is found, **but** there is a problem in your request? For instance, if have a correctly implemented Slack bot with a valid token and you try to open a direct message channel with a non-existent user, Slack will return something like:

    HTTP/1.1 200 OK

    {
      'ok': 'false',
      'error': 'user_not_found'
    }

They return a `200 OK`, because your request is valid, but then the response body specifies `ok: false`, and tells you the user wasn't found. Neat? Neat. Point is: there are usual practices and things one expects, and then there's The Internet.


## More About Headers

```sh
curl -I http://www.google.com
```

    HTTP/1.1 200 OK
    Date: Wed, 01 Mar 2017 05:10:54 GMT
    Expires: -1
    Cache-Control: private, max-age=0
    Content-Type: text/html; charset=ISO-8859-1
    P3P: CP="This is not a P3P policy! See https://www.google.com/support/accounts/answer/151657?hl=en for more info."
    Server: gws
    X-XSS-Protection: 1; mode=block
    X-Frame-Options: SAMEORIGIN
    Set-Cookie: NID=98=jdPTzVCJRC3etOcZBnsAx4l5NB4p9Y3039cVc7zb_6A--ZIVMNEW035GfrQDzbS8gBZJAISfUn1Kc1T0yCzsbKIptIiX3z0sn8Vs6gkCESZXm3eAW_OE2zY_7r72IS7gQibaBRDYVeKo_Ms62w; expires=Thu, 31-Aug-2017 05:10:54 GMT; path=/; domain=.google.com; HttpOnly
    Transfer-Encoding: chunked
    Accept-Ranges: none
    Vary: Accept-Encoding

We can think of headers, *generally* as sets of key-value pairs, which you can see up above &#x2013; the key `Expires` has the value `-1`, for instance. In this way, a client and the responding HTTP server convey useful information to each other. `Content-Type`, for instance, is how the server tells the client, "here is what I'm going to give you" &#x2013; plain text, or JSON, or a PNG or a JavaScript application. A client might set authorization information as a header, so the server knows the client is allowed access to a given URL. Cookies are passed back and forth in headers, allowing a site to (on the benign end of the spectrum) color links you've already clicked.


## HTTP Verbs and Resources

So: we know that clients and servers exchange messages using the same format. We've seen status codes in an HTTP response; for a request, the equivalent piece of the puzzle is a *verb* and a *resource*. Let's use `curl -v` to see what our *request* looks like &#x2013; what the server is actually responding to:

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

The line we care about right now is: `GET / HTTP/1.1`. And really, only the first two things &#x2013; `HTTP/1.1` specifies the version of HTTP our request is speaking, which is useful but not particularly interesting (it'll almost always be 1.1). Let's focus on `GET /`.

`/` is our *resource*. In much the same way `/` represents the root of the file system on our Linux computers, here `/` is the root of the website we're viewing. Now, several fun bits of obfuscation on the modern web: notice that in my `curl` request, I didn't specify I wanted `/` &#x2013; `curl` automatically "rebuilt" the URL to include it. Remember the format of URIs? As a reminder, it's this:

    scheme:[//[user:password@]host[:port]][/]path[?query][#fragment]

A URL (Uniform Resource *Locator*) is a more specific form of URI in which the scheme<sup><a id="fnr.1" class="footref" href="#fn.1">1</a></sup> is always specified. For instance, in the URL `http://www.google.com`, `http` is the *scheme*. User and password are omitted most of the time on the Internet-at-large, so they're absent; `www.google.com` is the *host*. What `curl` has implicitly added is the `/` that indicates the root resource at the given host. (Modern web browsers make this all even more opaque by eliding more and more of a given URL &#x2013; for instance, we typically don't see the scheme or the port in a URL, even if we specify them.)

There's a second tier of obfuscation: by convention, specifying a resource either as `/` or ending in `/` means, "give me a document named index.html at location `/`". So we ask for `www.google.com`, which implicitly means `www.google.com/`. A web server can return whatever it likes for the root resource; in the absence of anything else, by convention a page called `index.html` is returned. So the URL we've gotten might *actually* be `wwww.google.com/index.html`, while the browser just shows us that we're at `www.google.com`. Great.

`GET` is an HTTP *verb* (technically *methods*, but *verb* is common parlance and I find it to be clearer). It describes what action we want to take on the thing we're requesting. `GET` is far and away the most common &#x2013; it means, "just give me the thing I asked for, maybe with some parameters". (`GET` is so common that it's the default for tools like `curl`, though other verbs can be specified.) There are others; the other two you're likely to come across are:

-   `POST` &#x2013; "Upload this information to this resource"; commonly used in web forms.
-   `DELETE` &#x2013; Delete whatever is described by this resource


## Updating our Client/Server Conversation

Our conversation between client and server could now be fleshed out to look like this:

-   <REQUEST> Your Computer: Hey thewebpage.com! I'd like to `GET` the root resource at `/`, please!
-   <RESPONSE> The Server: 200 OK you got it! Here's a `text/html` response body for my root `index.html`. Also can you hang on to this cookie for me? Send it back to me next time so I can keep track of you a little.


## But Wait, There's More: IP Addresses, `localhost`, ports, and a touch of DNS

Okay, here's a fun one: there is no such thing as `www.google.com`. Or, more precisely: there is no *one* thing that is `www.google.com`, and none of the things that serve `www.google.com` URLs have any idea what this "google dot com" nonsense is. `www.google.com` is a *host name*, which servers don't speak. Instead, servers speak *Internet Protocol Addresses* &#x2013; IP addresses for short. Bad news: the systems that handle IP addresses are monstrously complicated. Good news: while it's good to know those systems are there and what their names are, you don't need to know much at all about how they actually work.

The system that maps host names to IP Addresses is called a *Domain Name System*, or DNS. Here's a gross oversimplification of how this works:

-   You, the User: Computer, bring me www.google.com
-   Computer: Great. Do I know the IP address of a DNS server? **checks** Yes, I do. Hey DNS Server! What the hell is www.google.com?
-   DNS Server: I'm not sure, but I know a DNS Server who does. Talk to Google's DNS Server &#x2013; have an IP address.
-   Computer : Hokay. Hey Google's DNS Server. What the hell is www.google.com?
-   Google's DNS Server : Oh, it's this &#x2013; have an IP Address.

So: DNS is a hierarchical system by which a computer can talk to a general lookup service and reach more specific lookup services until it can talk to a specific server that can fulfill its request. **Whew**. That is more than enough DNS for our purposes.

I bring all of this up in part because we need to talk about a special hostanme/IP Address combo: `localhost`. `localhost`, which on Macs has the default IP address of 127.0.0.1, is your computers way to refer to itself. When you run a web server on your laptop for local development, the *host* you'll specify in your URL is `localhost`.

A cool true fact:

Desperately want to know more about DNS? Start with Monica Dinculescu's [Cat DNS](http://meowni.ca/posts/go-cat-dns-go/) &#x2013; the DNS server that resolves everything to cats.


## One Last Thing: Public vs. Private

Most often, when we say "on the Internet", we mean we'll be serving content *publicly* &#x2013; available to the world at large &#x2013; but there's nothing about HTTP that requires it to be public. I can, for example, start an HTTP server on my laptop, accessibly only to web browsers also on my computer. Businesses often create a variety of flavors of Walled Garden for themselves, in which a thing might be "on the Internet", but not available to the public at large. A Virtual Private Network &#x2013; usually just VPN &#x2013; is a common approach to this. Real Talk, VPNs are too big a topic for us to get in to, but the extra-short version goes like this: a VPN allows a set of computers to behave as though they are all on the same private network while being connected to the public internet. This is done (again, a gross simplification) by encrypting communication between members of the network. Wanna be on the VPN? You'll need a password or key, and a client. Anywho, [here's a lot more about VPNs](https://en.wikipedia.org/wiki/Virtual_private_network).

You should know that you *can* serve content to the Public Internet from your laptop. You almost certainly don't want to do this. Beware of any bug fix or problem solving suggestion that suggests you serve your content on `0.0.0.0` &#x2013; that means, "respond to requests from the public internet" and it's very likely not what you're trying to do.


## Let's check in with that computer/server conversation again

So now, with DNS and a sense of the basics of HTTP, our conversation looks like this:

-   You, the User: Computer, bring me thewebpage.com
-   Computer: Great. Do I know the IP address of a DNS server? **checks** Yes, I do. Hey DNS Server! What the hell is thewebpage.com?
-   DNS Server: I'm not sure, but I know a DNS Server who does. Talk to the server at this IP Address.
-   Computer: Hokay. Hey next DNS Server. What the hell is thewebpage.com?
-   Next DNS Server : Oh, it's this &#x2013; have an IP Addres.
-   Computer: Great. Hey thewebpage.com! I'd like to `GET` the root resource at `/`, please!
-   The Server: 200 OK you got it! Here's a `text/html` response body for my root `index.html`. Also can you hang on to this cookie for me? Send it back to me next time so I can keep track of you a little.
-   Computer: Great. Hey the User: here is some rendered HTML.

Now. A *lot* of how that last bit goes is actually a function of the *architecture* of the web application in question. So:


# What the crap is "architecture"

A shorter, clearer way to frame this is, "how is your application built?" What are the pieces? Is there a database? What is the client like? How do you scale your app for traffic? Now: this is a whole buuuuunch of questions, and there are a lot we aren't going to get to just yet. For now, we're going to ignore the computer that runs your code and only talk about the code, which will have one or both of these components:

-   A Web Server: some flavor of code you've written that responds to HTTP requests with HTTP/JavaScript/images/etc.
-   A Client: Probably almost entirely JavaScript; might talk to a Server, rendering results. Might be the entire deal, for sufficiently simple apps.

You might also have a database! We're gonna start talking about them next week. Right now, what you need to know is that a database stores stuff, in a durable way, for repeat access and manipulation.


# Yes OK Good let's look at a web app

[Here's a demo web app!](https://github.com/Gastove/http-demo) We'll be working our way through the pieces. You can clone and virtualenv it, in the traditional manner.

Turn on yer virtualenv and run this thing with:

```python
python http-demo
```

If it works, you should see a little bit of logging in your terminal. You should also be able to go to <http://localhost:5000> in your web browser of choice and see a tiny little message. Wee!


# So what's going on here?

There's now a little Python web server running on your computer. It's host is `localhost` (127.0.0.1, as you'll recall), and its port is 5000. (When we develop locally, we almost always have to specify a port; when we use the Internet at Large we almost never do.) You'll notice you'll get the same web page if you ask for localhost:5000, localhost:5000/, or localhost:5000/index.html.

Inside `http-demo` is a method that listens for `/` or `/index.html`, and responds by "serving static HTML". *Static* here means, "unchanging" &#x2013; the opposite of *dynamic*, which we'll define in just a few more paragraphs. Look in `static/html`; you'll see a file named `index.html`. Its contents are precisely identical to what you'll see in your web browser if you inspect the source of the page you're seeing.

In Flask, at least, your methods barely have to do anything at all. Go to `localhost:5000/minimal`; those words are the only words in the corresponding method in `http-demo`. Flask adds just a *touch* of wrapping HTML, and it appears in the browser. Neat.

It turns out that when we talk about serving static files, we're almost never talking about serving pure HTML files. More commonly, we'll talk about *static assets*, and what we'll be referring to is content like images and CSS (we'll be discussing what CSS is Soon). If you make a directory inside `static` called `gifs`, and put a gif in there, you can now access it by name at `localhost:5000/gifs/<gif_name>`. Neat? Neat.

Now let's head to <http://localhost:5000/helloworld>. It's got&#x2026; slightly more to it! (Very, very slightly.) In fact, it can do a trick. Try <http://localhost:5000/helloworld/> + your name (<http://localhost:5000/helloworld/Ross>, for instance). Neat, eh?

The `helloworld` resource is returning HTML, but it's doing a handy trick called *server-side rendering*. It works like this: there is a template called `hello.html`, which uses a templating system called Jinja. When you ask for `helloworld/Ross`, for instance, the *Ross* part of the URL is captured as a variable. Flask then loads and *renders* the `hello.html` template, which creates the HTML that's then sent back to your browser.

Here's another way this can be used: head to <http://localhost:5000/form>. Pick a beverage and hit `Yar`. Now there's a result! M A G I C. Okay, more template rendering &#x2013; in this case, `form` is a static page (not a template) that uses `POST` to pass data from itself to the `yousaid` resource, which renders a template.


# So where does JavaScript fit in?

Terrific question. This demo doesn't currently account for JavaScript, because there's a *lot* JS can do. This gets us back to the slowly-expanding idea of Architecture. See, right now, `http-demo` is an entirely server-side application. A little Flask app serves rendered HTML to your browser *and that's pretty much it*. These pages are still basically static &#x2013; they arrive at the browser fully formed and with very litter interactivity, save for what HTML itself provides (forms, for instance).

We could change this by adding a little JavaScript. HTML pages can define a `script` tag, which will cause that page to load in, well, a script (almost always JavaScript). Our app can serve JS scripts just like any other static asset, and now our page can have a little interactivity &#x2013; maybe a little navigation menu, say. Fundamentally, all the action still really happens on the server, but with JS we can program in the browser and Do More. HTML is what you can *see*; JS is really what you can *do*. (It will accomplish this task, almost always, by creating either HTML or SVG images, or by modifying CSS.)

But there's another option: make a *client out of pure JavaScript*. My personal web site works like this. There are, in effect, *two* HTTP servers. One is the server-side application, which is written in Clojure, and has routes like <http://thermador.herokuapp.com/api/page/about> &#x2013; which you can go to in your browser. Looks&#x2026; pretty weird, right? Not super useful.

But then you head to <http://www.gastove.com>, and you see a Real Thing. This is the *second* HTTP server, which really actually only serves one thing &#x2013; a JavaScript application. When you click on links in that application, JavaScript intercepts the routes, parses them, and then asks the server for content. This is called a *Single Page Application* &#x2013; the only "page" in my client is an index.html that loads JavaScript, and then JS does *everything else*. Specifically, it communicates with my server using a paradigm called REST (REpresentational State Transfer) &#x2013; the JS client says, "hey, I need the pages of this site!", and the Server responds with a JSON blob describing all of them, which the JS then turns in to HTML.

As you might apprehend, this can get complex in a hurry.


# Homework

Okay, it's time to start tinkering!

1.  Install the \`http-demo\` app and run it locally.
2.  Read over the source code.
3.  Start reading about [jinja2](http://jinja.pocoo.org/docs/2.9/)
4.  Start changing things! See if they break, and how.
5.  See if you can add a few new routes! What about a new template?
6.  For the bold, try adding basic CSS!

## Footnotes

<sup><a id="fn.1" class="footnum" href="#fnr.1">1</a></sup> Sometimes the scheme is also referred to as the *network transport*. Thank god we aren't stuck with only one name for one thing &#x2013; can you imagine.
