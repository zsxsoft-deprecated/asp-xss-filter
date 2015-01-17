<script language="javascript" runat="server">
/*var describe = function (name, func) {
	var it = function (name, func) {
		Response.Write("<p>测试：" + name + "</p>");
		func.call(this);
	}
	func.call(this);
}*/
var it = function (name, func) {
	Response.Write("<p>测试：" + name + "</p>\n\n");
	func.call(this);
}

var describe = function (name, func) {
	func.call(this);
}

var assert = {
	equal: function (a, b) {
		if (a != b) {
			Response.Write ("<p style='color:red'>ERROR - " + a + " ||| " + b + "</p>\n\n");
		}  else {
			Response.Write ("<p style='color:green'>PASS - " + a + " ||| " + b + "</p>\n\n");
		}
	}
}
</script>