asp-xss-filter
=====

**This is classical ASP, not ASP.NET!!!!**

**这是经典ASP，不是ASP.NET！！！！**

Transplanted from [js-xss project](https://github.com/leizongmin/js-xss)（由[js-xss](https://github.com/leizongmin/js-xss)项目移植）

Although it is written by JScript, but can also be used in VBScript.（虽然它是由JScript写的，但是在VBScript里也可以正常调用。）

## Install
In Windows, run ``build.vbs``, then you will get 2 files in ``dist``. Copy the file that you need to your projects, then include it.
在Windows下，双击``build.vbs``，然后你会在``dist``目录里得到两个文件。复制你需要的文件到你的项目内，引用即可。

```html
<!-- #include file="xss.class.utf8.asp"-->
```
In Linux/Mac, are you kidding me?

在Linux/Mac下，你TM在逗我？


## Example

See index.asp
```asp
<%@ CODEPAGE="65001"%>
<!-- #include file="dist/xss.class.utf8.asp"-->
<%
Response.Write filterXSS("<a style=""font-family: aaa"" href=""http://www.baidu.com/"">aa</a>")
%>
```

## Other

See [js-xss](https://github.com/leizongmin/js-xss)

## License

The MIT License