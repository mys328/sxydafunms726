<%@page language="java" contentType="text/html;charset=GB2312"%>
<%@page import="java.util.List"%>
<%@page import="com.afunms.inform.model.Performance"%>
<%@page import="com.afunms.inform.dao.PerformanceDao"%>
<%@page import="com.afunms.inform.model.Alarm"%>
<%@page import="com.afunms.topology.util.NodeHelper"%>
<%@page import="com.afunms.inform.util.SystemSnap"%>
<%@page import="com.afunms.common.util.SysUtil"%>
<%@page import="com.afunms.event.model.*"%>
<%@page import="com.afunms.inform.dao.AlarmDao"%>
<%@ include file="/include/globe.inc"%>
<%@ page import="java.util.*"%>
<%@page import="com.afunms.topology.dao.*"%>
<%@page import="com.afunms.topology.model.*"%>
<%@page import="java.util.List"%>
<%@page import="com.afunms.topology.model.CustomXml"%>
<%@page import="com.afunms.topology.dao.CustomXmlDao"%>
<%
  String rootPath = request.getContextPath();
  String menuTable = (String)request.getAttribute("menuTable");
  List list = null;
  Date c1=new Date();
	String timeFormat = "MM-dd HH:mm:ss";
	java.text.SimpleDateFormat timeFormatter = new java.text.SimpleDateFormat(timeFormat);
	List networklist = (List)session.getAttribute("networklist");
	List hostlist = (List)session.getAttribute("hostlist");
	String hostsize = "0";
	if(hostlist != null && hostlist.size()>0)hostsize=hostlist.size()+"";
	String dbsize = (String)session.getAttribute("dbsize");
	if(dbsize == null)dbsize="0";
	String securesize = (String)session.getAttribute("securesize");
	if(securesize == null)securesize="0";
	String servicesize = (String)session.getAttribute("servicesize");
	if(servicesize == null)servicesize="0";
	String midsize = (String)session.getAttribute("midsize");
	if(midsize == null)midsize="0";
	String routesize = (String)session.getAttribute("routesize");
	if(routesize == null)routesize="0";
	String switchsize = (String)session.getAttribute("switchsize");
	if(switchsize == null)switchsize="0";
	String chart2 = null;
	chart2 = (String)session.getAttribute("chart2");
	System.out.println(chart2+"----");
	String chart1 = null;
	chart1 = (String)session.getAttribute("chart1");
	System.out.println(chart1+"----");
%>
<html>

<head>
<script language="JavaScript" type="text/javascript" src="<%=rootPath%>/include/navbar.js"></script>
<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath() %>css/global/global.css" rel="stylesheet" type="text/css" />
<LINK href="<%=rootPath%>/resource/css/style.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="<%=rootPath%>/resource/js/page.js"></script> 

<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="<%=rootPath%>/resource/css/itsm_style.css" type="text/css" rel="stylesheet">
<link href="<%=rootPath%>/resource/css/detail.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=rootPath%>/resource/css/style.css" type="text/css">

<link href="<%=rootPath%>/include/mainstyle.css" rel="stylesheet" type="text/css">

<script type="text/javascript" src="<%=rootPath%>/include/swfobject.js"></script>
<script type="text/javascript" src="<%=rootPath%>/resource/xml/flush/amcolumn/swfobject.js"></script>
<script type="text/javascript" src="<%=rootPath%>/js/jquery/jquery-1.3.2.js"></script>
<script type="text/javascript" src="<%=rootPath%>/js/jquery/jquery-1.2.6.js"></script>

