<%@page language="java" contentType="text/html;charset=gb2312" %>
<%@page import="com.afunms.application.model.HostServiceGroup"%>
<%@page import="com.afunms.application.model.HostServiceGroupConfiguration"%>
<%@ include file="/include/globe.inc"%>
<%@page import="java.util.List"%>
<%@page import="com.afunms.config.dao.DistrictDao"%>
<%@page import="com.afunms.config.model.DistrictConfig"%>



<%
  String rootPath = request.getContextPath();
  String menuTable = (String)request.getAttribute("menuTable");
  String ipaddress = (String)request.getAttribute("ipaddress");
  String nodeid = (String)request.getAttribute("nodeid");
  String groupId = (String)request.getAttribute("groupId");
  HostServiceGroup hostservicegroup = (HostServiceGroup)request.getAttribute("hostservicegroup");
  List list = (List)request.getAttribute("list");
  %>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script type="text/javascript" src="<%=rootPath%>/include/swfobject.js"></script>

<script type="text/javascript" src="<%=rootPath%>/resource/js/wfm.js"></script>

<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath() %>css/global/global.css" rel="stylesheet" type="text/css"/>

<link rel="stylesheet" type="text/css" 	href="<%=rootPath%>/js/ext/lib/resources/css/ext-all.css" charset="gb2312" />
<script type="text/javascript" 	src="<%=rootPath%>/js/ext/lib/adapter/ext/ext-base.js" charset="gb2312"></script>
<script type="text/javascript" src="<%=rootPath%>/js/ext/lib/ext-all.js" charset="gb2312"></script>
<script type="text/javascript" src="<%=rootPath%>/js/ext/lib/locale/ext-lang-zh_CN.js" charset="gb2312"></script>

<!--nielin add for processgroupconfiguration at 2010-08-17 start-->
<script type="text/javascript" 	src="<%=rootPath%>/application/resource/js/hostservicegroupconfiguration.js" charset="gb2312"></script>
<!--nielin add for processgroupconfiguration at 2010-08-17 end-->




<script language="JavaScript" type="text/javascript">


  Ext.onReady(function()
{  

setTimeout(function(){
	        Ext.get('loading').remove();
	        Ext.get('loading-mask').fadeOut({remove:true});
	    }, 250);
	
	
 Ext.get("process").on("click",function(){
  			var chk = checkinput("name","string","主机服务组名称",200,false);
  			if(chk){
  				 Ext.MessageBox.wait('数据加载中，请稍后.. ');
        	mainForm.action = "<%=rootPath%>/hostservicegroup.do?action=edit";
        	mainForm.submit();
  			}
           
       // mainForm.submit();
 });	
	
});
//-- nielin modify at 2010-01-04 start ----------------
function CreateWindow(url)
{
	
msgWindow=window.open(url,"protypeWindow","toolbar=no,width=600,height=400,directories=no,status=no,scrollbars=yes,menubar=no")
}    

function chooseHostService(eventId){
	return CreateWindow('<%=rootPath%>/hostservicegroup.do?action=chooseHostService&ipaddress=' + "<%=ipaddress%>" + '&nodeid=' + "<%=nodeid%>" + '&eventId='+eventId);
}
//-- nielin modify at 2010-01-04 end ----------------
</script>
<script language="JavaScript" type="text/javascript">
	function processConfigInit(){
		var rowNum = document.getElementById("rowNum");
		rowNum.value = "0";
		var hostServiceConfigs = new Array();
		<%	
			if(list!=null && list.size()>=0){
				for(int i = 0 ; i < list.size(); i++){	        
		            HostServiceGroupConfiguration hostServiceGroupConfiguration = (HostServiceGroupConfiguration) list.get(i);
		            int hostServiceConfigId = hostServiceGroupConfiguration.getId();
		            String hostServiceConfigName = hostServiceGroupConfiguration.getName();
		            String hostServiceConfigStatus = hostServiceGroupConfiguration.getStatus();
		            
		    %>
		            hostServiceConfigs.push({
		                hostServiceId:"<%=hostServiceConfigId%>",
		                hostServiceName:"<%=hostServiceConfigName%>",
		                hostServiceStatus:"<%=hostServiceConfigStatus%>"
		            });
		    <%
		        }
	        }
	    %> 
		hostServiceConfig("hostServiceGroupConfigureTable",hostServiceConfigs);
		
		document.getElementById("alarm_level").value = "<%=hostservicegroup.getAlarm_level()%>";
		document.getElementById("mon_flag").value = "<%=hostservicegroup.getMon_flag()%>";
		
	}
</script>

<style>
<!--
body{
background-image: url(${pageContext.request.contextPath}/common/images/menubg_report.jpg);
TEXT-ALIGN: center; 
}
-->
</style>

