<%@ CODEPAGE="65001"%>
<!-- #include file="dist/xss.class.utf8.asp"-->
<%
Response.Write filterXSS("<a style=""font-family: aaa"" href=""http://www.baidu.com/"">aa</a>")
%>