<script language="JavaScript" type="text/JavaScript">
var show = true;
var hide = false;
//修改菜单的上下箭头符号
function my_on(head,body)
{
	var tag_a;
	for(var i=0;i<head.childNodes.length;i++)
	{
		if (head.childNodes[i].nodeName=="A")
		{
			tag_a=head.childNodes[i];
			break;
		}
	}
	tag_a.className="on";
}
function my_off(head,body)
{
	var tag_a;
	for(var i=0;i<head.childNodes.length;i++)
	{
		if (head.childNodes[i].nodeName=="A")
		{
			tag_a=head.childNodes[i];
			break;
		}
	}
	tag_a.className="off";
}
//添加菜单	
function initmenu()
{
	var idpattern=new RegExp("^menu");
	var menupattern=new RegExp("child$");
	var tds = document.getElementsByTagName("div");
	for(var i=0,j=tds.length;i<j;i++){
		var td = tds[i];
		if(idpattern.test(td.id)&&!menupattern.test(td.id)){					
			menu =new Menu(td.id,td.id+"child",'dtu','100',show,my_on,my_off);
			menu.init();		
		}
	}
}
// 获取Flex参数
function getFlexParam(param)
{
	//alert(param);
/*	
	$.ajax({
		type:"POST",
		url: "<%=rootPath%>/user.do?action=testJQury",
		data: "param=Test",
		cache: false,
		beforeSend:function loadImg(){
			$("#device_list").html("<img style='margin:10px;' src='<%=rootPath%>/img/loading.gif' />");
		},
		success: function(html){
			$("#device_list").html(html);
		}
	});
*/	
}

