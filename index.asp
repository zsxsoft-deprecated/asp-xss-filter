<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!-- #include file="xss.default.asp"-->
<!-- #include file="xss.parser.asp"-->
<!-- #include file="xss.xss.asp"-->

<%
function filterXSS (html, options) {
  var xss = FilterXSS(options);
  return xss.process(html);
}

Response.Write(filterXSS("<a style=\"font-family: aaa\" href=\"http://www.baidu.com/\">aa</a>"));
%>