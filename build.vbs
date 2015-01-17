Dim objFSO, objFiles, objFile
Dim strDir, strContent, strTemp
Set objFSO = CreateObject("Scripting.FileSystemObject")
strDir = objFSO.GetFolder(".").Path & "\"
objFiles = Array("xss.default.asp", "xss.parser.asp", "xss.xss.asp")
strContent = ""
Dim i
For i = 0 To Ubound(objFiles)
	strTemp = LoadFromFile(strDir & "\lib\" & objFiles(i), "UTF-8")
	strTemp = Split(strTemp, "<script language=""javascript"" runat=""server"">")(1)
	strTemp = Split(strTemp, "</script>")(0)
	strContent = strContent & strTemp
Next
strTemp = "<script language=""javascript"" runat=""server"">" & vbCrlf
strTemp = strTemp & "var FilterXSS = (function () {"
strContent = strTemp & strContent
strTemp = "return FilterXSS;})();" & vbCrlf & vbCrlf
strTemp = strTemp & "function filterXSS(html, options) {" & vbCrlf
strTemp = strTemp & "var xss = FilterXSS(options);" & vbCrlf
strTemp = strTemp & "return xss.process(html);" & vbCrlf
strTemp = strTemp & "}" & vbCrlf
strTemp = strTemp & "</script>"
strContent = strContent & vbCrlf & strTemp
If Not objFSO.FolderExists(".\dist") Then
	objFSO.CreateFolder ".\dist"
End If

If (MsgBox("Charset:" & vbCrlf & vbCrlf & "Yes - UTF-8" & vbCrlf & "No - GBK", vbQuestion + vbYesNo) = vbYes) Then
	Call SaveToFile(strDir & "\dist\xss.class.asp", strContent, "UTF-8")
Else
	Call SaveToFile(strDir & "\dist\xss.class.asp", strContent, "GBK")
End If

Function LoadFromFile(strFile, strCharset) 
	Dim objStream 
	Set objStream = CreateObject("ADODB.Stream") 
	With objStream 
		.Type = 2 
		.Mode = 3 
		.Open 
		.LoadFromFile strFile
		.Charset = strCharset
		.Position = 2 
		LoadFromFile = .ReadText 
		.Close 
	End With 
	Set objStream = Nothing 
End Function 

Sub SaveToFile(strFile, strBody, strCharset) 
	Dim objStream 
	Set objStream = CreateObject("ADODB.Stream") 
	With objStream 
		.Type = 2 
		.Open 
		.Charset = strCharset
		.Position = objStream.Size 
		.WriteText = strBody 
		.SaveToFile strFile, 2 
		.Close 
	End With 
	Set objStream = Nothing 
End Sub 