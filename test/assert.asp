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
		if (a !== b) {
			console.error(a + " ||| " + b);
		}  else {
			console.success(a + " ||| " + b);
		}
	}
}

var console = {
	error: function (msg) {
		Response.Write("<p style='color: red'>ERROR - " + msg + "</p>\n");
	}, 
	success: function (msg) {
		Response.Write("<p style='color: green'>OK - " + msg + "</p>\n");
	}, 
	log: function (msg) {
		Response.Write("<p>" + msg + "</p>\n");
	}
}
</script>