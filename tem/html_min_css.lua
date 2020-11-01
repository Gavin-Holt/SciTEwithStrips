-- **MinimalistTemplate
-- Create html{} and w{} - (which are actually the same table)
dofile([[P:\MyPrograms\PROFILE\Tools\lua\lua\html\init.lua]])

html.CSS.headcode = {[[
* {
    margin: 10;
    padding: 0;
}
html {
	overflow-y: scroll;
}
body {
	background:#ffffff;
	font-size: 13px;
	color: #666666;
	font-family: Arial, helvetica, sans-serif;
}
ol, ul {
	list-style: none;
	margin: 0;
}
ul li {
	margin: 0;
	padding: 0;
}
h1 {
	margin-bottom: 10px;
	color: #111111;
}
a, img {
	outline: none;
	border:none;
	color: #000;
	font-weight: bold;
	text-transform: uppercase;
}
p {
	margin: 0 0 10px;
	line-height: 1.4em;
	font-size: 1.2em;
}
img {
	display: block;
	margin-bottom: 10px;
}
aside {
	font-style: italic;
	font-size: 0.9em;
}
article, aside, details, figcaption, figure,
footer, header, hgroup, menu, nav, section {
    display: block;
}

/* Structure */
#wrapper {
	width: 96%;
	max-width: 920px;
	margin: auto;
	padding: 2%;
}

#main {
	width: 60%;
	margin-right: 5%;
	float: left;
}

aside {
	width: 35%;
	float: right;
}

/* Logo H1 */
header h1 {
	height: 70px;
	width: 160px;
	float: left;
	display: block;
	background: url(../images/demo.gif) 0 0 no-repeat;
	text-indent: -9999px;
}

/* Nav */
header nav {
	float: right;
	margin-top: 40px;
}

header nav li {
	display: inline;
	margin-left: 15px;
}

#skipTo {
	display: none;
}
#skipTo li {
	background: #b1fffc;
}

/* Banner */
#banner {
	float: left;
	margin-bottom: 15px;
	width: 100%;
}

#banner img {
	width: 100%;
}


/* Media Queries */
@media screen and (max-width: 480px) {

#skipTo {
		display: block;
}

header nav, #main, aside {
	float: left;
	clear: left;
	margin: 0 0 10px;
	width: 100%;
}
header nav li {
	margin: 0;
	background: #efefef;
	display: block;
	margin-bottom: 3px;
}
header nav a {
	display: block;
	padding: 10px;
	text-align: center;
	}
}

]]}

