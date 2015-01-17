<%@ CODEPAGE="65001"%>
<!-- #include file="lib/xss.default.asp"-->
<!-- #include file="lib/xss.parser.asp"-->
<!-- #include file="lib/xss.xss.asp"-->
<script language="javascript" runat="server">
function filterXSS (html, options) {
  var xss = FilterXSS(options);
  return xss.process(html);
}
</script>
<%
Response.Write filterXSS("<a style=""font-family: aaa"" href=""http://www.baidu.com/"">aa</a>")
%>