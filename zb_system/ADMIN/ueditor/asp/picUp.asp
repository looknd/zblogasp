<!--#include file="up_inc.asp"-->
<!-- #include file="..\..\..\..\zb_users\c_option.asp" -->
<!-- #include file="..\..\..\function\c_function.asp" -->
<!-- #include file="..\..\..\function\c_function_md5.asp" -->
<!-- #include file="..\..\..\function\c_system_lib.asp" -->
<!-- #include file="..\..\..\function\c_system_base.asp" -->
<!-- #include file="..\..\..\function\c_system_event.asp" -->
<!-- #include file="..\..\..\function\c_system_plugin.asp" -->
<!-- #include file="..\..\..\function\rss_lib.asp" -->
<!-- #include file="..\..\..\function\atom_lib.asp" -->
<!-- #include file="..\..\..\..\zb_users\plugin\p_config.asp" -->
<%
Call System_Initialize()
Call CheckReference("")
If Not CheckRights("ArticleEdt") Then Call ShowError(6)
For Each sAction_Plugin_FileUpload_Begin in Action_Plugin_FileUpload_Begin
	If Not IsEmpty(sAction_Plugin_FileUpload_Begin) Then Call Execute(sAction_Plugin_FileUpload_Begin)
Next

dim upload,file,state,uploadPath,PostTime
Randomize

PostTime=GetTime(Now())
Dim strUPLOADDIR
If ZC_UPLOAD_DIRBYMONTH Then
		strUPLOADDIR = ZC_UPLOAD_DIRECTORY&"\"&Year(GetTime(Now()))&"\"&Month(GetTime(Now()))
		CreatDirectoryByCustomDirectory("zb_users\"&strUPLOADDIR)
Else
		strUPLOADDIR = ZC_UPLOAD_DIRECTORY
End If
Set upload=New UpLoadClass
upload.AutoSave=2
upload.Charset="UTF-8"
upload.FileType=Replace(ZC_UPLOAD_FILETYPE,"|","/")
upload.savepath=BlogPath & "zb_users\"& strUPLOADDIR &"\"
upload.maxsize=1024*1024*1024
upload.open
Dim Path
Path=Replace(BlogPath & "zb_users\"& strUPLOADDIR &"\" & upload.form("edtFileLoad_Name")	,"\","/")
Dim s
FileName=ZC_BLOG_HOST&"zb_users\"& strUPLOADDIR &"\" & upload.form("edtFileLoad_Name")
s=upload.Save("edtFileLoad",0)
objConn.Execute("INSERT INTO [blog_UpLoad]([ul_AuthorID],[ul_FileSize],[ul_FileName],[ul_PostTime],[ul_FileIntro],[ul_DirByTime]) VALUES ("& BlogUser.ID &",'"& upload.form("edtFileLoad_Size") &"','"& upload.form("edtFileLoad") &"','"& PostTime &"','Attatment',"&CInt(ZC_UPLOAD_DIRBYMONTH)&")")
SetBlogHint_Custom "{'state':'"& upload.Error2Info("edtFileLoad") & "','url':'"& Replace(FileName,"\","/") &"','fileType':'"&upload.form("edtFileLoad_Ext")&"'}"
response.Write "{'state':'"& upload.Error2Info("edtFileLoad") & "','url':'"& upload.form("edtFileLoad") &"','fileType':'"&upload.form("edtFileLoad_Ext")&"'}"

	
For Each sAction_Plugin_uEditor_FileUpload_End in Action_Plugin_uEditor_FileUpload_End
	If Not IsEmpty(sAction_Plugin_uEditor_FileUpload_End) Then Call Execute(sAction_Plugin_uEditor_FileUpload_End)
Next

set upload=nothing
Call System_Terminate()

%>