<%@ page language="java" import="java.util.*" pageEncoding="GBK"%>
<%
String rootPath = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+rootPath+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>附件上传</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	
	<script type="text/javascript">
		/**
	*检查扩展名
	*/
		function check(){
			var upfilename=document.uploadform.files.value;
			if(upfilename==""){
			   alert("你还没有选择你要上传的文件!");
			   return false;
			  } 
			  var filetype=upfilename.substring(upfilename.indexOf(".")+1,upfilename.length).toLowerCase();
			  var fileName=upfilename.substring(0,upfilename.indexOf("."));
			  /**
				*限制上传类型
				*/
			  if(filetype!="flv"&& filetype!="avi"&&filetype!="asx"&&filetype!="asf"&& filetype!="mp4"&&filetype!="mov"&&
			  		filetype!="3gp"&& filetype!="wmv"&&filetype!="mpg"&&filetype!="rmvb"&& filetype!="rm"&&filetype!="wmv9")
			  {
			     alert("只支持flv,avi,asx,asf,mp4,mov,3gp,wmv,mpg,rmvb,rm,wmv9文件!!!");
			     return false;
			  }
			  
			  window.uploadform.action="<%=rootPath%>/config/vpntelnet/mediaPlayer/upload.jsp";
			  window.uploadform.submit();
		}	
	</script>
  </head>
  
  <body>
  	<form method="post" enctype="multipart/form-data" target="_self" name="uploadform">
    <h2 align="center">选择您要上传的视频</h2> <br>
    方案：<input type="file" id="files" name="files">
    	<input type="button" value="上传" align="middle" onclick="check()">
    	<br><br>
    	<div align="center"><font color="red" style="font-size: 13">&nbsp;视频格式支持flv,avi,asx,asf,mp4,mov,3gp,wmv,mpg,rmvb,rm,wmv9类型</font></div>
  	</form>
  </body>
</html>
