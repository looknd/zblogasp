﻿<%
Call RegisterPlugin("metro","ActivePlugin_metro")

Function ActivePlugin_metro()
	'配置初始化
	Dim c
	Set c = New TConfig
	c.Load("metro")
	If c.Exists("vesion")=False Then
		c.Write "vesion","1.1"
		c.Write "custom_bodybg","#EEEEEE|images/bg.jpg|repeat|2|top|"
		c.Write "custom_hdbg","|images/headbg.jpg|repeat  fixed|1|top|100|"
		c.Write "custom_color","#5EAAE4| #A3D0F2| #222222| #333333| #FFFFFF"
		c.Save
	End If 

    Call Add_Response_Plugin("Response_Plugin_Admin_Top",MakeTopMenu(1,"主题配置",BlogHost & "/zb_users/theme/metro/plugin/editor.asp","ametroManage",""))
    '这里是给后台加管理按钮
    If BlogVersion<=121028 Then Call Add_Response_Plugin("Response_Plugin_ThemeMng_SubMenu","<script type='text/javascript'>$(document).ready(function(){$(""#theme-metro .theme-name"").append('<input class=""button"" style=""float:right;margin:0;padding-left:10px;padding-right:10px;"" type=""button"" value=""配置"" onclick=""location.href=\'"&BlogHost&"/zb_users/theme/metro/plugin/editor.asp\'"">')})</script>")
End Function



'******************************************************************************************
' 保存css文件
'******************************************************************************************
Function metro_savetofile(stylefile)
	Dim strBodyBg,aryBodyBg
	Dim strHdBg,aryHdBg
	Dim strColor,aryColor
	Dim c,i

	'刷新Configs
	IsRunConfigs=False
	Call GetConfigs()

	Set c = New TConfig
	c.Load("metro")
	If c.Exists("vesion")=true Then
		strBodyBg=c.read("custom_bodybg")
		strHdBg=c.read("custom_hdbg")
		strColor=c.read("custom_color")
		aryBodyBg=Split(strBodyBg,"|")
		aryHdBg=Split(strHdBg,"|")
		aryColor=Split(strColor,"|")
	End If 
	Set c =Nothing

	Dim p
	p=Array("","left","center","right")
	aryBodyBg(3)=p(int(aryBodyBg(3)))
	aryHdBg(3)=p(int(aryHdBg(3)))

	If InStr(aryBodyBg(2),"repeat")=0 Then 
		aryBodyBg(2)="no-repeat "& aryBodyBg(2)
	End If 
	If InStr(aryHdBg(2),"repeat")=0 Then 
		aryHdBg(2)="no-repeat "& aryHdBg(2)
	End If 

	If aryBodyBg(5)="True" Then 
		strBodyBg=aryBodyBg(0)&" "&"url("& aryBodyBg(1) &")"&" "& aryBodyBg(2) &" "& aryBodyBg(3) &" "& aryBodyBg(4) 
	Else 
		strBodyBg=aryBodyBg(0)
	End If 

	If aryHdBg(0)<>"transparent" Then aryHdBg(0)=aryColor(0)
	If aryHdBg(6)="True" Then 
		strHdBg=aryHdBg(0)&" "&"url("& aryHdBg(1) &")"& aryHdBg(2) &" "& aryHdBg(3) &" "& aryHdBg(4) 
	Else 
		strHdBg=aryHdBg(0)
	End If 

	'替换模版标签
	Dim strContent
	strContent=LoadFromFile(BlogPath & "zb_users\theme\metro\plugin\style.css.html" ,"utf-8")

	strContent=Replace(strContent,"{%strBodyBg%}",strBodyBg)
	strContent=Replace(strContent,"{%strHdBg%}",strHdBg)

	For i=0 To UBound(aryBodyBg)
		strContent=Replace(strContent,"{%aryBodyBg("&i&")%}",aryBodyBg(i))
	Next
	For i=0 To UBound(aryHdBg)
		strContent=Replace(strContent,"{%aryHdBg("&i&")%}",aryHdBg(i))
	Next
	For i=0 To UBound(aryColor)
		strContent=Replace(strContent,"{%aryColor("&i&")%}",aryColor(i))
	Next

	Call SaveToFile(BlogPath & "zb_users\theme\metro\style\"&stylefile,strContent,"utf-8",False)

End Function
'******************************************************************************************
%>