</head>
<body id="body" style="padding:5px;" class="body" onload="processConfigInit();">

	<form id="mainForm" method="post" name="mainForm">
		
		<table>
			<tr>
				<td class="td-container-main">
					<table>
						<tr>
							<td class="td-container-main-add">
								<table >
									<tr>
										<td>
											<table>
												<tr>
													<td>
														<table id="add-content-header" class="add-content-header">
										                	<tr>
											                	<td align="left" width="5"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
											                	<td class="add-content-title"> 应用 &gt;&gt; 服务组管理 &gt;&gt; 编辑 </td>
											                    <td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>
											       			</tr>
											        	</table>
				        							</td>
				        						</tr>
				        						<tr>
				        							<td>
				        								<table id="detail-content-body" class="detail-content-body">
				        									<tr>
				        										<td>
				        												<table>
				        													<tr>
				        														<td>
				        															<table>
																						<tr>						
																							<td align="right" height="24" width="10%">IP 地址:&nbsp;</td>				
																							<td width="40%">&nbsp;<input type="text" id="ipaddress" readonly="readonly" value="<%=ipaddress%>" name="ipaddress">
																							<input type="hidden" id="nodeid"  value="<%=nodeid%>" name="nodeid">
																							<input type="hidden" id="groupId"  value="<%=groupId%>" name="groupId">
																							</td>
																						</tr>														
																						<tr>						
																							<td align="right" height="24" width="10%">主机服务组名称:&nbsp;</td>				
																							<td width="40%">&nbsp;<input type="text" id="name" name="name" value="<%=hostservicegroup.getName()%>">
																							</td>
																						</tr>
																						<tr>						
																							<td align="right" height="24" width="10%">告警等级:&nbsp;</td>				
																							<td width="40%">
																								<select name="alarm_level" id="alarm_level">
																									<option value="1">普通告警</option>
																									<option value="2">严重告警</option>
																									<option value="3">紧急告警</option>
																								</select>
																							</td>
																						</tr>
																						<tr>						
																							<td align="right" height="24" width="10%">是否监控:&nbsp;</td>				
																							<td width="40%">
																								<select name="mon_flag" id="mon_flag">
																									<option value="1">是</option>
																									<option value="0">否</option>
																								</select>
																							</td>
																						</tr>
																						<tr>
																							<td nowrap colspan="8">
																							
																							    <!-- nielin modify begin (Phone div)*/ 2009-01-03--->
																							        <div id="formDiv" style="">         
																						                <table width="100%" style="BORDER-COLLAPSE: collapse" borderColor=#cedefa cellPadding=0 rules=none border=1 algin="center" >
																					                        <tr>
																					                            <td style="padding:0px 0px 0px 5px">&nbsp;&nbsp;进程组详细配置</td>
																					                        </tr>
																					                        <tr>
																					                            <td align="center">           
																					                                <table id="hostServiceGroupConfigureTable"  style="width:80%; padding:0;  background-color:#FFFFFF;" >
																				                                        <tr>
																				                                            <td colspan="0" height="50" align="center"> 
																				                                                <span  onClick='addRow("hostServiceGroupConfigureTable","hostservice");' style="border: 1px solid black;margin:10px;padding:0px 3px 0px 3px;cursor: hand;">增加一行</span>
																				                                            </td>
																				                                        </tr>
																					                                </table>
																					                            </td>
																					                        </tr>
																						                </table>
																						            </div> 
																							      <!-- nielin modify end */ 2009-01-03--->	
																												
																								
																							</td>
																						</tr>
																						<tr>
																							<!-- nielin add (for timeShareConfig) start 2010-01-03 -->
																							<td><input type="hidden" id="rowNum" name="rowNum"></td>
																							<!-- nielin add (for timeShareConfig) end 2010-01-03 -->
																						</tr>	
																						<tr>
																							<TD nowrap colspan="4" align=center>
																							<br><input type="button" value="保 存" style="width:50" id="process" onclick="#">&nbsp;&nbsp;
																								<input type="reset" style="width:50" value="关 闭" onclick="javascript:window.close()">&nbsp;&nbsp;
																								<input type="reset" style="width:50" value="返 回" onclick="javascript:window.history.back(1)">
																							</TD>	
																						</tr>	
														
													                        </TABLE>		
			        														</td>
			        													<tr>
			        												</table>					
																</td>
				        									</tr>
				        								</table>
				        							</td>
				        						</tr>
				        						<tr>
				        							<td>
				        								<table id="detail-content-footer" class="detail-content-footer">
				        									<tr>
				        										<td>
				        											<table width="100%" border="0" cellspacing="0" cellpadding="0">
											                  			<tr>
											                    			<td align="left" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_01.jpg" width="5" height="12" /></td>
											                    			<td></td>
											                    			<td align="right" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_03.jpg" width="5" height="12" /></td>
											                  			</tr>
											              			</table>
				        										</td>
				        									</tr>
				        								</table>
				        							</td>
				        						</tr>
				        					</table>
										</td>
									</tr>
									<tr>
										<td>
											
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>	
				</td>
			</tr>
		</table>
	</form>
</body>
</HTML>