</script>
</head>
<BODY leftmargin="0" topmargin="0" bgcolor="#cedefa" onload="initmenu();">
<form name="mainForm" method="post">
<table border="0" id="table1" cellpadding="0" cellspacing="0" >
	<tr>
		<td width="200" valign=top align=center style="background-image:url(<%=rootPath%>/resource/image/1bgmv.png)"><%=menuTable %></td>
		<td width="2" valign=top align=center bgcolor="#397dbd">&nbsp;</td>		
		
		<td bgcolor="#ffffff" valign="top"  align="center" width=1100>
			<table cellpadding="0" cellspacing="0" width=100% bgcolor=#ffffff align='center'>
				<tr>
					<td width=2></td>
					<td align=left width=100%>
						<table cellpadding="0" cellspacing="0" width="100%"  align='left'>
							<tr style="background-color: #ECECEC;"><td colspan="8" align="center" height='28'><b>系统快照</b></td></tr>
							<tr>
  								<td align="center">
   									<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getRouterStatus(),1)%>" ><br>
   									<a href="<%=rootPath%>/network.do?action=monitorroutelist&jp=1">路由器(<%=routesize%>)</a>
   								</td>
  								<td align="center">
   									<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getSwitchStatus(),2)%>" ><br>
   									<a href="<%=rootPath%>/network.do?action=monitorswitchlist&jp=1">交换机(<%=switchsize%>)</a>
   								</td>   
  								<td align="center">
   									<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getServerStatus(),3)%>"><br>
   									<a href="<%=rootPath%>/network.do?action=monitorhostlist&jp=1">服务器(<%=hostsize%>)</a>
   								</td>
   								<td align="center">
   									<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getDbStatus(),4)%>"><br>
   									<a href="<%=rootPath%>/db.do?action=list&jp=1">数据库(<%=dbsize%>)</a>
   								</td>
  								<td align="center">
  									<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getMiddleStatus(),5)%>"><br>
  									<a href="<%=rootPath%>/FTP.do?action=midalllist&jp=1">中间件(<%=midsize%>)</a>
  								</td>
  								<td align="center">
  									<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getServiceStatus(),6)%>"><br>
  									<a href="<%=rootPath%>/FTP.do?action=allservice&jp=1">服务(<%=servicesize%>)</a>
  								</td>
  								<td align="center">
  									<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getFirewallStatus(),7)%>">
  									<br>
  									<a href="<%=rootPath%>/network.do?action=monitorfirewalllist&jp=1">安全(<%=securesize%>)</a>
  								</td>
  								<td align="center" bgcolor=#ffffff>
  									<img src="<%=rootPath%>/resource/image/ariconditioner.gif"><br>
  									<a href="#">环境</a>
  								</td>
							</tr>		
						</table>
					</td>
					<td width=2></td>
				</tr>
			</table>
          	<table width="100%" border="0" cellpadding="0" cellspacing="0">
          		<tr>
          			<td width=33%>
	            		<table cellpadding="0" cellspacing="0" width=100% class="tborder" align='left'>
	              			<tr style="background-color: #ECECEC;">
	              				<td align="center" height='28'>
	              					<b>事件汇总图</b>
	              				</td>
	              			</tr>
	              			<tr> 
	                			<td> 
	                				<div id="eventpie">
										<strong>You need to upgrade your Flash Player</strong>
							</div>
									<script type="text/javascript">
										var so = new SWFObject("<%=rootPath%>/flex/Event_Pie.swf", "Event_Pie", "346", "300", "8", "#ffffff");
										so.write("eventpie");
									</script> 				
	                			</td>
	              			</tr>
	            		</table>
	            	</td>
	            	<td colspan="2" id="device_list" width="67%" height="100%" valign="top" style="border:1px solid #0000FF;background-color:#FFFFFF;">
						<table width="100%" cellpadding="0" cellspacing="0" style="text-align:center;">
							<tr align="center" height="28" style="background-color:#EEEEEE;"> 
						 		<td width="7%" style="word-wrap:break-word;word-break: normal;border-left:1px solid #EEEEEE;border-bottom:1px solid #EEEEEE;"> 
						   			<b>等级</b>
						   		</td>
						 		<td width="18%" style="word-wrap:break-word;word-break: normal;border-left:1px solid #EEEEEE;border-bottom:1px solid #EEEEEE;"> 
						   			<b>来源</b>
						   		</td>                                           
						 		<td width="60%" style="word-wrap:break-word;border-left:1px solid #EEEEEE;border-bottom:1px solid #EEEEEE;"> 
						   			<b>事件描述</b>
						   		</td>
						 		<td width="15%" style="word-wrap:break-word;word-break: normal;border-bottom:1px solid #EEEEEE;"> 
						   			<b>时间</b>
						   		</td>
							</tr>
  		 <%
  			int index3 = 0;
  			List _rpceventlist = (List)session.getAttribute("rpceventlist");
  			if(_rpceventlist != null && _rpceventlist.size()>0){
	  			for(int i=0;i<_rpceventlist.size();i++){
		  			String eventsrc = "";
		  			index3 ++;
		  			if(index3 == 9)break;	 
		  			EventList e2 = (EventList)_rpceventlist.get(i); 			  
		  			if(e2.getManagesign() != 0) continue;

			  		if(e2.getSubtype().equalsIgnoreCase("network") || e2.getSubtype().equalsIgnoreCase("host")){
			  			HostNode node = new HostNode();
						HostNodeDao _dao = new HostNodeDao();
						node = _dao.loadHost(e2.getNodeid()); 
						_dao.close();
						eventsrc = node.getAlias()+"("+node.getIpAddress()+")";
			  		}else{
			  			eventsrc = e2.getEventlocation();
			  		}  			  
  			  
  			  		Date d2 = e2.getRecordtime().getTime();
  			  		String time2 = timeFormatter.format(d2);
  					String l1 = String.valueOf(e2.getLevel1());
	  			   if("1".equals(l1)){
	  					l1="普通事件";
	  			   }
	  			   if("2".equals(l1)){
	  			  		l1="紧急事件";
	  			  }
	  			  if("3".equals(l1)){
	  			  		l1="严重事件";
	  			  }
  		 %>
	                   		<tr height="25">
                     			<td style="border-left:1px solid #EEEEEE;border-bottom:1px solid #EEEEEE;"><img src="<%=rootPath%>/resource/<%=NodeHelper.getStatusImage(e2.getLevel1())%>" alt="<%=e2.getContent()%>" border="0"/></td>
                     			<td title="<%=eventsrc%>" style="border-left:1px solid #EEEEEE;border-bottom:1px solid #EEEEEE;"><%=eventsrc%>&nbsp;</td>
                     			<td title="<%=e2.getContent()%>" align="left" style="word-wrap:break-word;padding-left:2px; border-left:1px solid #EEEEEE;border-bottom:1px solid #EEEEEE;"><%=e2.getContent()%></td>
                     			<td title="<%=time2%>" style="word-wrap:break-word;border-left:1px solid #EEEEEE;border-bottom:1px solid #EEEEEE;"><%=time2%></td>
	                   		</tr>
          <%
          	   }
		  %>
	                   		<tr> 
	                     		<td colspan="4" align="right" style="border-left:1px solid #EEEEEE;border-bottom:1px solid #EEEEEE;" nowrap>&nbsp;<a href="<%=rootPath%>/event.do?action=list&jp=1"><font color="397dbd"><em>>>查看更多扫描事件...</em></font></a>&nbsp;</td>
	                   		</tr>   
          <%
          	} else {
          %>
          
							<!-- 没有设备显示时调用 -->
							
							<tr>
								<td colspan="4">
									<table width="100%" height="100%" style="background-color:#ffffff;">
										<tr>
											<td width="75%" valign="middle" align="center"><img  align="absmiddle" style="margin-right:3px;" src="<%=rootPath%>/img/talk.gif" />该视图中没有项目可显示</td>
											<td width="25%" valign="bottom" align="right"><img style="margin:30px;" src="<%=rootPath%>/img/bg.gif" /></td>
									</table>
								</td>
							</tr>
			<%
				}
			 %>				
						</table>
					</td>
				</tr>

          <% 
          		if(networklist != null && networklist.size()>0){
          %>
           		<tr>
          			<td width="33%">
            			<table width="100%" border="0" cellpadding="0" cellspacing="0">
              				<tr> 
                				<td align=left> 
		 							<table cellpadding="0" cellspacing="0" width=95% class="tborder" align='left'>
		 								<tr style="background-color: #ECECEC;">
              								<td align="center" height='28'>
              									<b>网络设备CPU利用率TOP10</b>
              								</td>
              							</tr>
              							<tr> 
                							<td width="100%" > 
                								<div id="flashcontent2">
													<strong>You need to upgrade your Flash Player</strong>
												</div>
												<script type="text/javascript">
													var so = new SWFObject("<%=rootPath%>/flex/Column_TOP.swf?projectName=<%=rootPath%>&dataFileName=column_network_cpu_top10.xml&dir=network_cpu", "Column_Network_Cpu_Top10", "346", "230", "8", "#ffffff");
													so.write("flashcontent2");
												</script>				
							                </td>
										</tr>             
									</table> 			
								</td>
							</tr>
						</table>
					</td>
					<td width="33%">
						<table cellpadding="0" cellspacing="0" width=100% class="tborder" align='left'>
							<tr style="background-color: #ECECEC;">
								<td align="center" height='28'>
									<b>网络设备入口流速TOP10</b>
								</td>
							</tr>
							<tr> 
								<td width="100%" > 
									<div id="flashcontent4">
										<strong>You need to upgrade your Flash Player</strong>
									</div>
									<script type="text/javascript">
										var so = new SWFObject("<%=rootPath%>/flex/Column_TOP.swf?projectName=<%=rootPath%>&dataFileName=column_network_in_top10.xml&dir=network_in", "Column_Network_In_TOP10", "346", "230", "8", "#ffffff");
										so.write("flashcontent4");
									</script>				
								</td>
							</tr>             
						</table> 
					</td>
					<td width="34%">
		          		<table cellpadding="0" cellspacing="0" width=100% class="tborder" align='left'>
		          			<tr style="background-color: #ECECEC;">
		            			<td align="center" height='28'>
		            				<b>网络设备出口流速TOP10</b>
		            			</td>
		            		</tr>
		              		<tr> 
		                		<td width="100%" > 
		                			<div id="flashcontent5">
										<strong>You need to upgrade your Flash Player</strong>
									</div>
									<script type="text/javascript">
										var so = new SWFObject("<%=rootPath%>/flex/Column_TOP.swf?projectName=<%=rootPath%>&dataFileName=column_network_out_top10.xml&dir=network_out", "Column_Network_Out_TOP10", "346", "230", "8", "#ffffff");
										so.write("flashcontent5");
									</script>				
		                		</td>
		              		</tr>             
		            	</table> 
		          	</td>
          		</tr>
 		<%
 			}
 			if(hostlist != null && hostlist.size()>0){
 		%>
 				<tr>
					<td width="33%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr> 
								<td align=left> 
									<table cellpadding="0" cellspacing="0" width=95% class="tborder" align='left'>
										<tr style="background-color: #ECECEC;">
											<td align="center" height='28'>
												<b>服务器CPU利用率TOP10</b>
											</td>
										</tr>
										<tr> 
											<td width="100%" > 
												<div id="flashcontent6">
													<strong>You need to upgrade your Flash Player</strong>
												</div>
												<script type="text/javascript">
													var so = new SWFObject("<%=rootPath%>/flex/Column_TOP.swf?projectName=<%=rootPath%>&dataFileName=column_host_cpu_top10.xml&dir=host_cpu", "Column_Host_CPU_TOP10", "346", "230", "8", "#ffffff");
													so.write("flashcontent6");
												</script>				
											</td>
										</tr>              
									</table> 			
								</td>
							</tr>
						</table>
					</td>
					<td width="33%">
						<table cellpadding="0" cellspacing="0" width=100% class="tborder" align='left'>
							<tr style="background-color: #ECECEC;">
								<td align="center" height='28'>
									<b>服务器内存利用率TOP10</b>
								</td>
							</tr>
							<tr> 
								<td width="100%" > 
									<div id="flashcontent7">
										<strong>You need to upgrade your Flash Player</strong>
									</div>
									<script type="text/javascript">
										var so = new SWFObject("<%=rootPath%>/flex/Column_TOP.swf?projectName=<%=rootPath%>&dataFileName=column_host_memory_top10.xml&dir=host_memory", "Column_Host_Memory_TOP10", "346", "230", "8", "#ffffff");
										so.write("flashcontent7");
									</script>			
								</td>
							</tr>             
						</table> 
					</td>
					<td width="34%">
						<table cellpadding="0" cellspacing="0" width=100% class="tborder" align='left'>
							<tr style="background-color: #ECECEC;">
								<td align="center" height='28'>
									<b>服务器磁盘利用率TOP10</b>
								</td>
							</tr>
							<tr> 
								<td width="100%" > 
									<div id="flashcontent8">
										<strong>You need to upgrade your Flash Player</strong>
									</div>
									<script type="text/javascript">
										var so = new SWFObject("<%=rootPath%>/flex/Column_TOP.swf?projectName=<%=rootPath%>&dataFileName=column_host_disk_top10.xml&dir=host_disk", "Column_Host_Disk_TOP10", "346", "230", "8", "#ffffff");
										so.write("flashcontent8");
									</script>				
								</td>
							</tr>             
						</table> 
					</td>
				</tr>
 		<%
 			}
 		%>
          	</table> 
          	
          	  				
		</td>
		
		<td width="2" valign=top align=center bgcolor="#397dbd">&nbsp;</td>
		<!--<img src="<%=rootPath%>/artist?series_key=<%=chart2%>">    <img src="<%=rootPath%>/artist?series_key=<%=chart1%>">     -->
	</tr>			
</table>
</form>	
</body>
</html>