table.insert(html.JS.headcode,[[
/*! matchMedia() polyfill - Test a CSS media type/query in JS. Authors & copyright (c) 2012: Scott Jehl, Paul Irish, Nicholas Zakas. Dual MIT/BSD license */
/*! NOTE: If you're already including a window.matchMedia polyfill via Modernizr or otherwise, you don't need this part */
window.matchMedia=window.matchMedia||(function(e,f){var c,a=e.documentElement,b=a.firstElementChild||a.firstChild,d=e.createElement("body"),g=e.createElement("div");g.id="mq-test-1";g.style.cssText="position:absolute;top:-100em";d.style.background="none";d.appendChild(g);return function(h){g.innerHTML='&shy;<style media="'+h+'"> #mq-test-1 { width: 42px; }</style>';a.insertBefore(d,b);c=g.offsetWidth==42;a.removeChild(d);return{matches:c,media:h}}})(document);

/*! Respond.js v1.1.0: min/max-width media query polyfill. (c) Scott Jehl. MIT/GPLv2 Lic. j.mp/respondjs  */
(function(e){e.respond={};respond.update=function(){};respond.mediaQueriesSupported=e.matchMedia&&e.matchMedia("only all").matches;if(respond.mediaQueriesSupported){return}var w=e.document,s=w.documentElement,i=[],k=[],q=[],o={},h=30,f=w.getElementsByTagName("head")[0]||s,g=w.getElementsByTagName("base")[0],b=f.getElementsByTagName("link"),d=[],a=function(){var D=b,y=D.length,B=0,A,z,C,x;for(;B<y;B++){A=D[B],z=A.href,C=A.media,x=A.rel&&A.rel.toLowerCase()==="stylesheet";if(!!z&&x&&!o[z]){if(A.styleSheet&&A.styleSheet.rawCssText){m(A.styleSheet.rawCssText,z,C);o[z]=true}else{if((!/^([a-zA-Z:]*\/\/)/.test(z)&&!g)||z.replace(RegExp.$1,"").split("/")[0]===e.location.host){d.push({href:z,media:C})}}}}u()},u=function(){if(d.length){var x=d.shift();n(x.href,function(y){m(y,x.href,x.media);o[x.href]=true;u()})}},m=function(I,x,z){var G=I.match(/@media[^\{]+\{([^\{\}]*\{[^\}\{]*\})+/gi),J=G&&G.length||0,x=x.substring(0,x.lastIndexOf("/")),y=function(K){return K.replace(/(url\()['"]?([^\/\)'"][^:\)'"]+)['"]?(\))/g,"$1"+x+"$2$3")},A=!J&&z,D=0,C,E,F,B,H;if(x.length){x+="/"}if(A){J=1}for(;D<J;D++){C=0;if(A){E=z;k.push(y(I))}else{E=G[D].match(/@media *([^\{]+)\{([\S\s]+?)$/)&&RegExp.$1;k.push(RegExp.$2&&y(RegExp.$2))}B=E.split(",");H=B.length;for(;C<H;C++){F=B[C];i.push({media:F.split("(")[0].match(/(only\s+)?([a-zA-Z]+)\s?/)&&RegExp.$2||"all",rules:k.length-1,hasquery:F.indexOf("(")>-1,minw:F.match(/\(min\-width:[\s]*([\s]*[0-9\.]+)(px|em)[\s]*\)/)&&parseFloat(RegExp.$1)+(RegExp.$2||""),maxw:F.match(/\(max\-width:[\s]*([\s]*[0-9\.]+)(px|em)[\s]*\)/)&&parseFloat(RegExp.$1)+(RegExp.$2||"")})}}j()},l,r,v=function(){var z,A=w.createElement("div"),x=w.body,y=false;A.style.cssText="position:absolute;font-size:1em;width:1em";if(!x){x=y=w.createElement("body");x.style.background="none"}x.appendChild(A);s.insertBefore(x,s.firstChild);z=A.offsetWidth;if(y){s.removeChild(x)}else{x.removeChild(A)}z=p=parseFloat(z);return z},p,j=function(I){var x="clientWidth",B=s[x],H=w.compatMode==="CSS1Compat"&&B||w.body[x]||B,D={},G=b[b.length-1],z=(new Date()).getTime();if(I&&l&&z-l<h){clearTimeout(r);r=setTimeout(j,h);return}else{l=z}for(var E in i){var K=i[E],C=K.minw,J=K.maxw,A=C===null,L=J===null,y="em";if(!!C){C=parseFloat(C)*(C.indexOf(y)>-1?(p||v()):1)}if(!!J){J=parseFloat(J)*(J.indexOf(y)>-1?(p||v()):1)}if(!K.hasquery||(!A||!L)&&(A||H>=C)&&(L||H<=J)){if(!D[K.media]){D[K.media]=[]}D[K.media].push(k[K.rules])}}for(var E in q){if(q[E]&&q[E].parentNode===f){f.removeChild(q[E])}}for(var E in D){var M=w.createElement("style"),F=D[E].join("\n");M.type="text/css";M.media=E;f.insertBefore(M,G.nextSibling);if(M.styleSheet){M.styleSheet.cssText=F}else{M.appendChild(w.createTextNode(F))}q.push(M)}},n=function(x,z){var y=c();if(!y){return}y.open("GET",x,true);y.onreadystatechange=function(){if(y.readyState!=4||y.status!=200&&y.status!=304){return}z(y.responseText)};if(y.readyState==4){return}y.send(null)},c=(function(){var x=false;try{x=new XMLHttpRequest()}catch(y){x=new ActiveXObject("Microsoft.XMLHTTP")}return function(){return x}})();a();respond.update=a;function t(){j(true)}if(e.addEventListener){e.addEventListener("resize",t,false)}else{if(e.attachEvent){e.attachEvent("onresize",t)}}})(this);
]])

html.Title = "My First Web Page"
html.HTMLbody = {
w.h1("Title of my masterpiece")..
w.h2("Subtitle of my masterpiece")..
"This is the first paragraph of the first page of the rest of my life.",
"again we stray into the dark world of html"..
w.footnote("help is there anybody out there")..
"more stuff to learn"..
w.footnote("nobody else here")..
"last line",
}

-- Output for tinyweb
html:serve()
-- Saved copy of generated file
html:save([[P:\MyPrograms\EDITORS\SciTE\tem\test\test.html]])
